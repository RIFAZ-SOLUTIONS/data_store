import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class DatabaseService{

  Future<DatabaseEvent> fetchData(String userId) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets/$userId');
    final DatabaseEvent event = await ref
        .orderByChild('title')
        .once();
    return event;
  }

  Future<String> addFile(Map<String,dynamic> fileData, String userId) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final String? key = ref.push().key;
    final DatabaseReference newRef = rtDatabase.ref('datasets/$userId/$key');
    await newRef.update(fileData);
    return key!;
  }

  Future<String> storeFile(String filePath, Uint8List fileBytes ) async{
    await FirebaseStorage.instance.ref(filePath).putData(fileBytes);
    final String downloadLink = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadLink;
  }

  Future<void> addDownloadLink(String downloadLink, String userId, String datasetId) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets/$userId/$datasetId');
    await ref.update({
      'downloadLink': downloadLink
    });
  }
}
