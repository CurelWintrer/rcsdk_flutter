import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rcsdk_flutter_platform_interface.dart';

/// An implementation of [RcsdkFlutterPlatform] that uses method channels.
class MethodChannelRcsdkFlutter extends RcsdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rcsdk_flutter');

  MethodChannelRcsdkFlutter(){
    methodChannel.setMethodCallHandler(_methodHandler);
  }

  @override
  Future<void> initSDK() async{
    await methodChannel.invokeMethod("initSDK");
  }

  @override
  Future<String?> modelNumber() async{
    return await methodChannel.invokeMethod<String>("modelNumber");
  }

  @override
  Future<void> connectToRC() async{
    await methodChannel.invokeMethod("connectToRC");
  }

  @override
  Future<void> disconnectRC() async{
    await methodChannel.invokeMethod("disconnectRC");
  }


  @override
  Future<List<int>> getKeyChannels() async{
    final result = await methodChannel.invokeMethod<List<dynamic>>("getKeyChannels");
    return result?.cast<int>() ?? <int>[];
  }

  @override
  Future<void> startKeyChannelsListen() async{

    return await methodChannel.invokeMethod("startKeyChannelsListen",);
  }

  @override
  Future<void> stopKeyChannelsListen() async{
    return await methodChannel.invokeMethod("stopKeyChannelsListen");
  }

  Future<dynamic> _methodHandler(MethodCall methodCall) async{
    final method = methodCall.method;
    if (method == "onKeyChannels") {
      final result = methodCall.arguments as List<int>;
      _onKeyChannels(result);
    }
  }

  void _onKeyChannels(List<int> channels) {
    _keyChannels.add(channels);
  }


  final StreamController<List<int>> _keyChannels = StreamController<List<int>>.broadcast();

  @override
  Stream<List<int>> get keyChannels => _keyChannels.stream;

}
