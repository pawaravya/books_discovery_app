import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/shared/internet_connection_helper.dart';
import 'package:books_discovery_app/shared/widgets/common_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BaseWidget extends StatefulWidget {
  Widget screen;
  Widget? bottomNavigationBar;
  bool isRequiredBottomInsect = false;
  final Future<bool> Function()? handleOnWillPop;
  BaseWidget({
    super.key,
    required this.screen,
    this.bottomNavigationBar,
    this.isRequiredBottomInsect = false,
    this.handleOnWillPop,
  });

  @override
  State<BaseWidget> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseWidget> {
  final InternetConnectionHelper _internetConnectionController = Get.put(
    InternetConnectionHelper(),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(() {
          final isConnected =
              _internetConnectionController.isInternetConnected.value;
          return WillPopScope(
            onWillPop: isConnected == false
                ? () async {
                    return false;
                  }
                : widget.handleOnWillPop ??
                      () async {
                        return true;
                      },
            child: Scaffold(
            
              bottomNavigationBar: isConnected
                  ? widget.bottomNavigationBar
                  : null,
              resizeToAvoidBottomInset: widget.isRequiredBottomInsect,
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.only(left: 20.0 , right: 20),
                child: Stack(
                  children: [
                    PopScope(
                      onPopInvokedWithResult: (didPop, result) {},
                      child: Opacity(
                        opacity: isConnected
                            ? 1
                            : 0, // Make the content invisible when disconnected
                        child: IgnorePointer(
                          ignoring:
                              !isConnected, // Disable interaction when disconnected
                          child: Stack(children: [widget.screen]),
                        ),
                      ),
                    ),
                    // The "No Internet" overlay (displayed when disconnected)
                    if (!isConnected)
                      Positioned.fill(
                        child: CommonEmptyState(
                          onTapButton: () {},
                          stateScreenEmoji: ImageConstants.noInternetLottie,
                          stateScreenHeading: "No Internet Connection",
                          buttonText: 'RETRY',
                          stateScreenSubHeading:
                              "Please Check your Network and try again after sometime.",
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
