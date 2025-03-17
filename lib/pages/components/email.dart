import 'package:employee_checks/lib.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeChecksFieldEmail extends StatelessWidget {
  const EmployeeChecksFieldEmail({super.key, this.initialValue});
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: UserEnum.email.name,
      initialValue: initialValue,
      textDirection: TextDirection.ltr,
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: FormBuilderValidators.compose(
        <FormFieldValidator<String>>[
          FormBuilderValidators.email(checkNullOrEmpty: false),
        ],
      ),
      decoration: InputDecoration(
        hintText: context.tr.email,
        labelText: context.tr.email,
      ),
    );
  }
}
