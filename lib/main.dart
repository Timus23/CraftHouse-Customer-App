import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/pages/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:customer/components/pages/cart.dart';
import 'package:customer/components/pages/login.dart';
//my imports
import 'package:customer/components/pages/about.dart';
import 'package:customer/components/horizontal_listview.dart';
import 'package:customer/components/pages/mypurchaes.dart';
import 'package:customer/components/pages/videos.dart';
import 'package:customer/components/products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    ),
  );
}

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> kWords;
  SharedPreferences pref;
  bool authenticate = false;
  bool connectionState = false;
  Map<String, dynamic> userInfo = {};
  _SearchAppBarDelegate _searchDelegate;
  TextEditingController _searchController = TextEditingController();

  _HomepageState()
      : kWords = <String>['Bags', 'Bottles', 'Plates', 'Buddha_Statue']..sort(
            (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
          ),
        super();

  @override
  void initState() {
    super.initState();
    checkConnection();
    checkAuthentication();
    _searchDelegate = _SearchAppBarDelegate(kWords);
  }

  void checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        connectionState = false;
      });
    }
    if (result == ConnectivityResult.wifi) {
      setState(() {
        connectionState = true;
      });
    }
  }

  checkAuthentication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('token') == null) {
      setState(() {
        authenticate = false;
      });
    } else {
      setState(() {
        authenticate = true;
        userInfo['token'] = pref.getString('token');
        userInfo['id'] = pref.getInt('id').toString();
        userInfo['first_name'] = pref.getString('first_name');
        userInfo['last_name'] = pref.getString('last_name');
        userInfo['email'] = pref.getString('email');
        userInfo['phone_no'] = pref.getString('phone_no');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageCarousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/a.jpg'),
          AssetImage('images/c.jpg'),
          AssetImage('images/d.jpg'),
          AssetImage('images/e.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 2.0,
      ),
    );

    Widget reconnect(msg) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(msg),
            ),
            Center(
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    checkConnection();
                  });
                },
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('CraftHouse'),
        actions: <Widget>[
          //Adding the search widget in AppBar
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            //Don't block the main thread
            onPressed: () {
              showSearchPage(context, _searchDelegate);
            },
          ),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                if (userInfo['token'] == null || userInfo['id'] == null) {
                  Toast.show('Please Log In', context);
                  Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  ).then((val) {
                    if (val.length > 0) {
                      setState(() {
                        authenticate = true;
                        userInfo = val;
                      });
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new Cart(
                            token: userInfo['token'],
                            userId: userInfo['id'].toString(),
                          ),
                    ),
                  );
                }
              })
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            // header
            new UserAccountsDrawerHeader(
              accountName:
                  authenticate ? Text(userInfo['first_name']) : Text(''),
              accountEmail: authenticate ? Text(userInfo['email']) : Text(''),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red),
            ),
            //        body
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Homepage()));
              },
              child: ListTile(
                title: Text('HomePage'),
                leading: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                if (authenticate) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Account(
                            userData: userInfo,
                          ),
                    ),
                  );
                } else {
                  Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new Login(),
                    ),
                  ).then((val) {
                    if (val.length > 0) {
                      setState(() {
                        userInfo = val;
                        authenticate = true;
                      });
                    }
                  });
                }
              },
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                if (userInfo['token'] == null || userInfo['id'] == null) {
                  Toast.show('Please Log In', context);
                  Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  ).then((val) {
                    if (val.length > 0) {
                      setState(() {
                        authenticate = true;
                        userInfo = val;
                      });
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyPurchase(
                            config: {
                              'Authorization': 'Token ' + userInfo['token']
                            },
                          ),
                    ),
                  );
                }
              },
              child: ListTile(
                title: Text('My Purchases'),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                if (userInfo['token'] == null || userInfo['id'] == null) {
                  Toast.show('Please Log In', context);
                  Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  ).then((val) {
                    if (val.length > 0) {
                      setState(() {
                        authenticate = true;
                        userInfo = val;
                      });
                    }
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new Cart(
                            token: userInfo['token'],
                            userId: userInfo['id'].toString(),
                          ),
                    ),
                  );
                }
              },
              child: ListTile(
                title: Text('Shopping Cart'),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Videos()));
              },
              child: ListTile(
                title: Text('Tutorials'),
                leading: Icon(
                  Icons.video_library,
                  color: Colors.red,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new About()));
              },
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      body: connectionState
          ? (ListView(
              children: <Widget>[
                //carousel begins
                imageCarousel,
                //padding_widget
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text('Categories'),
                ),

                //horizontal list
                FutureBuilder(
                  future: http.get(Server.category),
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset('images/imageLoading.gif'),
                      );
                    } else if (snap.connectionState == ConnectionState.done) {
                      List<dynamic> _category = json.decode(snap.data.body);
                      return HorizontalList(
                        category: _category,
                      );
                    }
                  },
                ),

                //padding widget
                new Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text('Recent Products'),
                ),
                //grid view
                Container(
                  height: 320,
                  child: FutureBuilder(
                    future: http.get(Server.products),
                    builder: (BuildContext context, AsyncSnapshot snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset('images/imageLoading.gif'),
                        );
                      } else if (snap.connectionState == ConnectionState.done) {
                        List<dynamic> products = json.decode(snap.data.body);
                        return Products(
                          products: products,
                        );
                      }
                    },
                  ),
                )
              ],
            ))
          : reconnect('No Connection!!'),
    );
  }
}

void showSearchPage(
    BuildContext context, _SearchAppBarDelegate searchDelegate) async {
  final String selected = await showSearch<String>(
    context: context,
    delegate: searchDelegate,
  );

  if (selected != null) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Your Word Choice: $selected'),
      ),
    );
  }
}

//Search delegate
class _SearchAppBarDelegate extends SearchDelegate<String> {
  final List<String> _words;
  final List<String> _history;

  _SearchAppBarDelegate(List<String> words)
      : _words = words,
        //pre-populated history of words
        _history = <String>['Bags', 'Bottles', 'Plates', 'Buddha_Statue'],
        super();

  // Setting leading icon for the search bar.
  //Clicking on back arrow will take control to main page
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //Take control back to previous page
        this.close(context, null);
      },
    );
  }

  // Builds page to populate search results.
  @override
  Widget buildResults(BuildContext context) {
    print(this.query);
    return FutureBuilder(
      future: http.get(Server.searchProduct + this.query.toLowerCase() + '/'),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snap.connectionState == ConnectionState.done) {
          var list = json.decode(snap.data.body);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Products(
                products: list,
              ),
            ),
          );
        }
      },
    );
  }

  // Suggestions list while typing search query - this.query.
  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
        ? _history
        : _words.where((word) => word.startsWith(query));

    return _WordSuggestionList(
      query: this.query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        this.query = suggestion;
        this._history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  // Action buttons at the right of search bar.
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }
}

// Suggestions list widget displayed in the search page.
class _WordSuggestionList extends StatelessWidget {
  const _WordSuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: query.isEmpty ? Icon(Icons.history) : Icon(null),
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
