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

  Future<String> addFile(Map<String,dynamic> fileData) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final String? key = ref.push().key;
    final DatabaseReference newRef = rtDatabase.ref('datasets/$key');
    await newRef.update(fileData);
    return key!;
  }

  Future<void> addDownloadLink(String downloadLink, String datasetID) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets/$datasetID');
    await ref.update({
      'downloadLink': downloadLink
    });
  }
}
