import 'package:flutter/material.dart';
import 'package:mvvm_stream/presentation/forgot_password/forgot_password.dart';
import 'package:mvvm_stream/presentation/login/login.dart';
import 'package:mvvm_stream/presentation/main/main_view.dart';
import 'package:mvvm_stream/presentation/onboarding/onboarding.dart';
import 'package:mvvm_stream/presentation/register/register.dart';
import 'package:mvvm_stream/presentation/resources/strings_manager.dart';
import 'package:mvvm_stream/presentation/splash/splash.dart';
import 'package:mvvm_stream/presentation/store_details/store_details.dart';
import '../../app/di.dart' as dependency;
import '../../app/di.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onBoarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => Splash());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => Login());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => Onboarding());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => ForgotPassword());
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => MainView());
      case Routes.storeDetailsRoute:
        return MaterialPageRoute(builder: (_) => StoreDetails());
      default:
        return unDefinedRoute();
    }
  }
 
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound),
              ),
              body: Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}