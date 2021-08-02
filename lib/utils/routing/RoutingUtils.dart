/// *using router :
///  *  ```
///  Navigator.pushNamed(Routes.routeName)
///  * ```
///  *
/// *passing arguments, routes that require arguments recieve it through a map (occassionally Strings )
///  *
///  * the structure of map for arguments for certain
/// *  routes is present as a documentation comment
/// *  ```
///  Navigator.pushNamed(Routes.routeName, arguments: {"key1":val1,"key2":val2})
///  * ```
/// * you can hover a route it anywhere in VSCode/Android Studio to see argement structure
class Routes {
  //auth
  static const String forgotPwd = 'forgotPassword';
  static const String login = 'login';
  static const String signUp = 'signUp';

  //home
  static const String homepage = 'homepage';
  static const String favorites = 'favorites';
  static const String account = 'account';

  //profile
  static const String viewProfile = 'viewProfile';
  static const String editProfile = 'editProfile';

  //product
  static const String newProduct = 'newProduct';
  static const String productDetails = 'productDetails';
  static const String popularProducts = 'popularProduct';

  //order
  static const String bidding = 'bidding';
  static const String checkout = 'checkout';
  static const String orderDetails = 'orderDetails';

  //account
  static const String myProducts = 'myProducts';
  static const String orderHistory = 'orderHistory';
  static const String notifications = 'notifications';
  static const String settings = 'settings';
  static const String helpCenter = 'helpCenter';

  //help center
  static const String aboutUs = 'aboutUs';
  static const String contactUs = 'contactUs';
  static const String faqs = 'faqs';

  static const List<String> bottomNavBarRoutes = [homepage, favorites, account];

  static const List<String> unprotectedRouts = [login, signUp, forgotPwd];
}
