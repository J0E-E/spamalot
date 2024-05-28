import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'spamALOT',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: Colors.white,
    );

    // set your recipients here.
    List<String> recipients = [
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
      "8136903843",
      "8136990142",
    ];

    String message = "Test Message";

    void _sendSMS(String message, List<String> recipients) async {
      while (recipients.isNotEmpty) {
        // Adjust this for your batch size.
        int batchSize = 10;
        // Get the first N (or fewer) recipients
        List<String> batch = recipients.length > batchSize
            ? recipients.sublist(0, batchSize)
            : recipients.sublist(0, recipients.length);

        // Remove the first 10 (or fewer) recipients from the original list
        recipients.removeRange(0, batch.length);

        try {
          String _result = await sendSMS(message: message, recipients: batch);
          print(_result);
        } catch (onError) {
          print(onError);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  appState.getNext();
                  _sendSMS(message, recipients);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: Text(
                  'spamALOT',
                  style: textStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
