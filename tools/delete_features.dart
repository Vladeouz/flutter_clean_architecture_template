import 'dart:io';
import 'utils.dart';

void deleteFeature() {
  stdout.write('Masukkan nama feature yang mau dihapus: ');
  final featureName = stdin.readLineSync()?.toLowerCase();
  if (featureName == null || featureName.isEmpty) {
    print('Nama feature tidak boleh kosong.');
    return;
  }

  final pascalCaseFeature = toPascalCase(featureName);
  final kebabCaseFeature = toKebabCase(featureName);

  final basePath = 'lib/features/$featureName';

  final dir = Directory(basePath);
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    print('✅ Folder "$basePath" dihapus');
  } else {
    print('⚠️ Folder "$basePath" tidak ditemukan');
  }

  final injectionFile = File('lib/injection_container.dart');
  if (injectionFile.existsSync()) {
    var content = injectionFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r"import 'features/" + featureName + r"[^;]+;\n"),
      '',
    );
    content = content.replaceAll(
      RegExp(
        r"  // Features - " +
            pascalCaseFeature +
            r"[\s\S]*?(?=\n\s*// NEW_DEPENDENCY_HERE)",
      ),
      '',
    );
    injectionFile.writeAsStringSync(content);
    print('✅ injection_container.dart dibersihkan');
  }

  final routerFile = File('lib/router.dart');
  if (routerFile.existsSync()) {
    var content = routerFile.readAsStringSync();
    content = content.replaceAll(
      RegExp(r"import 'features/" + featureName + r"[^;]+;\n"),
      '',
    );
    content = content.replaceAll(
      RegExp(
        r"    GoRoute\([\s\S]*?path: '/" + kebabCaseFeature + r"'[\s\S]*?\),\n",
      ),
      '',
    );
    routerFile.writeAsStringSync(content);
    print('✅ router.dart dibersihkan');
  }

  print('\n✅ Feature "$featureName" berhasil dihapus!');
}
