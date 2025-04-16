import 'dart:io';

void main() {
  final folders = [
    'lib/core/errors',
    'lib/core/usecases',
    'lib/core/utils',
    'lib/features/todo/data/models',
    'lib/features/todo/data/repositories',
    'lib/features/todo/domain/entities',
    'lib/features/todo/domain/repositories',
    'lib/features/todo/domain/usecases',
    'lib/features/todo/presentation/bloc',
    'lib/features/todo/presentation/pages',
    'lib/features/todo/presentation/widgets',
  ];

  final files = {
    // CORE
    'lib/core/errors/exceptions.dart': '''
class ServerException implements Exception {}

class CacheException implements Exception {}
''',
    'lib/core/usecases/usecase.dart': '''
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

class NoParams {}
''',
    'lib/core/utils/constants.dart': '''
class Constants {
  static const String appName = 'Clean Architecture Template';
}
''',

    // DATA
    'lib/features/todo/data/models/todo_model.dart': '''
class TodoModel {
  final String id;
  final String title;

  TodoModel({required this.id, required this.title});
}
''',
    'lib/features/todo/data/repositories/todo_repository_impl.dart': '''
import '../../domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  @override
  List<String> fetchTodos() {
    return ['Sample Todo 1', 'Sample Todo 2'];
  }
}
''',

    // DOMAIN
    'lib/features/todo/domain/entities/todo.dart': '''
class Todo {
  final String id;
  final String title;

  Todo({required this.id, required this.title});
}
''',
    'lib/features/todo/domain/repositories/todo_repository.dart': '''
abstract class TodoRepository {
  List<String> fetchTodos();
}
''',
    'lib/features/todo/domain/usecases/get_todos.dart': '''
import 'package:flutter_clean_architecture_template/core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';
import '../entities/todo.dart';

class GetTodos implements UseCase<List<Todo>, NoParams> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<List<Todo>> call(NoParams params) async {
    return await repository.fetchTodos();
  }
}
''',

    // PRESENTATION - BLOC
    'lib/features/todo/presentation/bloc/todo_bloc.dart': '''
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TodoEvent {}

class LoadTodosEvent extends TodoEvent {}

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoaded extends TodoState {
  final List<String> todos;
  TodoLoaded(this.todos);
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<LoadTodosEvent>((event, emit) {
      emit(TodoLoaded(['Example Todo']));
    });
  }
}
''',

    // PRESENTATION - PAGES
    'lib/features/todo/presentation/pages/todo_page.dart': '''
import 'package:flutter/material.dart';
import '../bloc/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(state.todos[index]));
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
''',
    'lib/features/todo/presentation/pages/another_page.dart': '''
import 'package:flutter/material.dart';

class AnotherPage extends StatelessWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Another Page')),
      body: const Center(child: Text('Another Page Content')),
    );
  }
}
''',

    // DEPENDENCY INJECTION
    'lib/injection_container.dart': '''
import 'package:get_it/get_it.dart';

import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/get_todos.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => TodoBloc());

  // Use cases
  sl.registerLazySingleton(() => GetTodos(sl()));

  // Repositories
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl());
}
''',

    // ROUTER
    'lib/router.dart': '''
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'features/todo/presentation/pages/todo_page.dart';
import 'features/todo/presentation/pages/another_page.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';
import 'injection_container.dart';

class AppRouter {
  static GoRouter get router {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => sl<TodoBloc>()..add(LoadTodosEvent()),
              child: const TodoPage(),
            );
          },
        ),
        GoRoute(
          path: '/another',
          builder: (context, state) => const AnotherPage(),
        ),
      ],
    );
  }
}
''',
  };

  for (var folder in folders) {
    Directory(folder).createSync(recursive: true);
  }

  files.forEach((path, content) {
    File(path).writeAsStringSync(content);
  });

  print('✅ Folder and file structure created successfully!');
}
