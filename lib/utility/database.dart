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

  Future<void> addFile(Map<String,dynamic> fileData) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    await ref.push().update(fileData);
  }


}
