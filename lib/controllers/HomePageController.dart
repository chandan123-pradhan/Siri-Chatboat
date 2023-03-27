import 'dart:async';
import 'dart:developer';

import 'package:chat_boat/utils/AppConstant.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class HomePageController extends GetxController {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  final openAI = OpenAI.instance.build(
      token: AppConstant.Chat_Gpt_Api_Key,
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)));
  // final openAI = OpenAI.instance.builder(AppConstant.CHAT_GPT_TOKEN,
  //     baseOption: HttpSetup(receiveTimeout: 6000));

  @override
  void onInit() {
    // TODO: implement onInit
    _initSpeech();
    super.onInit();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    update();
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    lastWords = '';
    try {
      await speechToText.listen(onResult: _onSpeechResult);
    } catch (e) {
      print("Error $e");
    }
    update();
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await speechToText.stop();

    update();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    if (result.finalResult == true) {
      Timer(const Duration(milliseconds: 200), () {
        askQuestionToBot(lastWords);
      });
    }

    update();
  }

/**
 * This method will ask question to the Chat Gpt.
 * 
 * [question] String Question is your question.
 */
  void askQuestionToBot(String question) async {
    final request =
        CompleteText(prompt: question, model: kTextDavinci3, maxTokens: 200);

    final response = await openAI.onCompletion(request: request);
    debugger();
    print(response!.choices.last.text.trimLeft());
  }
}
