import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  List<TodoModel> getTodos();
}

class DummyTodoLocalDataSource implements TodoLocalDataSource {
  @override
  List<TodoModel> getTodos() {
    return [
      const TodoModel(id: 1, title: 'Buy milk', isCompleted: false),
      const TodoModel(id: 2, title: 'Do homework', isCompleted: true),
    ];
  }
}
