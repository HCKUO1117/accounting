import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/main_provider.dart';
import 'package:accounting/res/app_color.dart';
import 'package:accounting/screens/member/google_drive_page.dart';
import 'package:accounting/screens/member/notification_page.dart';
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
    return Consumer<MainProvider>(
      builder: (BuildContext context, MainProvider provider, _) {
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
          body: ListView(
            children: [
              settingTitle(
                title: S.of(context).backup,
                icon: Icons.backup_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleDrivePage(),
                    ),
                  );
                },
              ),
              const Divider(),
              settingTitle(
                title: S.of(context).notification,
                icon: Icons.notifications_none_sharp,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget settingTitle({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
