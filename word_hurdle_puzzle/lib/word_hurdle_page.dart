
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'hurdle_provider.dart';
import 'wordle_view.dart';
import 'keyboard_view.dart';
import 'helper_functions.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<HurdleProvider>(
        context,
        listen: false,
      ).init();
    });
  }

  void _handleInput(HurdleProvider provider) {
    // Kontrola platnosti slova
    if (!provider.isValidWord) {
      showMsg(context, 'Not a word in my dictionary');
      return;
    }

    // Kontrola počtu písmen
    if (provider.shouldCheckForAnswer) {
      provider.checkAnswer();
    } else {
      return;
    }

    // Výhra
    if (provider.wins) {
      showResult(
        context: context,
        title: 'You Win!!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );

    // Prehra
    } else if (provider.noAttemptsLeft) {
      showResult(
        context: context,
        title: 'You lost!!',
        body: 'The word was ${provider.targetWord}',
        onPlayAgain: () {
          Navigator.pop(context);
          provider.reset();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            // Herná mriežka
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.70,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: provider.hurdleBoard.length,
                      itemBuilder: (context, index) {
                        final wordle = provider.hurdleBoard[index];

                        return WordleView(wordle: wordle);
                      },
                    );
                  },
                ),
              ),
            ),

            // Virtuálna klávesnica
            Consumer<HurdleProvider>(
              builder: (context, provider, child) {
                return KeyboardView(
                  excludedLetters: provider.excludedLetters,
                  onPressed: (value) {
                    provider.inputLetter(value);
                  },
                );
              },
            ),

            // Tlačidlá DELETE a SUBMIT
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // DELETE
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                      },
                      child: const Text('DELETE'),
                    ),

                    // SUBMIT
                    ElevatedButton(
                      onPressed: () {
                        _handleInput(provider);
                      },
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
