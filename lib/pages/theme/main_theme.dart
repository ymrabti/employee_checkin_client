import "package:flutter/cupertino.dart";
import "package:flutter/services.dart";
import "package:employee_checks/lib.dart";
import "package:google_fonts/google_fonts.dart";

ThemeData EmployeeChecksTheme({required bool dark}) {
  MaterialColor fgColor = dark ? EmployeeChecksColors.textColorDark : EmployeeChecksColors.textColorLight;
  MaterialColor bgColor = dark ? EmployeeChecksColors.textColorLight : EmployeeChecksColors.textColorDark;
  //
  Color colorFill = bgColor[dark ? 800 : 300]!;
  Color colorForePrimary = fgColor[!dark ? 800 : 300]!;
  Color colorFore = fgColor[!dark ? 700 : 400]!;
  ColorScheme colorSchemeDark = ColorScheme.dark(
    primary: EmployeeChecksColors.schemeDark,
    secondary: EmployeeChecksColors.schemeAccent,
    error: EmployeeChecksColors.errorColor,
    surface: bgColor,
    brightness: Brightness.dark,
  );
  //
  ColorScheme colorSchemeLight = ColorScheme.light(
    primary: EmployeeChecksColors.schemeLight,
    secondary: EmployeeChecksColors.schemeAccent,
    error: EmployeeChecksColors.errorColor,
    surface: bgColor,
    brightness: Brightness.light,
  );
  IconThemeData iconTheme = IconThemeData(
    color: fgColor,
    weight: 500,
    fill: 0.4,
    shadows: <Shadow>[
      BoxShadow(
        color: bgColor.withValues(alpha: 0.5),
      ),
    ],
    opticalSize: 64,
  );
  TextTheme textTheme = TextTheme(
    // Body
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: fgColor),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: fgColor),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: fgColor),

    // Labels
    labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.5, color: fgColor),
    labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: fgColor),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.1, color: fgColor),

    // Display
    displaySmall: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: fgColor),
    displayMedium: GoogleFonts.poppins(fontSize: 45, fontWeight: FontWeight.w400, color: fgColor),
    displayLarge: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w400, color: fgColor),

    // Titles
    titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: fgColor),
    titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: fgColor),
    titleLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0.2, color: fgColor),

    // Headlines
    headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: fgColor),
    headlineMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w500, letterSpacing: 0.2, color: fgColor),
    headlineLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w500, letterSpacing: 0.25, color: fgColor),
  );
  double maxWidth = EmployeeChecksPlatform.isPhone ? double.maxFinite : 600.0;
  WidgetStateProperty<double> elevationButton = WidgetStateProperty<double>.fromMap(
    <WidgetStatesConstraint, double>{
      WidgetState.hovered: 5.0,
      WidgetState.disabled: 0.0,
      WidgetState.pressed: 0.0,
      WidgetState.selected: 0.0,
      WidgetState.any: 3.0,
    },
  );
  WidgetStatePropertyAll<Size> maxSizeButton = WidgetStatePropertyAll<Size>(Size(maxWidth, 200));
  WidgetStatePropertyAll<EdgeInsets> paddingButton = WidgetStatePropertyAll<EdgeInsets>(
    EdgeInsets.all(12.0.r),
  );
  WidgetStatePropertyAll<RoundedRectangleBorder> shapeButton = WidgetStatePropertyAll<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
  WidgetStateProperty<Color> foreGroundButton = WidgetStateProperty.resolveWith(
    (Set<WidgetState> states) {
      return states.contains(WidgetState.disabled) ? colorFore : Colors.white;
    },
  );
  WidgetStateProperty<Color> bgFilledButton = WidgetStateProperty.resolveWith(
    (Set<WidgetState> states) {
      return states.contains(WidgetState.disabled) ? Color(0x819E9E9E) : EmployeeChecksColors.schemeDark;
    },
  );
  FilledButtonThemeData filledButtonThemeData = FilledButtonThemeData(
    style: ButtonStyle(
      shadowColor: WidgetStatePropertyAll<Color>(fgColor.withValues(alpha: .35)),
      backgroundColor: bgFilledButton,
      textStyle: WidgetStatePropertyAll<TextStyle?>(
        textTheme.labelMedium?.copyWith(
          fontFamily: 'InterEmployeeChecks',
          color: fgColor,
          fontSize: 18.spMin,
        ),
      ),
      maximumSize: maxSizeButton,
      elevation: elevationButton,
      padding: paddingButton,
      shape: shapeButton,
      foregroundColor: foreGroundButton,
      alignment: Alignment.center,
    ),
  );
  return ThemeData(
    fontFamily: 'InterEmployeeChecks',
    useMaterial3: true,
    visualDensity: VisualDensity.comfortable,
    brightness: dark ? Brightness.dark : Brightness.light,

    adaptations: null,
    fontFamilyFallback: null,
    package: null,
    //COLORS

    cardColor: bgColor,
    scaffoldBackgroundColor: bgColor,
    dialogBackgroundColor: EmployeeChecksColors.transparent,
    colorScheme: dark ? colorSchemeDark : colorSchemeLight,
    colorSchemeSeed: null,
    hintColor: null,
    focusColor: null,
    hoverColor: null,
    splashColor: null,
    canvasColor: null,
    dividerColor: null,
    disabledColor: null,
    highlightColor: null,
    indicatorColor: null,
    secondaryHeaderColor: null,
    unselectedWidgetColor: null,
    applyElevationOverlayColor: null,
    shadowColor: fgColor.withValues(alpha: .35),
    // PALETTE START
    primaryColor: EmployeeChecksColors.schemeDark,
    primaryColorDark: EmployeeChecksColors.schemeDark,
    primaryColorLight: EmployeeChecksColors.schemeLight,
    primarySwatch: EmployeeChecksColors.schemeDark,
    // PALETTE END
    //
    cardTheme: CardTheme(
      color: bgColor,
      elevation: 8,
      shadowColor: fgColor.withValues(alpha: 0.3),
      shape: Border(),
    ),
    // TEXT START
    textTheme: textTheme,
    iconTheme: iconTheme,
    primaryTextTheme: textTheme,
    primaryIconTheme: iconTheme,
    typography: Typography(platform: TargetPlatform.iOS),

    // TEXT END

    expansionTileTheme: ExpansionTileThemeData(
      textColor: fgColor,
      iconColor: fgColor,
      collapsedTextColor: fgColor.contrast(20),
      collapsedIconColor: fgColor,
      backgroundColor: bgColor.contrast(20),
      collapsedBackgroundColor: bgColor.contrast(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tilePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: bgColor.contrast(10),
      iconColor: fgColor,
      style: ListTileStyle.list,
      subtitleTextStyle: TextStyle(
        letterSpacing: 4.r,
        color: fgColor,
        fontStyle: FontStyle.italic,
      ),
      titleTextStyle: TextStyle(
        letterSpacing: 4.r,
        color: fgColor,
      ),
    ),

    // BUTTONS

    filledButtonTheme: filledButtonThemeData,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    buttonTheme: ButtonThemeData(
      minWidth: 250,
      alignedDropdown: true,
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(12.r),
      shape: Border.all(),
      // foregroundColor: foreGroundButton,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        maximumSize: maxSizeButton,
        elevation: elevationButton,
        padding: paddingButton,
        shape: shapeButton,
        // foregroundColor: foreGroundButton,
        alignment: Alignment.center,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: filledButtonThemeData.style),
    menuButtonTheme: MenuButtonThemeData(),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: filledButtonThemeData.style,
      selectedIcon: Icon(
        Icons.verified,
        color: Colors.white,
      ),
    ),
    toggleButtonsTheme: null,
    floatingActionButtonTheme: null,

    // Inputs

    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: fgColor),
        gapPadding: 10.r,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colorSchemeDark.primary),
        gapPadding: 10.r,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: EmployeeChecksColors.errorColor.shade200),
        gapPadding: 10.r,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: fgColor),
        gapPadding: 10.r,
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey),
        gapPadding: 10.r,
      ),
      suffixIconColor: fgColor,
      //   filled: true,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
      ),
      suffixIconConstraints: BoxConstraints(
        minHeight: 40.h,
        minWidth: 40.h,
      ),
      //   fillColor: colorFill,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
      focusColor: EmployeeChecksColors.errorColor.shade800,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: EmployeeChecksColors.errorColor.shade800),
        gapPadding: 10.r,
      ),
      labelStyle: TextStyle(
        letterSpacing: 4.r,
        color: colorForePrimary,
        fontSize: 16.spMin,
      ),
      hintStyle: TextStyle(
        letterSpacing: 4.r,
        fontSize: 14.spMin,
        color: colorFore,
        fontFamily: 'InterEmployeeChecks',
      ),
      outlineBorder: BorderSide(color: EmployeeChecksColors.schemeAccent),
    ),
    timePickerTheme: TimePickerThemeData(
      elevation: 0,
    ),
    datePickerTheme: DatePickerThemeData(
      todayBackgroundColor: WidgetStatePropertyAll<Color>(EmployeeChecksColors.schemeDark),
      dayStyle: TextStyle(letterSpacing: 4.r, fontSize: 11.spMin),
      yearStyle: TextStyle(letterSpacing: 4.r, fontSize: 13.spMin),
      weekdayStyle: TextStyle(letterSpacing: 4.r, fontSize: 13.spMin),
      confirmButtonStyle: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(letterSpacing: 4.r, fontSize: 19.spMin),
        ),
      ),
      headerHelpStyle: TextStyle(letterSpacing: 4.r, fontSize: 12.spMin),
      headerHeadlineStyle: TextStyle(letterSpacing: 4.r, fontSize: 12.spMin),
      cancelButtonStyle: ButtonStyle(
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(letterSpacing: 4.r, fontSize: 16.spMin),
        ),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: textTheme.labelMedium?.copyWith(fontSize: 13.r),
      inputDecorationTheme: InputDecorationTheme(filled: false),
    ),
    // Material

    appBarTheme: AppBarTheme(
      //   color: appbarColor,
      backgroundColor: bgColor,
      //   foregroundColor: fgColor,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        letterSpacing: 4.r,
        color: fgColor.contrast(50),
        fontSize: 20.sw,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: fgColor,
        weight: 900,
        fill: 1,
        opticalSize: 96,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: textTheme.bodyMedium,
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: fgColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0,
    ),
    drawerTheme: DrawerThemeData(
      width: EmployeeChecksPlatform.isPhone ? 304.r : 400,
    ),

    // Messages && Dialogs

    badgeTheme: BadgeThemeData(
      backgroundColor: EmployeeChecksColors.errorColor.shade800,
      smallSize: 12.r,
      padding: EdgeInsets.all(4.r),
      textColor: Colors.white,
      textStyle: TextStyle(
        letterSpacing: 4.r,
        fontFamily: 'InterEmployeeChecks',
        fontSize: 14.spMin,
        color: Colors.white,
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: bgColor.contrast(35),
      elevation: 0,
      shape: RoundedRectangleBorder(),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: TextStyle(
        letterSpacing: 4.r,
        color: fgColor,
        fontSize: 16.spMin,
      ),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colorFill,
        border: Border.all(color: fgColor.contrast(30), width: 2),
        borderRadius: BorderRadius.circular(12.r),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor.contrast((dark ? -1 : 1) * 20),
      actionTextColor: fgColor,
      actionBackgroundColor: bgColor.contrast((dark ? -1 : 1) * 5),
      closeIconColor: fgColor,
      width: EmployeeChecksPlatform.isPhone ? double.maxFinite : 400,
      showCloseIcon: true,
      contentTextStyle: TextStyle(
        letterSpacing: 4.r,
        color: fgColor,
        fontSize: 14.spMin,
        fontFamily: 'InterEmployeeChecks',
      ),
    ),

    // OTHERS

    // buttonBarTheme: null,
    bannerTheme: MaterialBannerThemeData(),
    actionIconTheme: ActionIconThemeData(
      drawerButtonIconBuilder: (BuildContext context) => Tooltip(
        message: context.tr.openMenu,
        child: TooltipVisibility(
          visible: false,
          child: Icon(Icons.menu),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(),
    bottomSheetTheme: null,
    checkboxTheme: null,
    chipTheme: null,
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      applyThemeToAll: true,
    ),
    dataTableTheme: null,
    dividerTheme: null,
    extensions: null,
    materialTapTargetSize: null,
    menuBarTheme: null,
    menuTheme: null,
    navigationBarTheme: null,
    navigationDrawerTheme: null,
    navigationRailTheme: null,
    pageTransitionsTheme: null,
    platform: null,
    popupMenuTheme: null,
    progressIndicatorTheme: null,
    radioTheme: null,
    scrollbarTheme: null,
    searchBarTheme: null,
    searchViewTheme: null,
    sliderTheme: null,
    splashFactory: null,
    switchTheme: null,
    textSelectionTheme: null,
  );
}
