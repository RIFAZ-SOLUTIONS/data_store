import 'package:flutter_svg/flutter_svg.dart';
import 'package:data_store/pages/authentication/authentication.dart';
import 'package:data_store/utility/database.dart';
import 'package:data_store/utility/functions.dart';
import 'package:data_store/widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fuzzy/fuzzy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String,dynamic> previewInput;
  late bool isVisible;
  User? currentUser;
  bool isAuthorized = false;
  bool isSignedIn = false;
  final ScrollController scrollController = ScrollController();
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1691071716244-db306a482fc0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1691264122434-3b5a1dac81d5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=928&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  ];
  final MaterialStateProperty<Color> searchBarColor = MaterialStateProperty.all(Colors.white);
  final TextEditingController searchController = TextEditingController();
  final DatabaseService database = DatabaseService();
  final AuthService auth = AuthService();
  List<dynamic> suggestions = [];
  late DatabaseEvent dataEvent;
  late DatabaseEvent downloadsEvent;

  Future<void> fetchSuggestions(query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });
    }

    final updatedSuggestions = [];
    late Map<dynamic, dynamic> dataValues;
    late Map<dynamic, dynamic> downloadsValues;
    try {
      dataValues = dataEvent.snapshot.value as Map<dynamic, dynamic>;
      downloadsValues = downloadsEvent.snapshot.value as Map<dynamic, dynamic>;
    } catch(e){
      dataValues = {'fsdlajaidjfas4':
        {
        'fhaskadkasl': {
          'title': 'No results',
          'downloads': 0,
          'added': ''
          }
        }
      };
      downloadsValues = {"123yghui9nslfsi9":
        {
          "datasetId": "123yghui9nslfsi9",
          "downloads": 0
        }
      };
    }

    // final RegExp regExp = RegExp(query, caseSensitive: false);
    dataValues.forEach((userId, dataset) {
      dataset.forEach((datasetId,value){
        final List<dynamic> matches = Fuzzy(value['title'].toString().trim().split(' '), options: FuzzyOptions(threshold: 0.72)).search(query);
        // regExp.hasMatch(value['title'])
        if (matches.isNotEmpty){
          downloadsValues.forEach((key, downloads) {
            if(downloads['datasetId'] == value['datasetId']){
              value['downloads'] = downloads['downloads'];
            }
          });
          updatedSuggestions.add(value);
        }
      });
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
    previewInput = {};

    // This stream makes the user to persist between sessions
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          currentUser = user;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight;
    late double screenWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth <= 500) {
          screenWidth = 500;
          screenHeight = MediaQuery.of(context).size.height;
        } else if(constraints.maxHeight <= 400){
          screenHeight = 400;
          screenWidth = MediaQuery.of(context).size.width;
        } else {
          screenHeight = MediaQuery.of(context).size.height;
          screenWidth = MediaQuery.of(context).size.width;
        }

        // final List<Widget> imageSliders = imgList
        //     .map((item) => SizedBox(
        //           width: screenWidth,
        //           child: Image.network(item,
        //               fit: BoxFit.fitWidth,
        //               height: screenHeight / 3,
        //               width: screenWidth),
        //         ))
        //     .toList();

        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight/6),
            child: AppBar(
              elevation: 0,
              toolbarHeight: screenHeight/6,
              title: Padding(
                padding: EdgeInsets.only(left: screenWidth/20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('The DataStore',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: screenWidth/130,),
                    const Text('Portal',
                      style: TextStyle(
                        color: Color(0xFFC4660C),
                        fontSize: 24,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  child:  currentUser == null ?
                  Row(
                    children: [
                      InkWell(
                        onTap: () async{
                          try{
                            final UserCredential credentials = await auth.signInWithGoogle();
                            setState(() {
                              currentUser = credentials.user;
                            });
                          } catch(_){
                            await showErrorDialog(context, _.toString());
                          }
                        },
                        child: Container(
                          width: 168,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E7EB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 8,),
                              SvgPicture.asset("assets/images/google.svg",
                              height: 25,
                              ),
                              const SizedBox(width: 12,),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Tooltip(
                        message: 'change account',
                        child: IconButton(
                          onPressed: () async{
                            try{
                              await auth.changeAccountWithGoogle();
                            } catch(_){
                              await showErrorDialog(context, _.toString());
                            }
                          },
                          icon: const Icon(Icons.account_box_outlined,
                            color: Color.fromRGBO(196, 102, 12, 0.6),
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  )
                      :
                  Container(
                    width: screenWidth/4.5,
                    height: screenHeight/14,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(0, 101, 168, 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: screenWidth/50,
                              height: screenWidth/50,
                              child: ClipOval(
                                child: CircleAvatar(
                                  radius: screenWidth/50,
                                  child: Image.network(currentUser!.photoURL!),
                                ),
                              )
                          ),
                        ],
                      ),
                      tileColor: const Color.fromRGBO(0, 101, 168, 1),
                      dense: true,
                      visualDensity: const VisualDensity(
                        vertical: -4.0,
                        horizontal: 1.0,
                      ),
                      title: Text(currentUser?.displayName ?? 'user',
                        style: TextStyle(
                            color: const Color.fromRGBO(196, 102, 12, 1),
                            fontSize: screenWidth/100,
                            fontWeight: FontWeight.w600
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(currentUser!.email!,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth/100,
                            fontWeight: FontWeight.w400
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth/50,
                            height: screenWidth/50,
                            child: Tooltip(
                              message: 'Sign out',
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async{
                                  try{
                                    await auth.handleSignOut();
                                    await auth.signOutWithGoogle();
                                    setState(() {
                                      currentUser = null;
                                    });
                                  } catch(_){
                                    await showErrorDialog(context, _.toString());
                                  }
                                },
                                icon: const Icon(Icons.logout_outlined,
                                  color: Color.fromRGBO(196, 102, 12, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              bottomOpacity: 3.5,
              backgroundColor: Colors.transparent,
            ),
          ),
          body: Stack(
            children: [
              Positioned(
                  top: 2,
                  left: 150,
                  child: CustomPaint(
                      foregroundPainter: CircleBlurPainter(
                          color: const Color.fromRGBO(20, 27, 52, 0.3),
                          circleStrokeWidth: 200,
                          radius: 150,
                          blurSigma: 90.0
                      ),
                  ),
              ),
              Positioned(
                  top: 0,
                  right: 150,
                  child: CustomPaint(
                      foregroundPainter: CircleBlurPainter(
                          color: const Color.fromRGBO(242, 95, 51, 0.3),
                          circleStrokeWidth: 400,
                          radius: 250,
                          blurSigma: 90.0
                      ),
                  ),
              ),
              Positioned(
                  bottom: 30,
                  left: 500,
                  child: CustomPaint(
                      foregroundPainter: CircleBlurPainter(
                          color: const Color.fromRGBO(11, 98, 154, 0.3),
                          circleStrokeWidth: 400,
                          radius: 250,
                          blurSigma: 90.0
                      ),
                  ),
              ),
              RawScrollbar(
                controller: scrollController,
                thumbColor: const Color.fromRGBO(196, 102, 12, 0.6),
                thickness: 8,
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(
                      height: (screenHeight * 2) / 4,
                      child: Stack(
                        children: [
                          Positioned(
                              top: screenHeight / 13,
                              left: screenWidth / 2.6,
                              child: Text('Tanzania Accessible Data',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth / 45,
                                  fontWeight: FontWeight.w700,
                                ),)
                          ),
                          Positioned(
                              top: screenHeight / 5,
                              left: screenWidth / 3,
                              child: Text(
                                '"We believe in the power of data custodianship."',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth / 60,
                                  fontWeight: FontWeight.w700,
                                ),)
                          ),
                          Positioned(
                              top: screenHeight / 3,
                              left: screenWidth / 4.4,
                              child: SearchBar(
                                controller: searchController,
                                hintText: 'Search datasets',
                                backgroundColor: searchBarColor,
                                constraints: BoxConstraints(
                                    maxWidth: screenWidth / 1.85),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                      style: BorderStyle.solid,
                                      color: Color.fromRGBO(196, 102, 12, 1),
                                    )),
                                elevation: MaterialStateProperty.all(3.0),
                                trailing: [
                                  Center(
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.search_rounded,
                                          color: const Color.fromRGBO(
                                              196, 102, 12, 1),
                                          size: screenWidth / 45,)),
                                  ),
                                ],
                                onTap: () async {
                                  final DatabaseEvent currentDataEvent = await database
                                      .fetchData();
                                  final DatabaseEvent currentDownloadsEvent = await database
                                      .fetchDownloads();
                                  setState(() {
                                    dataEvent = currentDataEvent;
                                    downloadsEvent = currentDownloadsEvent;
                                  });
                                },
                                onChanged: (query) async {
                                  if (query.isEmpty) {
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
                      height: screenHeight / 40,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: suggestions.length > 6 ? 6 : suggestions
                          .length,
                      itemBuilder: (context, index) {
                        return Visibility(
                          visible: isVisible,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth / 1.6,
                                decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(
                                            196, 102, 12, 0.7),
                                        style: BorderStyle.solid,
                                        width: 2,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Color.fromRGBO(
                                            196, 102, 12, 0.7),
                                        blurRadius: 2,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ]
                                ),
                                child: suggestions[index]['title'] ==
                                    'No results' ? ListTile(
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
                                      Flexible(
                                          fit: FlexFit.loose,
                                          child: Text(
                                              'Date added: ${suggestions[index]["dateAdded"]}')),
                                      SizedBox(width: screenWidth / 120,),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                              'Category: ${suggestions[index]["category"]}')),
                                      SizedBox(width: screenWidth / 120,),
                                      Container(
                                        height: screenHeight / 38,
                                        width: screenWidth / 35,
                                        decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                196, 102, 12, 0.7),
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                        child: Center(
                                          child: Text(
                                            suggestions[index]["fileType"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth / 110,
                                              fontWeight: FontWeight.bold,
                                            ),),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth / 120,),
                                      const Icon(Icons.file_download_outlined,
                                        color: Color.fromRGBO(0, 101, 168, 1),),
                                      Text(suggestions[index]["downloads"]
                                          .toString(),
                                        style: const TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontWeight: FontWeight.bold
                                        ),),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: screenWidth / 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Tooltip(
                                            message: 'preview',
                                            preferBelow: false,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  0, 101, 168, 1),
                                            ),
                                            child: IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    previewInput = {
                                                      'userId': suggestions[index]['userId'],
                                                      'datasetId': suggestions[index]['datasetId'],
                                                      'title': suggestions[index]['title'],
                                                      'description': suggestions[index]['description'],
                                                      'fileType': suggestions[index]['fileType'],
                                                      'fileSize': suggestions[index]['fileSize'],
                                                      'dateAdded': suggestions[index]['dateAdded'],
                                                      'source': suggestions[index]['source'],
                                                      'downloads': suggestions[index]['downloads'],
                                                      'downloadLink': suggestions[index]['downloadLink'],
                                                    };
                                                  });
                                                  await datasetPreview(
                                                      context,
                                                      previewInput,
                                                      currentUser
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.preview_outlined,
                                                  color: Color.fromRGBO(
                                                      196, 102, 12, 1),
                                                )
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10,),
                                        Flexible(
                                          child: Tooltip(
                                            message: 'download',
                                            preferBelow: false,
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(
                                                  0, 101, 168, 1),
                                            ),
                                            child: IconButton(
                                                onPressed: () async {
                                                  final String url = suggestions[index]['downloadLink'];
                                                  if (currentUser != null) {
                                                    downloadFile(url);
                                                    await database
                                                        .updateDownloads(
                                                      suggestions[index]['downloads'],
                                                      suggestions[index]['datasetId'],
                                                    );
                                                  } else {
                                                    await showErrorDialog(
                                                        context,
                                                        'You must Sign in, to download a file.');
                                                  }
                                                },
                                                icon: const Icon(Icons
                                                    .download_for_offline_outlined,
                                                  color: Color.fromRGBO(
                                                      196, 102, 12, 1),
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  textColor: Colors.black,
                                  tileColor: Colors.white54,
                                  onTap: () async {
                                    setState(() {
                                      previewInput = {
                                        'userId': suggestions[index]['userId'],
                                        'datasetId': suggestions[index]['datasetId'],
                                        'title': suggestions[index]['title'],
                                        'description': suggestions[index]['description'],
                                        'fileType': suggestions[index]['fileType'],
                                        'fileSize': suggestions[index]['fileSize'],
                                        'dateAdded': suggestions[index]['dateAdded'],
                                        'source': suggestions[index]['source'],
                                        'downloads': suggestions[index]['downloads'],
                                        'downloadLink': suggestions[index]['downloadLink'],
                                      };
                                    });
                                    await datasetPreview(
                                        context,
                                        previewInput,
                                        currentUser
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight / 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (currentUser != null) {
                              await datasetInput(context, currentUser);
                            } else {
                              await showErrorDialog(context,
                                  'You must Sign in, to upload a file.');
                            }
                          },
                          child: Container(
                            height: screenHeight / 5,
                            width: screenWidth / 4,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 101, 168, 1),
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(196, 102, 12, 0.8),
                                    offset: Offset(0, 3),
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
                                        fontSize: screenWidth / 50,
                                      ),),
                                    SizedBox(width: screenWidth / 50,),
                                    Icon(Icons.upload_file_outlined,
                                      color: const Color.fromRGBO(
                                          196, 102, 12, 1),
                                      size: screenWidth / 30,
                                    )
                                  ],
                                ),
                                SizedBox(height: screenHeight / 50,),
                                Text('file types: .csv, .xlsx, .pdf, .odt',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth / 80,
                                      fontWeight: FontWeight.w500
                                  ),)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight / 10,),
                  ],
                ),
              ),
            ]
          ),
        );

      },
    );
  }
}

class CircleBlurPainter extends CustomPainter {

  CircleBlurPainter({required this.color, required this.circleStrokeWidth, required this.radius, required this.blurSigma});

  double circleStrokeWidth;
  double blurSigma;
  double radius;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = color
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.fill
      ..strokeWidth = circleStrokeWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = const Offset(0, 0);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

