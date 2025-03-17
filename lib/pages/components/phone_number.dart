import 'package:employee_checks/lib.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeChecksFieldPhoneNumber extends StatelessWidget {
  const EmployeeChecksFieldPhoneNumber({
    super.key,
    required TextEditingController phoneController,
  }) : _phoneController = phoneController;

  final TextEditingController _phoneController;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: UserEnum.phoneNumber.name,
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
