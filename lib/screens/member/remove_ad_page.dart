import 'package:accounting/generated/l10n.dart';
import 'package:accounting/provider/iap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveAdPage extends StatefulWidget {
  const RemoveAdPage({Key? key}) : super(key: key);

  @override
  State<RemoveAdPage> createState() => _RemoveAdPageState();
}

class _RemoveAdPageState extends State<RemoveAdPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IAP>(builder: (BuildContext context, IAP iap, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).removeAd,
            style: const TextStyle(fontFamily: 'RobotoMono'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              S.of(context).removeAdInfo,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const Divider(),
            if(iap.isSubscription ?? false)
              Center(
                child: Text(S.of(context).subscribing),
              )else
            for (var element in iap.products) ...[
              Row(
                children: [
                  Expanded(child: Text('${element.price}/${S.of(context).eachMonth}')),
                  ElevatedButton(
                    onPressed: () {
                      iap.subscription();
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: Text(
                      S.of(context).subscription,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              const Divider()
            ],
          ],
        ),
      );
    });
  }
}
