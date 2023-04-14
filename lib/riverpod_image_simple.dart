import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'image_notifier.dart';

//final imageProvider = StateProvider((ref) => null);
final imageNotifierProvider =
    StateNotifierProvider<ImageNotifier, ImageModel>((ref) {
  return ImageNotifier();
});

class RiverpodWidget extends StatelessWidget {
  const RiverpodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Riverpod Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final url = 'https://cataas.com/cat';
                http.get(Uri.parse(url)).then((response) {
                  final imageUrl = 'https://cataas.com/${response.body}';
                  context.read(imageNotifierProvider).setImage(imageUrl);
                });
              },
              child: const Text('Random image'),
            ),
            const SizedBox(height: 16),
            Consumer(builder: (context, watch, _) {
              var state = watch(imageNotifierProvider) as ImageModel;
              final imageAsyncValue = (imageNotifierProvider.state);
              return Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  image: imageAsyncValue.data != null
                      ? DecorationImage(
                          image: NetworkImage(imageAsyncValue.data!.url),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
