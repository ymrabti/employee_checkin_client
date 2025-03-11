import 'package:employee_checks/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomThemeSwitchingArea extends StatelessWidget {
  CustomThemeSwitchingArea({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(
        builder: (BuildContext context) => child,
      ),
    );
  }
}

class EmployeeChecksWaiter extends StatelessWidget {
  const EmployeeChecksWaiter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180.r,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Image.asset(
            'src/logo-animated.gif',
          ),
        ),
      ),
    );
  }
}

class EmployeeChecksScaffold extends StatelessWidget {
  const EmployeeChecksScaffold({super.key, this.body, this.appBar, this.backgroundColor});
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    bool loading = context.select((EmployeeChecksState state) => state.loading);
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: loading ? EmployeeChecksWaiter() : body,
    );
  }
}

class EmployeeChecksFieldPhoneNumber extends StatelessWidget {
  const EmployeeChecksFieldPhoneNumber({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: EmployeeChecksEnum.phoneNumber.name,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      controller: _phoneController,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(14),
        FilteringTextInputFormatter.digitsOnly,
        PhoneNumberFormatter(),
      ],
      validator: FormBuilderValidators.compose(
        <FormFieldValidator<String>>[
          FormBuilderValidators.required(),
          (String? value) => PhoneNumberFormatter.validator(context, value),
        ],
      ),
      decoration: InputDecoration(
        hintText: '06 00 00 00 00',
        labelText: context.tr.phoneNumberLabelText,
      ),
    );
  }
}

class EmployeeChecksFieldUsername extends StatelessWidget {
  const EmployeeChecksFieldUsername({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: EmployeeChecksEnum.username.name,
      textDirection: TextDirection.ltr,
      controller: _phoneController,
      inputFormatters: <TextInputFormatter>[
        UsernameFormatter(), // generate this
      ],
      validator: FormBuilderValidators.compose(
        <FormFieldValidator<String>>[
          FormBuilderValidators.required(),
          (String? value) => PhoneNumberFormatter.validator(context, value),
        ],
      ),
      decoration: InputDecoration(
        hintText: EmployeeChecksEnum.username.hintTr(context),
        labelText: EmployeeChecksEnum.username.labelTr(context),
      ),
    );
  }
}

class EmployeeChecksFieldPassword extends StatefulWidget {
  const EmployeeChecksFieldPassword({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.name,
    required this.controller,
    this.matchController,
  });

  final TextEditingController controller;
  final String name;
  final String labelText;
  final String hintText;
  final TextEditingController? matchController;

  @override
  State<EmployeeChecksFieldPassword> createState() => _EmployeeChecksFieldPasswordState();
}

class _EmployeeChecksFieldPasswordState extends State<EmployeeChecksFieldPassword> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: widget.name,
      obscureText: !_showPassword,
      controller: widget.controller,
      validator: (String? value) {
        String? confirmPassword = widget.matchController?.text;
        if (confirmPassword != null && confirmPassword != widget.controller.text) {
          return context.tr.passwordMismatchError;
        } else {
          if (value == null || value.isEmpty) {
            return context.tr.enterPasswordText;
          }
          if (value.length < 8) {
            return context.tr.passwordMinLengthText;
          }
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return context.tr.passwordUppercaseRequirementText;
          }
          if (!RegExp(r'[0-9]').hasMatch(value)) {
            return context.tr.passwordDigitRequirementText;
          }
          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            return context.tr.passwordSpecialCharRequirementText;
          }
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: InkWell(
          onTap: () {
            _showPassword = !_showPassword;
            setState(() {});
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            child: _showPassword ? Icon(CupertinoIcons.eye) : Icon(CupertinoIcons.eye_slash),
            transitionBuilder: (Widget child, Animation<double> animation) => RotationTransition(
              turns: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeChecksFieldFirstName extends StatelessWidget {
  const EmployeeChecksFieldFirstName({super.key, this.initialValue});
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return FormBuilderTextField(
          name: EmployeeChecksEnum.firstName.name,
          autovalidateMode: AutovalidateMode.onUnfocus,
          initialValue: initialValue,
          validator: FormBuilderValidators.compose(
            <FormFieldValidator<String>>[
              FormBuilderValidators.required(),
            ],
          ),
          decoration: InputDecoration(
            hintText: EmployeeChecksEnum.firstName.hintTr(context),
            labelText: EmployeeChecksEnum.firstName.labelTr(context),
          ),
        );
      },
    );
  }
}

class EmployeeChecksFieldLasstName extends StatelessWidget {
  const EmployeeChecksFieldLasstName({super.key, this.initialValue});
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return FormBuilderTextField(
          name: EmployeeChecksEnum.lastName.name,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: FormBuilderValidators.compose(
            <FormFieldValidator<String>>[
              FormBuilderValidators.required(),
            ],
          ),
          decoration: InputDecoration(
            hintText: EmployeeChecksEnum.lastName.hintTr(context),
            labelText: EmployeeChecksEnum.lastName.labelTr(context),
          ),
        );
      },
    );
  }
}
