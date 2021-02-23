import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  final picker = ImagePicker();
  //拍照
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    print(pickedFile);
  }

  //相册选择
  Future getImageFromGallery() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    print(image);
  }
}
