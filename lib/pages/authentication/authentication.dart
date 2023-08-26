import 'package:data_store/utility/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('email');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
  }

}