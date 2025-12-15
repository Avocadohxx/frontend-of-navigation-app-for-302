import 'dart:io';

import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/config.dart';

/// Map page widget for displaying campus map with AMap integration
/// 地图页面组件，集成高德地图显示校园地图
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

/// State class for map page, handling map interactions and location services
/// 地图页面的状态类，处理地图交互和定位服务
class _MapPageState extends State<MapPage> {
  /// AMap controller for map communication and operations
  /// 高德地图控制器，用于地图通信和操作
  AMapController? mapController;

  /// Location plugin instance for handling device location
  /// 定位插件实例，用于处理设备定位
  AMapFlutterLocation? location;

  /// Current permission status for location access
  /// 当前位置访问权限状态
  PermissionStatus? permissionStatus;

  /// Current camera position and view settings for the map
  /// 地图当前相机位置和视图设置
  CameraPosition? currentLocation;

  /// Current map type (normal, satellite, navigation, etc.)
  /// 当前地图类型（普通、卫星、导航等）
  late MapType _mapType;

  /// List of nearby points of interest (POI) data
  /// 周边兴趣点（POI）数据列表
  List poisData = [];

  /// Latitude coordinate for marker placement
  /// 标记点的纬度坐标
  var markerLatitude;

  /// Longitude coordinate for marker placement
  /// 标记点的经度坐标
  var markerLongitude;

  /// Current user latitude coordinate
  /// 当前用户纬度坐标
  double? meLatitude;

  /// Current user longitude coordinate
  /// 当前用户经度坐标
  double? meLongitude;

  @override
  void initState() {
    super.initState();
    _mapType = MapType.normal;

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
    
    /// Request location permission from user
    /// 向用户请求位置权限
    requestPermission();
  }

  /// Request location permission and handle different permission states
  /// 请求位置权限并处理不同的权限状态
  Future<void> requestPermission() async {
    final status = await Permission.location.request();
    permissionStatus = status;
    switch (status) {
      case PermissionStatus.denied:
        print("Location permission denied / 位置权限被拒绝");
        break;
      case PermissionStatus.granted:
        requestLocation();
        break;
      case PermissionStatus.limited:
        print("Location permission limited / 位置权限受限");
        break;
      default:
        print("Other permission status / 其他权限状态");
        requestLocation();
        break;
    }
  }

  /// Request and start location service, listen for location changes
  /// 请求并启动定位服务，监听位置变化
  void requestLocation() {
    location = AMapFlutterLocation()
      ..setLocationOption(AMapLocationOption())
      ..onLocationChanged().listen((event) {
        print("Location update: $event / 位置更新: $event");
        double? latitude = double.tryParse(event['latitude'].toString());
        double? longitude = double.tryParse(event['longitude'].toString());
        markerLatitude = latitude.toString();
        markerLongitude = longitude.toString();
        meLatitude = latitude;
        meLongitude = longitude;
        if (latitude != null && longitude != null) {
          setState(() {
            currentLocation = CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 10,
            );
          });
        }
      })
      ..startLocation();
  }

  /// Handle POI (Point of Interest) touch events on the map
  /// 处理地图上兴趣点（POI）的触摸事件
  void _onMapPoiTouched(AMapPoi? poi) async {
    if (poi == null) {
      return;
    }
    print('POI touched: ${poi.toJson()} / POI被触摸: ${poi.toJson()}');

    var poiJson = poi.toJson();
    var latLng = poiJson['latLng'];

    // 添加安全检查
    if (latLng != null &&
        latLng is List &&
        latLng.length >= 2) {
      markerLatitude = latLng[1];  // 纬度
      markerLongitude = latLng[0]; // 经度

      print('POI coordinates: $latLng / POI坐标: $latLng');
      print('Marker latitude: $markerLatitude / 标记点纬度: $markerLatitude');
      print('Marker longitude: $markerLongitude / 标记点经度: $markerLongitude');

      setState(() {
        _addMarker(poi.latLng!);
      });
      _getPoisData();
    } else {
      print('Invalid or missing coordinates in POI data');
    }
  }

  /// Map to store markers with their unique IDs
  /// Note: Must initialize with an empty map for AMapWidget markers property
  /// 
  /// 存储标记点的映射表，使用唯一ID作为键
  /// 注意：需要先设置一个空的map赋值给AMapWidget的markers属性，否则后续无法添加marker
  final Map<String, Marker> _markers = <String, Marker>{};

  /// Add a marker to the map at specified position
  /// 在指定位置向地图添加标记点
  void _addMarker(LatLng markPostion) async {
    _removeAll();
    final Marker marker = Marker(
      position: markPostion,
      // Use default marker icon with orange hue
      // 使用默认的橙色色调标记图标
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    // Call setState to trigger AMapWidget update and complete marker addition
    // 调用setState触发AMapWidget的更新，从而完成marker的添加
    setState(() {
      // Add the new marker to the map
      // 将新的marker添加到map里
      _markers[marker.id] = marker;
    });
    _changeCameraPosition(markPostion);
  }

  /// Remove all markers from the map
  /// 清除地图上的所有标记点
  void _removeAll() {
    if (_markers.isNotEmpty) {
      setState(() {
        _markers.clear();
      });
    }
  }

  /// Change camera position to focus on specified coordinates
  /// 改变相机位置以聚焦到指定坐标
  void _changeCameraPosition(LatLng markPostion, {double zoom = 13}) {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          // Center point / 中心点
          target: markPostion,
          // Zoom level / 缩放级别
          zoom: zoom,
          // Tilt angle 0°~45° (0 when perpendicular to map) / 俯仰角0°~45°（垂直于地图时为0）
          tilt: 30,
          // Bearing angle 0~360° (0 for true north) / 偏航角 0~360° (正北方为0)
          bearing: 0),
      ),
      animated: true,
    );
  }

  @override
  void dispose() {
    location?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Campus Map",
          style: TextStyle(),
        ),
      ),
      body: currentLocation == null
          ? Container()
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 350,
            child: SizedBox(
              child: AMapWidget(
                // Privacy statement must be included for AMap compliance
                // 隐私政策必须包含以满足高德地图合规要求
                privacyStatement: ConstConfig.amapPrivacyStatement,
                apiKey: ConstConfig.amapApiKeys,
                // Initial map center position
                // 初始化地图中心点
                initialCameraPosition: currentLocation!,
                // Location blue dot style options
                // 定位小蓝点样式选项
                myLocationStyleOptions: MyLocationStyleOptions(
                  true,
                ),
                // Map types: normal, satellite, night, navigation, bus
                // 地图类型：普通地图normal,卫星地图satellite,夜间视图night,导航视图navi,公交视图bus
                mapType: _mapType,
                // Zoom level range constraints
                // 缩放级别范围限制
                minMaxZoomPreference: const MinMaxZoomPreference(3, 20),
                onPoiTouched: _onMapPoiTouched,
                markers: Set<Marker>.of(_markers.values),
                // Callback when map is successfully created, returns AMapController
                // 地图创建成功时的回调，返回AMapController
                onMapCreated: (AMapController controller) {
                  mapController = controller;
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: const Text(
                    'nearby places',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildPoisList(),
                ElevatedButton(
                  onPressed: _getPoisData,
                  child: Text('Get nearby places'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        // marginRight: 25, // Right margin / 右边距
        // marginBottom: 50, // Bottom margin / 下边距
        animatedIcon: AnimatedIcons.menu_close, // Animated button icon / 带动画的按钮图标
        animatedIconTheme: const IconThemeData(size: 22.0),
        // visible: isShow, // Whether to show the button / 是否显示按钮
        closeManually: false, // Whether to close after clicking child button / 是否在点击子按钮后关闭展开项
        curve: Curves.bounceIn, // Expansion animation curve / 展开动画曲线
        overlayColor: Colors.black, // Overlay color / 遮罩层颜色
        overlayOpacity: 0.5, // Overlay opacity / 遮罩层透明度
        onOpen: () => print('Speed dial opened / 速度拨号打开'),
        onClose: () => print('Speed dial closed / 速度拨号关闭'),
        tooltip: 'Speed Dial', // Long press tooltip / 长按提示文字
        heroTag: 'speed-dial-hero-tag', // Hero animation tag / Hero动画标记
        backgroundColor: Colors.blue, // Button background color / 按钮背景色
        foregroundColor: Colors.white, // Button foreground/text color / 按钮前景色/文字色
        elevation: 8.0, // Shadow elevation / 阴影高度
        shape: const CircleBorder(), // Shape decoration / 形状修饰
        children: [
          // Child buttons / 子按钮
          SpeedDialChild(
              label: 'Normal Map',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                setState(() {
                  _mapType = MapType.normal;
                });
              }),
          SpeedDialChild(
            label: 'Satellite Map',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.satellite;
              });
            },
          ),
          SpeedDialChild(
            label: 'Navigation Map',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.navi;
              });
            },
          ),
          SpeedDialChild(
            label: 'Traffic Map',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.bus;
              });
            },
          ),
          SpeedDialChild(
            label: 'Dark Model',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _mapType = MapType.night;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Build list widget for displaying nearby POI (Points of Interest)
  /// 构建用于显示附近兴趣点（POI）的列表组件
  Widget _buildPoisList() {
    return Column(
      children: poisData.map((value) {
        return ListTile(
          title: Text(value['name']),
          subtitle: Text(
              '${value['pname']}${value['cityname']}${value['adname']}${value['address']}'),
          onTap: () async {
            List locationData = value['location'].split(',');
            double l1 = double.parse(locationData[1]);
            double l2 = double.parse(locationData[0]);
            markerLatitude = l2;
            markerLongitude = l1;
            _getPoisData();
            _addMarker(LatLng(l1, l2));
            _changeCameraPosition(LatLng(l1, l2));
          },
          onLongPress: () {
            showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('提示 / Prompt'),
                    content: const Text('是否进入高德地图导航 / Navigate with AMap?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('取消 / Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('确认 / Confirm'),
                        onPressed: () async {
                          String title = value['name'];
                          var locationData = value['location'].split(',');
                          double l1 = double.parse(locationData[1]);
                          double l2 = double.parse(locationData[0]);

                          Uri uri = Uri.parse(
                              '${Platform.isAndroid ? 'android' : 'ios'}amap://path?sourceApplication=applicationName&sid=&slat=$meLatitude&slon=$meLongitude&sname=&did=&dlat=$l1&dlon=$l2&dname=$title&dev=0&t=0');

                          try {
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              print('无法调起高德地图 / Failed to launch AMap');
                            }
                          } catch (e) {
                            print('无法调起高德地图 / Failed to launch AMap');
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          },
        );
      }).toList(),
    );
  }
AMapSearchAPI
  /// Get nearby POI (Points of Interest) data from AMap API
  /// 从高德地图API获取周边兴趣点（POI）数据
  Future<void> _getPoisData() async {
    try {
      var response = await Dio().get(
          'https://restapi.amap.com/v3/place/around?key=${ConstConfig.webKey}&location=$markerLatitude,$markerLongitude&keywords=&types=&radius=1000&offset=20&page=1&extensions=base');

      // --- Critical modifications for safe data handling ---
      // --- 关键修改：安全数据处理开始 ---
      // 1. Check if response data is a Map (standard JSON response)
      // 1. 检查响应数据本身是否为 Map (标准 JSON 响应)
      if (response.data is Map<String, dynamic>) {
        // 2. Check if 'pois' field exists, is not null, and is a List
        // 2. 检查 'pois' 字段是否存在且不为 null，并且是一个 List
        final poisResult = response.data['pois'];
        if (poisResult != null && poisResult is List) {
          // 3. If all conditions are met, safely update the state
          // 3. 如果都满足，安全地更新状态
          setState(() {
            poisData = poisResult.cast<dynamic>(); // .cast ensures type safety / .cast 确保类型正确
            // Alternative: if poisData is declared as List<Map<String, dynamic>>:
            // 或者，如果 poisData 声明为 List<Map<String, dynamic>>:
            // poisData = List<Map<String, dynamic>>.from(poisResult);
          });
        } else {
          // 'pois' field doesn't exist, is null, or is not a List type
          // 'pois' 字段不存在、为 null 或不是 List 类型
          print("API returned invalid 'pois' field: $poisResult, type: ${poisResult.runtimeType} / API 返回的 'pois' 字段无效: $poisResult, 类型: ${poisResult.runtimeType}");
          setState(() {
            poisData = []; // Assign empty list as default value / 赋予一个空列表作为默认值
          });
        }
      } else {
        // Response data is not the expected Map type
        // 响应数据不是预期的 Map 类型
        print("API response format error: ${response.data}, type: ${response.data.runtimeType} / API 响应格式错误: ${response.data}, 类型: ${response.data.runtimeType}");
        setState(() {
          poisData = []; // Assign empty list as default value / 赋予一个空列表作为默认值
        });
      }
      // --- Critical modifications end ---
      // --- 关键修改结束 ---

    } catch (e) {
      // Catch network request and other exceptions
      // 捕获网络请求等异常
      print("Error occurred while fetching POI data: $e / 获取 POI 数据时发生错误: $e");
      setState(() {
        poisData = []; // Assign empty list on error / 发生错误时也赋予一个空列表
      });
    }
  }
}