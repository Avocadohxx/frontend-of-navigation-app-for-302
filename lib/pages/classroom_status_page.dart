import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../app/bottom_nav_controller.dart';

class ClassroomStatusPage extends StatefulWidget {
  const ClassroomStatusPage({super.key, required this.loggedInUser});

  final UserModel loggedInUser;

  @override
  State<ClassroomStatusPage> createState() => _ClassroomStatusPageState();
}

class _ClassroomStatusPageState extends State<ClassroomStatusPage> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _dataController;
  List<Classroom> classrooms = [];
  List<Classroom> filteredClassrooms = [];
  bool _isRealTime = false; // Disable real-time changes
  String _selectedBuilding = 'All';
  String _selectedFloor = 'All';

  final List<String> _buildings = ['All', 'Build1', 'Build2', 'Build3'];
  final List<String> _floors = ['All', 'Floor1', 'Floor2', 'Floor3', 'Floor4', 'Floor5', 'Floor6'];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _dataController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _loadClassrooms();
    _startRealTimeUpdates();
  }

  void _loadClassrooms() {
    // Use preset classroom data without real-time changes
    classrooms = [
      // Build1 - Preset occupancy
      Classroom('Build1-Floor1-A101', 'Available', Colors.green, 'No classes scheduled', 'Build1', 'Floor1'),
      Classroom('Build1-Floor1-A102', 'In Class', Colors.red, 'Data Structure 8:00-10:00', 'Build1', 'Floor1'),
      Classroom('Build1-Floor2-B201', 'Available', Colors.green, 'No classes scheduled', 'Build1', 'Floor2'),
      Classroom('Build1-Floor2-B202', 'Reserved', Colors.orange, 'Student Activity 14:00-16:00', 'Build1', 'Floor2'),
      Classroom('Build1-Floor3-C301', 'In Class', Colors.red, 'Algorithm Design 10:00-12:00', 'Build1', 'Floor3'),
      Classroom('Build1-Floor3-C302', 'Available', Colors.green, 'No classes scheduled', 'Build1', 'Floor3'),
      // Build2 - Preset occupancy
      Classroom('Build2-Floor1-D101', 'Available', Colors.green, 'No classes scheduled', 'Build2', 'Floor1'),
      Classroom('Build2-Floor1-D102', 'Maintenance', Colors.grey, 'Equipment Maintenance 9:00-17:00', 'Build2', 'Floor1'),
      Classroom('Build2-Floor2-E201', 'Reserved', Colors.orange, 'Seminar 13:00-15:00', 'Build2', 'Floor2'),
      Classroom('Build2-Floor2-E202', 'In Class', Colors.red, 'Operating System 8:00-11:00', 'Build2', 'Floor2'),
      Classroom('Build2-Floor4-F401', 'Available', Colors.green, 'No classes scheduled', 'Build2', 'Floor4'),
      // Build3 - Preset occupancy
      Classroom('Build3-Floor1-G101', 'Available', Colors.green, 'No classes scheduled', 'Build3', 'Floor1'),
      Classroom('Build3-Floor2-H201', 'In Class', Colors.red, 'Database Principles 14:00-17:00', 'Build3', 'Floor2'),
      Classroom('Build3-Floor3-I301', 'Reserved', Colors.orange, 'Club Activity 19:00-21:00', 'Build3', 'Floor3'),
      Classroom('Build3-Floor5-J501', 'Available', Colors.green, 'No classes scheduled', 'Build3', 'Floor5'),
      Classroom('Build3-Floor6-K601', 'Available', Colors.green, 'No classes scheduled', 'Build3', 'Floor6'),
    ];
    _applyFilters();
    setState(() {});
  }
  
  void _applyFilters() {
    filteredClassrooms = classrooms.where((classroom) {
      final buildMatch = _selectedBuilding == 'All' || classroom.build == _selectedBuilding;
      final floorMatch = _selectedFloor == 'All' || classroom.floor == _selectedFloor;
      return buildMatch && floorMatch;
    }).toList();
  }

  void _startRealTimeUpdates() {
    // 模拟实时数据更新
    Future.delayed(const Duration(seconds: 3), () {
      if (_isRealTime && mounted) {
        _updateRandomClassroom();
        _startRealTimeUpdates();
      }
    });
  }

  void _updateRandomClassroom() {
    if (filteredClassrooms.isNotEmpty) {
      final randomIndex = (filteredClassrooms.length * (DateTime.now().millisecond % 100) / 100).floor();
      final classroom = filteredClassrooms[randomIndex];
      final originalClassroom = classrooms.firstWhere((c) => c.roomNumber == classroom.roomNumber);
      
      // Simulate status change
      final statuses = ['Available', 'In Class', 'Reserved', 'Study'];
      final colors = [Colors.green, Colors.red, Colors.orange, Colors.blue];
      final randomStatus = statuses[(DateTime.now().second % statuses.length)];
      
      setState(() {
        classroom.status = randomStatus;
        classroom.color = colors[statuses.indexOf(randomStatus)];
        originalClassroom.status = randomStatus;
        originalClassroom.color = colors[statuses.indexOf(randomStatus)];
      });
      
      _dataController.forward().then((_) => _dataController.reverse());
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      appBar: AppBar(
        title: const Text('Real-time Classroom Status'),
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
            icon: Icon(_isRealTime ? Icons.sync : Icons.sync_disabled),
            onPressed: () {
              setState(() => _isRealTime = !_isRealTime);
              if (_isRealTime) _startRealTimeUpdates();
            },
            tooltip: _isRealTime ? 'Pause Update' : 'Enable Update',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showTechInfo,
            tooltip: 'Tech Info',
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选器
          _buildFilters(),
          
          // 状态概览
          _buildStatusOverview(),
          
          // 教室列表
          Expanded(
            child: AnimatedBuilder(
              animation: _dataController,
              builder: (context, child) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredClassrooms.length,
                itemBuilder: (context, index) {
                  final classroom = filteredClassrooms[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    transform: Matrix4.identity()
                      ..scale(1.0 + (_dataController.value * 0.02)),
                    child: _buildClassroomCard(classroom),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOverview() {
    final stats = _calculateStats();
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Opacity(
                opacity: 0.6 + (_pulseController.value * 0.4),
                child: const Icon(
                  Icons.sensors,
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ),
              const SizedBox(width: 8),
              const Text(
                'Real-time Monitoring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'ESP32 × ${classrooms.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
            Row(
              children: [
                _buildStatItem('Available', stats['available'] ?? 0, Colors.green),
                _buildStatItem('Occupied', stats['occupied'] ?? 0, Colors.red),
                _buildStatItem('Reserved', stats['soon'] ?? 0, Colors.orange),
                _buildStatItem('Study', stats['study'] ?? 0, Colors.blue),
              ],
            ),
          
          const SizedBox(height: 12),
          
          // 技术指标
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.wifi, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('MQTT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('Latency: ${_getRandomLatency()}ms', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.data_usage, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Redis', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('QPS: ${_getRandomQPS()}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassroomCard(Classroom classroom) {
    return GestureDetector(
      onTap: () => _showBookingTimeline(classroom),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: classroom.color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // 状态指示器
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) => Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: classroom.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: classroom.color.withOpacity(0.3 + (_pulseController.value * 0.3)),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 教室信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classroom.roomNumber,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    classroom.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // 状态标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: classroom.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                classroom.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: classroom.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Classrooms',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Building', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBuilding,
                          isExpanded: true,
                          items: _buildings.map((building) {
                            return DropdownMenuItem(
                              value: building,
                              child: Text(building),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedBuilding = value!;
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Floor', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFloor,
                          isExpanded: true,
                          items: _floors.map((floor) {
                            return DropdownMenuItem(
                              value: floor,
                              child: Text(floor),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFloor = value!;
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateStats() {
    final stats = <String, int>{
      'available': 0,
      'occupied': 0,
      'soon': 0,
      'study': 0,
    };

    for (final classroom in filteredClassrooms) {
      switch (classroom.status) {
        case 'Available':
          stats['available'] = (stats['available'] ?? 0) + 1;
          break;
        case 'In Class':
          stats['occupied'] = (stats['occupied'] ?? 0) + 1;
          break;
        case 'Reserved':
          stats['soon'] = (stats['soon'] ?? 0) + 1;
          break;
        case 'Study':
          stats['study'] = (stats['study'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }

  int _getRandomLatency() => 15 + (DateTime.now().millisecond % 35);
  int _getRandomQPS() => 800 + (DateTime.now().second % 400);

  void _showTechInfo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔧 Technical Architecture',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _buildTechItem('📡 ESP32 IR Counter', 'Sensors on each door for real-time occupancy tracking'),
            _buildTechItem('📡 MQTT Protocol', 'Lightweight IoT communication protocol with low latency'),
            _buildTechItem('💾 Redis Stream', 'High-performance data stream processing with real-time subscription'),
            _buildTechItem('🔄 GraphQL Subscription', 'Frontend real-time data subscription with auto UI updates'),
            _buildTechItem('📅 Airflow Scheduler', 'Weekly automatic course schedule synchronization'),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Data Flow: Sensor → MQTT → NestJS → Redis → GraphQL → App',
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  void _showBookingTimeline(Classroom classroom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BookingTimelinePage(classroom: classroom),
    );
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isOccupied;
  final String? description;

  TimeSlot(this.startTime, this.endTime, this.isOccupied, [this.description]);
}

class BookingTimelinePage extends StatefulWidget {
  final Classroom classroom;

  const BookingTimelinePage({required this.classroom, super.key});

  @override
  State<BookingTimelinePage> createState() => _BookingTimelinePageState();
}

class _BookingTimelinePageState extends State<BookingTimelinePage> {
  late List<TimeSlot> timeSlots;
  String? selectedStartTime;
  String? selectedEndTime;
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  void _generateTimeSlots() {
    timeSlots = [];
    
    // 生成从8:00到22:00的时间段，每30分钟一个时间段
    for (int hour = 8; hour < 22; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final startTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        final endHour = minute == 30 ? hour + 1 : hour;
        final endTime = '${endHour.toString().padLeft(2, '0')}:${minute == 0 ? '30' : '00'}';
        
        // Use preset occupied time slots
        bool isOccupied = false;
        String? description;

        // Preset class time
        if ((hour >= 8 && hour < 10) || (hour >= 10 && hour < 12) || (hour >= 14 && hour < 16)) {
          if ((hour * 60 + minute) % 5 == 0) { // Fixed pattern
            isOccupied = true;
            description = 'Class Scheduled';
          }
        }

        // Preset reservation time
        if (hour >= 19 && hour < 21) {
          if ((hour * 60 + minute) % 3 == 0) { // Fixed pattern
            isOccupied = true;
            description = 'Reserved';
          }
        }
        
        timeSlots.add(TimeSlot(startTime, endTime, isOccupied, description));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.classroom.roomNumber,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Timeline Booking',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // 选择状态显示
          if (selectedStartTime != null && selectedEndTime != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Selected: $selectedStartTime - $selectedEndTime',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _confirmBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Confirm Booking'),
                  ),
                ],
              ),
            ),
          
          // 时间轴
          Expanded(
            child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final slot = timeSlots[index];
                final isSelected = _isInSelectedRange(slot);
                final canSelect = !slot.isOccupied;
                
                return GestureDetector(
                  onTap: canSelect ? () => _selectTimeSlot(slot) : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: slot.isOccupied 
                          ? Colors.red.shade50
                          : isSelected
                              ? Colors.blue.shade100
                              : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: slot.isOccupied
                            ? Colors.red.shade200
                            : isSelected
                                ? Colors.blue.shade300
                                : Colors.green.shade200,
                      ),
                    ),
                    child: Row(
                      children: [
                        // 时间
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${slot.startTime} - ${slot.endTime}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: slot.isOccupied ? Colors.red.shade700 : Colors.green.shade700,
                            ),
                          ),
                        ),
                        
                        // 状态指示器
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: slot.isOccupied ? Colors.red : Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Description
                        Expanded(
                          child: Text(
                            slot.isOccupied
                                ? slot.description ?? 'Occupied'
                                : isSelected
                                    ? 'Selected'
                                    : 'Available',
                            style: TextStyle(
                              color: slot.isOccupied
                                  ? Colors.red.shade600
                                  : isSelected
                                      ? Colors.blue.shade600
                                      : Colors.green.shade600,
                            ),
                          ),
                        ),
                        
                        // 选择指示器
                        if (isSelected)
                          Icon(Icons.check_circle, color: Colors.blue.shade600, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // 底部提示
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Green slots are available for booking\n• Red slots are occupied\n• Click green slots to start selection, click again to end selection',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectTimeSlot(TimeSlot slot) {
    if (slot.isOccupied) return;
    
    setState(() {
      if (!isSelecting) {
        // 开始选择
        selectedStartTime = slot.startTime;
        selectedEndTime = null;
        isSelecting = true;
      } else {
        // 结束选择
        if (selectedStartTime != null) {
          selectedEndTime = slot.endTime;
          isSelecting = false;
        }
      }
    });
  }

  bool _isInSelectedRange(TimeSlot slot) {
    if (selectedStartTime == null || selectedEndTime == null) return false;
    
    final start = _timeToMinutes(selectedStartTime!);
    final end = _timeToMinutes(selectedEndTime!);
    final slotStart = _timeToMinutes(slot.startTime);
    final slotEnd = _timeToMinutes(slot.endTime);
    
    return slotStart >= start && slotEnd <= end;
  }
  
  int _timeToMinutes(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return hour * 60 + minute;
  }

  void _confirmBooking() {
    if (selectedStartTime == null || selectedEndTime == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed! ${widget.classroom.roomNumber} $selectedStartTime - $selectedEndTime'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}

class Classroom {
  String roomNumber;
  String status;
  Color color;
  String description;
  String build;
  String floor;

  Classroom(this.roomNumber, this.status, this.color, this.description, this.build, this.floor);
}