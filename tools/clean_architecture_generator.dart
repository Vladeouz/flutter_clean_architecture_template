import 'dart:io';

void main() async {
  final base = 'lib/features/todo';

  final files = {
    '$base/domain/entities/todo_entity.dart': '''
import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String title;
  final bool isCompleted;

  const TodoEntity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, title, isCompleted];
}
''',
    '$base/domain/repositories/todo_repository.dart': '''
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos();
}
''',
    '$base/domain/usecases/get_todos.dart': '''
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodos {
  final TodoRepository repository;

  GetTodos(this.repository);

  Future<List<TodoEntity>> call() async {
    return repository.getTodos();
  }
}
''',
    '$base/data/models/todo_model.dart': '''
import '../../domain/entities/todo_entity.dart';

class TodoModel extends TodoEntity {
  const TodoModel({
    required super.id,
    required super.title,
    required super.isCompleted,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
''',
    '$base/data/datasources/todo_local_datasource.dart': '''
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
''',
    '$base/data/repositories/todo_repository_impl.dart': '''
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl(this.localDataSource);

  @override
  Future<List<TodoEntity>> getTodos() async {
    return localDataSource.getTodos();
  }
}
''',
    '$base/presentation/bloc/todo_bloc.dart': '''
import 'package:flutter_bloc/flutter_bloc.dart';
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
        final todos = await getTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoError("Failed to load todos"));
      }
    });
  }
}
''',
    '$base/presentation/bloc/todo_event.dart': '''
part of 'todo_bloc.dart';

abstract class TodoEvent {}

class LoadTodosEvent extends TodoEvent {}
''',
    '$base/presentation/bloc/todo_state.dart': '''
part of 'todo_bloc.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoEntity> todos;
  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}
''',
    '$base/presentation/pages/todo_page.dart': '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Icon(
                    todo.isCompleted ? Icons.check : Icons.close,
                    color: todo.isCompleted ? Colors.green : Colors.red,
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
''',
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    await file.create(recursive: true);
    await file.writeAsString(entry.value);
  }

  print('✅ Semua file Todo feature berhasil digenerate!');
}
