import 'package:flutter/material.dart';

Future<void> datasetPreview(context, String title, String date) async{
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
              Text(title,
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth/50,
                ),
              ),
              const Text(' Egestas fringilla phasellus faucibus scelerisque eleifend donec pretium.\n'
                  ' Diam maecenas sed enim ut sem viverra aliquet. Facilisi cras fermentum odio eu feugiat pretium nibh ipsum.\n'
                  ' Nunc aliquet bibendum enim facilisis gravida neque convallis. Accumsan tortor posuere ac ut.\n'
                  ' Ac turpis egestas maecenas pharetra convallis posuere morbi leo.\n'
                  ' Eu turpis egestas pretium aenean pharetra magna ac placerat vestibulum.\n'
                  ' Elementum eu facilisis sed odio morbi quis commodo. Nisi est sit amet facilisis magna etiam tempor.\n'
                  ' Nunc lobortis mattis aliquam faucibus purus. Viverra adipiscing at in tellus.\n'
                  ' Et tortor consequat id porta nibh. Sit amet luctus venenatis lectus magna.',
              ),
               SizedBox(height: screenHeight/20,),
              const Text('Tags: Column A, Column B, Column C, Column D',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
               const Text('Dimensions: 12 \u00D7 400',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
              const Text('Type: .CSV',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
              const Text('Size: 3.0 MB',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
              Text('Date added: $date',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  )
              ),
            ],
          ),
          actions: [
            IconButton.outlined(
              onPressed: () {},
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
  final screenWidth = MediaQuery.of(context).size.width;

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
  late String title;
  late String description;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> categories = ['Finance', 'Economics', 'Agriculture', 'Medicine', 'Education'];

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
          DropdownMenu(
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
          )
        ],
      ),
    );
  }
}
