// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide Context;
import 'package:power_geojson/power_geojson.dart';

import 'package:employee_checks/lib.dart';

class EmployeeChecksProfilePic extends StatelessWidget {
  EmployeeChecksProfilePic({
    super.key,
    required this.width,
    this.showEdit = false,
  });

  final double width;
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.surface;
    return FormBuilderFieldDecoration<XFile>(
      name: UserEnum.photo.name,
      validator: FormBuilderValidators.compose(
        <FormFieldValidator<XFile>>[FormBuilderValidators.required()],
      ),
      valueTransformer: (XFile? value) {
        return value == null
            ? null
            : MultipartFile.fromFileSync(
                value.path,
                filename: basename(value.path),
              ).clone();
      },
      builder: (FormFieldState<XFile> fieldState) {
        return Column(
          spacing: 8.r,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ClipOval(
                  child: Container(
                    color: context.theme.primaryColor,
                    height: width,
                    width: width,
                    child: avatar(
                      url: context.watch<EmployeeChecksState>().user?.personalInfos.photo,
                      pickedFile: fieldState.value,
                    ),
                  ),
                ),
                if (width > 100 && showEdit) _UploadPhoto(background, fieldState),
              ],
            ),
            if (fieldState.hasError)
              Text(
                fieldState.errorText!,
                style: TextStyle(
                  color: context.theme.colorScheme.error,
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage({
    required ImageSource source,
    required BuildContext context,
    required FormFieldState<XFile> fieldState,
    bool pop = true,
  }) async {
    if (pop) Navigator.of(context).pop();
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        fieldState.didChange(pickedFile);
      }
    } catch (e) {
      logg(e);
      Get.showSnackbar(
        GetSnackBar(
          message: context.tr.unexpected_error,
        ),
      );
    } finally {}
  }

  Builder _UploadPhoto(Color background, FormFieldState<XFile> fieldState) {
    return Builder(
      builder: (BuildContext context) {
        return Positioned(
          right: -16,
          bottom: 0,
          child: SizedBox(
            height: width * .4,
            width: width * .4,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (Set<WidgetState> states) => background,
                ),
                shape: WidgetStateProperty.resolveWith(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(color: background),
                      );
                    }
                    return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: BorderSide(color: background),
                    );
                  },
                ),
              ),
              onPressed: () async {
                if (AppPlatform.isWindows) {
                  await _pickImage(
                    context: context,
                    source: ImageSource.gallery,
                    fieldState: fieldState,
                    pop: false,
                  );
                  return;
                }
                await showModalBottomSheet(
                  enableDrag: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BottomSheet(
                      onClosing: () {},
                      constraints: BoxConstraints(
                        maxHeight: 100,
                      ),
                      enableDrag: false,
                      builder: (BuildContext context) => Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            InkWell(
                              onTap: () async => await _pickImage(
                                context: context,
                                fieldState: fieldState,
                                source: ImageSource.camera,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.camera, size: 40),
                                  Text /** TV **/ (
                                    context.tr.camera,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async => await _pickImage(
                                context: context,
                                fieldState: fieldState,
                                source: ImageSource.gallery,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.image, size: 40),
                                  Text /** TV **/ (
                                    context.tr.gallery,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.camera_alt_outlined,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget avatar({
    XFile? pickedFile,
    String? url,
  }) {
    Widget image = pickedFile == null
        ? ((url == null || url.isEmpty)
            ? //
            Image.asset(
                'src/employee_checks.png',
                fit: BoxFit.cover,
              )
            : Builder(
                builder: (BuildContext context) {
                  Widget? img = context.watch<EmployeeChecksState>().user?.personalInfos.imageWidget;
                  return img ?? SizedBox();
                },
              ))
        : Image.file(
            File(pickedFile.path),
            fit: BoxFit.cover,
          );
    return Builder(
      builder: (BuildContext context) {
        return Hero(
          tag: 'User_Avatar_Image',
          flightShuttleBuilder: (
            BuildContext context1,
            Animation<double> animati,
            HeroFlightDirection heroFlightDirection,
            BuildContext buildContext2,
            BuildContext buildContext,
          ) {
            if (animati.isCompleted) {
              return SizedBox(
                width: 120,
                height: 120,
                child: FittedBox(
                  child: Container(
                    color: context.theme.primaryColor.withValues(alpha: animati.value),
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: image,
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator.adaptive(
                      value: animati.value,
                    ),
                  ),
                ),
              );
            }
          },
          child: GestureDetector(
            child: ClipOval(
              child: image,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: GestureDetector(
                        key: Key('User_Avatar_Image'),
                        onTap: () => Navigator.pop(context),
                        child: SizedBox.expand(
                          child: Hero(
                            tag: 'User_Avatar_Image',
                            child: InteractiveViewer(
                              child: image,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ImagedNetwork extends StatelessWidget {
  ImagedNetwork({
    super.key,
    required this.url,
    this.headers,
  });
  final String url;
  final Map<String, String>? headers;
  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(
        url,
        headers: headers,
      ),
      fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Center(
          child: Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 60,
          ),
        );
      },
      frameBuilder: (BuildContext context, Widget child, int? num, bool boolea) {
        return child;
      },
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        int? expectedTotalBytes = loadingProgress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator(
            value: expectedTotalBytes != null ? (loadingProgress.cumulativeBytesLoaded / expectedTotalBytes) : null,
          ),
        );
      },
      alignment: Alignment.center,
      width: 120.0,
      height: 120.0,
    );
  }
}
