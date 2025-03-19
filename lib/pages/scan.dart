import 'dart:async';
import 'dart:io';
import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:just_audio/just_audio.dart';
import 'package:volume_controller/volume_controller.dart';

class QRScanView extends StatefulWidget {
  static const String route = '/scan-it';
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey();
  final AudioPlayer playerSuccess = AudioPlayer();
  final AudioPlayer playerError = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration timeStamp) async {
        await playerSuccess.setAsset(
          'assets/success.mp3',
        );
        await playerError.setAsset('assets/fail.mp3');
      },
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    double width2 = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double scanArea = (width2 < 400 || height < 400) ? 250.0 : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (QRViewController ctrl, bool p) => _onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        borderColor: context.theme.primaryColor,
        borderLength: 30,
        overlayColor: Colors.grey.withAlpha(128),
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) async {
      result = scanData;
      setState(() {});
      await controller.pauseCamera();
      String? code = result?.code;
      if (code == null) {
        await controller.resumeCamera();
        setState(() {});
        return;
      }
      AuthorizationUser? qrOffered = await EmployeeChecksService(
        auth: context.read<EmployeeChecksState>().user?.tokens,
        context: context,
      ).scanNow(qr: code);
      if (qrOffered != null) {
        double currentVolume = await VolumeController.instance.getVolume();
        await VolumeController.instance.setVolume(1);
        await playerSuccess.play();
        await VolumeController.instance.setVolume(currentVolume);
        context.hideCurrentAndShowSnackbar(
          SnackBar(
            content: Text(context.tr.checked_successfully),
          ),
        );
        Get.off(
          () {
            DateTime dateTime = DateTime.now();
            return TempShowWhenIScan(dateTime: dateTime, qrOffered: qrOffered);
          },
        );
      } else {
        await controller.resumeCamera();
        double currentVolume = await VolumeController.instance.getVolume();
        await VolumeController.instance.setVolume(1);
        await playerError.play();
        await VolumeController.instance.setVolume(currentVolume);
        setState(() {});
        context.hideCurrentAndShowSnackbar(
          SnackBar(
            content: Text(context.tr.error_submitting),
          ),
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr.no_permission)),
      );
    }
  }

  Future<void> pauseAudioSuccess() async {
    await playerSuccess.stop();
    await playerSuccess.dispose();
  }

  Future<void> pauseAudioError() async {
    await playerError.stop();
    await playerError.dispose();
  }

  @override
  void dispose() {
    unawaited(pauseAudioSuccess());
    unawaited(pauseAudioError());
    super.dispose();
  }
}

class TempShowWhenIScan extends StatelessWidget {
  const TempShowWhenIScan({
    super.key,
    required this.dateTime,
    required this.qrOffered,
  });

  final DateTime dateTime;
  final AuthorizationUser? qrOffered;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserWidget(
        start: dateTime,
        personalInfos: qrOffered,
        autoBack: true,
      ),
    );
  }
}
