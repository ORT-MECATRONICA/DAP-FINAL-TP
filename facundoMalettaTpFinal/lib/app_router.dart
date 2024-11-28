import 'package:clase18_4/presentation/Screens/home_screen.dart';
import 'package:clase18_4/presentation/Screens/Login_screen.dart';
import 'package:clase18_4/presentation/Screens/pais_info.dart';
import 'package:clase18_4/presentation/Screens/pais_form.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: '/new',
      name: 'Nuevo pais',
      builder: (context, state) {
        return PaisForm();
      },
    ),
    GoRoute(
      path: '/edit/:pais_id',
      name: 'Editar pais',
      builder: (context, state) {
        final paisId = state.pathParameters['pais_id'] ?? '';
        return PaisForm(paisId: paisId);
      },
    ),
    GoRoute(
      name: InfopaisesScreen.name,
      path: '/info/:pais_id',
      builder: (context, state) {
        final paisId = state.pathParameters['pais_id'] ?? '';
        return InfopaisesScreen(paisId: paisId);
      },
    ),
  ],
);
