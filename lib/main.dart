import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/strings.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/router/navigation_service.dart';
import 'package:elevator/router/router.dart' as router;
import 'package:elevator/src/core/localization/common_localizations_delegate.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/core/bloc/main_bloc.dart';
import 'src/core/localization/app_localizations.dart';
import 'src/core/localization/fallback_cupertino_localisations_delegate.dart';
import 'src/core/ui/base_stateless_widget.dart';

/// main configuration of the app
void main() {
  InjectorDI().configure(Flavor.PROD);
  runApp(CoreApp());
}

/// widget of app and its configuration
class CoreApp extends BaseStatelessWidget {
  final mainBloc = MainBloc();

  CoreApp() {
    mainBloc.add(MainBlocEvent.SET_PORTRAIT);
  }

  // This widget is the root of your application.
  @override
  Widget getLayout(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: colorPrimaryDark));
    return BlocProvider(
      create: (context) => mainBloc,
      child: BlocListener<MainBloc, MainBlocState>(
          listener: (context, MainBlocState state) {
            if (state is MainOrientationState) {
              SystemChrome.setPreferredOrientations(state.orientations);
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              CommonLocalizationDelegate(),
              FallbackCupertinoLocalisationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: Localization.getSupportedLocales(),
            title: AppTitle,
            theme: buildThemeData(),
            navigatorKey: injector<NavigationService>().navigatorKey,
            onGenerateRoute: router.generateRoute,
            home: SplashScreen(),
          )),
    );
  }
}
