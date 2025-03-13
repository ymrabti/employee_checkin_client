import 'package:employee_checks/lib.dart';
import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EmployeeChecksRegisterScreen extends StatefulWidget {
  static const String route = '/set-password';
  const EmployeeChecksRegisterScreen({super.key});

  @override
  State<EmployeeChecksRegisterScreen> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<EmployeeChecksRegisterScreen> {
  final TextEditingController _usernameController = TextEditingController(text: kDebugMode ? faker.internet.userName() : null);
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
    return Scaffold(
      body: TypicalCenteredResponsive(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.r),
          child: FormBuilder(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  context.tr.quick_registration,
                  textAlign: TextAlign.center,
                  style: context.theme.primaryTextTheme.displayLarge,
                ),
                EmployeeChecksProfilePic(width: 150, showEdit: true),
                _fullName(),
                EmployeeChecksFieldEmail(initialValue: kDebugMode ? faker.email3 : null),
                EmployeeChecksFieldUsername(controller: _usernameController),
                EmployeeChecksFieldPassword(
                  name: UserEnum.password.name,
                  controller: _passwordController,
                  hintText: context.tr.passwordLabelText,
                  labelText: context.tr.passwordLabelText,
                ),
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
                      await _submitAction(context);
                    },
                    child: ButtonContent(context.tr.registerButton),
                  ),
                ),
                Center(
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
                ),
              ].joinBy(item: Gap(18.r)),
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
              EmployeeChecksFieldFirstName(
                initialValue: kDebugMode ? faker.person.firstName() : '',
              ),
              Gap(18.r),
              EmployeeChecksFieldLasstName(
                initialValue: kDebugMode ? faker.person.lastName() : '',
              ),
            ],
          );
        } else {
          return Row(
            children: <Widget>[
              Expanded(
                child: EmployeeChecksFieldFirstName(
                  initialValue: kDebugMode ? faker.person.firstName() : '',
                ),
              ),
              Gap(18.r),
              Expanded(
                child: EmployeeChecksFieldLasstName(
                  initialValue: kDebugMode ? faker.person.lastName() : '',
                ),
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
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitAction(BuildContext context) async {
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
