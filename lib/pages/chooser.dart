import 'package:colorama/configuration/colors.dart';
import 'package:colorama/configuration/helpers.dart';
import 'package:flutter/material.dart';

class ChooserPage extends StatefulWidget {
  const ChooserPage({super.key});

  @override
  State<ChooserPage> createState() => _ChooserPageState();
}

class _ChooserPageState extends State<ChooserPage> {
  var _r = 0.0;
  var _g = 0.0;
  var _b = 0.0;

  Color get _backgroundColor {
    final r = (_r * 255).toInt();
    final g = (_g * 255).toInt();
    final b = (_b * 255).toInt();

    return Color.fromARGB(255, r, g, b);
  }

  Color get _textColor {
    return ThemeData.estimateBrightnessForColor(_backgroundColor) ==
            Brightness.light
        ? Colors.black
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => willPop(context),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _backgroundColor,
          foregroundColor: _textColor,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox.shrink()),
                Text(
                  'Definí el color de la ronda',
                  style: TextStyle(fontSize: 24, color: _textColor),
                ),
                const SizedBox(height: 24),
                ColorSlider(
                  label: 'R',
                  value: _r,
                  color: rColor,
                  textColor: _textColor,
                  onChanged: (value) {
                    _r = value;
                    if (mounted) setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                ColorSlider(
                  label: 'G',
                  value: _g,
                  color: gColor,
                  textColor: _textColor,
                  onChanged: (value) {
                    _g = value;
                    if (mounted) setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                ColorSlider(
                  label: 'B',
                  value: _b,
                  color: bColor,
                  textColor: _textColor,
                  onChanged: (value) {
                    _b = value;
                    if (mounted) setState(() {});
                  },
                ),
                const Expanded(child: SizedBox.shrink()),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Cuando hayas terminado, apretá continuar',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: _textColor),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChooserPage(),
                        settings: const RouteSettings(name: 'ChooserPage'),
                      ),
                    ),
                    child: const Text('Continuar'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColorSlider extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final Color textColor;
  final Function(double) onChanged;

  const ColorSlider({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Slider(
              thumbColor: color,
              value: value,
              divisions: 10,
              onChanged: onChanged,
            ),
          ),
          Text(
            '${(value * 255).toInt()}'.padLeft(3, '0'),
            style: TextStyle(
              fontSize: 24,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
