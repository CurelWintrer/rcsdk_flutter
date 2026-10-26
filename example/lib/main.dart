import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rcsdk_flutter/rcsdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _rcsdkFlutterPlugin = RcsdkFlutter();

  List<int> _keys = [];

  Timer? _keysListener;

  StreamSubscription<List<int>>? _keyChannelsSub;

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Center(
          child: Column(
            children: [
              Text(_keys.toString(),),
              FilledButton(
                onPressed: (){
                  _rcsdkFlutterPlugin.initSDK();
                },
                child: Text("initSDK"),
              ),

              FilledButton(
                onPressed: (){
                  _rcsdkFlutterPlugin.connectToRC();
                },
                child: Text("connect"),
              ),

              FilledButton(
                onPressed: (){
                  _rcsdkFlutterPlugin.disconnectRC();
                },
                child: Text("disconnect"),
              ),

              FilledButton(
                onPressed: (){
                  // final keys = await _rcsdkFlutterPlugin.getKeyChannels();
                  // setState(() {
                  //   _keys = keys;
                  // });

                  _startKeysListener();

                },
                child: Text("遥感数值监听"),
              ),

              FilledButton(onPressed:_stopKeysListener, child: Text("停止遥控器监听"),),

            ],
          ),
        ),
      ),
    );
  }

  void _startKeysListener() async{
    // _keysListener = Timer.periodic(const Duration(milliseconds: 100), (cancel)async{
    //   final keys = await _rcsdkFlutterPlugin.getKeyChannels();
    //   setState(() {
    //     _keys = keys;
    //   });
    // });
    // _rcsdkFlutterPlugin.
    _rcsdkFlutterPlugin.startKeyChannels();
    _keyChannelsSub?.cancel();
    _keyChannelsSub = _rcsdkFlutterPlugin.keyChannels.listen(_onKeyChannels);
  }


  void _onKeyChannels(List<int> keyChannels) {
    setState(() {
      _keys = keyChannels;
    });
  }

  void _stopKeysListener() async{
    // _keysListener?.cancel();
    // _keysListener = null;
    _rcsdkFlutterPlugin.stopKeyChannels();
    _keyChannelsSub?.cancel();
    _keyChannelsSub = null;
  }
}
