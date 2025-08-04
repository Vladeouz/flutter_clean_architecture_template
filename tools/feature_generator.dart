import 'dart:io';

void createFeature() {
  stdout.write('Masukkan nama feature (contoh: sign_in): ');
  final featureName = stdin.readLineSync()?.toLowerCase();
  if (featureName == null || featureName.isEmpty) {
    print('Nama feature tidak boleh kosong.');
    return;
  }

  stdout.write('Butuh Local DataSource? (y/n): ');
  final useLocal = stdin.readLineSync()?.toLowerCase() == 'y';

  stdout.write('Butuh Remote DataSource? (y/n): ');
  final useRemote = stdin.readLineSync()?.toLowerCase() == 'y';

  String toPascalCase(String text) {
    return text
        .split('_')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join();
  }

  String toKebabCase(String text) {
    return text.replaceAll('_', '-');
  }

  final pascalCaseFeature = toPascalCase(featureName);
  final kebabCaseFeature = toKebabCase(featureName);

  final basePath = 'lib/features/$featureName';
  final folders = [
    if (useLocal) '$basePath/data/datasources',
    if (useRemote) '$basePath/data/datasources',
    '$basePath/data/models',
    '$basePath/data/repositories',
    '$basePath/domain/entities',
    '$basePath/domain/repositories',
    '$basePath/domain/usecases',
    '$basePath/presentation/bloc',
    '$basePath/presentation/pages',
    '$basePath/presentation/widgets',
  ];

  final files = <String, String>{
    if (useLocal)
      '$basePath/data/datasources/${featureName}_local_datasource.dart':
          """abstract class ${pascalCaseFeature}LocalDataSource {
  // define methods here
}

class ${pascalCaseFeature}LocalDataSourceImpl implements ${pascalCaseFeature}LocalDataSource {
  // implement dummy methods
}
""",

    if (useRemote)
      '$basePath/data/datasources/${featureName}_remote_datasource.dart':
          """abstract class ${pascalCaseFeature}RemoteDataSource {
  // define methods here
}

class ${pascalCaseFeature}RemoteDataSourceImpl implements ${pascalCaseFeature}RemoteDataSource {
  // implement dummy methods
}
""",

    '$basePath/data/models/${featureName}_model.dart':
        """import '../../domain/entities/${featureName}.dart';

class ${pascalCaseFeature}Model extends ${pascalCaseFeature} {
  ${pascalCaseFeature}Model({required super.id, required super.name});

  factory ${pascalCaseFeature}Model.fromJson(Map<String, dynamic> json) {
    return ${pascalCaseFeature}Model(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
""",

    '$basePath/data/repositories/${featureName}_repository_impl.dart':
        """import '../../domain/repositories/${featureName}_repository.dart';

class ${pascalCaseFeature}RepositoryImpl implements ${pascalCaseFeature}Repository {
  @override
  List<String> fetchData() => ['Example data'];
}
""",

    '$basePath/domain/entities/${featureName}.dart':
        """class ${pascalCaseFeature} {
  final String id;
  final String name;

  ${pascalCaseFeature}({required this.id, required this.name});
}
""",

    '$basePath/domain/repositories/${featureName}_repository.dart':
        """abstract class ${pascalCaseFeature}Repository {
  List<String> fetchData();
}
""",

    '$basePath/domain/usecases/get_${featureName}s.dart':
        """import 'package:nupay/core/usecases/usecases.dart';
import '../repositories/${featureName}_repository.dart';

class Get${pascalCaseFeature}s extends UseCase<List<String>, NoParams> {
  final ${pascalCaseFeature}Repository repository;

  Get${pascalCaseFeature}s(this.repository);

  @override
  Future<List<String>> call(NoParams params) async {
    return repository.fetchData();
  }
}
""",

    '$basePath/presentation/bloc/${featureName}_bloc.dart':
        """import 'package:flutter_bloc/flutter_bloc.dart';
import '${featureName}_event.dart';
import '${featureName}_state.dart';

class ${pascalCaseFeature}Bloc extends Bloc<${pascalCaseFeature}Event, ${pascalCaseFeature}State> {
  ${pascalCaseFeature}Bloc() : super(${pascalCaseFeature}Initial()) {
    on<Load${pascalCaseFeature}sEvent>((event, emit) {
      emit(${pascalCaseFeature}Loaded(['Item 1', 'Item 2']));
    });
  }
}
""",

    '$basePath/presentation/bloc/${featureName}_event.dart':
        """abstract class ${pascalCaseFeature}Event {}

class Load${pascalCaseFeature}sEvent extends ${pascalCaseFeature}Event {}
""",

    '$basePath/presentation/bloc/${featureName}_state.dart':
        """abstract class ${pascalCaseFeature}State {}

class ${pascalCaseFeature}Initial extends ${pascalCaseFeature}State {}

class ${pascalCaseFeature}Loaded extends ${pascalCaseFeature}State {
  final List<String> items;
  ${pascalCaseFeature}Loaded(this.items);
}
""",

    '$basePath/presentation/pages/${featureName}_page.dart':
        """import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/${featureName}_bloc.dart';
import '../bloc/${featureName}_state.dart';

class ${pascalCaseFeature}Page extends StatelessWidget {
  const ${pascalCaseFeature}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$pascalCaseFeature Page')),
      body: BlocBuilder<${pascalCaseFeature}Bloc, ${pascalCaseFeature}State>(
        builder: (context, state) {
          if (state is ${pascalCaseFeature}Loaded) {
            return ListView(
              children: state.items.map((e) => ListTile(title: Text(e))).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
""",
  };

  for (var folder in folders) {
    Directory(folder).createSync(recursive: true);
  }

  files.forEach((path, content) {
    File(path).writeAsStringSync(content);
  });

  final injectionFile = File('lib/injection_container.dart');
  if (injectionFile.existsSync()) {
    var content = injectionFile.readAsStringSync();
    content = content.replaceFirst(
      '// NEW_IMPORT_HERE',
      "import 'features/$featureName/data/repositories/${featureName}_repository_impl.dart';\n" +
          "import 'features/$featureName/domain/repositories/${featureName}_repository.dart';\n" +
          "import 'features/$featureName/domain/usecases/get_${featureName}s.dart';\n" +
          "import 'features/$featureName/presentation/bloc/${featureName}_bloc.dart';\n" +
          (useLocal
              ? "import 'features/$featureName/data/datasources/${featureName}_local_datasource.dart';\n"
              : '') +
          (useRemote
              ? "import 'features/$featureName/data/datasources/${featureName}_remote_datasource.dart';\n"
              : '') +
          '// NEW_IMPORT_HERE',
    );

    content = content.replaceFirst(
      '// NEW_DEPENDENCY_HERE',
      "\n  // Features - $pascalCaseFeature\n" +
          "  // Bloc\n  sl.registerFactory(() => ${pascalCaseFeature}Bloc());\n" +
          "  // Usecase\n  sl.registerLazySingleton(() => Get${pascalCaseFeature}s(sl()));\n" +
          "  // Repository\n  sl.registerLazySingleton<${pascalCaseFeature}Repository>(() => ${pascalCaseFeature}RepositoryImpl());\n" +
          (useLocal
              ? "  // Data source\n  sl.registerLazySingleton<${pascalCaseFeature}LocalDataSource>(() => ${pascalCaseFeature}LocalDataSourceImpl());\n"
              : '') +
          (useRemote
              ? "  // Data source\n  sl.registerLazySingleton<${pascalCaseFeature}RemoteDataSource>(() => ${pascalCaseFeature}RemoteDataSourceImpl());\n"
              : '') +
          '\n  // NEW_DEPENDENCY_HERE',
    );

    injectionFile.writeAsStringSync(content);
  }

  final routerFile = File('lib/router.dart');
  if (routerFile.existsSync()) {
    var content = routerFile.readAsStringSync();
    content = content.replaceFirst(
      '// NEW_IMPORT_PAGE_HERE',
      "import 'features/$featureName/presentation/pages/${featureName}_page.dart';\n" +
          "import 'features/$featureName/presentation/bloc/${featureName}_bloc.dart';\n" +
          "import 'features/$featureName/presentation/bloc/${featureName}_event.dart';\n" +
          '// NEW_IMPORT_PAGE_HERE',
    );

    content = content.replaceFirst(
      '// NEW_ROUTE_HERE',
      "    GoRoute(\n" +
          "      path: '/$kebabCaseFeature',\n" +
          "      builder: (context, state) => BlocProvider(\n" +
          "        create: (_) => sl<${pascalCaseFeature}Bloc>()..add(Load${pascalCaseFeature}sEvent()),\n" +
          "        child: const ${pascalCaseFeature}Page(),\n" +
          "      ),\n" +
          "    ),\n\n" +
          '    // NEW_ROUTE_HERE',
    );

    routerFile.writeAsStringSync(content);
  }

  print('\n✅ Feature "$featureName" berhasil dibuat dan diinject otomatis!');
}
