import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import package untuk Bloc
import 'features/todo/presentation/pages/todo_page.dart';
import 'features/todo/presentation/pages/another_page.dart'; // halaman contoh lain
import 'features/todo/presentation/bloc/todo_bloc.dart'; // Import TodoBloc

import 'injection_container.dart'; // Import dependency injection
// NEW_IMPORT_HERE

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // opsional untuk debugging
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            create:
                (_) =>
                    sl<TodoBloc>()..add(
                      LoadTodosEvent(),
                    ), // Memberikan TodoBloc ke halaman ini
            child: const TodoPage(),
          );
        },
      ),
      GoRoute(
        path: '/another',
        builder: (context, state) => const AnotherPage(),
      ),
      // NEW_ROUTE_HERE
    ],
  );
}
