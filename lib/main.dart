import 'package:flutter/material.dart';
import 'package:to_do_list/todo_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoPage();
  }
}


