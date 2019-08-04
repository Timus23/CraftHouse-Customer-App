class Server {
  static const String login = 'http://10.0.2.2:8000/api/accounts/login/';
  static const String logout = 'http://10.0.2.2:8000/api/accounts/logout';
  static const String signup = 'http://10.0.2.2:8000/api/accounts/signup/';
  static const String reset =
      'http://10.0.2.2:8000/api/accounts/password/reset/';
  static const String resetCodeVerifed =
      'http://10.0.2.2:8000/api/accounts/password/reset/verified/';
  static const String resetCodeVerify =
      'http://10.0.2.2:8000/api/accounts/password/reset/verify/?code=';
  static const String signupVerify =
      'http://10.0.2.2:8000/api/accounts/signup/verify/?code=';
  static const String category =
      'http://10.0.2.2:8000/api/products/categories/';
  static const String products = 'http://10.0.2.2:8000/api/products/';
  static const String courses = 'http://10.0.2.2:8000/api/courses/';
  static const String media = 'http://10.0.2.2:8000/media/';
  static const String localAddress = 'http://10.0.2.2:8000';
  static const String searchProduct =
      'http://10.0.2.2:8000/api/products/search/';
  static const String rateProduct =
      'http://10.0.2.2:8000/api/products/rating/add/';
  static const String reviewProduct =
      'http://10.0.2.2:8000/api/products/review/add/';
  static const String addAddress = 'http://10.0.2.2:8000/api/users/address/';
  static const String productPayment =
      'http://10.0.2.2:8000/api/payment/product/';
  static const String coursePayment =
      'http://10.0.2.2:8000/api/courses/payment/';
  static const String cart = 'http://10.0.2.2:8000/api/products/cart/';
  static const String updateCart =
      'http://10.0.2.2:8000/api/products/cart/update/';
  static const String deleteCart =
      'http://10.0.2.2:8000/api/products/cart/delete/';
  static const String deleteAllFromCart =
      'http://10.0.2.2:8000/api/products/cart/deleteall/';
  static const String myPurchase =
      'http://10.0.2.2:8000/api/products/mypurchase/';
  static const String watchList =
      'http://10.0.2.2:8000/api/video/add/watchlist/';
  static const String submitReport =
      'http://10.0.2.2:8000/api/courses/createReport/';
  static const String rateCourse =
      'http://10.0.2.2:8000/api/courses/rating/add/';
  static const String reviewCourse =
      'http://10.0.2.2:8000/api/courses/review/add/';
}
