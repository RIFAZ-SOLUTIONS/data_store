import 'dart:math';

import 'package:data_store/pages/authentication/stub.dart';
import 'package:data_store/utility/database.dart';
import 'package:data_store/utility/functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

Future<void> showErrorDialog(context,String error) async{
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Warning',
          style: TextStyle(
              color: Color.fromRGBO(196, 102, 12, 1)
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(error),
              const Text('Please try again!'),
            ],
          ),
        ),
      );
    },
  );
}


Future<void> datasetPreview(context, Map<String,dynamic> previewInput) async{
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(196, 102, 12, 1)
            ),
          ),
          elevation: 2,
          shadowColor: const Color.fromRGBO(196, 102, 12, 1),
          icon: Icon(Icons.view_headline_outlined,
              color: const Color.fromRGBO(196, 102, 12, 1),
              size: screenHeight/20,
            ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(previewInput['title'],
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth/50,
                ),
              ),
              Text(previewInput['description']),
               SizedBox(height: screenHeight/20,),
              Text('Type: ${previewInput['fileType']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
              Text('Size: ${previewInput['fileSize']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
              Text('Date added: ${previewInput['dateAdded']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
            ],
          ),
          actions: [
            IconButton.outlined(
              onPressed: () {
                downloadFile(previewInput['downloadLink']);
              },
              style: ButtonStyle(
                side: MaterialStateProperty.all( const BorderSide(color: Color.fromRGBO(196, 102, 12, 1)))
              ),
                icon: const Text(
                  'Download',
                  style: TextStyle(
                    color: Color.fromRGBO(196, 102, 12, 1),
                  ),
                ),
              color: const Color.fromRGBO(196, 102, 12, 1),
            ),
          ],
        );
      },);
}

Future<void> datasetInput(context) async{
  final screenHeight = MediaQuery.of(context).size.height;

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File Information',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(196, 102, 12, 1)
            ),
          ),
          elevation: 2,
          shadowColor: const Color.fromRGBO(196, 102, 12, 1),
          icon: Icon(Icons.description_outlined,
            color: const Color.fromRGBO(196, 102, 12, 1),
            size: screenHeight/20,
            ),
          content: const InputDetails(),
        );
      },
  );
}

class InputDetails extends StatefulWidget {
  const InputDetails({super.key});

  @override
  State<InputDetails> createState() => _InputDetailsState();
}

class _InputDetailsState extends State<InputDetails> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService database = DatabaseService();
  int fileSizeLimit = 3*1024*1024;
  late int fileSize;
  late String? fileType;
  late Uint8List fileBytes;
  late String fileName;
  late bool isUploaded;
  late String title;
  late String description;
  late String category;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dropdownMenuController = TextEditingController();

  final List<String> categories = ['Finance', 'Economics', 'Agriculture', 'Medicine', 'Education', 'Other'];

  List<DropdownMenuEntry> createCategories(List<String> categories){
    final List<DropdownMenuEntry> categoryList = [];
    for(int i=0; i<categories.length; i++){
      final DropdownMenuEntry category = DropdownMenuEntry(value: 'value$i', label: categories[i]);
       categoryList.add(category);
    }
    return categoryList;
  }

  @override
  void initState() {
    super.initState();
    title = '';
    description = '';
    category = '';
    fileName = '';
    fileSize = 0;
    fileBytes = Uint8List(0);
    isUploaded = false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async{
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['csv','pdf','xlsx','odt'],
                  );
                  if (result != null) {
                    setState(() {
                      isUploaded = true;
                      fileName = result.files.first.name;
                      fileBytes = result.files.first.bytes!;
                      fileSize = result.files.first.size;
                      fileType = result.files.first.extension;
                    });
                    if(fileSize>fileSizeLimit){
                      if(context.mounted) await showErrorDialog(context, 'File size is greater than 3MB!');
                    }
                  }
                },
                child: Container(
                  width: screenWidth/10,
                  height: screenHeight/16,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(196, 102, 12, 1),
                  ),
                  child: const Center(
                    child: Text('Upload a file',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth/60,),
              Visibility(
                visible: isUploaded,
                child: SizedBox(
                  width: screenWidth/8,
                  child: Text(fileName,
                    style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight/20,),
          Container(
            height: screenHeight/10,
            width: screenWidth/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromRGBO(196, 102, 12, 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Center(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      title = titleController.text;
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Enter File Title'
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight/20,),
          Container(
            height: screenHeight/5,
            width: screenWidth/4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromRGBO(196, 102, 12, 1)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom:10, left: 20),
              child: Center(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Empty';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      description = descriptionController.text;
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Enter File Description'
                  ),
                  expands: true,
                  maxLines: null,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight/20,),
          Flexible(
            child: DropdownMenu(
              controller: dropdownMenuController,
              dropdownMenuEntries: createCategories(categories),
              label: const Text('Select Category'),
              menuStyle: MenuStyle(
                  elevation: MaterialStateProperty.all(2),
                  side: MaterialStateProperty.all(const BorderSide(
                      color: Color.fromRGBO(196, 102, 12, 1),
                      width: 2,
                      style: BorderStyle.solid
                  ),),
              ),
              width: screenWidth/4,
              initialSelection: 'Finance',
              onSelected: (value) {
                setState(() {
                  category = dropdownMenuController.text;
                });
              },
              errorText: category.isEmpty? 'Empty' : null,
            ),
          ),
          SizedBox(height: screenHeight/20,),
          InkWell(
            onTap: () async{
              if (_formKey.currentState!.validate() && isUploaded && fileSize<fileSizeLimit){
                final String newFileName = '${fileName.split('.')[0]}${Random().nextInt(1000)}.$fileType';
                final String newFileSize = (fileSize/(1024*1024)).toStringAsFixed(3);
                final Map<String, dynamic> fileData = {
                  'title': title,
                  'fileName': newFileName,
                  'description': description,
                  'category': category,
                  'dateAdded': DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  'downloads': 0,
                  'fileType': '.${fileType!.toUpperCase()}',
                  'fileSize': '${newFileSize}MB',
                };
                try {
                  // TODO add loading overlay
                  final String datasetID = await database.addFile(fileData);
                  await FirebaseStorage.instance.ref('uploads/$newFileName').putData(fileBytes);
                  final String downloadLink = await FirebaseStorage.instance.ref('uploads/$newFileName').getDownloadURL();
                  await database.addDownloadLink(downloadLink, datasetID);
                  if(context.mounted) Navigator.of(context).pop();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                      content: Center(child: Text('File is uploaded!')),
                      duration: Duration(seconds: 3),
                      backgroundColor: Color.fromRGBO(196, 102, 12, 1),
                      )
                    );
                  }
                } catch(_){
                  await showErrorDialog(context, _.toString());
                }
              }
            },
            child: Container(
              width: screenWidth/10,
              height: screenHeight/16,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(196, 102, 12, 1),
              ),
              child: const Center(
                child: Text('Submit',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}