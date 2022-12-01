import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/google_drive_provider.dart';
import 'package:accounting/provider/iap.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/screens/widget/google_sign_in_button.dart';
import 'package:accounting/utils/my_banner_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
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
      child: Consumer2<GoogleDriveProvider,IAP>(
        builder: (BuildContext context, GoogleDriveProvider provider,IAP iap, _) {
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
                            child: Builder(
                              builder: (c) {
                                return ElevatedButton(
                                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                                  onPressed: provider.googleSignInAccount != null
                                      ? () async {
                                          bool? success = await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content: Text(S.of(context).backupInfo),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(S.of(context).cancel),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: Text(S.of(context).ok),
                                                )
                                              ],
                                            ),
                                          );
                                          if (success ?? false) {
                                            if (!mounted) return;
                                            await provider.uploadFile(
                                              context,
                                              onSuccess: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(S.of(context).uploadSuccess),
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                              },
                                              onError: (e) {
                                                showDialog(
                                                  context: c,
                                                  builder: (context) => AlertDialog(
                                                    content: Text('${S.of(context).error}\n$e'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          final Email email = Email(
                                                            body: e,
                                                            subject:
                                                                'Accounting ${S.of(context).errorReport}',
                                                            recipients: [
                                                              'bad.tech.service@gmail.com'
                                                            ],
                                                            cc: [],
                                                            bcc: [],
                                                            attachmentPaths: [],
                                                            isHTML: false,
                                                          );
                                                          await FlutterEmailSender.send(email);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(S.of(context).report),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(S.of(context).ok),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
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
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(
                              builder: (c) {
                                return ElevatedButton(
                                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                                  onPressed: provider.googleSignInAccount != null &&
                                          provider.id != null
                                      ? () async {
                                          bool? success = await showDialog(
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
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: Text(S.of(context).ok),
                                                )
                                              ],
                                            ),
                                          );
                                          if (success ?? false) {
                                            provider.downloadGoogleDriveFile(
                                              onSuccess: () async {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(S.of(context).downloadSuccess),
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                                await context.read<MainProvider>().getFixedIncomeList();
                                                context.read<MainProvider>().checkInsertData();
                                              },
                                              onError: (e) {
                                                showDialog(
                                                  context: c,
                                                  builder: (context) => AlertDialog(
                                                    content: Text('${S.of(context).error}\n$e'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          final Email email = Email(
                                                            body: e,
                                                            subject:
                                                                'Accounting ${S.of(context).errorReport}',
                                                            recipients: [
                                                              'bad.tech.service@gmail.com'
                                                            ],
                                                            cc: [],
                                                            bcc: [],
                                                            attachmentPaths: [],
                                                            isHTML: false,
                                                          );
                                                          await FlutterEmailSender.send(email);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(S.of(context).report),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(S.of(context).ok),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                        onPressed: provider.user != null
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
                      const SizedBox(height: 32),

                        const AdBanner(large: true),
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
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
