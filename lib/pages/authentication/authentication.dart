import 'package:data_store/utility/functions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  List<String> scopes = <String>[
    'email',
  ];

  static const List<String> scope = <String>[
    'email',
  ];

  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: getClientID(),
    scopes: scope,
  );

  Future<bool> handleAuthorizeScopes() async {
    final bool authorized = await googleSignIn.requestScopes(scope);
    return authorized;
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();
}