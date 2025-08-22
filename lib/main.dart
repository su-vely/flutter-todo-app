import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/firebase_options.dart';
import 'package:flutter_todo_app/home_page.dart';

void main() async {
  // 플러터에서 비동기 함수 사용하려면 WidgetsFlutterBinding 이라는 객체가 필요한데
  // 이 객체는 runApp 함수 내에서 생성을 해줌
  // 따라서 runApp 함수 전에 비동기 함수 실행하려면
  // WidgetsFlutterBinding 객체를 생성해줘야되는데
  // WidgetsFlutterBinding 클래스 내에 있는 ensureInitialized 함수가
  // 객체를 생성해주는 역할을 함

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
