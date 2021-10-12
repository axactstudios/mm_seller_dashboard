
import 'Model.dart';

class Category extends Model {
  static const String BANNER_URL_KEY = "bannerUrl";

  static const String CAT_NAME_KEY = "catName";
  static const String STATUS_KEY = "status";
  static const String CAT_TYPE_KEY = "catType";
  static const String SUB_NAME_KEY = "subName";
  static const String SUPER_NAME_KEY = "superName";
  static const String FILTERS_AVAILABLE_KEY = "filtersAvailable";

  String bannerUrl;

  String catName;
  String status;
  String catType;
  String subName;
  String superName;
  List filtersAvailable;

  Category(String id,
      {this.catName,
      this.bannerUrl,
      this.status,
      this.catType,
      this.subName,
      this.filtersAvailable,
      this.superName})
      : super(id);

  factory Category.fromMap(Map<String, dynamic> map, {String id}) {
    return Category(id,
        bannerUrl: map[BANNER_URL_KEY],
        catName: map[CAT_NAME_KEY],
        status: map[STATUS_KEY],
        catType: map[CAT_TYPE_KEY],
        superName: map[SUPER_NAME_KEY],
        filtersAvailable: map[FILTERS_AVAILABLE_KEY],
        subName: map[SUB_NAME_KEY]);
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      BANNER_URL_KEY: bannerUrl,
      CAT_NAME_KEY: catName,
      STATUS_KEY: status,
      CAT_TYPE_KEY: catType,
      SUB_NAME_KEY: subName,
      FILTERS_AVAILABLE_KEY: filtersAvailable,
      SUPER_NAME_KEY: superName,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};

    if (bannerUrl != null) map[BANNER_URL_KEY] = bannerUrl;
    if (catName != null) map[CAT_NAME_KEY] = catName;
    if (status != null) map[STATUS_KEY] = status;
    if (catType != null) map[CAT_TYPE_KEY] = catType;
    if (subName != null) map[SUB_NAME_KEY] = subName;
    if (superName != null) map[SUPER_NAME_KEY] = superName;
    if (filtersAvailable != null) map[FILTERS_AVAILABLE_KEY] = filtersAvailable;

    return map;
  }
}
