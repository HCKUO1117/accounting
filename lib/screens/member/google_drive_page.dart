import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/google_drive_provider.dart';
import 'package:accounting/screens/widget/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GoogleDrivePage extends StatefulWidget {
  const GoogleDrivePage({Key? key}) : super(key: key);

  @override
  State<GoogleDrivePage> createState() => _GoogleDrivePageState();
}

class _GoogleDrivePageState extends State<GoogleDrivePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleDriveProvider()..initializeFirebase(context: context),
      child: Consumer<GoogleDriveProvider>(
        builder: (BuildContext context, GoogleDriveProvider provider, _) {
          return Container(
            color: Colors.white,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  S.of(context).backup,
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
              body: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 16),
                      if (provider.user == null)
                        GoogleSignInButton(
                          signInClick: () {
                            provider.signInWithGoogle(context: context);
                          },
                          isSigningIn: provider.logingIn,
                        )
                      else ...[
                        if (provider.user!.photoURL != null)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Image.network(
                                  provider.user!.photoURL!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(provider.user!.email!),
                        ),
                        const SizedBox(height: 32),
                      ],
                      if (provider.googleSignInAccount != null) ...[
                        Center(
                          child: Text(
                              '${S.of(context).backupTime} : ${provider.lastSaveTime != null ? DateFormat('yyyy/MM/dd HH:mm:ss').format(provider.lastSaveTime!) : S.of(context).none}'),
                        ),
                        const SizedBox(height: 32),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                              onPressed: provider.googleSignInAccount != null
                                  ? () {
                                      provider.uploadFile(context);
                                    }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cloud_upload_outlined),
                                  const SizedBox(width: 8),
                                  Text(S.of(context).backup),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                              onPressed: provider.googleSignInAccount != null && provider.id != null
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Text(S.of(context).overwriteInfo),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(S.of(context).cancel),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                provider.downloadGoogleDriveFile();
                                                Navigator.pop(context);
                                              },
                                              child: Text(S.of(context).ok),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.cloud_download_outlined),
                                  const SizedBox(width: 8),
                                  Text(S.of(context).download),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                        onPressed: provider.googleSignInAccount != null
                            ? () {
                                provider.signOut(context);
                              }
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout),
                            const SizedBox(width: 8),
                            Text(S.of(context).logout),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(S.of(context).googleDriveInfo),
                    ],
                  ),
                  if (provider.loading)
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
