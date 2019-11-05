import 'package:scoped_model/scoped_model.dart';
import 'package:trash_safari/scoped_model/point_model.dart';

import './user_model.dart';
import './point_model.dart';

class MainModel extends Model
    with ConnectedProductsModel, UserModel, PointsModel {}
