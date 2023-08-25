import 'package:data_store/pages/authentication/web.dart';
import 'package:data_store/utility/functions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
];

class SignInButton extends StatefulWidget {
  const SignInButton({super.key});

  @override
  State<SignInButton> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SignInButton> {
  late GoogleSignInAccount? currentUser;
  bool isAuthorized = false;

  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: getClientID(),
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
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(196, 102, 12, 0.8),
              offset: Offset(0,3),
              blurRadius: 6,
            )
          ],
      ),
      child: buildSignInButton(
        onPressed: () async{
          await handleAuthorizeScopes();
          // TODO add setState here
        },
      ),
    );
  }
}