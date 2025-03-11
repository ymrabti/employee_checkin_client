import 'dart:ui';

import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecks_401 extends StatefulWidget {
  const EmployeeChecks_401({
    super.key,
  });

  @override
  State<EmployeeChecks_401> createState() => _UnauthorizedScreenState();
}

class _UnauthorizedScreenState extends State<EmployeeChecks_401> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback(
      (Duration timeStamp) {
        if (!mounted) return;
        setWebTitle(context, context.tr.unauthorizedAccess);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeChecksScaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              context.theme.colorScheme.primary,
              context.theme.colorScheme.primary.contrast(-60),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Frosted glass effect container
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              Icons.lock_outline,
                              size: 80,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            SizedBox(height: 24),
                            Text(
                              '401',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              context.tr.unauthorizedAccess,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              context.tr.unauthorizedMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: () => Get.toNamed(EmployeeChecksLoginPage.route),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: context.theme.colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                context.tr.loginButtonText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextButton(
                              onPressed: Get.back,
                              child: Text(
                                context.tr.goBack,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    unsetWebTitle();
    super.dispose();
  }
}
