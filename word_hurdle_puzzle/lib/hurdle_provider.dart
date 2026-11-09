
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words;
import 'wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();

  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];

  String targetWord = '';

  int count = 0;
  int index = 0;
  final int lettersPerRow = 5;
  final int totalAttempts = 6;
  int attempts = 0;

  bool wins = false;

  bool get isValidWord =>
    totalWords.contains(rowInputs.join('').toLowerCase());

  bool get shouldCheckForAnswer =>
    rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts >= totalAttempts;

  // Inicializácia hry
  void init() {
    if (totalWords.isNotEmpty) return;

    totalWords = words.all
        .where((element) => element.length == 5)
        .toList();

    generateBoard();
    generateRandomWord();

    notifyListeners();
  }

  // Generovanie hernej mriežky
  void generateBoard() {
    hurdleBoard = List.generate(
      30,
      (index) => Wordle(letter: ''),
    );
  }

  // Generovanie náhodného cieľového slova
  void generateRandomWord() {
    targetWord = totalWords[
      random.nextInt(totalWords.length)
    ].toUpperCase();

    print(targetWord);
  }

  void inputLetter(String letter) {
    if (count < lettersPerRow) {
      // pridanie písmena do zoznamu aktuálneho vstupu
      rowInputs.add(letter);

      // vloženie písmena do príslušnej pozície v hernej doske
      hurdleBoard[index] = Wordle(letter: letter);

      // inkrementácia počítadiel
      count++;
      index++;

      // aktualizácia UI
      notifyListeners();
    }
  }

  void deleteLetter() {
  // Odstránenie posledného písmena zo vstupu
  if (rowInputs.isNotEmpty) {
    rowInputs.removeAt(rowInputs.length - 1);
  }

  // Odstránenie písmena z hernej mriežky
  if (count > 0) {
    hurdleBoard[index - 1] = Wordle(letter: '');

    count--;
    index--;
  }

  notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('');

    if (targetWord == input) {
      wins = true;
    } else {
      _markLettersOnBoard();

      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }

    notifyListeners();
  }

  void _markLettersOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }

  notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    // index = attempts * lettersPerRow;
    count = 0;
    rowInputs.clear();
  }

  void reset() {
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';

    generateBoard();
    generateRandomWord();

    notifyListeners();
  }
}
