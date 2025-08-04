import 'package:flutter_clean_architecture_template/core/styles/app_loading_styles.dart';
import 'package:get_it/get_it.dart';
// NEW_IMPORT_HERE

import 'package:flutter_clean_architecture_template/core/utils/dio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/todo/data/datasources/todo_local_datasource.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/get_todos.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';

final sl = GetIt.instance;

void init() async {
  // NEW_DEPENDENCY_HERE

  // Core
  sl.registerLazySingleton(() => DioService());

  // Features - Todo
  // Bloc
  sl.registerFactory(() => TodoBloc(sl()));

  // Usecase
  sl.registerLazySingleton(() => GetTodos(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  // Data source
  sl.registerLazySingleton<TodoLocalDataSource>(
    () => DummyTodoLocalDataSource(),
  );

  // Flutter Easy Loading
  configLoading();

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}
