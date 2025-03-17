import 'package:employee_checks/lib.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeChecksFieldFirstName extends StatelessWidget {
  const EmployeeChecksFieldFirstName({super.key, this.initialValue});
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return FormBuilderTextField(
          name: UserEnum.firstName.name,
          autovalidateMode: AutovalidateMode.onUnfocus,
          initialValue: initialValue,
          validator: FormBuilderValidators.compose(
            <FormFieldValidator<String>>[
              FormBuilderValidators.firstName(),
            ],
          ),
          decoration: InputDecoration(
            hintText: context.tr.enterFirstName,
            labelText: context.tr.firstName,
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
          name: UserEnum.lastName.name,
          initialValue: initialValue,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: FormBuilderValidators.compose(
            <FormFieldValidator<String>>[
              FormBuilderValidators.lastName(),
            ],
          ),
          decoration: InputDecoration(
            hintText: context.tr.enterLastName,
            labelText: context.tr.lastName,
          ),
        );
      },
    );
  }
}
