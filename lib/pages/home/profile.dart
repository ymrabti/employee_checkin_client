import 'dart:async';
import 'package:employee_checks/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart' hide MultipartFile;

class EmployeeChecksPersonalInfos extends StatefulWidget {
  const EmployeeChecksPersonalInfos({
    super.key,
    required this.onButtonTap,
    required this.textButton,
    this.initialValue,
    this.isRegister = false,
  });
  final FutureOr<void> Function(BuildContext context, GlobalKey<FormBuilderState> formKey) onButtonTap;
  final String Function(BuildContext context) textButton;
  final AuthorizationUser? Function(BuildContext context)? initialValue;
  final bool isRegister;

  @override
  State<EmployeeChecksPersonalInfos> createState() => _EmployeeChecksPersonalInfosState();
}

class _EmployeeChecksPersonalInfosState extends State<EmployeeChecksPersonalInfos> {
  final TextEditingController _passwordController = TextEditingController(text: kDebugMode ? 'Azer12@6Gh11' : null);
  final TextEditingController _confirmPasswordController = TextEditingController(text: kDebugMode ? 'Azer12@6Gh11' : null);
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(
      (Duration timeStamp) {
        if (!mounted) return;
        setWebTitle(context, context.tr.createPassword);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthorizationUser? Function(BuildContext)? fn = widget.initialValue;
    AuthorizationUser? initialValue = fn == null ? null : fn(context);
    return Scaffold(
      body: TypicalCenteredResponsive(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.r),
          child: SingleChildScrollView(
            child: Column(
              spacing: 12.r,
              children: <Widget>[
                Gap(12.r),
                if (!widget.isRegister) SoloPictureForm(child: _pic()),
                FormBuilder(
                  key: _formKey,
                  initialValue: initialValue?.toMap() ?? <String, Object?>{},
                  child: Column(
                    spacing: 18.r,
                    children: <Widget>[
                      if (widget.isRegister)
                        Text(
                          context.tr.quick_registration,
                          textAlign: TextAlign.center,
                          style: context.theme.primaryTextTheme.displayLarge,
                        ),
                      if (widget.isRegister) _pic(),
                      _fullName(),
                      EmployeeChecksFieldEmail(),
                      EmployeeChecksFieldUsername(),
                      if (widget.isRegister)
                        EmployeeChecksFieldPassword(
                          name: UserEnum.password.name,
                          controller: _passwordController,
                          hintText: context.tr.passwordLabelText,
                          labelText: context.tr.passwordLabelText,
                        ),
                      if (widget.isRegister)
                        EmployeeChecksFieldPassword(
                          name: UserEnum.confirmPassword.name,
                          matchController: _passwordController,
                          controller: _confirmPasswordController,
                          hintText: context.tr.passwordConfirmation,
                          labelText: context.tr.passwordConfirmation,
                        ),
                      Padding(
                        padding: EdgeInsets.all(12.0.r),
                        child: FilledButton(
                          onPressed: () async {
                            await widget.onButtonTap(context, _formKey);
                          },
                          child: ButtonContent(widget.textButton(context)),
                        ),
                      ),
                      if (widget.isRegister)
                        haveNoAccountPrompt(context)
                      else
                        FilledButton(
                          onPressed: () {
                            context.logOut();
                          },
                          child: Text(context.tr.logout),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  EmployeeChecksProfilePic _pic() => EmployeeChecksProfilePic(width: 150, showEdit: true);

  Center haveNoAccountPrompt(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          Navigator.canPop(context) ? Get.back<void>() : Get.toNamed(EmployeeChecksLoginPage.route);
        },
        child: Padding(
          padding: EdgeInsets.all(18.0.r),
          child: Text(
            context.tr.have_account_prompt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'InterEco',
              fontSize: 12.spMin,
            ),
          ),
        ),
      ),
    );
  }

  EmployeeChecksResponsiveWidget _fullName() {
    return EmployeeChecksResponsiveWidget(
      builder: (bool isPortrait, Animation<double> fa, Animation<Offset> sa) {
        if (isPortrait) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              EmployeeChecksFieldFirstName(),
              Gap(18.r),
              EmployeeChecksFieldLasstName(),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Expanded(
                child: EmployeeChecksFieldFirstName(),
              ),
              Gap(18.r),
              Expanded(
                child: EmployeeChecksFieldLasstName(),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  void dispose() {
    unsetWebTitle();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class SoloPictureForm extends StatefulWidget {
  const SoloPictureForm({super.key, required this.child});
  final Widget child;

  @override
  State<SoloPictureForm> createState() => _SoloPictureFormState();
}

class _SoloPictureFormState extends State<SoloPictureForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    AuthorizationUser? pi = context.watch<EmployeeChecksState>().user?.personalInfos;
    return FormBuilder(
      key: _formKey,
      initialValue: pi?.toMap() ?? <String, Object>{},
      onChanged: () async {
        logg(_formKey.currentState?.instantValue);
      },
      child: widget.child,
    );
  }
}
