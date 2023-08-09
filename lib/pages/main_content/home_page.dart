import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1691071716244-db306a482fc0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1691264122434-3b5a1dac81d5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=928&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  ];
  final MaterialStateProperty<Color> searchBarColor = MaterialStateProperty.all(Colors.white);


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Widget> imageSliders = imgList
        .map((item) => SizedBox(
      width: screenWidth,
      child: Image.network(item, fit: BoxFit.fitWidth, height:screenHeight/3, width: screenWidth),
    ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white70,
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
            SizedBox(width: screenWidth/100,),
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
      body: Stack(
        children: [
          Positioned(
              top: 0,
              bottom: screenHeight/3,
              left: 0,
              right: 0,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  clipBehavior: Clip.hardEdge,
                ),
                items: imageSliders,
              )
          ),
          Positioned(
              top: screenHeight/15,
              left: screenWidth/2.8,
              child: const Text('Tanzania Accessible Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),)
          ),
          Positioned(
              top: screenHeight/5,
              left: screenWidth/2.8,
              child: const Text('"We believe in the power of data custodianship."',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),)
          ),
          Positioned(
              top: screenHeight/3,
              left: screenWidth/4.8,
              child: SearchBar(
                hintText: 'Search datasets',
                backgroundColor: searchBarColor,
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
                  )
                ],
              )
          ),
          Positioned(
            top: screenHeight / 1.58,
            left: screenWidth / 2.6,
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
                  Text('file types: .csv, .xsxl, .shp, .odt',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth/80,
                    fontWeight: FontWeight.w500
                  ),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
