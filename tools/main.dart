import 'dart:io';
import 'delete_features.dart';
import 'feature_generator.dart';

void main() {
  stdout.write('Pilih aksi (create/delete): ');
  final action = stdin.readLineSync()?.toLowerCase();

  if (action == 'create') {
    createFeature();
  } else if (action == 'delete') {
    deleteFeature();
  } else {
    print('Aksi tidak valid.');
  }
}
