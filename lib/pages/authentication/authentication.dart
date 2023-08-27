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

    // This code works best when not in web platform
    // final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    // final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth?.accessToken,
    //   idToken: googleAuth?.idToken,
    // );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    //This code works best when not in web platform
    // return await FirebaseAuth.instance.signInWithCredential(credential);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<UserCredential> changeAccountWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('email');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    // Once signed in, return the UserCredential
    // return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    //This code works best when not in web platform
    // This code works best when not in web platform
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleSignInAccount?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutWithGoogle() async {
    await FirebaseAuth.instance.signOut();
  }

}