import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStatusToggle extends StatefulWidget {
  const BatteryStatusToggle({super.key});

  @override
  _BatteryStatusToggleState createState() => _BatteryStatusToggleState();
}

class _BatteryStatusToggleState extends State<BatteryStatusToggle> {
  final Battery _battery = Battery();
  BatteryState _batteryState = BatteryState.unknown;
  int _batteryLevel = 0; // Add battery level
  bool _powerSavingMode = false;

  @override
  void initState() {
    super.initState();
    _getBatteryStatus();
  }

  Future<void> _getBatteryStatus() async {
    final batteryState = await _battery.batteryState;
    final batteryLevel = await _battery.batteryLevel; // Get battery level
    setState(() {
      _batteryState = batteryState;
      _batteryLevel = batteryLevel;
    });
    print('Battery Status: ${_batteryState.toString().split('.').last}');
    print('Battery Level: $_batteryLevel%');
  }

  void _togglePowerSavingMode(bool value) {
    setState(() {
      _powerSavingMode = value;
    });
    print('Power Saving Mode: ${_powerSavingMode ? 'ON' : 'OFF'}');
  }

  @override
  Widget build(BuildContext context) {
    // Determine battery color based on battery level
    final Color batteryColor = _batteryLevel <= 25
        ? Colors.red
        : _batteryState == BatteryState.charging
        ? Colors.green
        : Colors.grey;

    return ListTile(
      title: const Text('Turn on Power Saving Mode'), // Updated title
      subtitle: Text(
        'Battery: ${_batteryState.toString().split('.').last} ($_batteryLevel%)', // Show battery level
        style: TextStyle(color: batteryColor),
      ),
      trailing: Switch(
        value: _powerSavingMode,
        onChanged: _togglePowerSavingMode,
      ),
      leading: Icon(
        Icons.battery_std,
        color: batteryColor,
      ),
      onTap: () {
        // Refresh battery status when tapped
        _getBatteryStatus();
      },
    );
  }
}