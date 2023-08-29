import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class DatabaseService{

  Future<DatabaseEvent> fetchData() async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final DatabaseEvent event = await ref.once();
    return event;
  }

  Future<DatabaseEvent> fetchDownloads() async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference downRef = rtDatabase.ref('downloads');
    final DatabaseEvent event = await downRef.once();
    return event;
  }

  Future<String> addFile(Map<String,dynamic> fileData, String userId) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final String? key = ref.push().key;
    final DatabaseReference newRef = rtDatabase.ref('datasets/$userId/$key');
    final DatabaseReference downRef = rtDatabase.ref('downloads/$key');
    await newRef.update(fileData);
    await downRef.update({'downloads':0,'datasetId':key});
    return key!;
  }

  Future<String> storeFile(String filePath, Uint8List fileBytes ) async{
    await FirebaseStorage.instance.ref(filePath).putData(fileBytes);
    final String downloadLink = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return downloadLink;
  }

  Future<void> addNewFields(String downloadLink, String userId, String datasetId) async{
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets/$userId/$datasetId');
    await ref.update({
      'downloadLink': downloadLink,
      'datasetId': datasetId,
    });
  }

  // Future<void> updateDownloads(int downloads, String datasetId, String userId) async{
  //   final int newValue = downloads + 1;
  //   final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
  //   final DatabaseReference ref = rtDatabase.ref('datasets/$userId/$datasetId');
  //   await ref.update({
  //     'downloads': newValue,
  //   });
  // }

  Future<void> updateDownloads(int downloads, String datasetId) async{
    final int newValue = downloads + 1;
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference downRef = rtDatabase.ref('downloads/$datasetId');
    await downRef.update({
      'downloads': newValue,
    });
  }

  Future<double> calculateUsedStorage(String userId) async{
    double totalSizeInBytes = 0;
    final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
    final DatabaseReference ref = rtDatabase.ref('datasets/$userId');
    final DatabaseEvent event = await ref.once();
    late Map<dynamic,dynamic> events;

    try{
      events = event.snapshot.value as Map<dynamic,dynamic>;
    } catch(_){
      events = {
        "datasetId":{"fileSize":"0MB"}
      };
    }

    events.forEach((key, value) {
      final double fileSizeInMB = double.parse(value['fileSize'].toString().split('M')[0]);
      totalSizeInBytes += (fileSizeInMB*1024*1024);
    });
    return totalSizeInBytes;
  }
}
