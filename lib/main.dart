import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = new GoogleSignIn();
  GoogleSignInAccount googleAccount;
  Stream<FirebaseUser> get user => auth.onAuthStateChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: user,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot);
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  FirebaseUser user = snapshot.data;
                  print(user);
                  return Center(
                    child: Text('로그인 완료'),
                  );
                } else {
                  return Center(
                    child: Text('로그인 되어있지 않음'),
                  );
                }
              },
            ),
            RaisedButton(
              child: Text('로그인'),
              onPressed: () async {
                GoogleSignInAccount googleSignInAccount =
                    await googleSignIn.signIn();
                final GoogleSignInAuthentication googleSignInAuthentication =
                    await googleSignInAccount.authentication;
                final AuthCredential credential =
                    GoogleAuthProvider.getCredential(
                  accessToken: googleSignInAuthentication.accessToken,
                  idToken: googleSignInAuthentication.idToken,
                );
                await auth.signInWithCredential(credential);
              },
            ),
            RaisedButton(
              child: Text('로그아웃'),
              onPressed: auth.signOut,
            )
          ],
        ),
      ),
    );
  }
}
