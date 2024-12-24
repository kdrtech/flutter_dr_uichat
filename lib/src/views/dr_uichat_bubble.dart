import 'package:flutter/material.dart';

import 'dr_uichat.dart';
import 'dr_uimessage.dart';

class DRUIChatBubble extends WidgetsBindingObserver {
  static OverlayEntry? _overlayEntry;
  static BuildContext? baseContext;
  static void initChatBubble(BuildContext context,
      {Color backgroundColor = Colors.blue, Duration? delay}) {
    baseContext = context;
    WidgetsBinding.instance.addObserver(_DRUIChatBubbleObserver(
      onShow: () => show(context, backgroundColor: backgroundColor),
      delay: delay,
    ));
  }

  static void show(
    BuildContext context, {
    //required String message,
    Color backgroundColor = Colors.blue,
  }) {
    if (_overlayEntry != null) {
      return; // Already shown
    }

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        bottom: 50,
        right: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 60,
            height: 60,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () {
                hide();
                Navigator.push(
                  baseContext!,
                  MaterialPageRoute(builder: (context) => DRUIMessage()),
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.send),
            ),
          ),
        ),
      ),
    );

    // Insert into overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _DRUIChatBubbleObserver extends WidgetsBindingObserver {
  final VoidCallback onShow;
  final Duration? delay;

  _DRUIChatBubbleObserver({required this.onShow, this.delay}) {
    WidgetsBinding.instance.addObserver(this);
    _triggerShow();
  }

  void _triggerShow() async {
    if (delay != null) await Future.delayed(delay!);
    onShow();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Optionally auto-show overlay again when app comes to the foreground
      _triggerShow();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
