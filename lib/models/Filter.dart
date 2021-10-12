
import 'Model.dart';

class Filter extends Model {
  static const String FILTER_NAME_KEY = "filterName";

  static const String OPTIONS_KEY = "options";
  static const String CATEGORIES_KEY = "categories";

  String filterName;

  List options;
  List categories;

  Filter(String id, {this.filterName, this.options, this.categories})
      : super(id);

  factory Filter.fromMap(Map<String, dynamic> map, {String id}) {
    return Filter(id,
        filterName: map[FILTER_NAME_KEY],
        options: map[OPTIONS_KEY],
        categories: map[CATEGORIES_KEY]);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      FILTER_NAME_KEY: filterName,
      OPTIONS_KEY: options,
      CATEGORIES_KEY: categories
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};

    if (filterName != null) map[FILTER_NAME_KEY] = filterName;
    if (options != null) map[OPTIONS_KEY] = options;
    if (categories != null) map[CATEGORIES_KEY] = categories;

    return map;
  }
}
