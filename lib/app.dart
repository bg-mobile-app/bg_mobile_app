import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/theme/app_theme.dart';
import 'routes/app_router.dart';

class BideshgamiApp extends StatelessWidget {
  const BideshgamiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bideshgami',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      routerConfig: appRouter,
    );
  }
}
