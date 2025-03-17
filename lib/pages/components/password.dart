import 'package:employee_checks/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
      validator: FormBuilderValidators.compose<String?>(
        <FormFieldValidator<String?>>[
          FormBuilderValidators.password(),
        ],
      ),
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

  String? validator(String? value) {
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
  }
}
