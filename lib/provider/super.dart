import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuperUserNotifier extends StateNotifier<bool> {
  SuperUserNotifier() : super(false);

  void loginAsSuperUser(String password) {
    if (password == 'SuperSecret') {
      state = true;
    } else {
      throw Exception('Invalid Password');
    }
  }

  void logout() => state = false;
}

final isSuperUserProvider = StateNotifierProvider<SuperUserNotifier, bool>((ref) => SuperUserNotifier());
