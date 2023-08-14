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