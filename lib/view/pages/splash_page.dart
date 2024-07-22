import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/');
    });

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/566/566985.png', // Replace with your image URL
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Text('Failed to load image');
            },
          ),
        ),
      ),
    );
  }
}