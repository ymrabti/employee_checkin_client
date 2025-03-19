import "package:power_geojson/power_geojson.dart";

class UploadPhotoResponse {
  final String message;

  final FileClass file;
  UploadPhotoResponse({
    required this.message,
    required this.file,
  });

  UploadPhotoResponse copyWith({
    String? message,
    FileClass? file,
  }) {
    return UploadPhotoResponse(
      message: message ?? this.message,
      file: file ?? this.file,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      UploadPhotoResponseEnum.message.name: message,
      UploadPhotoResponseEnum.file.name: file.toJson(),
    };
  }

  factory UploadPhotoResponse.fromJson(Map<String, Object?> json) {
    return UploadPhotoResponse(
      message: json[UploadPhotoResponseEnum.message.name] as String,
      file: FileClass.fromJson(json[UploadPhotoResponseEnum.file.name] as Map<String, Object?>),
    );
  }

  factory UploadPhotoResponse.fromMap(Map<String, Object?> json, {String? id}) {
    return UploadPhotoResponse(
      message: json[UploadPhotoResponseEnum.message.name] as String,
      file: json[UploadPhotoResponseEnum.file.name] as FileClass,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is UploadPhotoResponse &&
        other.runtimeType == runtimeType &&
        other.message == message && //
        other.file == file;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      message,
      file,
    );
  }
}

enum UploadPhotoResponseEnum {
  message,
  file,
  none,
}

extension UploadPhotoResponseSort on List<UploadPhotoResponse> {
  List<UploadPhotoResponse> sorty(UploadPhotoResponseEnum caseField, {bool desc = false}) {
    return this
      ..sort((UploadPhotoResponse a, UploadPhotoResponse b) {
        int fact = (desc ? 1 : -1);

        if (caseField == UploadPhotoResponseEnum.message) {
          // unsortable

          String akey = a.message;
          String bkey = b.message;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == UploadPhotoResponseEnum.file) {
          // unsortable
        }

        return 0;
      });
  }
}

class FileClass {
  final String fieldname;

  final String originalname;

  final String encoding;

  final String mimetype;

  final String destination;

  final String filename;

  final String path;

  final int size;
  FileClass({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.destination,
    required this.filename,
    required this.path,
    required this.size,
  });

  FileClass copyWith({
    String? fieldname,
    String? originalname,
    String? encoding,
    String? mimetype,
    String? destination,
    String? filename,
    String? path,
    int? size,
  }) {
    return FileClass(
      fieldname: fieldname ?? this.fieldname,
      originalname: originalname ?? this.originalname,
      encoding: encoding ?? this.encoding,
      mimetype: mimetype ?? this.mimetype,
      destination: destination ?? this.destination,
      filename: filename ?? this.filename,
      path: path ?? this.path,
      size: size ?? this.size,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      FileEnum.fieldname.name: fieldname,
      FileEnum.originalname.name: originalname,
      FileEnum.encoding.name: encoding,
      FileEnum.mimetype.name: mimetype,
      FileEnum.destination.name: destination,
      FileEnum.filename.name: filename,
      FileEnum.path.name: path,
      FileEnum.size.name: size,
    };
  }

  factory FileClass.fromJson(Map<String, Object?> json) {
    return FileClass(
      fieldname: json[FileEnum.fieldname.name] as String,
      originalname: json[FileEnum.originalname.name] as String,
      encoding: json[FileEnum.encoding.name] as String,
      mimetype: json[FileEnum.mimetype.name] as String,
      destination: json[FileEnum.destination.name] as String,
      filename: json[FileEnum.filename.name] as String,
      path: json[FileEnum.path.name] as String,
      size: int.parse('${json[FileEnum.size.name]}'),
    );
  }

  factory FileClass.fromMap(Map<String, Object?> json, {String? id}) {
    return FileClass(
      fieldname: json[FileEnum.fieldname.name] as String,
      originalname: json[FileEnum.originalname.name] as String,
      encoding: json[FileEnum.encoding.name] as String,
      mimetype: json[FileEnum.mimetype.name] as String,
      destination: json[FileEnum.destination.name] as String,
      filename: json[FileEnum.filename.name] as String,
      path: json[FileEnum.path.name] as String,
      size: json[FileEnum.size.name] as int,
    );
  }

  @override
  String toString() {
    return PowerJSON(toJson()).toText();
  }

  @override
  bool operator ==(Object other) {
    return other is FileClass &&
        other.runtimeType == runtimeType &&
        other.fieldname == fieldname && //
        other.originalname == originalname && //
        other.encoding == encoding && //
        other.mimetype == mimetype && //
        other.destination == destination && //
        other.filename == filename && //
        other.path == path && //
        other.size == size;
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      fieldname,
      originalname,
      encoding,
      mimetype,
      destination,
      filename,
      path,
      size,
    );
  }
}

enum FileEnum {
  fieldname,
  originalname,
  encoding,
  mimetype,
  destination,
  filename,
  path,
  size,
  none,
}

extension FileSort on List<FileClass> {
  List<FileClass> sorty(FileEnum caseField, {bool desc = false}) {
    return this
      ..sort((FileClass a, FileClass b) {
        int fact = (desc ? 1 : -1);

        if (caseField == FileEnum.fieldname) {
          // unsortable

          String akey = a.fieldname;
          String bkey = b.fieldname;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.originalname) {
          // unsortable

          String akey = a.originalname;
          String bkey = b.originalname;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.encoding) {
          // unsortable

          String akey = a.encoding;
          String bkey = b.encoding;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.mimetype) {
          // unsortable

          String akey = a.mimetype;
          String bkey = b.mimetype;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.destination) {
          // unsortable

          String akey = a.destination;
          String bkey = b.destination;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.filename) {
          // unsortable

          String akey = a.filename;
          String bkey = b.filename;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.path) {
          // unsortable

          String akey = a.path;
          String bkey = b.path;

          return fact * (bkey.compareTo(akey));
        }
        if (caseField == FileEnum.size) {
          // unsortable

          int akey = a.size;
          int bkey = b.size;

          return fact * (bkey - akey);
        }

        return 0;
      });
  }
}
