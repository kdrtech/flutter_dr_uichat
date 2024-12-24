import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dr_uichat/flutter_dr_uichat.dart';

void main() {
  DRChatConfig.config.set();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DRUIChatUser> users = [];
  List<DRUIChatMessage> chatMessages = [];
  @override
  void initState() {
    super.initState();
    //show chat bubble
    initChatBubble();
    //Set Message screen event
    setDRMessageEvent();
    //SetChat screen event
    setDRChatEvent();
  }

  void initChatBubble() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DRUIChatBubble.initChatBubble(
        context,
        backgroundColor: Colors.green,
        delay: const Duration(seconds: 2), // Optional delay before showing
      );
    });
  }

  //Testing  Receiver
  void testingReceiver() {
    Future.delayed(const Duration(milliseconds: 500), () {
      DRChatService.chatService.addReceiver(
        DRUIChatMessage(
          id: 1,
          name: "kuchdarith",
          isSender: false,
          message: "Testing hi from Receiver?",
          photo:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyCF3FunYuwPDPL9ovTOR0MQXdDJpW_ofgXA&s",
          createdAt: DateTime.now().toUtc().toString(),
        ),
      );
    });
  }

  ///Start Chat Screen
  void setDRChatEvent() {
    //Chat screen ready to add message list.
    DRChatService.chatService.onChatLoaded = (data) {
      getChatMessageList();
    };
    //Get message when sender send chat to receiver.
    DRChatService.chatService.onMessage = (message) {
      DRChatService.chatService.addSender(
        DRUIChatMessage(
          id: 1,
          name: "kuchdarith",
          photo:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",
          isSender: true,
          message: message,
          createdAt: DateTime.now().toUtc().toString(),
        ),
      );
      //This testing receiver send back only.
      testingReceiver();
    };
  }

  //Get Chat lists
  void getChatMessageList() {
    chatMessages = [];
    chatMessages.add(
      DRUIChatMessage(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",
        isSender: true,
      ),
    );
    chatMessages.add(
      DRUIChatMessage(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",
        isSender: true,
      ),
    );
    chatMessages.add(
      DRUIChatMessage(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyCF3FunYuwPDPL9ovTOR0MQXdDJpW_ofgXA&s",
        isSender: false,
      ),
    );
    chatMessages.add(
      DRUIChatMessage(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRXxfn1j1vKFy8yJeBGl2AS6Dcah-lKgHofg&s",
        isSender: true,
      ),
    );

    DRChatService.chatService.setChatMessageLists(chatMessages);
  }
  //End Chat Screen

  ///Start Message Screen
  void setDRMessageEvent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Delete Message.
      DRChatService.chatService.onDeleteMessage = (data) {
        print("Delete");
      };
      DRChatService.chatService.onMessageRefresh = () async {
        getMessageList();
        await Future.delayed(const Duration(seconds: 1));
      };
      DRChatService.chatService.onMessageLoadMore = () async {
        await Future.delayed(const Duration(seconds: 1));
        loadMoreMessageList();
      };
      DRChatService.chatService.onMessageLoaded = (status) {
        getMessageList();
      };
    });
  }

  void loadMoreMessageList() {
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyCF3FunYuwPDPL9ovTOR0MQXdDJpW_ofgXA&s",
      ),
    );
  }

  void getMessageList() {
    users = [];

    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Kuch Darith",
        message: "Hi , how are you?",
        createdAt: "2024-09-12T20:42:19Z",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyCF3FunYuwPDPL9ovTOR0MQXdDJpW_ofgXA&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Sok San",
        message: "hahaha",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );
    users.add(
      DRUIChatUser(
        id: Random().nextInt(10000),
        name: "Bopha",
        message: "hahaha",
        photo:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1oiHvf2LgSX3qMalIRToh28R40FJj4HA0Jg&s",
      ),
    );

    DRChatService.chatService.setMessageLists(users);
  }

  ///End Message Screen
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
