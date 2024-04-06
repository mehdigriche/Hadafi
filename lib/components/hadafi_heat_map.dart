import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:hadafi/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HadafiHeatMap extends StatelessWidget {
  final Map<DateTime, int> dataSets;
  final DateTime startDate;

  const HadafiHeatMap({
    super.key,
    required this.startDate,
    required this.dataSets,
  });

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: dataSets,
      colorMode: ColorMode.color,
      defaultColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Theme.of(context).colorScheme.tertiary
          : Theme.of(context).colorScheme.secondary,
      textColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Colors.white
          : Colors.grey.shade600,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        0: Colors.green.shade50,
        1: Colors.green.shade100,
        2: Colors.green.shade200,
        3: Colors.green.shade300,
        4: Colors.green.shade400,
        5: Colors.green.shade500,
        6: Colors.green.shade600,
        7: Colors.green.shade700,
        8: Colors.green.shade800,
        9: Colors.green.shade900,
      },
    );
  }
}
