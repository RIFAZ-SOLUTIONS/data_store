import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
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
      appBar: AppBar(
        elevation: 3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The Data Store',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27
            ),
            ),
            SizedBox(width: screenWidth/90,),
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

                trailing: [Container(
                  height: screenHeight/17,
                  width: screenWidth/35,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(196, 102, 12, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search_rounded,
                        color: Colors.white,
                        size: 30,)),
                  ),
                )],
              )
          ),
        ],
      ),
    );
  }
}
