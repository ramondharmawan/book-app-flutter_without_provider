import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // menggunakan stack karena kita akan menumpuk gambar tersebut dengan tombol back
        child: Stack(
          children: [
            Image.network(imageUrl),
            BackButton(),
          ],
        ),
      ),
      //safeArea digunakan jika tidak menggunakan appBar maka image akan terlanjur pada bagian atas
    );
  }
}
