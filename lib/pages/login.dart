import 'package:employee_checks/lib.dart';
import "package:flutter_form_builder/flutter_form_builder.dart";
import 'package:get/get.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:tutorial_coach_mark/tutorial_coach_mark.dart";

class ButtonContent extends StatelessWidget {
  const ButtonContent(this.text, {super.key, this.textColor = Colors.white});
  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 18.r,
      //   mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(fontFamily: 'InterEmployeeChecksRegular'),
        ),
        if (context.watch<EmployeeChecksState>().loading) CupertinoActivityIndicator(color: textColor),
      ],
    );
  }
}

Builder skipWidget() {
  return Builder(
    builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.all(16.r),
        constraints: BoxConstraints(
          maxWidth: 140.r,
          maxHeight: 80.r,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: RadialGradient(
            center: Alignment(0.4, 0.3),
            colors: <Color>[
              context.theme.colorScheme.primary.withValues(alpha: 0.4),
              context.theme.colorScheme.primary.contrast(30).withValues(alpha: 0.4),
            ],
          ),
        ),
        child: Text(
          context.tr.skip,
          style: TextStyle(
            fontSize: 12.spMin,
          ),
        ),
      );
    },
  );
}

class EmployeeChecksLoginPage extends StatefulWidget {
  static const String route = '/login';
  const EmployeeChecksLoginPage({super.key});

  @override
  State<EmployeeChecksLoginPage> createState() => _EmployeeChecksLoginPageState();
}

class _EmployeeChecksLoginPageState extends State<EmployeeChecksLoginPage> {
  final TextEditingController _phoneController = TextEditingController(
    text: kDebugMode ? '07 08 24 94 65' : '',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: kDebugMode ? 'Azer12@6Gh11' : '',
  );
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TargetFocus> targets = <TargetFocus>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomThemeSwitchingArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: EmployeeChecksResponsiveWidget(
            builder: (bool isPortrait, Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
              return isPortrait
                  ? _portrait(
                      fadeAnimation,
                      slideAnimation,
                    )
                  : _mediumAndLarge(
                      fadeAnimation,
                      slideAnimation,
                    );
            },
            medium: (Animation<double> fadeAnimation, Animation<Offset> slideAnimation) => _mediumAndLarge(fadeAnimation, slideAnimation),
            large: (Animation<double> fadeAnimation, Animation<Offset> slideAnimation) => _mediumAndLarge(
              fadeAnimation,
              slideAnimation,
            ),
          ),
        ),
      ),
    );
  }

  Center _mediumAndLarge(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 500,
        height: double.maxFinite,
        child: _portrait(
          fadeAnimation,
          slideAnimation,
        ),
      ),
    );
  }

  @override
  void dispose() {
    unsetWebTitle();
    super /*  */ .dispose();
  }

  Builder _portrait(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                spacing: 24.r,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _title(fadeAnimation, slideAnimation),
                  _prompt(fadeAnimation, slideAnimation),
                  _form(fadeAnimation, slideAnimation),
                  goToRegister(fadeAnimation, slideAnimation),
                ]
                    .map((Widget f) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.r),
                          child: f,
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Builder _form(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              spacing: 18.r,
              children: <Widget>[
                EmployeeChecksFieldPhoneNumber(phoneController: _phoneController),
                EmployeeChecksFieldPassword(
                  name: UserEnum.password.name,
                  controller: _passwordController,
                  hintText: context.tr.passwordLabelText,
                  labelText: context.tr.passwordLabelText,
                ),
                _submit(fadeAnimation, slideAnimation),
              ],
            ),
          ),
        );
      },
    );
  }

  Builder _prompt(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: Row(
            children: <Widget>[
              Gap(16.w),
              Expanded(
                child: Text(
                  context.tr.loginPromptText,
                  style: TextStyle(
                    fontSize: 12.spMin,
                    color: context.theme.adaptativeTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(16.w),
            ],
          ),
        );
      },
    );
  }

  Builder _title(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: Text(
            context.tr.loginButtonText,
            style: context.theme.primaryTextTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Builder goToRegister(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: Column(
            spacing: 18.r,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  await Get.toNamed(EmployeeChecksRegisterScreen.route);
                },
                child: Text(
                  context.tr.no_account_prompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.spMin,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0.r),
                child: TextButton(
                  onPressed: () {
                    // Get.toNamed(EmployeeChecksGesteForgotPassword.route);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: context.tr.forgotPassword,
                      style: TextStyle(
                        // color: context.theme.adaptativeTextColor,
                        fontSize: 14.spMin,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Builder _submit(Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return Builder(
      builder: (BuildContext context) {
        return SlideFadeTransition(
          fadeAnimation: fadeAnimation,
          slideAnimation: slideAnimation,
          child: FilledButton(
            onPressed: () => _submitAction(context),
            child: ButtonContent(
              context.tr.login,
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitAction(BuildContext context) async {
    context.read<EmployeeChecksState>().load = true;

    bool validateSave = _formKey.validateSave();
    if (!validateSave) {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(
            context.tr.invalidFormText,
          ),
        ),
      );
      context.read<EmployeeChecksState>().load = true;
      return;
    }

    bool userInexist = await _check_user(context);
    if (userInexist) {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(context.tr.unregisteredNumber),
        ),
      );
      context.read<EmployeeChecksState>().load = false;
      return;
    }

    String phone = _phoneController.text;
    EmployeeChecksUser? userAuth = await EmployeeChecksAuthService().login(
      phone,
      _passwordController.text,
      context.read<EmployeeChecksState>().encryptKey,
    );
    if (userAuth == null) {
      context.hideCurrentAndShowSnackbar(
        SnackBar(
          content: Text(
            context.tr.incorrect_password,
          ),
        ),
      );
      context.read<EmployeeChecksState>().load = false;
      return;
    }
    await EmployeeChecksAuthService().redirectAfterAuth(
      username: phone,
      tokens: userAuth.tokens,
      context: context,
      route: EmployeeChecksHomeScreen.route,
    );
    return;
  }

  Future<bool> _check_user(BuildContext context) async {
    EmployeeChecksService citizenService = EmployeeChecksService(
      context: context,
      auth: null,
    );
    bool node = await citizenService.checkEmployee(
      _phoneController.text,
    );
    return !node;
  }
}
