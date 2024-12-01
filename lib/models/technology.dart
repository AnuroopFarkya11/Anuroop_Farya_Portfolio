import 'package:my_portfolio/core/utils/constants.dart';
import 'package:responsive_framework/responsive_value.dart';

class TechnologyModel {
  final String name;
  final String logo;

  TechnologyModel(this.name, this.logo);

  static List<TechnologyModel> jsonToList(List<dynamic> list) {
    List<TechnologyModel> tech = [];
    for (String s in list) {
      TechnologyModel? model = TechnologyConstants.technologyLearned
          .firstWhere((e) => e.name.toLowerCase().contains(s.toLowerCase()),orElse: () => TechnologyModel(s, ""));
      tech.add(model);
    }
    return tech;
  }
}

class TechnologyConstants {
  static TechnologyModel python =
      TechnologyModel("Python", AppConstants.pythonImage);
  static TechnologyModel php = TechnologyModel("Python", AppConstants.phpImage);
  static TechnologyModel flutter =
      TechnologyModel("Flutter", AppConstants.flutterImage);
  static TechnologyModel flask =
      TechnologyModel("Flask", AppConstants.flaskImage);
  static TechnologyModel firebase =
      TechnologyModel("Firebase", AppConstants.firebaseImage);
  static TechnologyModel razorPay =
      TechnologyModel("Razor Pay", AppConstants.razorPayImage);
  static TechnologyModel cPlus =
      TechnologyModel("C++", AppConstants.cPlusImage);
  static TechnologyModel javascript =
      TechnologyModel("Javascript", AppConstants.javascriptImage);
  static TechnologyModel swift =
      TechnologyModel("Swift", AppConstants.swiftImage);
  static TechnologyModel sceneKit =
      TechnologyModel("SceneKit", AppConstants.sceneKitImage);

  static List<TechnologyModel> technologyLearned = [
    flutter,
    firebase,
    swift,
    cPlus,
    python,
    javascript,
    flask
  ];
}
