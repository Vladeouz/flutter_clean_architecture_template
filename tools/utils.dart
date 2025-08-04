String toPascalCase(String text) {
  return text.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}

String toKebabCase(String text) {
  return text.replaceAll('_', '-');
}
