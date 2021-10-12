
import 'Model.dart';

class Variant extends Model {
  static const String COLOR_KEY = "color";
  static const String SIZE_KEY = "size";

  String color;
  String size;

  Variant(String id, {this.color, this.size}) : super(id);

  factory Variant.fromMap(Map<String, dynamic> map, {String id}) {
    return Variant(
      id,
      color: map[COLOR_KEY],
      size: map[SIZE_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      COLOR_KEY: color,
      SIZE_KEY: size,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};

    if (color != null) map[COLOR_KEY] = color;
    if (size != null) map[SIZE_KEY] = size;

    return map;
  }
}
