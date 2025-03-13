import 'dart:io';
import 'package:employee_checks/lib.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanView extends StatefulWidget {
  static const String route = '/scan-it';
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderLength: 30,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (QRViewController ctrl, bool p) => _onPermissionSet(context, ctrl, p),
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
        return;
      }
      bool submitScanResult = await EmployeeChecksService(
        auth: context.read<EmployeeChecksState>().user?.tokens,
        context: context,
      ).scanNow(qr: code);
      if (submitScanResult) {
        context.hideCurrentAndShowSnackbar(
          SnackBar(
            content: Text(context.tr.checked_successfully),
          ),
        );
        Get.back();
      } else {
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

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
