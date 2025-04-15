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
