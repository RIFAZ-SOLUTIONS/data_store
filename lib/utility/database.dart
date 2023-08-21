import 'package:firebase_database/firebase_database.dart';

class DatabaseService{

  Future<DatabaseEvent> fetchData() async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final DatabaseEvent event = await ref
        .orderByChild('title')
        .once();
    return event;
  }

  Future<void> addFile() async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    // await ref.update({
    //   "userId2":{
    //     "dataset1":{
    //     "added":'21/08/2023',
    //     "title":"Testing"
    //     }
    //   }
    // });
    await ref.push().update({
      "added":'22/08/2023',
      "title":"Ukwaju wetuuu",
      "userId": "useruser123"
    });

  }

}
