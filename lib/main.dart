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

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // controllers
  TextEditingController _recipientsController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _batchSizeController = TextEditingController();

  // defaults
  List<String> recipients = [];
  int batchSize = 10;
  String errorMessage = "";

  void _convertToRecipients(String input) {
    // converts the input of comma separated numbers into a List
    setState(() {
      recipients = input.split(',').map((s) => s.trim()).toList();
    });
  }

  bool _isValidListOfPhoneNumbers(List<String> recipients) {
    // a regex validation of the supplied recipient numbers.
    bool isValid = true;
    List<String> badNumbers = [];
    final RegExp phoneRegExp = RegExp(
        r'^\+?(\d{1,3})?[-. ]?(\(?\d{1,4}\)?)?[-. ]?\d{1,4}[-. ]?\d{1,4}[-. ]?\d{1,9}$'
    );

    recipients.forEach((recipientNumber) {
      if (!phoneRegExp.hasMatch(recipientNumber)) {
        isValid = false;
        badNumbers.add(recipientNumber);
      }
    });
    if (!isValid) {
      // generate an error message.
      errorMessage = "Bad format on the following recipient numbers: ${badNumbers}";
    }
    return isValid;
  }

  void _sendSMS(String message, List<String> recipients) async {
    while (recipients.isNotEmpty) {
      List<String> batch = recipients.length > batchSize
          ? recipients.sublist(0, batchSize)
          : recipients.sublist(0, recipients.length);

      recipients.removeRange(0, batch.length);

      try {
        String _result = await sendSMS(message: message, recipients: batch);
        print(_result);
      } catch (onError) {
        print(onError);
      }
    }
  }

  void _updateBatchSize(String input) {
    setState(() {
      batchSize = int.tryParse(input) ?? 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.displayMedium!.copyWith(
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 100, // Make the height more square-like
                    child: TextField(
                      controller: _recipientsController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        labelText: 'Enter comma-separated phone numbers',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (text) {
                        _convertToRecipients(text);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _batchSizeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter batch size',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      _updateBatchSize(text);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {
                  String message = _messageController.text;
                  if (_isValidListOfPhoneNumbers(recipients)) {
                    // valid numbers, SEND THE SPAM
                    _sendSMS(message, List.from(recipients));
                  }
                  else {
                    // display the error message.
                    final snackBar = SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.black,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
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
