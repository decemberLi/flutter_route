typeConvert(dynamic value, Type to) {
  var from = value.runtimeType;
  if (from == String) {
    if (to == int) {
      return int.parse(value);
    } else if (to == double) {
      return double.parse(value);
    } else if (to == bool) {
      return value == 'true';
    }
  }

  return value;
}
