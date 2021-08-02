import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/screens/account/addNewProduct.dart';
import 'package:bidding_app/screens/account/editUserProfile.dart';
import 'package:bidding_app/screens/account/helpCenter.dart';
import 'package:bidding_app/screens/account/helpCenter/aboutUs.dart';
import 'package:bidding_app/screens/account/helpCenter/contactUs.dart';
import 'package:bidding_app/screens/account/helpCenter/faqs.dart';
import 'package:bidding_app/screens/account/myProducts.dart';
import 'package:bidding_app/screens/account/orderHistory.dart';
import 'package:bidding_app/screens/account/viewProfile.dart';
import 'package:bidding_app/screens/auth/forgotPassword.dart';
import 'package:bidding_app/screens/auth/login.dart';
import 'package:bidding_app/screens/auth/signUp.dart';
import 'package:bidding_app/screens/favorites.dart';
import 'package:bidding_app/screens/order/checkout.dart';
import 'package:bidding_app/screens/order/orderDetails.dart';
import 'package:bidding_app/screens/product/allPopularProducts.dart';
import 'package:bidding_app/screens/home/homepage.dart';
import 'package:bidding_app/screens/product/bidsScreen.dart';
import 'package:bidding_app/screens/product/productDetails.dart';
import 'package:bidding_app/screens/account.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/widgets/internetCheck.dart';
import 'package:flutter/material.dart';

///     Adding route to router
///  * Step 1: Add your route as a member in Routes class of lib/utils/RoutingUtils.dart
///  * If your route takes an argument mention it above the member as a doc comment
///
///  *Step 2: Add case to this file
///     you can just copy this code and paste it above "Paste code above this comment"
///
///     case Routes.yourRouteName:
///     return MaterialPageRoute(builder: (_) {
///     //run type checks if you want to on arguements
///     return YourWidget();
///     });
///     You can run type checks and return any wigdet you want but don't forget to return some wiget at the end

class Router {
  Router._();

  static Widget wrong = Scaffold(
      body: Center(
    child: Text('Something went wrong'),
  ));

  static MaterialPageRoute routify(Widget screen, {RouteSettings? settings}) =>
      MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
                body: screen,
                bottomNavigationBar: CheckInternet(),
              ));

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      if (!authService.isLoggedIn() &&
          !Routes.unprotectedRouts.contains(settings.name))
        return routify(LoginPage());
      else {
        switch (settings.name) {
          //auth
          case Routes.forgotPwd:
            return routify(ForgotPasswordPage());
          case Routes.login:
            return routify(LoginPage());
          case Routes.signUp:
            return routify(SignupPage());

          //home
          case Routes.homepage:
            return routify(HomePage());
          case Routes.favorites:
            return routify(FavoriteProducts());
          case Routes.account:
            return routify(Account());

          //account
          case Routes.myProducts:
            return routify(MyProducts());
          case Routes.orderHistory:
            return routify(MyOrders());
          case Routes.helpCenter:
            return routify(HelpCenter());

          //profile
          case Routes.viewProfile:
            return routify(Profile());
          case Routes.editProfile:
            return routify(EditUserProfile());

          //help center
          case Routes.aboutUs:
            return routify(AboutUs());
          case Routes.faqs:
            return routify(FAQs());
          case Routes.contactUs:
            // if (settings.arguments is String) {
            //   return routify(ContactUs(
            //     initial: settings.arguments as String?,
            //   ));
            // }
            return routify(ContactUs());

          // product
          case Routes.newProduct:
            if (settings.arguments is Product)
              return routify(AddNewProduct(
                product: settings.arguments as Product,
              ));
            else
              return routify(AddNewProduct());
          case Routes.productDetails:
            if (settings.arguments is String) {
              return routify(ProductDetails(
                pId: settings.arguments as String,
              ));
            } else {
              return routify(wrong);
            }
          case Routes.popularProducts:
            return routify(AllPopularProducts());

          // order
          case Routes.bidding:
            if (settings.arguments is Product) {
              return routify(ProductBids(
                product: settings.arguments as Product,
              ));
            } else {
              return routify(wrong);
            }
          case Routes.checkout:
            if (settings.arguments is Map) {
              Map args = settings.arguments as Map;
              return routify(
                  Checkout(amount: args["amount"], product: args["product"]));
            } else {
              return routify(wrong);
            }
          case Routes.orderDetails:
            if (settings.arguments is String) {
              return routify(OrderDetails(
                oId: settings.arguments as String,
              ));
            } else {
              return routify(wrong);
            }

          // Paste new routes above this
          default:
            return routify(
              Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            );
        }
      }
    } catch (e) {
      return routify(wrong);
    }
  }
}
