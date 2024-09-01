import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/Ai-image/my_dailog.dart';
import 'package:flutter_gemini/api/app_write.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:share_plus/share_plus.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';



enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();
  final status = Status.none.obs;

  final url = ''.obs;

  final imageList = <String>[].obs;

  Uint8List? imageBytes;
  final StabilityAI _ai = StabilityAI();

  final ImageAIStyle imageAIStyle = ImageAIStyle.moreDetails;

   Future<void> createAIImage() async {
    if (textC.text.trim().isNotEmpty) {
      status.value = Status.loading;
      try {
        // Fetch the API key directly from AppWrite
        final apiKey = await AppWrite.getImageApiKey();
        
        imageBytes = await _ai.generateImage(
          apiKey: apiKey,
          imageAIStyle: imageAIStyle,
          prompt: textC.text,
        );
        status.value = Status.complete;
      } catch (e) {
        status.value = Status.none;
        Get.snackbar("Error", "Failed to generate image: $e");
      }
    } else {
      MyDialog.info('Provide some Image Description');
    }
  }

  void downloadImage() async {
    try {
      if (imageBytes == null) {
        Get.snackbar("Error", "No image to download");
        return;
      }
      MyDialog.showLoadingDialog();

      final dir = await getTemporaryDirectory();
      final file =
          await File('${dir.path}/ai_image.png').writeAsBytes(imageBytes!);

      // Using gallery_saver_updated package to save the image to the gallery
      await GallerySaver.saveImage(file.path, albumName: 'AI ArtBuddy')
          .then((success) {
        Get.back();
        if (success!) {
          MyDialog.success("Image Downloaded to Gallery!");
        } else {
          MyDialog.error("Failed to download image!");
        }
      });
    } catch (e) {
      Get.back();
      MyDialog.error("Something Went Wrong (Try again in Sometime)!");
    }
  }

  void ShareImage() async {
    try {
      if (imageBytes == null) {
        Get.snackbar("Error", "No image to share");
        return;
      }
      MyDialog.showLoadingDialog();

      final dir = await getTemporaryDirectory();
      final file =
          await File('${dir.path}/ai_image.png').writeAsBytes(imageBytes!);

      Get.back();

      await Share.shareXFiles([XFile(file.path)],
          text: 'Checkout this Amazing Cheat AI App generated image 👌');
    } catch (e) {
      Get.back();
      MyDialog.error("Something Went Wrong (Try again in Sometime)!");
    }
  }
}