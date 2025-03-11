import 'dart:developer';

void logg(dynamic v, [String? name]) {
  log('$v', name: name?.toUpperCase() ?? 'ECO_GESTE');
}
