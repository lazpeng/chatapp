abstract class BaseModel {
  static dynamic fromJsonMap(Map<String, dynamic> map) => null;

  static dynamic fromDbCursor(List<Map<String, dynamic>> cursor) => null;

  Map<String, dynamic> toJsonMap() => null;
}