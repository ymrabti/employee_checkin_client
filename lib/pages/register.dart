import 'dart:async';
import 'package:employee_checks/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeChecksRegisterScreen extends StatefulWidget {
  static const String route = '/set-password';
  const EmployeeChecksRegisterScreen({
    super.key,
    this.initialValue,
  });
  final AuthorizationUser? initialValue;
  @override
  State<EmployeeChecksRegisterScreen> createState() => _EmployeeChecksRegisterScreenState();
}

class _EmployeeChecksRegisterScreenState extends State<EmployeeChecksRegisterScreen> {
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
    return Scaffold(
      body: EmployeeChecksPersonalInfos(
        onButtonTap: _submitAction,
        isRegister: true,
        initialValue: (BuildContext context) => kDebugMode ? widget.initialValue : null,
        textButton: (BuildContext context) => context.tr.registerButton,
      ),
    );
  }

  Future<void> _submitAction(BuildContext context, GlobalKey<FormBuilderState> _formKey) async {
    context.read<EmployeeChecksState>().load = true;

    if (!_formKey.validateSave()) {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(context.tr.invalidFormText),
        ),
      );
      context.read<EmployeeChecksState>().load = false;
      return;
    }

    EmployeeChecksUser? userAuth = await EmployeeChecksAuthService().register(
      data: _formKey.currentState?.value,
    );
    if (userAuth == null) {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(context.tr.invalidFormText),
        ),
      );
      context.read<EmployeeChecksState>().load = false;
      return;
    }

    context.read<EmployeeChecksState>().load = false;
    await EmployeeChecksAuthService().redirectAfterAuth(
      context: context,
      username: _formKey.currentState?.fields[UserEnum.username.name]?.value,
      tokens: userAuth.tokens,
      route: EmployeeChecksHomeScreen.route,
    );
    return;
  }
}
