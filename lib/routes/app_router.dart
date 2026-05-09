import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/widgets/layout/app_scaffold.dart';
import '../features/auth/agency_sign_up_screen.dart';
import '../features/auth/agent_sign_up_screen.dart';
import '../features/auth/partner_sign_up_screen.dart';
import '../features/auth/recruiting_sign_up_screen.dart';
import '../features/auth/sign_in_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/onboarding/get_started_screen.dart';
import 'app_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.getStarted,
  routes: [
    GoRoute(path: AppRoutes.getStarted, builder: (_, __) => const GetStartedScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const SignInScreen()),
    GoRoute(path: AppRoutes.signUpCustomer, builder: (_, __) => const SignUpScreen()),
    GoRoute(path: AppRoutes.signUpPartner, builder: (_, __) => const PartnerSignUpScreen()),
    GoRoute(path: AppRoutes.agentSignUp, builder: (_, __) => const AgentSignUpScreen()),
    GoRoute(path: AppRoutes.agencySignUp, builder: (_, __) => const AgencySignUpScreen()),
    GoRoute(path: AppRoutes.recruitingSignUp, builder: (_, __) => const RecruitingSignUpScreen()),
    GoRoute(path: AppRoutes.tabHome, builder: (_, __) => const AppScaffold(tabIndex: 0)),
    GoRoute(path: AppRoutes.tabSearch, builder: (_, __) => const AppScaffold(tabIndex: 1)),
    GoRoute(path: AppRoutes.tabBooking, builder: (_, __) => const AppScaffold(tabIndex: 2)),
    GoRoute(path: AppRoutes.tabChat, builder: (_, __) => const AppScaffold(tabIndex: 3)),
    GoRoute(path: AppRoutes.tabProfile, builder: (_, __) => const AppScaffold(tabIndex: 4)),
    GoRoute(path: '/dashboard/:a', builder: (_, state) => AppScaffold(dashboardPath: state.uri.path, tabIndex: 4)),
    GoRoute(path: '/dashboard/:a/:b', builder: (_, state) => AppScaffold(dashboardPath: state.uri.path, tabIndex: 4)),
    GoRoute(path: '/dashboard/:a/:b/:c', builder: (_, state) => AppScaffold(dashboardPath: state.uri.path, tabIndex: 4)),
    GoRoute(path: '/dashboard/:a/:b/:c/:d', builder: (_, state) => AppScaffold(dashboardPath: state.uri.path, tabIndex: 4)),
  ],
);
