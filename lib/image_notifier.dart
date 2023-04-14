import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ImageModel {
  final String url;

  ImageModel({required this.url});
}

class ImageNotifier extends StateNotifier<ImageModel> {
  ImageNotifier() : super(ImageModel(url: ''));

  Future<void> setImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      state = ImageModel(url: url);
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> getUrl() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      state = ImageModel(url: response.body);
    } else {
      throw Exception('Failed to load image');
    }
  }
}
