import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:version4/config/config.dart';


/// Location page widget for displaying and managing device location information
/// 定位页面组件，用于显示和管理设备位置信息
class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

/// State class for location page, handling location services and UI updates
/// 定位页面的状态类，处理定位服务和UI更新
class _LocationPageState extends State<LocationPage> {
  String _latitude = ""; // Latitude coordinate / 纬度坐标
  String _longitude = ""; // Longitude coordinate / 经度坐标
  String country = ""; // Country name / 国家名称
  String province = ""; // Province name / 省份名称
  String city = ""; // City name / 城市名称
  String district = ""; // District name / 区县名称
  String street = ""; // Street name / 街道名称
  String adCode = ""; // Administrative code / 行政区划代码
  String address = ""; // Detailed address / 详细地址
  String cityCode = ""; // City code / 城市代码

  // Instantiate AMap location plugin
  // 实例化高德地图定位插件
  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  // Location change listener subscription
  // 定位变化监听器订阅
  late StreamSubscription<Map<String, Object>> _locationListener;

  @override
  void initState() {
    super.initState();

    /// Dynamically request location permission
    /// 动态申请定位权限
    requestPermission();

    /// Set API keys for Android and iOS platforms
    /// 设置Android和iOS平台的API密钥
    AMapFlutterLocation.setApiKey(ConstConfig.androidKey, ConstConfig.iosKey);

    /// Set user agreement status for AMap SDK compliance
    /// If user agreement is not obtained, AMap location SDK will not work
    /// 
    /// 设置用户同意状态以满足高德SDK合规要求
    /// 如果未取得用户同意，高德定位SDK将不会工作
    AMapFlutterLocation.updatePrivacyAgree(true);

    /// Set privacy policy display status for AMap SDK
    /// If privacy policy is not properly displayed, AMap location SDK will not work
    /// 
    /// 设置隐私政策显示状态以满足高德SDK要求
    /// 如果隐私政策未正确显示，高德定位SDK将不会工作
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// iOS: Get native accuracy authorization type
    /// iOS平台：获取原生精度类型
    if (Platform.isIOS) {
      requestAccuracyAuthorization();
    }

    /// Register location result listener
    /// 注册定位结果监听器
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      print("Location update: $result / 位置更新: $result");

      setState(() {
        _latitude = result["latitude"].toString();
        _longitude = result["longitude"].toString();
        country = result['country'].toString();
        province = result['province'].toString();
        city = result['city'].toString();
        district = result['district'].toString();
        street = result['street'].toString();
        adCode = result['adCode'].toString();
        address = result['address'].toString();
        cityCode = result['cityCode'].toString();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// Remove location listener to prevent memory leaks
    /// 移除定位监听器以防止内存泄漏
    if (null != _locationListener) {
      _locationListener.cancel();
    }

    /// Destroy location plugin to release resources
    /// 销毁定位插件以释放资源
    if (null != _locationPlugin) {
      _locationPlugin.destroy();
    }
  }

  /// Dynamically request location permission from user
  /// 动态向用户申请定位权限
  void requestPermission() async {
    // Request permission
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("Location permission granted / 定位权限申请通过");
    } else {
      print("Location permission denied / 定位权限申请不通过");
    }
  }

  /// Request location permission and return result
  /// Returns true if permission is granted, false otherwise
  /// 
  /// 申请定位权限并返回结果
  /// 授予定位权限返回true，否则返回false
  Future<bool> requestLocationPermission() async {
    // Get current permission status
    // 获取当前的权限状态
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      // Already authorized
      // 已经授权
      return true;
    } else {
      // Not authorized, initiate a permission request
      // 未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// Get iOS native accuracy authorization type
  /// 获取iOS原生精度授权类型
  void requestAccuracyAuthorization() async {
    // System location type information in iOS 14+
    // iOS 14+中系统的定位类型信息
    AMapAccuracyAuthorization currentAccuracyAuthorization =
    await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("Full accuracy location type / 精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("Reduced accuracy location type / 模糊定位类型");
    } else {
      print("Unknown location type / 未知定位类型");
    }
  }

  /// Set location parameters for AMap location plugin
  /// 为高德地图定位插件设置定位参数
  void _setLocationOption() {
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = AMapLocationOption();

      /// Whether to use single location or continuous location
      /// 是否单次定位
      locationOption.onceLocation = false;

      /// Whether to return reverse geocoding information
      /// 是否需要返回逆地理信息
      locationOption.needAddress = true;

      /// Language type for reverse geocoding information
      /// 逆地理信息的语言类型
      locationOption.geoLanguage = GeoLanguage.DEFAULT;

      /// Desired location accuracy authorization mode
      /// 期望的定位精度授权模式
      locationOption.desiredLocationAccuracyAuthorizationMode =
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

      /// Purpose key for full accuracy authorization
      /// 全精度授权的目的键
      locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

      /// Set location interval for continuous location on Android (in milliseconds)
      /// 设置Android端连续定位的定位间隔（毫秒）
      locationOption.locationInterval = 2000;

      /// Set location mode for Android platform<br>
      /// Available options:<br>
      /// <li>[AMapLocationMode.Battery_Saving] - Battery saving mode</li>
      /// <li>[AMapLocationMode.Device_Sensors] - Device sensors only</li>
      /// <li>[AMapLocationMode.Hight_Accuracy] - High accuracy mode</li>
      /// 
      /// 设置Android端的定位模式<br>
      /// 可选值：<br>
      /// <li>[AMapLocationMode.Battery_Saving] - 省电模式</li>
      /// <li>[AMapLocationMode.Device_Sensors] - 仅设备传感器</li>
      /// <li>[AMapLocationMode.Hight_Accuracy] - 高精度模式</li>
      locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

      /// Set minimum update distance for iOS location updates (in meters)<br>
      /// -1 means no distance filter
      /// 
      /// 设置iOS端的定位最小更新距离（米）<br>
      /// -1表示无距离过滤
      locationOption.distanceFilter = -1;

      /// Set desired location accuracy for iOS platform
      /// Available options:<br>
      /// <li>[DesiredAccuracy.Best] - Highest accuracy</li>
      /// <li>[DesiredAccuracy.BestForNavigation] - High accuracy for navigation</li>
      /// <li>[DesiredAccuracy.NearestTenMeters] - 10 meters</li>
      /// <li>[DesiredAccuracy.Kilometer] - 1000 meters</li>
      /// <li>[DesiredAccuracy.ThreeKilometers] - 3000 meters</li>
      /// 
      /// 设置iOS端期望的定位精度<br>
      /// 可选值：<br>
      /// <li>[DesiredAccuracy.Best] - 最高精度</li>
      /// <li>[DesiredAccuracy.BestForNavigation] - 适用于导航场景的高精度</li>
      /// <li>[DesiredAccuracy.NearestTenMeters] - 10米</li>
      /// <li>[DesiredAccuracy.Kilometer] - 1000米</li>
      /// <li>[DesiredAccuracy.ThreeKilometers] - 3000米</li>
      locationOption.desiredAccuracy = DesiredAccuracy.Best;

      /// Set whether to allow system to pause location updates on iOS
      /// 设置iOS端是否允许系统暂停定位
      locationOption.pausesLocationUpdatesAutomatically = false;

      /// Apply location parameters to the location plugin
      /// 将定位参数设置给定位插件
      _locationPlugin.setLocationOption(locationOption);
    }
  }

  /// Start location service
  /// 开始定位服务
  void _startLocation() {
    if (null != _locationPlugin) {
      /// Set location parameters before starting location
      /// 开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
    }
  }

  /// Stop location service
  /// 停止定位服务
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定位 / Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("longtitude:$_longitude"),
            Text("latitude:$_latitude"),
            Text('country：$country'),
            Text('provice：$province'),
            Text('city：$city'),
            Text('district：$district'),
            Text('citycode：$cityCode'),
            Text('street：$street'),
            Text('adcode：$adCode'),
            Text('address：$address'),
            SizedBox(height: 20),
            ElevatedButton(
              child: const Text('get my location / 获取我的位置'),
              onPressed: () {
                _startLocation();
              },
            ),

            const SizedBox(height: 40), // Spacing / 间距

            ElevatedButton(
              child: const Text('stop / 停止'),
              onPressed: () {
                _stopLocation();
              },
            ),
          ],
        ),
      ),
    );
  }
}