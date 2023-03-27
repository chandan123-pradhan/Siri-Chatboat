import 'package:chat_boat/controllers/HomePageController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GetBuilder<HomePageController>(
        init: HomePageController(),
        builder: (controller) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: 
                
                
                
                Lottie.asset(
                  'assets/listening_girl_icon.json',
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: InkWell(
                      onTap: () {
                        controller.speechToText.isNotListening
                            ? controller.startListening()
                            : controller.stopListening();
                      },
                      child: controller.speechToText.isListening
                          ? Lottie.asset('assets/animated_mic.json',
                              height: 120, width: 100)
                          : const Icon(
                              Icons.mic,
                              size: 70,
                              color: Colors.black54,
                            )))
            ],
          );
        },
      ),
    );
  }
}
