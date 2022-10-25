import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/widget/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({Key? key}) : super(key: key);

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (BuildContext context, MainProvider provider, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          title: Text(
            S.of(context).setting,
            style: const TextStyle(
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
        body: Column(
          children: [
            GoogleSignInButton(
              signInClick: () {
                provider.signInWithGoogle(context: context);
              },
              isSigningIn: provider.logingIn,
            ),
            ElevatedButton(
                onPressed: provider.googleSignInAccount != null
                    ? () {
                        provider.uploadFile(context);
                      }
                    : null,
                child: Text('123'),),
            ElevatedButton(
              onPressed: provider.googleSignInAccount != null
                  ? () {
                provider.downloadGoogleDriveFile();
              }
                  : null,
              child: Text('download'),),
            ElevatedButton(
              onPressed: provider.googleSignInAccount != null
                  ? () {
                provider.signOut(context);
              }
                  : null,
              child: Text('logout'),)
          ],
        ),
      );
    });
  }
}
