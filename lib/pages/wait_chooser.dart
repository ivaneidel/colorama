import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:colorama/configuration/storage.dart';
import 'package:colorama/pages/player_chooses.dart';
import 'package:flutter/material.dart';

class WaitChooserPage extends StatefulWidget {
  const WaitChooserPage({super.key});

  @override
  State<WaitChooserPage> createState() => _WaitChooserPageState();
}

class _WaitChooserPageState extends State<WaitChooserPage> {
  @override
  void initState() {
    super.initState();
    Storage.getStream().listen((snapshot) {
      final data = snapshot.data() as Map;
      print(data);
      final r = data['r'];
      final g = data['g'];
      final b = data['b'];

      if (r != null && g != null && b != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const PlayerChoosesPage(),
            settings: const RouteSettings(name: 'PlayerChoosesPage'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPop(context),
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Storage.getStream(),
            builder: (context, snapshot) {
              String chooser = '';

              if (snapshot.data?.data() != null) {
                final data = snapshot.data!.data() as Map;
                chooser = data['chooser'];
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox.shrink()),
                      Text(
                        '$chooser está eligiendo un color',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: const LinearProgressIndicator(),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'El juego comenzará pronto',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
