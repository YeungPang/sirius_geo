import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  Map<String, dynamic> stateData = {};

  dynamic get state => stateData["currState"];
  dynamic get prevState => stateData["prevState"];
  Map<String, dynamic> get map => stateData["map"];
  String get event => stateData["event"];

  String get name => stateData["name"];

  void notify() {
    notifyListeners();
  }
}
