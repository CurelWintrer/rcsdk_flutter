
import 'rcsdk_flutter_platform_interface.dart';

class RcsdkFlutter {


  Future<void> initSDK() async{
    await RcsdkFlutterPlatform.instance.initSDK();
  }

  Future<String?> modelNumber() async{
    return await RcsdkFlutterPlatform.instance.modelNumber();
  }

  Future<void> connectToRC() async{
    await RcsdkFlutterPlatform.instance.connectToRC();
  }

  Future<void> disconnectRC() async{
    await RcsdkFlutterPlatform.instance.disconnectRC();
  }

  Future<List<int>> getKeyChannels() async{
    return await RcsdkFlutterPlatform.instance.getKeyChannels();
  }

  Future<void> startKeyChannels() async{
    return await RcsdkFlutterPlatform.instance.startKeyChannelsListen();
  }

  Future<void> stopKeyChannels() async{
    return await RcsdkFlutterPlatform.instance.stopKeyChannelsListen();
  }


  Stream<List<int>> get keyChannels => RcsdkFlutterPlatform.instance.keyChannels;

}
