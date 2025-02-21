import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/google_speech.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';


import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';

void main() async{
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  String? _recordedFilePath;
  String _statusText = "Press Record to start";
  final AudioPlayer _audioPlayer = AudioPlayer();
  String _responseText = "";// Variable for generated JSON response
  @override
  void initState() {
    setPermissions();
    super.initState();
    _initRecorder();
  }

  void setPermissions() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  Future<void> _initRecorder() async {
    if (await Permission.microphone.request().isGranted) {
      await _recorder.openRecorder();
      setState(() {
        _isRecorderInitialized = true;
      });
    } else {
      setState(() {
        _statusText = "Microphone permission not granted.";
      });
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) return;
    String filePath = '${Directory.systemTemp.path}/flutter_sound_record.wav';
    _recordedFilePath = filePath;
    try {
      await _recorder.startRecorder(
        toFile: filePath,
        codec: Codec.pcm16WAV,
        sampleRate: 16000,
      );
      setState(() {
        _statusText = "Recording...";
      });
    } catch (e) {
      setState(() {
        _statusText = "Error starting recording: $e";
      });
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) return;
    try {
      String? filePath = await _recorder.stopRecorder();
      setState(() {
        _recordedFilePath = filePath;
        _statusText = "Recording stopped.";
      });
    } catch (e) {
      setState(() {
        _statusText = "Error stopping recording: $e";
      });
    }
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath == null) {
      setState(() {
        _statusText = "No recording found.";
      });
      return;
    }
    final filepath = '${Directory.systemTemp.path}/flutter_sound_record.wav';
    try {
      await _audioPlayer.play(DeviceFileSource(filepath));
      setState(() {
        _statusText = "Playing recording...";
      });
    } catch (e) {
      setState(() {
        _statusText = "Error playing recording: $e";
      });
    }
  }

  String content = '';
  void transcribe() async {
    setState(() {
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/ipocket-68f39a430624.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

    final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        //model: RecognitionModel.basic,
        //enableAutomaticPunctuation: true,
        sampleRateHertz: 16000,
        languageCode: 'en-US');

    final audio = await _getAudioContent('flutter_sound_record.wav');
    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        _statusText = value.results.map((e) => e.alternatives.first.transcript).join('\n');
        jsonControlledGeneration(_statusText);
      });
    });

  }

  Future<List<int>> _getAudioContent(String name) async {
    /*final directory = Directory; 
    await getApplicationDocumentsDirectory();*/
    final path = Directory.systemTemp.path + '/$name';
    //final path = '/sdcard/Download/temp.wav';
    return File(path).readAsBytesSync().toList();
  }

  Future<void> jsonControlledGeneration(sentence) async {
    final schema = Schema.object(properties: {
      'category': Schema.enumString(
        enumValues: [
          'Shopping',
          'Subscription',
          'Food',
          'Healthcare',
          'Groceries',
          'Transportation',
          'Utilities',
          'Housing',
          'Miscellaneous'
        ],
        description: 'Expense category chosen from predefined options.',
        nullable: true,
      ),
      'amount': Schema.number(description: 'Expense Total Amount', nullable: true),
      'description': Schema.string(description: 'Short description of the expense (in 1 line)', nullable: true),
    });

    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: '${dotenv.env['GEMINI_API_KEY']}',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    final prompt = 'Extract expense details from this sentence: $sentence . '
      'Return a JSON with category, amount, and description fields. '
      'The category must be one of: Shopping, Subscription, Food, Healthcare, Groceries Transportation, Utilities, Housing, or Miscellaneous. If unsure, set category to null.';

    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      _responseText = response.text!; // Update the state variable with the response text
    });
  }


  File? _image;
  String _extractedText = "Extracted text will appear here.";
  
  

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImage(_image!);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); 
      });
      _processImage(_image!);
    }
  }


  Future<void> _processImage(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String fullText = recognizedText.text; // Full receipt text
    RegExp regex = RegExp(r'\d+\.\d{2}'); // Match numbers like 25.96
    Iterable<Match> matches = regex.allMatches(fullText);
    print("matches: $matches");
    String totalAmount = matches.isNotEmpty ? matches.last.group(0)! : "0.00"; // Get last price

    setState(() {
      _extractedText = "Extracted Text:\n$fullText\n\nTotal Amount: RM $totalAmount";
    });

    // Send structured prompt to AI for JSON extraction
    jsonControlledGeneration("Receipt details:\n$fullText\n\nTotal Amount: RM $totalAmount");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sound STT Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("STT Demo"),
          backgroundColor: Colors.green,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // Remove mainAxisAlignment.center if you want the content to start at the top.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _statusText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _responseText.isNotEmpty
                        ? "Generated Response:\n$_responseText"
                        : "Generated response will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: [
                    FloatingActionButton(
                      onPressed: _startRecording,
                      tooltip: "Record",
                      child: const Icon(Icons.mic),
                    ),
                    FloatingActionButton(
                      onPressed: _stopRecording,
                      tooltip: "Stop",
                      child: const Icon(Icons.stop),
                    ),
                    FloatingActionButton(
                      onPressed: _playRecording,
                      tooltip: "Play",
                      child: const Icon(Icons.play_arrow),
                    ),
                    FloatingActionButton(
                      onPressed: transcribe,
                      tooltip: "Transcribe",
                      child: const Icon(Icons.text_fields),
                    ),
                  ],
                ),
                _image != null ? Image.file(_image!, height: 200) : Text("No Image Selected"),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text("Upload Image"),
                ),
                ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: Text("Take a photo"),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(_extractedText, textAlign: TextAlign.center),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
