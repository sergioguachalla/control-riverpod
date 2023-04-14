import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Riverpod Demo',
      home: const RiverpodWidget(),
    );
  }
}

final ImageProvider = StateNotifierProvider(
  (ref) => ImageNotifier(),
);

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
      state = ImageModel(url: json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load image');
    }
  }
}

class RiverpodWidget extends ConsumerWidget {
  const RiverpodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = ref.watch(ImageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Riverpod Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (image as ImageModel).url.isNotEmpty
                ? Image.network((image as ImageModel).url)
                : const Text('Press the button to load image'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(ImageProvider.notifier).getUrl();
        },
        tooltip: 'Generate',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
