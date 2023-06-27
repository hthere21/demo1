import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController =
      TextEditingController(text: '');
  SpeechToText _speechToText = SpeechToText();
  bool isListening = false;
  bool isUsingDictation = false;

  void _startListening() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() {
            isListening = false;
          });
        }
      },
      onError: (error) {
        print('Speech recognition error: $error');
      },
    );

    if (available) {
      setState(() {
        isListening = true;
      });

      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _textEditingController.text = result.recognizedWords;
          });
        },
        //Set the language to English
        localeId: 'en_US',
      );
    } else {
      print('Speech recognition not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Doctor Notes's",
            style: TextStyle(
              color: Colors.black,
            )),
        shadowColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient Name",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      Text("Patient Age"),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          isListening = !isListening;
                        });

                        if (isListening) {
                          _startListening();
                        } else {
                          _speechToText.stop();
                          _textEditingController.clear();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Dictation ",
                            style: TextStyle(color: Colors.black),
                          ),
                          Visibility(
                            child: Icon(
                              Icons.mic,
                              color: Colors.black,
                            ),
                            visible: !isListening,
                          ),
                          Visibility(
                            child: Icon(
                              Icons.pause_circle,
                              color: Colors.red,
                            ),
                            visible: isListening,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0, bottom: 5.0),
              child: Text(
                "Symptoms and Diagnosis",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Text(
                      "Summary of symtoms",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Cough, chest pain...',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Text(
                      "Diagnosis",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Cold...',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Text(
                      "Prescriptions",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ibuprofen...',
                      ),
                    ),
                  ),
                ]),
            Visibility(
              visible: isListening,
              child: Container(
                margin: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Dictation",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _textEditingController.text = '';
                                _speechToText.stop();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 100.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Summarize",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(
                                  Icons.summarize,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: _textEditingController,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Listening..',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:
                          Text('Cancel', style: TextStyle(color: Colors.black)),
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Handle button press
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
