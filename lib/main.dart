import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/bindings/home_binding.dart';
import 'package:myapp/view/pages/add_student.dart';
import 'package:myapp/view/pages/edit_student.dart';
import 'package:myapp/view/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/view/pages/splash_page.dart';
// import 'package:myapp/view/pages/student_details.dart';
import 'firebase_options.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(16, 14, 9, 1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(16, 14, 9, 1),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(16, 14, 9, 1),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
            name: '/', page: () => const HomeScreen(), binding: HomeBinding()),
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/edit', page: () => EditStudent(
          studentModel: Get.arguments,
        )),
        // GetPage(name: '/details', page: () => const StudentDetails(),),
        GetPage(name: '/addStudent', page: () => const AddStudent()),
      ],
      initialRoute: '/splash',
    );
  }
}
