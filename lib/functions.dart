
import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, bool> bookmarks = {};



  Future<void> getitems() async {

    await firestore
        .collection("SongList")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        bookmarks[element["songTitle"].toString()] = false;
      }
    });



  }






  Future<void> SongList( String item) async {
    Map<String, bool> bookmark = {};

    await firestore
        .collection("SongList")
        .where("songTitle")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        bookmark = Map.from(element["bookmarks"]);
        print(bookmark);
      }
    });

    for (var element in bookmark.keys) {
      if (element == item) {
        bookmark[item] = bookmark[item]! ? false : true;
      }
    }

    await firestore
        .collection("SongList")
        .where("songTitle")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        element.reference.update({"bookmarks": bookmark});
      }
    });


  }
}
