import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rcsdk_flutter_method_channel.dart';

abstract class RcsdkFlutterPlatform extends PlatformInterface {
  /// Constructs a RcsdkFlutterPlatform.
  RcsdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static RcsdkFlutterPlatform _instance = MethodChannelRcsdkFlutter();

  /// The default instance of [RcsdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelRcsdkFlutter].
  static RcsdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RcsdkFlutterPlatform] when
  /// they register themselves.
  static set instance(RcsdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Future<String?> getPlatformVersion() {
  //   throw UnimplementedError('platformVersion() has not been implemented.');
  // }

  Future<void> initSDK() {
    throw UnimplementedError('initSDK() has not been implemented.');
  }

  /// 遥控器型号
  Future<String?> modelNumber() {
    throw UnimplementedError('modelNumber() has not been implemented.');
  }

  Future<void> connectToRC() {
    throw UnimplementedError('connectToRC() has not been implemented.');
  }

  Future<void> disconnectRC() {
    throw UnimplementedError('disconnectRC() has not been implemented.');
  }

  /// 获取遥感量
  Future<List<int>> getKeyChannels() {
    throw UnimplementedError('getKeyChannels() has not been implemented.');
  }

  /// 开始遥感量监听
  Future<void> startKeyChannelsListen() {
    throw UnimplementedError('startKeyChannelsListen() has not been implemented.');
  }

  /// 停止遥感量监听
  Future<void> stopKeyChannelsListen() {
    throw UnimplementedError('stopKeyChannelsListen() has not been implemented.');
  }

  /// 遥感量
  Stream<List<int>> get keyChannels {
    throw UnimplementedError('keyChannels has not been implemented');
  }
}
