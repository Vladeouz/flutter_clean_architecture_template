String localDatasourceTemplate(String pascalCaseFeature) => """
abstract class ${pascalCaseFeature}LocalDataSource {
  // define methods here
}

class Dummy${pascalCaseFeature}LocalDataSource implements ${pascalCaseFeature}LocalDataSource {
  // implement dummy methods
}
""";

String remoteDatasourceTemplate(String pascalCaseFeature) => """
abstract class ${pascalCaseFeature}RemoteDataSource {
  // define methods here
}

class Dummy${pascalCaseFeature}RemoteDataSource implements ${pascalCaseFeature}RemoteDataSource {
  // implement dummy methods
}
""";

// Tambahin template lainnya kalau mau, atau tetap di create_feature.dart
