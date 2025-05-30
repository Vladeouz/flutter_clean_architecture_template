import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_template/core/usecases/usecases.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/get_todos.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;

  TodoBloc(this.getTodos) : super(TodoInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await getTodos(NoParams());
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError("Failed to load todos"));
      }
    });
  }
}
