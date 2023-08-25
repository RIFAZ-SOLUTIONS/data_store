import 'package:data_store/pages/authentication/web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
];

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  late GoogleSignInAccount? currentUser;
  bool isAuthorized = false;

  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    clientId: '1094134202046-r6itlfp4v9jhki7rk707v6fu54q5oedc.apps.googleusercontent.com',
    scopes: scopes,
  );

@override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async{
      if (kIsWeb && account != null) {
        isAuthorized = await googleSignIn.canAccessScopes(scopes);
      }

      setState(() {
        currentUser = account;
        isAuthorized = isAuthorized;
      });

      googleSignIn.signInSilently();
    });
  }

  // On the web, this must be called from an user interaction (button click).
  Future<void> handleAuthorizeScopes() async {
    final bool authorized = await googleSignIn.requestScopes(scopes);
    setState(() {
      isAuthorized = authorized;
      currentUser = currentUser;
    });
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        // child: TextButton(
        //   onPressed: () async{
        //     await handleAuthorizeScopes();
        //     print(currentUser);
        //   },
        //   child: const Text('Sign In'),
        // ),
        child: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(196, 102, 12, 0.8),
                  offset: Offset(0,3),
                  blurRadius: 6,
                )
              ]
          ),
          child: buildSignInButton(
            onPressed: () async{
              await handleAuthorizeScopes();
              print(currentUser);
            },
          ),
        ),
      ),
    );
  }
}