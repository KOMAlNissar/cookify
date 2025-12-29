import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    final File newImage = await File(image.path).copy(path);
    return newImage;
  }
}
