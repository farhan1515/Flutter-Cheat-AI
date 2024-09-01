import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/hive/boxes.dart';
import 'package:flutter_gemini/hive/user_model.dart';
import 'package:flutter_gemini/providers/settings_provider.dart';
import 'package:flutter_gemini/widgets/settings_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../document-summarizer/native_ad_widget.dart';
import '../hive/settings.dart';
import '../widgets/build_diaplay_image.dart';
// Import the native ad widget

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  String userImage = '';
  String userName = 'Developer';
  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
  void pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 95,
      );
      if (pickedImage != null) {
        final localFile = File(pickedImage.path);

        // Update state
        setState(() {
          file = localFile;
          userImage = pickedImage.path;
        });

        // Save image path to Hive
        final userBox = Boxes.getUser();
        if (userBox.isNotEmpty) {
          final user = userBox.getAt(0);
          user!.image = userImage;
          user.save();
        } else {
          final newUser = UserModel(
            uid: '1', // This should be uniquely generated
            name: userName,
            image: userImage,
          );
          userBox.add(newUser);
        }
      }
    } catch (e) {
      log('error : $e');
    }
  }

  // Retrieve user data from Hive
  void getUserData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get user data from the box
      final userBox = Boxes.getUser();

      // Check if user data is not empty
      if (userBox.isNotEmpty) {
        final user = userBox.getAt(0);
        setState(() {
          userImage = user!.image;
          userName = user.name;
          file = File(userImage);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Save data if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: BuildDisplayImage(
                  file: file,
                  userImage: userImage,
                  onPressed: () {
                    // Open camera or gallery
                    pickImage();
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // User name
              Text(userName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 40.0),
              ValueListenableBuilder<Box<Settings>>(
                valueListenable: Boxes.getSettings().listenable(),
                builder: (context, box, child) {
                  if (box.isEmpty) {
                    return Column(
                      children: [
                        // Theme setting
                        SettingsTile(
                          icon: Icons.light_mode,
                          title: 'Theme',
                          value: false,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleDarkMode(
                              value: value,
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    final settings = box.getAt(0);
                    return Column(
                      children: [
                        const SizedBox(height: 10.0),
                        // Theme setting
                        SettingsTile(
                          icon: settings!.isDarkTheme
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          title: 'Theme',
                          value: settings.isDarkTheme,
                          onChanged: (value) {
                            final settingProvider =
                                context.read<SettingsProvider>();
                            settingProvider.toggleDarkMode(
                              value: value,
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 40.0),
              Container(
                height: screenHeight * 0.4, // Adjust height as needed
                child: NativeAdWidget(), // Display the native ad here
              ), // Add the native ad here
            ],
          ),
        ),
      ),
    );
  }
}
