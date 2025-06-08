import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  CategoryModel({
    required this.name,
    required this.iconCodePoint,
    required this.fontFamily,
    required this.fontPackage,
    required this.color,
    this.budget,
    this.spent,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  int? iconCodePoint;

  @HiveField(2)
  String? fontFamily;

  @HiveField(3)
  String? fontPackage;

  @HiveField(4)
  int? color;

  @HiveField(5)
  double? budget;

  @HiveField(6)
  double? spent;

  IconData? get icon =>
      iconCodePoint != null
          ? IconData(
            iconCodePoint!,
            fontFamily: fontFamily,
            fontPackage: fontPackage,
          )
          : null;

  set icon(IconData? value) {
    if (value == null) return;
    iconCodePoint = value.codePoint;
    fontFamily = value.fontFamily;
    fontPackage = value.fontPackage;
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon, 'color': Color(color!)};
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    IconData iconData = json['icon'] as IconData;

    return CategoryModel(
      name: json['name'],
      iconCodePoint: iconData.codePoint,
      fontFamily: iconData.fontFamily,
      fontPackage: iconData.fontPackage,
      color: (json['color'] as Color).value32bit,
    );
  }
}
