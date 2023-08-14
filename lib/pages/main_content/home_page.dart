import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_store/pages/widgets/custom_widgets.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isVisible;
  final ScrollController scrollController = ScrollController();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1691071716244-db306a482fc0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1691264122434-3b5a1dac81d5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=928&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  ];
  final MaterialStateProperty<Color> searchBarColor = MaterialStateProperty.all(Colors.white);
  final FirebaseDatabase rtDatabase = FirebaseDatabase.instance;
  final TextEditingController searchController = TextEditingController();
  List<dynamic> suggestions = [];
  late DatabaseEvent event;

  Future<DatabaseEvent> fetchData() async{
    final DatabaseReference ref = rtDatabase.ref('datasets');
    final DatabaseEvent event = await ref
        .orderByChild('title')
        .once();
    return event;
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
    }

    final updatedSuggestions = [];
    late Map<dynamic, dynamic> values;
    try {
      values = event.snapshot.value as Map<dynamic, dynamic>;
    } catch(e){
      values = {'dataset0':
        {
        'title': 'No results',
        'downloads': 0,
        'added': ''
        }
      };
    }

    // final RegExp regExp = RegExp(query, caseSensitive: false);

    values.forEach((key, value) {
      final List<dynamic> matches = Fuzzy(value['title'].toString().trim().split(' '), options: FuzzyOptions(threshold: 0.72)).search(query);
      // regExp.hasMatch(value['title'])
      if (matches.isNotEmpty){
        updatedSuggestions.add(value);
      }
    });

    setState(() {
      if (updatedSuggestions.isEmpty){
        suggestions = [
          {
            'title': 'No results',
            'downloads': 0,
            'added': ''
          }
        ];
      } else {
        suggestions = updatedSuggestions;
      }
    });
  }

  @override
  void initState() {
    isVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> imageSliders = imgList
        .map((item) => SizedBox(
              width: screenWidth,
              child: Image.network(item,
                  fit: BoxFit.fitWidth,
                  height: screenHeight / 3,
                  width: screenWidth),
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        elevation: 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The DataStore',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27
            ),
            ),
            SizedBox(width: screenWidth/130,),
            const Text('Portal',
            style: TextStyle(
              color: Color.fromRGBO(196, 102, 12, 1),
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        bottomOpacity: 3.5,
        shadowColor: const Color.fromRGBO(50, 94, 135, 1),
        backgroundColor: const Color.fromRGBO(0, 101, 168, 1),
      ),
      body: RawScrollbar(
        controller: scrollController,
        thumbColor: const Color.fromRGBO(196, 102, 12, 0.6),
        thickness: 8,
        child: ListView(
          controller: scrollController,
          children: [
            SizedBox(
              height: (screenHeight*2)/4,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          clipBehavior: Clip.hardEdge,
                          autoPlayInterval: const Duration(seconds:5),
                        ),
                        items: imageSliders,
                      )
                  ),
                  Positioned(
                      top: screenHeight/13,
                      left: screenWidth/2.6,
                      child: Text('Tanzania Accessible Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth/45,
                          fontWeight: FontWeight.w700,
                        ),)
                  ),
                  Positioned(
                      top: screenHeight/5,
                      left: screenWidth/3,
                      child: Text('"We believe in the power of data custodianship."',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth/60,
                          fontWeight: FontWeight.w700,
                        ),)
                  ),
                  Positioned(
                      top: screenHeight/3,
                      left: screenWidth/4.4,
                      child: SearchBar(
                        controller: searchController,
                        hintText: 'Search datasets',
                        backgroundColor: searchBarColor,
                        constraints: BoxConstraints(maxWidth: screenWidth/1.85),
                        side: MaterialStateProperty.all( const BorderSide(
                          style: BorderStyle.solid,
                          color: Color.fromRGBO(196, 102, 12, 1),
                        )),
                        elevation: MaterialStateProperty.all(3.0),
                        trailing: [
                          Center(
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search_rounded,
                                  color: const Color.fromRGBO(196, 102, 12, 1),
                                  size: screenWidth/45,)),
                          ),
                        ],
                        onTap: () async{
                          final DatabaseEvent currentEvent = await fetchData();
                          setState(() {
                            event = currentEvent;
                          });
                        },
                        onChanged: (query) async{
                          if(query.isEmpty){
                            setState(() {
                              isVisible = false;
                            });
                          } else {
                            setState(() {
                              isVisible = true;
                            });
                            await fetchSuggestions(query);
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight/40,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length > 6 ? 6 : suggestions.length,
              itemBuilder: (context, index) {
                return Visibility(
                  visible: isVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth/1.6,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(196, 102, 12, 0.7),
                              style: BorderStyle.solid,
                              width: 2,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0,1),
                              color: Color.fromRGBO(196, 102, 12, 0.7),
                              blurRadius: 2,
                              blurStyle: BlurStyle.outer,
                            )
                          ]
                        ),
                        child: suggestions[index]['title'] == 'No results' ? ListTile(
                            title: Text(suggestions[index]['title'],
                              style: const TextStyle(
                                   fontWeight: FontWeight.bold
                                 ),
                            ),
                        ) :
                        ListTile(
                          title: Text(suggestions[index]['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          subtitle: Row(
                            children: [
                              Text('Date added: ${suggestions[index]["added"]}'),
                              SizedBox(width: screenWidth/120,),
                              Text('Category: ${suggestions[index]["category"]}'),
                              SizedBox(width: screenWidth/120,),
                              Container(
                                height: screenHeight/38,
                                width: screenWidth/35,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(196, 102, 12, 0.7),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text(suggestions[index]["filetype"].toString().toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth/110,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                ),
                              ),
                              SizedBox(width: screenWidth/120,),
                              const Icon(Icons.file_download_outlined,
                              color: Color.fromRGBO(0, 101, 168, 1),),
                              Text(suggestions[index]["downloads"].toString(),
                              style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                          trailing: SizedBox(
                            width: screenWidth/20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Tooltip(
                                    message: 'preview',
                                    preferBelow: false,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(0, 101, 168, 1),
                                    ),
                                    child: IconButton(
                                        onPressed: () async{
                                          await datasetPreview(context, suggestions[index]['title'], suggestions[index]['added']);
                                        },
                                        icon: const Icon(Icons.preview_outlined,
                                        color: Color.fromRGBO(196, 102, 12, 1),
                                        )
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Tooltip(
                                    message: 'download',
                                    preferBelow: false,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(0, 101, 168, 1),
                                    ),
                                    child: IconButton(
                                        onPressed: () async{},
                                        icon: const Icon(Icons.download_for_offline_outlined,
                                        color: Color.fromRGBO(196, 102, 12, 1),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          textColor: Colors.black,
                          tileColor: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: screenHeight/10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: screenHeight / 5,
                    width: screenWidth / 4,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 101, 168, 1),
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(196, 102, 12, 0.8),
                            offset: Offset(0,3),
                            blurRadius: 6,
                          )
                        ]
                    ),
                    constraints: BoxConstraints(
                      maxHeight: screenHeight / 5,
                      maxWidth: screenWidth / 4,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Upload Dataset',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: screenWidth/50,
                              ),),
                            SizedBox(width: screenWidth/50,),
                            Icon(Icons.upload_file_outlined,
                              color: const Color.fromRGBO(196, 102, 12, 1),
                              size: screenWidth/30,
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight/50,),
                        Text('file types: .csv, .xlsx, .shp, .odt',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth/80,
                              fontWeight: FontWeight.w500
                          ),)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight/10,),
          ],
        ),
      ),
    );
  }
}
