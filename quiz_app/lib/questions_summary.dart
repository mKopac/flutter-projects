
import 'package:flutter/material.dart';
import 'data/questions.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary({
    super.key,
    required this.selectedAnswers,
  });

  final List<String> selectedAnswers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < questions.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          selectedAnswers[i] ==
                                  questions[i]['correct_answer']
                              ? Colors.green
                              : Colors.red,
                      child: Text('${i + 1}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[i]['question'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tvoja odpoveď: ${selectedAnswers[i]}',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            'Správna odpoveď: '
                            '${questions[i]['correct_answer']}',
                            style: const TextStyle(
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
