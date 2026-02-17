import 'package:image_picker/image_picker.dart';
import 'dart:io';

final picker = ImagePicker();

Future<File?> pickImage() async {
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked != null) {
    return File(picked.path);
  }
  return null;
}
