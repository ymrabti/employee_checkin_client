import 'package:employee_checks/lib.dart';

class EmployeeChecksResponsiveWidget extends StatefulWidget {
  const EmployeeChecksResponsiveWidget({
    super.key,
    this.large,
    this.medium,
    required this.builder,
  });

  final Widget? Function(Animation<double> fa, Animation<Offset> sa)? large;
  final Widget? Function(Animation<double> fa, Animation<Offset> sa)? medium;
  final Widget Function(bool isPortrait, Animation<double> fa, Animation<Offset> sa) builder; //small screen
  @override
  State<EmployeeChecksResponsiveWidget> createState() => _EmployeeChecksResponsiveWidgetState();
}

class _EmployeeChecksResponsiveWidgetState extends State<EmployeeChecksResponsiveWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and orientation
    final Size size = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    // Determine if we're on mobile, tablet, or desktop
    // final isDesktop = size.width > 1024;
    final bool isTablet = size.width > 600 && size.width <= 1024;
    final bool isMobile = size.width <= 600;

    Widget? Function(Animation<double> fa, Animation<Offset> sa)? medium = widget.medium;
    Widget? Function(Animation<double> fa, Animation<Offset> sa)? large = widget.large;
    Widget widgetDefault = widget.builder(
      orientation == Orientation.portrait,
      _fadeAnimation,
      _slideAnimation,
    );
    return SizedBox(
      child: isMobile
          ? widgetDefault
          : isTablet
              ? (medium == null ? widgetDefault : medium(_fadeAnimation, _slideAnimation))
              : (large == null ? (medium == null ? widgetDefault : medium(_fadeAnimation, _slideAnimation)) : large(_fadeAnimation, _slideAnimation)),
    );
  }

  Widget buildTopSection(bool isDesktop, bool isTablet, bool isMobile) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.devices,
                  size: isDesktop ? 100 : (isTablet ? 80 : 60),
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                Text(
                  'Current Platform:',
                  style: TextStyle(
                    fontSize: isDesktop ? 24 : (isTablet ? 20 : 16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isDesktop ? 'Desktop' : (isTablet ? 'Tablet' : 'Mobile'),
                  style: TextStyle(
                    fontSize: isDesktop ? 20 : (isTablet ? 18 : 14),
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomSection(bool isDesktop, bool isTablet, bool isMobile) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
          ),
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return AnimatedCardScreenBuilder();
          },
        ),
      ),
    );
  }
}

class AnimatedCardScreenBuilder extends StatefulWidget {
  final Widget? child;

  const AnimatedCardScreenBuilder({
    super.key,
    this.child,
  });

  @override
  State<AnimatedCardScreenBuilder> createState() => _AnimatedCardScreenBuilderState();
}

class _AnimatedCardScreenBuilderState extends State<AnimatedCardScreenBuilder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final int index;
  final bool isDesktop;
  final bool isTablet;

  const AnimatedCard({
    super.key,
    required this.index,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.deepPurple[(widget.index + 1) * 100]!,
                  Colors.deepPurple[(widget.index + 2) * 100]!,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'Card ${widget.index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.isDesktop ? 24 : (widget.isTablet ? 20 : 16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SlideFadeTransition extends StatelessWidget {
  const SlideFadeTransition({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: child,
      ),
    );
  }
}

class TypicalCenteredResponsive extends StatelessWidget {
  const TypicalCenteredResponsive({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return EmployeeChecksResponsiveWidget(
      builder: (bool isPortrait, Animation<double> fa, Animation<Offset> sa) => child,
      medium: (Animation<double> fa, Animation<Offset> sa) => Center(
        child: SizedBox(
          width: 500,
          child: SlideFadeTransition(
            fadeAnimation: fa,
            slideAnimation: sa,
            child: child,
          ),
        ),
      ),
    );
  }
}
