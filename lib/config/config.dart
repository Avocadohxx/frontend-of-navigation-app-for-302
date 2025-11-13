import 'package:amap_flutter_base/amap_flutter_base.dart';

/// Configuration class for AMap SDK keys and privacy settings
/// 高德地图SDK密钥和隐私设置配置类
class ConstConfig {
  /// Android platform API key for AMap SDK
  /// 安卓平台高德地图SDK的API密钥
  static const androidKey = '5c9eaf78088b7edf4f26fcedef7ac634';
  
  /// iOS platform API key for AMap SDK
  /// iOS平台高德地图SDK的API密钥
  static const iosKey = 'ccbc40b69d70e054fe052ab24ce3ff11';
  
  /// Web platform API key for AMap SDK (currently not used)
  /// Web平台高德地图SDK的API密钥（当前未使用）
  static const webKey = '';

  /// Combined API keys configuration for AMap SDK
  /// 高德地图SDK的组合API密钥配置
  static const AMapApiKey amapApiKeys =
  AMapApiKey(iosKey: iosKey, androidKey: androidKey);

  /// Privacy statement configuration for AMap SDK compliance
  /// Important: If any of 'hasContains', 'hasShow', or 'hasAgree' is false,
  /// the AMap SDK will not work properly, resulting in white screen or other issues
  /// 
  /// 高德地图SDK隐私声明配置
  /// 重要提示：AMapPrivacyStatement 的'hasContains'、'hasShow'、'hasAgree'三个参数中
  /// 如果有一个为false，高德SDK将无法正常工作，会导致地图白屏等现象
  static const AMapPrivacyStatement amapPrivacyStatement =
  AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);
}


