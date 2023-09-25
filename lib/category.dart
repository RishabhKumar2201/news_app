
import 'dart:convert';
import 'package:news_app/NewsView.dart';
import 'package:news_app/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'model.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class category extends StatefulWidget {

  late String Query;
  category({super.key,required this.Query});

  @override
  State<category> createState() => _CategoryState();
}

class _CategoryState extends State<category> {

  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;

  Future<void> getNewsByQuery(String query) async {
    Map element;
    int i = 0;

    late String url = "";
    if(query == "Top News" || query == "India"){
       url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=fe5abb0a8bf84af7925c45c5c5345ff4";
    }
    else{
       url =
          "https://newsapi.org/v2/everything?q=$query&from=2023-09-18&sortBy=publishedAt&apiKey=fe5abb0a8bf84af7925c45c5c5345ff4";

    }


    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for(element in data["articles"]) {
        try{
        i++;
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

        } catch (e) {
          print(e);
        };
      }
    });

  }

  Future<void> _refreshNews() async {
    await getNewsByQuery("india");
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('YOUR NEWS'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(15, 13, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text(widget.Query , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 30
                      ),),
                    ],
                  ),
                ),
                isLoading ? const CircularProgressIndicator() :
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                    itemBuilder: (context, index) {
                      try{
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(newsModelList[index].newsUrl)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 5.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].newsImg ,
                                        fit: BoxFit.cover,
                                        height: 220,
                                        width: double.infinity,
                                      )
                                  ),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes ,
                                                style: TextStyle(color: Colors.white , fontSize: 14)
                                                ,)
                                            ],
                                          )))
                                ],
                              )),
                        ),
                      );
                      }catch(e) { print(e); return Container(); }
                    }),

              ],
            ),
          ),
        ),
      )
    );
  }
}
