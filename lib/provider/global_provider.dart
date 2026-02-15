import 'package:flutter_riverpod/legacy.dart';

final authUserProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
final userNameProvider = StateProvider<String?>((ref) => null);
final navigationProvider = StateProvider<String?>((ref) => "MARKETPLACE");
