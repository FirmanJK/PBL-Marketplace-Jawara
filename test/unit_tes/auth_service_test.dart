import 'package:flutter_test/flutter_test.dart';
import 'package:jawara/services/auth_service.dart';
import 'package:jawara/models/auth_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService - Unit Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('AuthService is singleton - same instance', () {
      final auth1 = AuthService();
      final auth2 = AuthService();
      expect(identical(auth1, auth2), true);
    });

    test('isLoggedIn should be false initially', () {
      expect(authService.isLoggedIn, false);
    });

    test('currentUser should be null initially', () {
      expect(authService.currentUser, null);
    });

    test('accessToken should be null initially', () {
      expect(authService.accessToken, null);
    });

    test('currentRole should be null when no user logged in', () {
      expect(authService.currentRole, null);
    });

    test('login with invalid credentials should throw ErrorResponse', () async {
      expect(
        () => authService.login('wrong@email.com', 'wrongpass'),
        throwsA(isA<ErrorResponse>()),
      );
    });
  });
}
