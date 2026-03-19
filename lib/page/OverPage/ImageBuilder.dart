import 'package:flutter/material.dart';

import 'package:untitled/widgets/Classroom.dart';
import 'package:untitled/widgets/Transition.dart';

class ImageBuilder extends StatefulWidget {
  const ImageBuilder({super.key, required this.numberFloor, required this.imageMap, required this.jsonFile,});

  final String? numberFloor;
  final Map<String, String> imageMap;
  final String? jsonFile;

  @override
  State<ImageBuilder> createState() => _ImageBuilder();
}

class _ImageBuilder extends State<ImageBuilder> {

  String? _numberFloor;
  late Map<String, String> _imageMap;
  String? _jsonFile;
  late TransformationController _scale;

  @override
  void initState () {
    super.initState();
    _numberFloor = widget.numberFloor;
    _imageMap = widget.imageMap;
    _jsonFile = widget.jsonFile;
    _scale = TransformationController();
  }

  @override
  void didUpdateWidget(covariant ImageBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.numberFloor != widget.numberFloor ||
        oldWidget.imageMap != widget.imageMap ||
        oldWidget.jsonFile != widget.jsonFile) {
      setState(() {
        _numberFloor = widget.numberFloor;
        _imageMap = widget.imageMap;
        _jsonFile = widget.jsonFile;
      });
    }
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  Future<List<Widget>> _getClassroom (BuildContext context) async {
    List<Classroom> classrooms = await Classroom.getClassroomsFromJson(_jsonFile!, _numberFloor!);
    List<Widget> classroomWidgets = classrooms.map((classroom) =>
        Classroom.classroom(context, classroom)).toList();

    List<Transition> transition = await Transition.getTransitionFromJson(_jsonFile!, _numberFloor!);
    classroomWidgets.addAll(transition.map((transition) => Transition.building(context, transition)));
    return classroomWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          InteractiveViewer(
              interactionEndFrictionCoefficient: 0.05,
              minScale: 1.0,
              maxScale: 5.0,
              transformationController: _scale,
              child: FutureBuilder<List<Widget>>(
                  future: _getClassroom(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return OrientationBuilder(
                            builder: (BuildContext context, Orientation orientation) {
                              return Stack(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.asset(
                                        'assets/img/${_imageMap[_numberFloor]}.jpg',
                                        key: UniqueKey(),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),

                                    ...snapshot.data!,

                                  ]
                              );
                            });
                      }
                    } else {
                      return const CircularProgressIndicator();
                    }
                  })
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () => _zoom(1.3),
                  backgroundColor: const Color.fromARGB(80, 200, 155, 250),
                  elevation: 0,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () => _zoom(0.7),
                  backgroundColor: const Color.fromARGB(80, 200, 155, 250),
                  elevation: 0,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ]);
  }

  void _zoom(double scale) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset center = renderBox.size.center(Offset.zero);

    _scale.value = _scale.value.clone()
      ..translate(center.dx, center.dy)
      ..scale(scale)
      ..translate(-center.dx, -center.dy);
  }

}