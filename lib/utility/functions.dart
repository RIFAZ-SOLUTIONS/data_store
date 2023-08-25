import 'dart:html' as html;

import 'package:flutter_dotenv/flutter_dotenv.dart';

void downloadFile(String url) {
  html.AnchorElement anchorElement = html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

String? getClientID(){
  final String? clientID = dotenv.env['CLIENT_ID'];
  return clientID;
}