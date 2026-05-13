import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/detail/spot_detail_screen.dart';
import '../../presentation/screens/detail/station_detail_screen.dart';
import '../../presentation/screens/detail/ubike_detail_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/categories/categories_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/settings/register_store_screen.dart';
import '../../presentation/screens/stamps/stamps_screen.dart';
import '../../presentation/screens/favorites/favorites_screen.dart';
import '../../presentation/screens/activities/activities_screen.dart';
import '../../presentation/screens/coupons/coupons_screen.dart';
import '../../presentation/screens/announcements/announcements_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.spotDetail}/:spotId',
        builder: (context, state) => SpotDetailScreen(
          spotId: state.pathParameters['spotId']!,
        ),
      ),
      GoRoute(
        path: '${AppRoutes.stationDetail}/:stationId/:type',
        builder: (context, state) => StationDetailScreen(
          stationId: state.pathParameters['stationId']!,
          type: state.pathParameters['type']!,
        ),
      ),
      GoRoute(
        path: '${AppRoutes.ubikeDetail}/:stationId',
        builder: (context, state) => UbikeDetailScreen(
          stationId: state.pathParameters['stationId']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerStore,
        builder: (context, state) => const RegisterStoreScreen(),
      ),
      GoRoute(
        path: AppRoutes.stamps,
        builder: (context, state) => const StampsScreen(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRoutes.activities,
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        path: AppRoutes.coupons,
        builder: (context, state) => const CouponsScreen(),
      ),
      GoRoute(
        path: AppRoutes.announcements,
        builder: (context, state) => const AnnouncementsScreen(),
      ),
    ],
  );
});

class AppRoutes {
  static const splash = '/';
  static const map = '/map';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const spotDetail = '/spot';
  static const stationDetail = '/station';
  static const ubikeDetail = '/ubike';
  static const search = '/search';
  static const categories = '/categories';
  static const settings = '/settings';
  static const registerStore = '/settings/register-store';
  static const stamps = '/stamps';
  static const favorites = '/favorites';
  static const activities = '/activities';
  static const coupons = '/coupons';
  static const announcements = '/announcements';
}