import 'package:employee_checks/lib.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeChecksFieldUsername extends StatelessWidget {
  const EmployeeChecksFieldUsername({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: UserEnum.username.name,
      textDirection: TextDirection.ltr,
      inputFormatters: <TextInputFormatter>[
        UsernameFormatter(), // generate this
      ],
      validator: FormBuilderValidators.compose(
        <FormFieldValidator<String>>[
          FormBuilderValidators.username(
            minLength: 8,
            allowUnderscore: true,
            allowDots: true,
            allowDash: true,
            allowSpecialChar: true,
          ),
          //   (String? value) => UsernameFormatter.validator(context, value),
        ],
      ),
      decoration: InputDecoration(
        hintText: context.tr.username,
        labelText: context.tr.username,
      ),
    );
  }
}
