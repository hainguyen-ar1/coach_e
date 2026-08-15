import 'package:cyr_app_kit/cyr_app_kit.dart';
import 'package:coach_e/core/auth/auth_cubit.dart';
import 'package:coach_e/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoachEApp());
}

class CoachEApp extends StatefulWidget {
  const CoachEApp({super.key});

  @override
  State<CoachEApp> createState() => _CoachEAppState();
}

class _CoachEAppState extends State<CoachEApp> {
  late final AuthCubit _authCubit;
  late final AppRouterRefreshStream _routerRefresh;
  late final RouterConfig<Object> _router;

  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
    _routerRefresh = AppRouterRefreshStream(_authCubit.stream);
    _router = createAppRouter(
      authCubit: _authCubit,
      refreshListenable: _routerRefresh,
    );
  }

  @override
  void dispose() {
    _routerRefresh.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Coach E',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
