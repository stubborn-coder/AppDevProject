import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/child_model.dart';

class ChildService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addChild(
      String fname, String lname, DateTime dob, String parentUUID,
      {String currClass = ""}) async {
    try {
      DocumentReference doc = await _firestore.collection('childs').add({
        "fName": fname,
        "lName": lname,
        "dob": dob,
        "noOfMonths": 1,
        "currentClass": currClass,
        "parentUUID": parentUUID,
        "isWaitListed": false,
      });

      //returning the uuid
      return doc.id;
    } catch (e) {
      print("Error in adding child to firebase: $e");
      return "";
    }
  }

  Future<List<Map<String, dynamic>>?> getChildren() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('childs').get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      List<Map<String, dynamic>> children = [];
      for (var doc in docs) {
        children.add(doc.data() as Map<String, dynamic>);
      }

      return children;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getChildById(uuid) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('childs').doc(uuid).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print("Error in getting childs details $e");
      return null;
    }
  }

  Future<void> updateChildClass(String uuid, String currentClass) async {
    try {
      await _firestore.collection('childs').doc(uuid).update({
        "currentClass": currentClass,
      });
    } catch (e) {
      print("Error while upating $e");
    }
  }

  Future<List<ChildModel>> getChildrenInClass(String classroom) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('childs')
          .where('currentClass', isEqualTo: classroom)
          .get();

      List<ChildModel> childList = snapshot.docs
          .map((doc) => ChildModel.fromQuerySnapshot(doc))
          .toList();

      return childList;
      // querySnapshot.map
      // Process the querySnapshot here
    } catch (e) {
      print("There is an error $e");
      return [];
    }
  }
}