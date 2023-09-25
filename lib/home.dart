import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:news_app/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/category.dart';
import 'package:news_app/empty.dart';
import 'model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:news_app/model.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:news_app/NewsView.dart';
import 'package:news_app/category.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  //Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = ["Top News", "India", "World", "Finance", "Health"];

  bool isLoading = true;
  Future<void> getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    late String? url =
        "https://newsapi.org/v2/everything?q=$query&from=2023-09-18&sortBy=publishedAt&apiKey=fe5abb0a8bf84af7925c45c5c5345ff4";
    try {
      final Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        setState(() {
          for (element in data["articles"]) {
            try {
              i++;
              NewsQueryModel newsQueryModel = new NewsQueryModel();
              newsQueryModel = NewsQueryModel.fromMap(element);
              newsModelList.add(newsQueryModel);
              setState(() {
                isLoading = false;
              });
              if (i == 8) {
                break;
              }
            } catch (e) {
              print('Error $e');
            }
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error $e');
      }
    }
  }

  Future<void> getNewsofIndia() async {
    Map element;
    int i = 0;
    late String url =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=fe5abb0a8bf84af7925c45c5c5345ff4";
    try {
      final Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        for (element in data["articles"]) {
          try {
            i++;
            NewsQueryModel newsQueryModel = new NewsQueryModel();
            newsQueryModel = NewsQueryModel.fromMap(element);
            newsModelListCarousel.add(newsQueryModel);
            setState(() {
              isLoading = false;
            });
            if (i == 5) {
              break;
            }
          } catch (e) {
            print('Error $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error $e');
      }
    }
  }

  Future<void> _refreshNews() async {
    await getNewsofIndia();
    getNewsByQuery("india");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsofIndia();
    getNewsByQuery("india");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DAILY NEWS"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //Search Wala Container

                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(24)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("Blank search");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      category(Query: searchController.text)));
                        }
                      },
                      child: Container(
                        child: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (value == "" || value == " ") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Empty()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        category(Query: value)));
                          }
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search Your News Here..."),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      category(Query: navBarItem[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xfff6d365), Color(0xfffda085)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 7,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 7),
                      child: CarouselSlider(
                        options: CarouselOptions(
                            height: 175,
                            autoPlay: true,
                            enlargeCenterPage: true),
                        items: newsModelListCarousel.map((instance) {
                          return Builder(builder: (BuildContext context) {
                            try {
                              return Container(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NewsView(instance.newsUrl)));
                                },
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child:
                                        Stack(fit: StackFit.expand, children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(instance.newsImg,
                                            fit: BoxFit.fitHeight,
                                            width: double.infinity),
                                      ),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 13),
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      instance.newsHead,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                          )),
                                    ])),
                              ));
                            } catch (e) {
                              print(e);
                              return Container();
                            }
                          });
                        }).toList(),
                      ),
                    ),
              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 13, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "LATEST NEWS !! ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: newsModelList.length,
                            itemBuilder: (context, index) {
                              try {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewsView(
                                                  newsModelList[index]
                                                      .newsUrl)));
                                    },
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        elevation: 5.0,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                  newsModelList[index].newsImg,
                                                  fit: BoxFit.fitHeight,
                                                  height: 220,
                                                  width: double.infinity,
                                                )),
                                            Positioned(
                                                left: 0,
                                                right: 0,
                                                bottom: 0,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Colors.black12
                                                                  .withOpacity(
                                                                      0),
                                                              Colors.black
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15, 15, 10, 8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          newsModelList[index]
                                                              .newsHead,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          newsModelList[index]
                                                                      .newsDes
                                                                      .length >
                                                                  50
                                                              ? "${newsModelList[index].newsDes.substring(0, 55)}...."
                                                              : newsModelList[
                                                                      index]
                                                                  .newsDes,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    )))
                                          ],
                                        )),
                                  ),
                                );
                              } catch (e) {
                                print(e);
                                return Container();
                              }
                            }),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 6, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            category(Query: "Top News")));
                              },
                              child: Text("Show More")),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 7,
                      child: Column(
                        /*mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,*/

                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 1, 0, 6),
                            /*decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.amber],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),*/
                            child: Column(
                              children: [
                                Text(
                                  "Made with ❤️ by R.K.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),

                                Text("Referenced from CodeWithDhruv",
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


