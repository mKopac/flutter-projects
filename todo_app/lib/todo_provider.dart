import 'package:flutter/material.dart';

/// Enum (výčtový typ) – definovanie troch úrovní priority
enum TodoPriority { Low, Normal, High }

/// Model (dátová trieda) pre jednu úlohu
class MyTodo {
  int id; // unikátne ID úlohy
  String name; // názov úlohy
  bool completed; // či je úloha dokončená
  TodoPriority priority; // priorita úlohy

  MyTodo({
    required this.id,
    required this.name,
    this.completed = false,
    required this.priority,
  });
}

/// Centralizovaná správa stavu aplikácie.
/// Všetky dáta (zoznam úloh, zvolená priorita) a logika sú tu,
/// namiesto setState() sa volá notifyListeners().
class TodoProvider extends ChangeNotifier {
  // Zoznam všetkých úloh (v pamäti aplikácie)
  final List<MyTodo> _todos = [];

  // Predvolená priorita novej úlohy
  TodoPriority _priority = TodoPriority.Normal;

  /// Zoznam úloh len na čítanie – zvonka sa nedá meniť priamo
  List<MyTodo> get todos => List.unmodifiable(_todos);

  TodoPriority get priority => _priority;

  bool get isEmpty => _todos.isEmpty;

  /// Zmena zvolenej priority v BottomSheete
  void setPriority(TodoPriority value) {
    _priority = value;
    notifyListeners();
  }

  /// Pridá novú úlohu do zoznamu.
  /// Vráti false, ak je názov prázdny (úloha sa nepridá).
  bool addTodo(String name) {
    if (name.trim().isEmpty) return false;

    _todos.add(
      MyTodo(
        id: DateTime.now().millisecondsSinceEpoch, // unikátne ID
        name: name.trim(),
        priority: _priority,
      ),
    );
    notifyListeners();
    return true;
  }

  /// Zmena stavu úlohy (označenie ako splnená / nesplnená)
  void toggleTodoStatus(int index, bool value) {
    _todos[index].completed = value;
    notifyListeners();
  }

  /// Dobrovoľné rozšírenie – odstránenie úlohy
  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}
