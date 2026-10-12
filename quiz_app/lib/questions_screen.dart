
import 'package:flutter/material.dart';
import 'data/questions.dart';
import 'models/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
  });

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = 0;
  }

  void selectAnswer(String answer) {
    widget.onSelectAnswer(answer);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    final answers = List<String>.from(
      currentQuestion['answers'] as List,
    )..shuffle();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Otázka ${currentQuestionIndex + 1} '
                'z ${questions.length}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                currentQuestion['question'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ...answers.map((answer) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnswerButton(
                    answer: answer,
                    onTap: () => selectAnswer(answer),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
