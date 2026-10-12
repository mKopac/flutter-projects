
import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'start_screen.dart';
import 'questions_screen.dart';
import 'results_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  String? activeScreen = 'start';
  final List<String> selectedAnswers = [];

  void startQuiz() {
    setState(() {
      selectedAnswers.clear();
      activeScreen = 'questions';
    });
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);

    setState(() {
      if (selectedAnswers.length == questions.length) {
        activeScreen = 'results';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    if (activeScreen == 'start') {
      screen = StartScreen(onStart: startQuiz);
    } else if (activeScreen == 'questions') {
      screen = QuestionsScreen(
        onSelectAnswer: chooseAnswer,
      );
    } else {
      screen = ResultsScreen(
        selectedAnswers: selectedAnswers,
        onRestart: startQuiz,
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF24104F),
              Color(0xFF5636A5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: screen),
      ),
    );
  }
}
