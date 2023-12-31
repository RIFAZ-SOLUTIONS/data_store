import 'dart:math';

import 'package:data_store/utility/database.dart';
import 'package:data_store/utility/functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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


Future<void> datasetPreview(context, Map<String,dynamic> previewInput, User? currentUser) async{
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;
  final DatabaseService database = DatabaseService();
  GlobalKey toolTipKey = GlobalKey();

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
          content: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight/1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(previewInput['title'],
                    style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
                  Text('Source: ${previewInput['source']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      )
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Tooltip(
              key: toolTipKey,
              message: 'You must Sign in, to download a file.',
              child: IconButton.outlined(
                onPressed: () async{
                  if(currentUser != null){
                    downloadFile(previewInput['downloadLink']);
                    await database.updateDownloads(
                        previewInput['downloads'],
                        previewInput['datasetId'],
                      );
                  } else{
                    final dynamic toolTip = toolTipKey.currentState;
                    toolTip.ensureTooltipVisible();
                  }
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
            ),
          ],
        );
      },);
}

Future<void> datasetInput(context, User? currentUser) async{
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
          content: InputDetails(user: currentUser,),
        );
      },
  );
}

class InputDetails extends StatefulWidget {
  final User? user;
  const InputDetails({super.key, this.user});

  @override
  State<InputDetails> createState() => _InputDetailsState();
}

class _InputDetailsState extends State<InputDetails> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService database = DatabaseService();
  int fileSizeLimit = 3*1024*1024;
  double storageSizeLimit = 100*1024*1024;
  late int fileSize;
  late String? fileType;
  late Uint8List fileBytes;
  late String fileName;
  late bool isUploaded;
  late String title;
  late String source;
  late String description;
  late String category;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dropdownMenuController = TextEditingController();

  final List<String> categories = [
    'Artificial Intelligence',
    'Biology',
    'Business',
    'Computer Science',
    'Economics',
    'Education',
    'Engineering',
    'Environmental Science',
    'Finance',
    'Governance',
    'Healthcare',
    'Manufacturing',
    'Marketing',
    'Medicine',
    'Other'
  ];

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
    source = '';
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
      child: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
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
                        allowedExtensions: ['csv','pdf','xls', 'xlsx','odt'],
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
                        title = titleController.text;
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
                        description = descriptionController.text;
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
              Container(
                height: screenHeight/12,
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
                      controller: sourceController,
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return 'Empty';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        source = sourceController.text;
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: 'Enter File source'
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight/20,),
              Flexible(
                child: DropdownMenu(
                  menuHeight: screenHeight/4,
                  controller: dropdownMenuController,
                  dropdownMenuEntries: createCategories(categories),
                  label: const Text('Select Category'),
                  menuStyle: MenuStyle(
                    mouseCursor: const MaterialStatePropertyAll(MaterialStateMouseCursor.clickable),
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
                  final String userId = widget.user!.uid;
                  final double usedStorageSize = await database.calculateUsedStorage(userId);
                  if (_formKey.currentState!.validate() && isUploaded && fileSize<fileSizeLimit && usedStorageSize<storageSizeLimit){
                    final String newFileName = '${fileName.split('.')[0]}${Random().nextInt(1000)}.$fileType';
                    final String newFileSize = (fileSize/(1024*1024)).toStringAsFixed(4);
                    final Map<String, dynamic> fileData = {
                      'userId': userId,
                      'title': title,
                      'fileName': newFileName,
                      'description': description,
                      'category': category,
                      'dateAdded': DateFormat('dd-MM-yyyy').format(DateTime.now()),
                      'userDownloads': 0,
                      'fileType': '.${fileType!.toUpperCase()}',
                      'fileSize': '${newFileSize}MB',
                    };
                    try {
                      final String filePath = '$userId/$newFileName';
                      final String downloadLink = await LoadingOverlay.of(context).during(database.storeFile(filePath, fileBytes));
                      final String datasetId = await LoadingOverlay.of(context).during(database.addFile(fileData, userId));
                      if(context.mounted) await LoadingOverlay.of(context).during(database.addNewFields(downloadLink, userId, datasetId));
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
                      if(context.mounted) await showErrorDialog(context, _.toString());
                    }
                  } else if(!isUploaded){
                    if(context.mounted) await showErrorDialog(context, 'Upload a file!');
                  } else if(fileSize>fileSizeLimit){
                    if(context.mounted) await showErrorDialog(context, 'File size exceeds upload limit, choose a smaller file!');
                  } else if(usedStorageSize>=storageSizeLimit){
                    if(context.mounted) await showErrorDialog(context, 'You have reached your storage limit, delete some files!');
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
        ),
      ),
    );
  }
}

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
        context: _context,
        barrierDismissible: false,
        builder: (ctx) => _FullScreenLoader());
  }

  Future<T> during<T>(Future<T> future) {
    show();
    return future.whenComplete(() => hide());
  }

  LoadingOverlay._create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._create(context);
  }
}

class _FullScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
        child: const Center(child: CircularProgressIndicator()));
  }
}