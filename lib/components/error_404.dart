import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';

class EmployeeChecks_404 extends StatefulWidget {
  static const String route = '/404';
  EmployeeChecks_404({super.key});

  @override
  State<EmployeeChecks_404> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<EmployeeChecks_404> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(
        reverse: true,
      );

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPersistentFrameCallback(
      (Duration timeStamp) {
        if (!mounted) return;
        setWebTitle(context, context.tr.pageNotFound);
      },
    );
  }

  @override
  void dispose() {
    unsetWebTitle();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeChecksScaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: Text(
                    '404',
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Colors.white,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: <Color>[Colors.purple, context.theme.colorScheme.primary],
                ).createShader(bounds);
              },
              child: Text(
                context.tr.pageNotFound,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                context.tr.goBack,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
