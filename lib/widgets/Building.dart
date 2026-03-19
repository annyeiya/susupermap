class Building {
  static final Map<String, String> jsonFiles = {
    'start' : "start",
    '3б' : "ThirdB",
    '3а' : "ThirdA"
 };

  static final Map<String, List<Object>> naming = {
    '3б' : [ "3бв", thirdB ],
    '3а': [ "3а", thirdA]
  };

  static const String start = 'assets/img/студГородок.jpg';

  static final Map<String, String> thirdB = {
    '1': '3b/1-3б',
    '2': '3b/2-3б',
    '3': '3b/3-3б',
    '4': '3b/4-3б',
    '5': '3b/5-3б',
    '6': '3b/6-3б',
    '7': '3b/7-3б',
    '8': '3b/8-3б',
    '9': '3b/9-3б',
    '10': '3b/10-3б',
  };

  static final Map<String, String> thirdA = {
    '1': 'пригодится',
    '2': '3a/2-3а',
    '3': '3a/3-3а',
    '4': 'пригодится',
    '5': 'пригодится',
    '6': 'пригодится',
  };

  //TODO
}