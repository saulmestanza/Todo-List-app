import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/provider/login_provider.dart';

void main() {
  late LoginProvider authProvider;

  setUp(() {
    authProvider = LoginProvider();
    SharedPreferences.setMockInitialValues({}); // Mock SharedPreferences
  });

  group('LoginProvider', () {
    test('Initial login state should be false', () {
      expect(authProvider.isLoggedIn, false);
    });

    test('Successful login updates isLoggedIn to true', () async {
      final result = await authProvider.login('user', 'password');
      expect(result, true);
      expect(authProvider.isLoggedIn, true);
    });

    test('Invalid credentials should not log in', () async {
      final result = await authProvider.login('invalid', 'invalid');
      expect(result, false);
      expect(authProvider.isLoggedIn, false);
    });

    test('Logout should reset isLoggedIn to false', () async {
      await authProvider.login('user', 'password');
      expect(authProvider.isLoggedIn, true);

      await authProvider.logout();
      expect(authProvider.isLoggedIn, false);
    });

    test('SharedPreferences retains login state', () async {
      await authProvider.login('user', 'password');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isLoggedIn'), true);

      await authProvider.logout();
      expect(prefs.getBool('isLoggedIn'), null);
    });
  });
}
