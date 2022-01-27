import 'package:flutter/material.dart';
import 'package:global_traveler_app/data/shared_prefs.dart';
import 'package:global_traveler_app/models/font_size.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int settingColor = 0xff1976d2;
  double? fontSize = 16;
  SPSettings settings = SPSettings();
  final List<FontSize> fontSizes = [
    FontSize('Small', 12),
    FontSize('Medium', 16),
    FontSize('Large', 20),
    FontSize('Extra-Large', 24),
  ];

  List<int> colors = [
    0xFF455A64,
    0xFFFFC107,
    0xFF673AB7,
    0xFFF57C00,
    0xFF795548
  ];

  List<GestureDetector> mainColorSquares = [];

  @override
  void initState() {
    settings = SPSettings();
    settings.init().then((_) {
      setState(() {
        settingColor = settings.getColor();
        fontSize = settings.getFontSize();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mainColorSquares = [];
    for (var x in colors) {
      mainColorSquares.add(
          GestureDetector(onTap: () => setColor(x), child: ColorSquare(x)));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        backgroundColor: Color(settingColor),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Choose a Font Size for the App',
            style: TextStyle(fontFamily: 'Raleway', fontSize: fontSize),
          ),
          DropdownButton(
            value: "16.0",
            items: getDropDownMenuItems(),
            onChanged: changeSize,
          ),
          Text('App Main Color'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: mainColorSquares,
          )
        ],
      ),
    );
  }

  setColor(int color) {
    setState(() {
      settingColor = color;
      settings.setColor(color);
    });
    // settings.setColor(color).then((value) => print(value.toString()));
  }

  void changeSize(String? newSize) {
    // List<FontSize> filteredFS =
    //     fontSizes.where((element) => element.size == double.tryParse(newSize)).toList();
    settings.setFontSize(double.tryParse(newSize as String));
    setState(() {
      //fontSizeString = newSize;
      fontSize = double.tryParse(newSize);
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (FontSize fontSize in fontSizes) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      print(fontSize.size.toString());
      items.add(DropdownMenuItem(
          value: fontSize.size.toString(),
          child: Text(fontSize.name,
              style: const TextStyle(fontFamily: 'Raleway'))));
    }
    return items;
  }
}

class ColorSquare extends StatelessWidget {
  final int colorCode;
  ColorSquare(this.colorCode);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Color(colorCode)),
    );
  }
}
