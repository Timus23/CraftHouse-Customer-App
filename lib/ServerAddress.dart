class Server {
  static const String login = 'http://192.168.0.3:8000/api/accounts/login/';
  static const String logout = 'http://192.168.0.3:8000/api/accounts/logout';
  static const String signup = 'http://192.168.0.3:8000/api/accounts/signup/';
  static const String reset =
      'http://192.168.0.3:8000/api/accounts/password/reset/';
  static const String resetCodeVerifed =
      'http://192.168.0.3:8000/api/accounts/password/reset/verified/';
  static const String resetCodeVerify =
      'http://192.168.0.3:8000/api/accounts/password/reset/verify/?code=';
  static const String signupVerify =
      'http://192.168.0.3:8000/api/accounts/signup/verify/?code=';
  static const String category =
      'http://192.168.0.3:8000/api/products/categories/';
  static const String products = 'http://192.168.0.3:8000/api/products/';
  static const String media = 'http://192.168.0.3:8000/media/';
  static const String localAddress = 'http://192.168.0.3:8000';
  static const String searchProduct =
      'http://192.168.0.3:8000/api/products/search/';
  static const String rateProduct =
      'http://192.168.0.3:8000/api/products/rating/add/';
  static const String reviewProduct =
      'http://192.168.0.3:8000/api/products/review/add/';
  static const String addAddress =
      'http://192.168.0.3:8000/api/users/address/';
  static const String payment = 'http://192.168.0.3:8000/api/payment/product/';
  static const String cart = 'http://192.168.0.3:8000/api/products/cart/';
  static const String updateCart =
      'http://192.168.0.3:8000/api/products/cart/update/';
  static const String deleteCart =
      'http://192.168.0.3:8000/api/products/cart/delete/';
}
