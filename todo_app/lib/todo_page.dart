import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo_provider.dart';

/// Hlavná stránka aplikácie so zoznamom úloh (To-Do list).
/// Je to StatelessWidget – všetok stav je v TodoProvider.
class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  /// Zobrazí spodné okno (BottomSheet) na pridanie novej úlohy
  void _showAddTodoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddTodoSheet(),
    );
  }

  /// Hlavné rozloženie obrazovky
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Umiestnenie tlačidla v strede dole
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Tlačidlo na pridanie úlohy
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoSheet(context),
        child: const Icon(Icons.add),
      ),

      // Horný AppBar s názvom
      appBar: AppBar(title: const Text('My Todos')),

      // Obsah obrazovky – Consumer sa prekreslí pri každom notifyListeners()
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.isEmpty) {
            return const Center(child: Text('Nothing to do!'));
          }

          final todos = provider.todos;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onChanged: (value) => provider.toggleTodoStatus(index, value),
                onDelete: () => provider.removeTodo(index),
              );
            },
          );
        },
      ),
    );
  }
}

/// Obsah BottomSheetu – textové pole, výber priority a tlačidlo SAVE.
/// StatefulWidget je tu len kvôli TextEditingController (treba ho uvoľniť
/// v dispose); setState() sa nikde nepoužíva.
class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
  // Kontrolér na prístup k hodnote z TextFieldu
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Funkcia, ktorá sa zavolá pri kliknutí na "SAVE"
  void _save() {
    final added = context.read<TodoProvider>().addTodo(_controller.text);

    if (!added) {
      showMsg(context, 'Input field must not be empty');
      return;
    }

    // Zatvorenie spodného okna (BottomSheet)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // odsadenie od klávesnice, aby ju BottomSheet neprekryl
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Textové pole pre názov úlohy
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'What to do?'),
          ),

          // Nadpis "Select Priority"
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Select Priority'),
          ),

          // Tri rádiové tlačidlá – výber priority (stav je v Provideri)
          Consumer<TodoProvider>(
            builder: (context, provider, child) => RadioGroup<TodoPriority>(
              groupValue: provider.priority,
              onChanged: (value) => provider.setPriority(value!),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<TodoPriority>(value: TodoPriority.Low),
                  Text('Low'),
                  Radio<TodoPriority>(value: TodoPriority.Normal),
                  Text('Normal'),
                  Radio<TodoPriority>(value: TodoPriority.High),
                  Text('High'),
                ],
              ),
            ),
          ),

          // Tlačidlo na uloženie úlohy
          ElevatedButton(onPressed: _save, child: const Text('SAVE')),
        ],
      ),
    );
  }
}

/// Pomocná funkcia – zobrazí dialógové okno s chybovou hláškou
void showMsg(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Caution!'),
      content: Text(s),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CLOSE'),
        ),
      ],
    ),
  );
}

/// Dobrovoľné rozšírenie – farba podľa priority
Color priorityColor(TodoPriority priority) {
  switch (priority) {
    case TodoPriority.Low:
      return Colors.green;
    case TodoPriority.Normal:
      return Colors.orange;
    case TodoPriority.High:
      return Colors.red;
  }
}

/// Widget pre jednotlivú úlohu – riadok so zaškrtávacím políčkom
class TodoItem extends StatelessWidget {
  final MyTodo todo;
  final void Function(bool) onChanged;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = priorityColor(todo.priority);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border(left: BorderSide(color: color, width: 6)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          todo.name,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Priority: ${todo.priority.name}',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
        value: todo.completed,
        onChanged: (value) => onChanged(value!),
        secondary: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete',
          onPressed: onDelete,
        ),
      ),
    );
  }
}
