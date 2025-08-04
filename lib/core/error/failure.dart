abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ServerException extends Failure {
  const ServerException(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class PackageException extends Failure {
  const PackageException(super.message);
}

class PackageFailure extends Failure {
  const PackageFailure(super.message);
}
