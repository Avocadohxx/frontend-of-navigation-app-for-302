import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../models/user_model.dart';
import '../app/bottom_nav_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late AnimationController _arController;
  late AnimationController _pathController;
  final MapController _mapController = MapController();
  bool _showAR = false;
  bool _show3D = false;
  // Set default location to Starfish Plaza (海星广场)
  LatLng? _currentLocation = const LatLng(30.882118, 121.893462);
  //LatLng? _currentLocation = const LatLng(30.885125,121.892606);
  LatLng? _destination; // 目标位置初始为空，等待用户搜索
  String? _destinationName; // 目的地名称，用于确定预定义路径
  List<LatLng> _straightPath = []; // 直线路径（浅蓝色虚线）
  List<LatLng> _roadPath = []; // 道路路径（紫色实线）
  bool _showRoadPath = false; // 是否显示道路路径

  @override
  void initState() {
    super.initState();
    _arController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pathController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // 获取真实GPS位置（已注释，使用默认位置）
    // _getCurrentLocation();
  }

  // 获取当前GPS位置
  Future<void> _getCurrentLocation() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location service not enabled, use default location (Building 1)
        setState(() {
          //_currentLocation = const LatLng(31.0285, 121.5037);
          _currentLocation = const LatLng(30.884383, 121.894146);
        });
        _calculatePath();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location service not enabled, using default location')),
        );
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permission denied, use default location
          setState(() {
            //_currentLocation = const LatLng(31.0285, 121.5037);
            _currentLocation = const LatLng(30.884383, 121.894146);
          });
          _calculatePath();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied, using default location')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permission permanently denied, use default location
        setState(() {
          //_currentLocation = const LatLng(31.0285, 121.5037);
          _currentLocation = const LatLng(30.884383, 121.894146);
        });
        _calculatePath();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission permanently denied, please enable in settings')),
        );
        return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = newLocation;
      });

      // Move map center to current GPS location
      _mapController.move(newLocation, 17.0);

      _calculatePath();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('GPS location obtained: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      // Failed to get location, use default location (Building 1)
      setState(() {
        //_currentLocation = const LatLng(31.0285, 121.5037);
        _currentLocation = const LatLng(30.884383, 121.894146);
      });
      _calculatePath();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e, using default location')),
      );
    }
  }

  // 计算直线路径（浅蓝色虚线）
  void _calculatePath() {
    if (_currentLocation == null || _destination == null) {
      return;
    }

    // 计算从当前位置到目标位置的直线路径
    setState(() {
      _straightPath = [
        _currentLocation!,
        _destination!,
      ];
    });
  }

  // Calculate road path (purple solid line) with predefined waypoints
  void _calculateRoadPath() {
    if (_currentLocation == null || _destination == null) {
      return;
    }

    // Use predefined paths based on destination
    List<LatLng> waypoints = [];

    // Add start point
    waypoints.add(_currentLocation!);

    // Add predefined waypoints based on destination name
    if (_destinationName == 'library') {
      // Route to Library: 海星广场 → waypoint1 → waypoint2 → Library
      waypoints.add(const LatLng(30.882271,121.892696));
      waypoints.add(const LatLng(30.885111, 121.892722));
      waypoints.add(const LatLng(30.885141, 121.891587));
      waypoints.add(const LatLng(30.885633, 121.891574));
      waypoints.add(const LatLng(30.885636, 121.891759));
    } else if (_destinationName == 'first_building') {
      // Route to First Building: 海星广场 → waypoint1 → waypoint2 → waypoint3 → First Building
      waypoints.add(const LatLng(30.882276, 121.892729));
      waypoints.add(const LatLng(30.883051, 121.892797));
      waypoints.add(const LatLng(30.883274, 121.893889));
      waypoints.add(const LatLng(30.883960, 121.894801));
      waypoints.add(const LatLng(30.884376, 121.894205));
    } else if (_destinationName == 'aien') {
      // Route to First Building: 海星广场 → waypoint1 → waypoint2 → waypoint3 → First Building
      waypoints.add(const LatLng(30.882271, 121.892696));
      waypoints.add(const LatLng(30.885434, 121.892723));
      waypoints.add(const LatLng(30.886559, 121.894033));
      waypoints.add(const LatLng(30.887076, 121.893435));
      waypoints.add(const LatLng(30.887058, 121.893368));
      waypoints.add(const LatLng(30.887162, 121.893237));
      waypoints.add(const LatLng(30.887302, 121.893322));
      waypoints.add(const LatLng(30.887491, 121.893221));
      waypoints.add(const LatLng(30.887698, 121.893250));
      waypoints.add(const LatLng(30.888425, 121.892869));
      waypoints.add(const LatLng(30.888580, 121.893451));
    } else {
      // Default: use Manhattan pathfinding for other destinations
      LatLng intermediatePoint = LatLng(
        _currentLocation!.latitude,
        _destination!.longitude,
      );
      if (intermediatePoint.latitude != _destination!.latitude &&
          intermediatePoint.longitude != _currentLocation!.longitude) {
        waypoints.add(intermediatePoint);
      }
      waypoints.add(_destination!);
    }

    setState(() {
      _roadPath = waypoints;
      _showRoadPath = true;
    });

    // Start path animation
    _pathController.reset();
    _pathController.forward();
  }

  void _startARNavigation() {
    setState(() => _showAR = true);
    _arController.forward();
  }

  void _show3DPath() {
    setState(() => _show3D = true);
    _pathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _arController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text('Smart Navigation Map'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            final navigator = HomeNavigator.of(context);
            if (navigator != null) {
              navigator.navigateToHome();
            }
          },
          tooltip: 'Back to Home',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_in_ar),
            onPressed: _startARNavigation,
            tooltip: 'AR Navigation',
          ),
          IconButton(
            icon: const Icon(Icons.threed_rotation),
            onPressed: _show3DPath,
            tooltip: '3D Path',
          ),
        ],
      ),
      body: Stack(
        children: [
          // 地图主体
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              //center: _currentLocation ?? const LatLng(31.0285, 121.5037),
              center: _currentLocation ?? const LatLng(30.884383, 121.894146),
              zoom: 17.0,
              minZoom: 1.0,
              maxZoom: 19.0,
            ),
            children: [
              // OpenStreetMap 瓦片（国外服务器，国内可能无法访问）
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                fallbackUrl: 'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pages',
              ),

              // 使用高德地图在线瓦片服务（国内可访问）
              // TileLayer(
              //   urlTemplate: 'http://wprd0{s}.is.autonavi.com/appmaptile?x={x}&y={y}&z={z}&lang=zh_cn&size=1&scl=1&style=7',
              //   subdomains: const ['1', '2', '3', '4'],
              //   userAgentPackageName: 'com.example.pages',
              // ),
              
              // 当前位置标记
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              
              // 目标位置标记
              MarkerLayer(
                markers: [
                  if (_destination != null)
                    Marker(
                      point: _destination!,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              
              // Path lines with animation
              AnimatedBuilder(
                animation: _pathController,
                builder: (context, child) {
                  // Calculate animated path points based on animation progress
                  List<LatLng> animatedRoadPath = [];
                  if (_showRoadPath && _roadPath.isNotEmpty) {
                    final progress = _pathController.value;
                    final totalPoints = _roadPath.length;
                    final visiblePoints = (totalPoints * progress).ceil().clamp(0, totalPoints);

                    if (visiblePoints > 0) {
                      animatedRoadPath = _roadPath.sublist(0, visiblePoints);

                      // If not at the end, interpolate the last point
                      if (visiblePoints < totalPoints && visiblePoints > 0) {
                        final prevPoint = _roadPath[visiblePoints - 1];
                        final nextPoint = _roadPath[visiblePoints];
                        final segmentProgress = (totalPoints * progress) - (visiblePoints - 1);

                        final interpolatedLat = prevPoint.latitude +
                          (nextPoint.latitude - prevPoint.latitude) * segmentProgress;
                        final interpolatedLng = prevPoint.longitude +
                          (nextPoint.longitude - prevPoint.longitude) * segmentProgress;

                        animatedRoadPath.add(LatLng(interpolatedLat, interpolatedLng));
                      }
                    }
                  }

                  return PolylineLayer(
                    polylines: [
                      // Straight path (light blue dashed line)
                      if (_straightPath.isNotEmpty)
                        Polyline(
                          points: _straightPath,
                          strokeWidth: 3.0,
                          color: Colors.lightBlue.withOpacity(0.7),
                          isDotted: true,
                        ),
                      // Animated road path (purple solid line)
                      if (_showRoadPath && animatedRoadPath.isNotEmpty)
                        Polyline(
                          points: animatedRoadPath,
                          strokeWidth: 4.0,
                          color: Colors.purple.withOpacity(0.8),
                          isDotted: false,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          
          // AR导航覆盖层
          if (_showAR)
            _buildAROverlay(),
          
          // 搜索栏
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildSearchBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAROverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: AnimatedBuilder(
        animation: _arController,
        builder: (context, child) {
          return Stack(
            children: [
              // AR相机视图模拟
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'AR Navigation Activated',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Follow 3D arrows to destination',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 3D箭头动画
              Positioned(
                bottom: 200,
                child: Transform.rotate(
                  angle: _arController.value * 2 * 3.14159,
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.green,
                    size: 60,
                  ),
                ),
              ),
              
              // 关闭按钮
              Positioned(
                top: 50,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    setState(() => _showAR = false);
                    _arController.reset();
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }





  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search for classrooms, buildings or places...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchLocation(value);
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                // 触发道路路径规划
                if (_destination != null) {
                  _calculateRoadPath();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please search for a destination first')),
                  );
                }
              },
              icon: const Icon(Icons.route),
              tooltip: 'Route Planning',
            ),
            IconButton(
              onPressed: _toggleAR,
              icon: Icon(_showAR ? Icons.view_in_ar : Icons.view_in_ar_outlined),
              tooltip: 'AR Navigation',
            ),
          ],
        ),
      ),
    );
  }
  
  void _searchLocation(String query) {
    if (query.isEmpty) {
      return;
    }

    // Match different locations based on search keywords
    LatLng? foundLocation;
    String locationName = '';
    String? destinationKey;

    String lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('first building') || lowerQuery.contains('first')) {
      // First Teaching Building
      foundLocation = const LatLng(30.884383, 121.894146);
      locationName = 'First Building';
      destinationKey = 'first_building';
    } else if (lowerQuery.contains('shanghai ocean library') || lowerQuery.contains('library')) {
      // Library
      foundLocation = const LatLng(30.885732, 121.892043);
      locationName = 'Shanghai Ocean University Library';
      destinationKey = 'library';
    } else if (lowerQuery.contains('aien institute') || lowerQuery.contains('aien')) {
      // AIEN Institute
      foundLocation = const LatLng(30.888522, 121.893677);
      locationName = 'AIEN Institute';
      destinationKey = 'aien';
    } else if (lowerQuery.contains('third building') || lowerQuery.contains('third')) {
      // Third Teaching Building
      foundLocation = const LatLng(30.885820, 121.894307);
      locationName = 'Third Building';
      destinationKey = 'third_building';
    }


    if (foundLocation != null) {
      // Set destination location and name
      setState(() {
        _destination = foundLocation;
        _destinationName = destinationKey;
        _showRoadPath = false; // Reset road path display status
      });

      // Calculate straight-line path (light blue dashed line)
      _calculatePath();

      // Move map view so both start and end points are visible
      _mapController.move(_currentLocation!, 16.0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location found: $locationName. Straight path displayed. Click "Route Planning" to view road path.')),
      );
    } else {
      // Location not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found: $query. Try searching for "first building", "library", or "AIEN institute"')),
      );
    }
  }
  
  void _toggleAR() {
    setState(() {
      _showAR = !_showAR;
      if (_showAR) {
        _arController.forward();
      } else {
        _arController.reverse();
      }
    });
  }
}