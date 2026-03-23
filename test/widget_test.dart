import 'package:campus_connect/screens/auth/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:campus_connect/main.dart';
import 'package:campus_connect/models/user_model.dart';
import 'package:campus_connect/services/auth_service.dart';
import 'package:campus_connect/services/notification_service.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => UserModel()),
          ChangeNotifierProvider(create: (_) => NotificationService()),
        ],
        child: const CampusConnectApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
  });

  testWidgets('User model initializes correctly', (WidgetTester tester) async {
    final userModel = UserModel();
    expect(userModel.isLoggedIn, false);

    userModel.loadMockUser();
    expect(userModel.isLoggedIn, true);
    expect(userModel.fullName, 'John Doe');
    expect(userModel.initials, 'JD');
  });

  testWidgets('Auth service login works', (WidgetTester tester) async {
    final authService = AuthService();
    expect(authService.isLoggedIn, false);

    final result = await authService.login('test@test.com', 'password123');
    expect(result, true);
    expect(authService.isLoggedIn, true);
  });
}