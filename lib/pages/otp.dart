import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

const Duration delay = Duration.zero;
const int maxAttemps = 3;

enum SMSAttempts {
  Attempts,
  NextAttempt,
  LastAttemptDate,
}

extension OTPOeration on OTP_Oeration {
  static OTP_Oeration find(String op) {
    return OTP_Oeration.values.firstWhere((OTP_Oeration element) => element.name == op);
  }
}

class EmployeeChecksOTP_Page extends StatefulWidget {
  static const String route = '/otp-verification';
  final OTPScreenArguments arguments;
  final String encryptionKey;
  const EmployeeChecksOTP_Page({
    super.key,
    required this.arguments,
    required this.encryptionKey,
  });

  @override
  State<EmployeeChecksOTP_Page> createState() => _EmployeeChecksOTP_PageState();
}

class _EmployeeChecksOTP_PageState extends State<EmployeeChecksOTP_Page> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _resendTimer;
  Timer? _retryTimer;
  int _attemptsRemaining = maxAttemps;
  int _nextAttemptTime = 0;
  bool _isLoading = false;
//   final Telephony telephony = Telephony.instance;
  StreamSubscription<SmsMessage>? _smsSubscription;

  // Keys for SharedPreferences
  late FocusNode pin1FocusNode;
  late FocusNode pin2FocusNode;
  late FocusNode pin3FocusNode;
  late FocusNode pin4FocusNode;

  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    pin1FocusNode = FocusNode(debugLabel: 'pin_1');
    pin2FocusNode = FocusNode(debugLabel: 'pin_2');
    pin3FocusNode = FocusNode(debugLabel: 'pin_3');
    pin4FocusNode = FocusNode(debugLabel: 'pin_4');
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration duration) async {
        logg(duration, 'otp load time (ms)');
        setWebTitle(context, context.tr.otpPrompt);
        await _loadAttemptData();
        await _initSmsListener();
        _startResendTimer();
      },
    );
  }

  late DateTime _lastSet;
  Future<void> _loadAttemptData() async {
    String phoneNumber = widget.arguments.phoneNumber;
    OTP_Oeration otp_oeration = widget.arguments.otp_oeration;
    OTP_Verification_Limits empty = OTP_Verification_Limits(phone: phoneNumber, operation: otp_oeration, attempts: 0, next_attempt: 0);
    IGenericAppMap<OTP_Verification_Limits>? loaded = (await IGenericAppModel.load<OTP_Verification_Limits>(
      empty.savekey,
      widget.encryptionKey,
    ));
    DateTime now = DateTime.now().add(delay);
    DateTime savedTime = loaded?.dateTime ?? now;
    _lastSet = savedTime;
    setState(() {});
    OTP_Verification_Limits? otpData = loaded?.value;

    // Reset attempts if it's a new day
    if (!savedTime.sameDayAs(DateTime.now().add(delay))) {
      await _resetAttempts();
    } else {
      _attemptsRemaining = otpData?.attempts ?? maxAttemps;
      _nextAttemptTime = otpData?.next_attempt ?? 0;
      setState(() {});
    }
  }

  Future<void> _resetAttempts() async {
    String encryptKey = widget.encryptionKey;
    OTP_Verification_Limits defaultAttemptions = OTP_Verification_Limits(
      phone: widget.arguments.phoneNumber,
      operation: widget.arguments.otp_oeration,
      attempts: maxAttemps,
      next_attempt: 0,
    );
    await defaultAttemptions.saveData(encryptKey);
    _lastSet = DateTime.now().add(delay);
    _attemptsRemaining = defaultAttemptions.attempts;
    _nextAttemptTime = defaultAttemptions.next_attempt;
    setState(() {});
  }

  Future<void> _initSmsListener() async {
    /* bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    if (permissionsGranted ?? false) {
      _smsSubscription = telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Assuming OTP is 6 digits and comes in a specific format
          final RegExp otpRegExp = RegExp(r'\b\d{6}\b');
          final match = otpRegExp.firstMatch(message.body ?? '');
          if (match != null) {
            _otpController.text = match.group(0)!;
            _verifyOTP();
          }
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    } */
  }

  /* static Future<void> backgroundMessageHandler(SmsMessage message) async {
    // Handle background SMS if needed
  } */

  void _startResendTimer() {
    if (_nextAttemptTime > 0) {
      _resendTimer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          if (_nextAttemptTime > 0) {
            _nextAttemptTime--;
            OTP_Verification_Limits defaultAttemptions = OTP_Verification_Limits(
              phone: widget.arguments.phoneNumber,
              operation: widget.arguments.otp_oeration,
              attempts: _attemptsRemaining,
              next_attempt: _nextAttemptTime,
            );
            await defaultAttemptions.saveData(widget.encryptionKey);

            _lastSet = DateTime.now().add(delay);
            setState(() {});
          } else {
            if (_attemptsRemaining == 0) {
              _retryTimer?.cancel();
              _retryTimer = Timer.periodic(
                const Duration(seconds: 1),
                (Timer timer) async {
                  DateTime add = _lastSet.add(Duration(days: 1) - _lastSet.dura);
                  if (add.isAfter(DateTime.now().add(delay))) {
                    setState(() {});
                  } else {
                    timer.cancel();
                    await _resetAttempts();
                  }
                },
              );
            }
            timer.cancel();
          }
        },
      );
    } else {
      _retryTimer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) async {
          DateTime add = _lastSet.add(Duration(days: 1) - _lastSet.dura);
          if (add.isAfter(DateTime.now().add(delay))) {
            setState(() {});
          } else {
            timer.cancel();
            await _resetAttempts();
          }
        },
      );
    }
  }

  Future<void> _resendOTP(BuildContext context) async {
    String otpResentSuccessfully2 = context.tr.otpResentSuccessfully;
    String failedToVerifyOtp2 = context.tr.failedToVerifyOtp;
    ScaffoldMessengerState of = ScaffoldMessenger.of(context);
    if (_attemptsRemaining <= 0 || _nextAttemptTime > 0) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Implement your OTP sending logic here
      await Future<void>.delayed(const Duration(milliseconds: 350)); // Simulated API call

      if (!context.mounted) return;
      _attemptsRemaining--;
      _nextAttemptTime = _calculateNextAttemptDelay();
      OTP_Verification_Limits update = OTP_Verification_Limits(
        phone: widget.arguments.phoneNumber,
        operation: widget.arguments.otp_oeration,
        attempts: _attemptsRemaining,
        next_attempt: _nextAttemptTime,
      );
      _lastSet = DateTime.now().add(delay);
      setState(() {});
      await update.saveData(widget.encryptionKey);

      if (!context.mounted) return;
      _startResendTimer();
      of.showSnackBar(
        SnackBar(content: Text(otpResentSuccessfully2)),
      );
    } catch (e) {
      of.showSnackBar(
        SnackBar(content: Text(failedToVerifyOtp2)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _calculateNextAttemptDelay() {
    // Exponential backoff: 30s, 60s, 120s
    return (15) * (1 << (maxAttemps - _attemptsRemaining));
  }

  Future<void> _verifyOTP(BuildContext context) async {
    bool valid = _formKey.validateSave();
    if (!valid) return;
    _otpController.text = _formKey.instantValue.values.join('');
    if (_otpController.text.length != 4) return;

    _isLoading = true;
    setState(() {});

    try {
      // Implement your OTP verification logic here
      await Future<void>.delayed(const Duration(seconds: 1)); // Simulated API call

      if (!context.mounted) return;
      if (widget.arguments.phoneNumber.replaceAll(' ', '').endsWith(_otpController.text)) {
        // Success
        // If verification successful, navigate to next screen
        // Navigator.pushReplacement(...);
        await _resetAttempts();
        widget.arguments.onSuccess.call();
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.failedToVerifyOtp)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.failedToVerifyOtp)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<FocusNode> get focuses => <FocusNode>[
        pin1FocusNode,
        pin2FocusNode,
        pin3FocusNode,
        pin4FocusNode,
      ];

  @override
  void dispose() {
    _resendTimer?.cancel();
    _retryTimer?.cancel();
    _smsSubscription?.cancel();
    _otpController.dispose();
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    unsetWebTitle();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<int> list = List<int>.generate(4, (int index) => index);

    List<Widget> children = <Widget>[
      Text.rich(
        textDirection: TextDirection.ltr,
        TextSpan(
          text: '${context.tr.enterVerificationCode}:',
        ),
        textAlign: TextAlign.center,
        style: context.theme.textTheme.titleLarge,
      ),
      Text.rich(
        textDirection: TextDirection.ltr,
        TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: widget.arguments.phoneNumber,
              style: TextStyle(
                color: context.theme.adaptativePrimaryColor,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: context.theme.textTheme.titleLarge,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (int i in list)
            Builder(builder: (BuildContext context) {
              return SizedBox(
                width: 60.r,
                child: FormBuilderTextField(
                  name: 'pin_i_$i',
                  focusNode: focuses.elementAt(i),
                  autofocus: i == list.first,
                  style: TextStyle(fontSize: 24.r /* , color: context.theme.foregroundColor */),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  showCursor: true,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(1), // Limits input to 1 number
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: FormBuilderValidators.compose(
                    <FormFieldValidator<String>>[
                      FormBuilderValidators.required(),
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.maxLength(1),
                    ],
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.theme.primaryColor,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.r,
                    ),
                    border: outlineInputBorder(),
                    focusedBorder: outlineInputBorder(),
                    enabledBorder: outlineInputBorder(),
                  ),
                  onChanged: (String? value) {
                    if ((value?.isEmpty ?? false) && i > 0) {
                      FocusNode e = focuses.elementAt(i - 1);
                      e.requestFocus();
                    } else if (value?.length == 1 && i == list.last) {
                      focuses.last.unfocus();
                      _verifyOTP(context);
                    } else {
                      FocusNode? e = focuses.elementAt(i + 1);
                      nextField(value ?? '', e);
                    }
                  },
                ),
              );
            }),
        ],
      ),
      Gap(12.r),
      if (_isLoading)
        SizedBox(
          width: 30.0.r,
          height: 30.0.r,
          child: CupertinoActivityIndicator(),
        )
      else
        FilledButton(
          onPressed: () => _verifyOTP(context),
          child: Text(context.tr.valider),
        ),
      Builder(
        builder: (BuildContext context) {
          String retries = '${context.tr.resendOtp} ($_attemptsRemaining ${context.tr.attemptsRemaining})';
          String waitnew = '${context.tr.resendOtpIn} ${_nextAttemptTime}s';
          return TextButton(
            onPressed: _attemptsRemaining > 0 && _nextAttemptTime == 0 ? () => _resendOTP(context) : null,
            child: Text(
              () {
                Duration odd = Duration(days: 1);
                Duration now = DateTime.now().add(delay).dura;
                if (_nextAttemptTime == 0 && _attemptsRemaining == 0 && odd > now) {
                  return (odd - now).format();
                } else {
                  return _nextAttemptTime > 0 ? waitnew : retries;
                }
              }(),
              style: TextStyle(
                fontFamily: 'InterEmployeeChecksRegular',
                fontSize: 14.spMin,
              ),
            ),
          );
        },
      ),
    ];

    return EmployeeChecksScaffold(
      appBar: AppBar(),
      body: Center(
        child: TypicalCenteredResponsive(
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20.0.r),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: children.length,
                separatorBuilder: (BuildContext context, int index) => Gap(18.r),
                itemBuilder: (BuildContext context, int index) => children.elementAt(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
}

class SmsMessage {
  final String body;

  SmsMessage({required this.body});
}

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15.r),
    borderSide: BorderSide(),
  );
}
