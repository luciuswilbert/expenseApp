import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Recorder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RecorderScreen(),
    );
  }
}

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isRecorderReady = false;
  String? _recordedFilePath;

  String? _recognizedText='text to be recognized';
  String? _responseText='categorized text';

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initialize();
  }

  Future<void> _initialize() async {
    // Request microphone permission
    var status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await _recorder!.openRecorder();
      await _player!.openPlayer();
      setState(() {
        _isRecorderReady = true;
      });
    } else {
      // Handle permission denial (for simplicity, just log it)
      debugPrint('Microphone permission denied');
    }
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isRecorderReady) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = '${appDocDir.path}/audio.amr';
      await _recorder!.startRecorder(
        toFile: path,
        codec: Codec.amrNB,
        );
      setState(() {
        _isRecording = true;
      });
    } else {
      debugPrint('Recorder is not ready');
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecorderReady && _isRecording) {
      _recordedFilePath = await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath != null && !_isRecording) {
      await _player!.startPlayer(fromURI: _recordedFilePath);
    }
  }

  Future<void> transcribe(String? path) async {
    print("path: $path");
    setState(() {
    });
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/ipocket-68f39a430624.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

    final config = RecognitionConfig(
        encoding: AudioEncoding.AMR,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 8000,
        languageCode: 'en-US');

    final audio = File(path!).readAsBytesSync().toList();
    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        _recognizedText = value.results.map((e) => e.alternatives.first.transcript).join('\n');
        print("Text: $_recognizedText");
        //jsonControlledGeneration(_recognizedText);
      });
    });
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
      apiKey: 'AIzaSyDReqVkKB-d5f4U9gr06wdGbsyXrt9Q8eQ',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Recorder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status text
            Text(
              _isRecorderReady
                  ? (_isRecording
                      ? 'Recording...'
                      : (_recordedFilePath != null
                          ? 'Recording finished'
                          : 'Ready to record'))
                  : 'Initializing...',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Record/Stop button
            ElevatedButton(
              onPressed: _isRecorderReady
                  ? (_isRecording ? _stopRecording : _startRecording)
                  : null,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 10),
            // Play button (visible only after recording)
            if (_recordedFilePath != null)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _isRecording ? null : _playRecording,
                    child: const Text('Play Recording'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:()=>{  _isRecording ? null : transcribe(_recordedFilePath)},
                    child: const Text('Transcribe'),
                  ),
                  Padding(padding: EdgeInsets.all(8),child:Text("Recongized text: ${_recognizedText!}",style: TextStyle(fontSize: 20),)
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:()=>{  _isRecording ? null : jsonControlledGeneration(
                      _recognizedText
                    )},
                    child: const Text('Categorize'),
                  ),
                  Padding(padding: EdgeInsets.all(8),child:Text("Response text: ${_responseText!}",style: TextStyle(fontSize: 20),)
                  ),
                ]
              ),
          ],
        ),
      ),
    );
  }
}