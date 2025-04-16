import 'dart:io';

void main() {
  stdout.write('Masukkan nama fitur baru: ');
  final feature = stdin.readLineSync()!.toLowerCase();
  final className = _capitalize(feature);
  final path = 'lib/features/$feature';

  final folders = [
    '$path/data/datasources',
    '$path/data/repositories',
    '$path/domain/entities',
    '$path/domain/repositories',
    '$path/domain/usecases',
    '$path/presentation/bloc',
    '$path/presentation/pages',
  ];

  final files = {
    '$path/domain/entities/$feature.dart': '''
class ${className}Entity {
  final String id;
  final String name;

  ${className}Entity({required this.id, required this.name});
}
''',
    '$path/domain/repositories/${feature}_repository.dart': '''
import '../entities/$feature.dart';

abstract class ${className}Repository {
  Future<List<${className}Entity>> get${className}s();
}
''',
    '$path/domain/usecases/get_${feature}s.dart': '''
import '../../../../core/usecases/usecase.dart';
import '../entities/$feature.dart';
import '../repositories/${feature}_repository.dart';

class Get${className}s implements UseCase<List<${className}Entity>, void> {
  final ${className}Repository repository;

  Get${className}s(this.repository);

  @override
  Future<List<${className}Entity>> call(void params) {
    return repository.get${className}s();
  }
}
''',
    '$path/data/datasources/${feature}_remote_datasource.dart': '''
abstract class ${className}RemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchRemote${className}s();
}
''',
    '$path/data/datasources/${feature}_local_datasource.dart': '''
abstract class ${className}LocalDataSource {
  Future<List<Map<String, dynamic>>> fetchLocal${className}s();
}
''',
    '$path/data/repositories/${feature}_repository_impl.dart': '''
import '../../domain/entities/$feature.dart';
import '../../domain/repositories/${feature}_repository.dart';
import '../datasources/${feature}_remote_datasource.dart';
import '../datasources/${feature}_local_datasource.dart';

class ${className}RepositoryImpl implements ${className}Repository {
  final ${className}RemoteDataSource remote;
  final ${className}LocalDataSource local;

  ${className}RepositoryImpl(this.remote, this.local);

  @override
  Future<List<${className}Entity>> get${className}s() async {
    final data = await remote.fetchRemote${className}s();
    return data.map((e) => ${className}Entity(id: e['id'], name: e['name'])).toList();
  }
}
''',
    '$path/presentation/bloc/${feature}_bloc.dart': '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_${feature}s.dart';

abstract class ${className}Event {}
class Load${className}sEvent extends ${className}Event {}

abstract class ${className}State {}
class ${className}Initial extends ${className}State {}
class ${className}Loaded extends ${className}State {
  final List data;
  ${className}Loaded(this.data);
}

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
  final Get${className}s get${className}s;

  ${className}Bloc(this.get${className}s) : super(${className}Initial()) {
    on<Load${className}sEvent>((event, emit) async {
      final items = await get${className}s.call(null);
      emit(${className}Loaded(items));
    });
  }
}
''',
    '$path/presentation/pages/${feature}_page.dart': '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/${feature}_bloc.dart';

class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$className Page')),
      body: BlocBuilder<${className}Bloc, ${className}State>(
        builder: (context, state) {
          if (state is ${className}Loaded) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (_, i) => ListTile(title: Text(state.data[i].name)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
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

  _appendInjection(feature, className);
  _appendRoute(feature, className);

  print('✅ Fitur "$feature" berhasil digenerate!');
}

String _capitalize(String text) => text[0].toUpperCase() + text.substring(1);

void _appendInjection(String feature, String className) {
  final file = File('lib/injection_container.dart');
  final content = file.readAsStringSync();

  final newLines = '''
  // $className Feature
  sl.registerFactory(() => ${className}Bloc(sl()));
  sl.registerLazySingleton(() => Get${className}s(sl()));
  sl.registerLazySingleton<${className}Repository>(() => ${className}RepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<${className}RemoteDataSource>(() => Your${className}RemoteDataSourceImpl());
  sl.registerLazySingleton<${className}LocalDataSource>(() => Your${className}LocalDataSourceImpl());
''';

  final updated = content.replaceFirst(
    'Future<void> init() async {',
    'Future<void> init() async {\n$newLines',
  );

  file.writeAsStringSync(updated);
}

void _appendRoute(String feature, String className) {
  final file = File('lib/router.dart');
  final content = file.readAsStringSync();

  final importLine =
      "import 'features/$feature/presentation/pages/${feature}_page.dart';";
  final routeEntry = '''
        GoRoute(
          path: '/$feature',
          builder: (context, state) {
            return BlocProvider(
              create: (_) => sl<${className}Bloc>()..add(Load${className}sEvent()),
              child: const ${className}Page(),
            );
          },
        ),
''';

  final newContent = content
      .replaceFirst('// NEW_IMPORT_HERE', "$importLine\n// NEW_IMPORT_HERE")
      .replaceFirst(
        '// NEW_ROUTE_HERE',
        "$routeEntry\n        // NEW_ROUTE_HERE",
      );

  file.writeAsStringSync(newContent);
}
