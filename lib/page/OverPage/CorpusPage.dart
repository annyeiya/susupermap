import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../../widgets/Building.dart';
import 'ImageBuilder.dart';


class CorpusPage extends StatefulWidget {
  const CorpusPage({super.key, this.numberFloor, required this.name});

  final String? numberFloor;
  final String name;

  @override
  State<CorpusPage> createState() => _CorpusPage();
}

class _CorpusPage extends State<CorpusPage> {

  late Map<String, String> _imageMap;
  late String _name;
  String? _numberFloor;
  late String? _jsonFile;

  @override
  void initState () {
    super.initState();
    _name = widget.name;
    _imageMap = Building.naming[_name]![1] as Map<String, String>;
    _numberFloor = widget.numberFloor ?? _imageMap.keys.first;
    _jsonFile = Building.jsonFiles[_name];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
     body: NestedScrollView (
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: Text("${context.localeString("housing")} ${Building.naming[_name]![0] as String}"),
          centerTitle: true,
          floating: false,
          pinned: false,
          snap: false,
      ),],
        body: SingleChildScrollView (
          child: Column(
            children: [
              const SizedBox(height: 60.0),
              Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LocaleText('floor', style: TextStyle(fontSize: 20),),
                  SizedBox (
                  height: 30,
                  width: 50,
                  child: DropdownButton<String>(
                    value: _numberFloor,
                    icon: const Icon(Icons.keyboard_arrow_right_outlined),
                    underline: Container(height: 0,),
                    isExpanded: true,
                    iconSize: 24,
                    style: const TextStyle(color: Colors.black, fontSize: 20.0),
                    onChanged: (String? newValue) {
                      setState(() {
                        _numberFloor = newValue!;
                      });
                    },
                    items: _imageMap.keys.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ]),
              const SizedBox(height: 40.0),
              ImageBuilder(numberFloor: _numberFloor, imageMap: _imageMap, jsonFile: _jsonFile,),
              const SizedBox(height: 40.0),
              OrientationBuilder(
                builder: (context, orientation) {
                  if (MediaQuery.of(context).orientation == Orientation.portrait) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset(
                        context.currentLocale?.languageCode == "ru"
                            ? 'assets/img/легенда_карты_ru.jpg'
                            : 'assets/img/легенда_карты_en.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
