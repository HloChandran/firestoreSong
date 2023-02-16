/*
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController songTitle = TextEditingController();
  bool likeValue = false;
  List<String> savedWords = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('SongList').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              String word = document['songTitle'];
              bool isSaved = savedWords.contains(word);
              return ListTile(
                title: Text(word),
                trailing: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : null,
                ),
                onTap: () {
                  if (isSaved) {
                    savedWords.remove(word);
                  } else {
                    savedWords.add(word);
                  }
                },
              );

              //   Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(document['songTitle']),
              //           InkWell(child: !likeValue? Icon(Icons.library_add) :Icon(Icons.abc) ,onTap: (){
              //             likeValue=true;
              //             setState(() {
              //
              //             });
              //
              //           },),
              //
              //         ],
              //       ),
              //     ),
              //     Divider()
              //   ],
              // );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          songListAdd();
        },
      ),
    );
  }


}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'functions.dart';


Functions func = Functions();

List<Widget> pages = [AllItems(), BookMarkedItems()];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  PageController _pageController = PageController();
  TextEditingController songTitle = TextEditingController();
  @override
  void initState() {
     func.getitems();
    super.initState();
    _pageController = PageController(initialPage: _index);
  }

  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
        ],
      ),
      body: PageView(
        children: pages,
        controller: _pageController,
        onPageChanged: onPageChanged,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          songListAdd();
        },
      ),
    );
  }

  void songListAdd() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add New Songs List..',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    controller: songTitle,
                    style: const TextStyle(fontSize: 13.0),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.blue, width: 5.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: "Song Title",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: TextButton(
                            child: Text("Cancel".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(12)),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)))),
                            onPressed: () => null),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: TextButton(
                            child: Text("Add".toUpperCase(),
                                style: TextStyle(fontSize: 14)),
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(12)),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.green),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(18.0),
                                        side:
                                        BorderSide(color: Colors.green)))),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('SongList')
                                  .add(
                                  {'songTitle': songTitle.text.toString(),'like':false}).then((value) =>  func.getitems());
                            }),
                      ),
                    ])
              ]),
        );
      },
    );
  }
}

class AllItems extends StatefulWidget {
  @override
  _AllItemsState createState() => _AllItemsState();
}

class _AllItemsState extends State<AllItems> {
  List<String> items = [];
  List<bool> bookmark = [];

  @override
  void initState() {
    Map<String, bool> book = func.bookmarks;

    items = book.keys.toList();
    bookmark = book.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Items"),
        actions: [
          IconButton(
            onPressed: () async {

            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              trailing: IconButton(
                onPressed: () async {


                  var collection = FirebaseFirestore.instance.collection('SongList');
                  collection.doc()
                      .update({'like' : true }) // <-- Updated data
                      .then((_) => print('Success'))
                      .catchError((error) => print('Failed: $error'));

                  setState(() {
                  bookmark[index] = !bookmark[index];
                    print(bookmark[index]);
                    print(index);
                  });
                },
                icon: bookmark[index]
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border_outlined),
              ),
            );
          }),

    );
  }
}

class BookMarkedItems extends StatefulWidget {
  @override
  _BookMarkedItemsState createState() => _BookMarkedItemsState();
}

class _BookMarkedItemsState extends State<BookMarkedItems> {
  List<String> bookmarked = [];

  @override
  void initState() {
    Map<String, bool> book = func.bookmarks;

    bookmarked.clear();
    List<String> items = book.keys.toList();
    List<bool> bookmark = book.values.toList();
    for (int i = 0; i < items.length; i++) {
      if (bookmark[i]) bookmarked.add(items[i]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bookmarked Items"),
        actions: [
          IconButton(
            onPressed: () async {

            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: bookmarked.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bookmarked[index]),
            );
          }),
    );
  }
}
