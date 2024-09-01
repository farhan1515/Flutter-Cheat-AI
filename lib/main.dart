import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gemini/Ai-image/image_feature.dart';
import 'package:flutter_gemini/api/app_write.dart';

import 'package:flutter_gemini/document-summarizer/ai_screen.dart';
import 'package:flutter_gemini/providers/chat_provider.dart';
import 'package:flutter_gemini/providers/settings_provider.dart';
import 'package:flutter_gemini/screens/home_screen.dart';
import 'package:flutter_gemini/document-summarizer/pdf_screen.dart';
import 'package:flutter_gemini/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

import 'hive/chat_history.dart';
import 'hive/settings.dart';
import 'hive/user_model.dart';
import 'screens/signin_screen.dart';

void main() async {
  // Ensure necessary bindings are initialized
  // await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  //Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await initializeFirebase();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyCSK-8ika2KSFXKOWVcq_3NXdWX87GbvJA',
              appId: '1:602160717104:android:72b8c9b450972cefb87cf5',
              messagingSenderId: '602160717104',
              projectId: 'document-summarizer-733b5'))
      : await Firebase.initializeApp();

  AppWrite.init();

  MobileAds.instance.initialize();

  // Set system UI settings
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(ChatHistoryAdapter());

  // Open Hive boxes
  await Hive.openBox<UserModel>(Constants.userBox);
  await Hive.openBox<Settings>(Constants.settingsBox);
  await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);

  // Initialize the ChatProvider Hive setup (if needed)
  await ChatProvider.initHive();

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    setTheme();
    super.initState();
  }

  void setTheme() {
    final settingsProvider = context.read<SettingsProvider>();
    settingsProvider.getSavedSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<SettingsProvider>().isDarkMode;

    return GetMaterialApp(
      title: 'Cheat AI',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.ubuntuTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/signin', page: () => const SigninScreen()),
        GetPage(name: '/chat', page: () => HomeScreen()),
        GetPage(name: '/createImages', page: () => ImageFeature()),
        GetPage(name: '/summarizeDocuments', page: () => PdfScreen()),
        GetPage(name: '/ai', page: () => AiScreen()),
      ],
    );
  }
}