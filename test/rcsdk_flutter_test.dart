import 'package:flutter_test/flutter_test.dart';
import 'package:rcsdk_flutter/rcsdk_flutter.dart';
import 'package:rcsdk_flutter/rcsdk_flutter_platform_interface.dart';
import 'package:rcsdk_flutter/rcsdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockRcsdkFlutterPlatform
//     with MockPlatformInterfaceMixin
//     implements RcsdkFlutterPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final RcsdkFlutterPlatform initialPlatform = RcsdkFlutterPlatform.instance;
//
//   test('$MethodChannelRcsdkFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelRcsdkFlutter>());
//   });
//
//   test('getPlatformVersion', () async {
//     RcsdkFlutter rcsdkFlutterPlugin = RcsdkFlutter();
//     MockRcsdkFlutterPlatform fakePlatform = MockRcsdkFlutterPlatform();
//     RcsdkFlutterPlatform.instance = fakePlatform;
//
//     // expect(await rcsdkFlutterPlugin.getPlatformVersion(), '42');
//   });
// }
