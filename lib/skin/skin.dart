import 'package:h3_app/constants.dart';
import 'package:flutter/material.dart';

abstract class SkinOptions {}

@immutable
class Skin {
  final String id;
  final ThemeData data;
  final SkinOptions options;
  final String description;

  Skin({
    @required this.id,
    @required ThemeData data,
    String description,
    this.options,
  })  : this.data = data,
        this.description = description ??
            (data.brightness == Brightness.light
                ? "Light Theme"
                : "Dark Theme") {
    assert(description != null, "Theme $id does not have a description");
    assert(description.length < 30, "Theme description too long ($id)");
    assert(id.isNotEmpty, "Id cannot be empty");
    assert(id.toLowerCase() == id, "Id has to be a lowercase string");
    assert(!id.contains(" "), "Id cannot contain spaces. (Use _ for spaces)");
  }

  /// Default light theme
  factory Skin.light({String id}) {
    return Skin(
      data: ThemeData(
        brightness: Brightness.light,
        fontFamily: "Alibaba PuHuiTi",
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#7A73C7"), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#7A73C7"), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#E0E0E0"), width: 1),
          ),
          hintStyle: TextStyle(
              color: Constants.hexStringToColor("#999999"), fontSize: 24),
        ),
      ),
      id: id ?? "default_light_theme",
      description: "Android Default Light Theme",
    );
  }

  /// Default dark theme
  factory Skin.dark({String id}) {
    return Skin(
      data: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Alibaba PuHuiTi",
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#7A73C7"), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#7A73C7"), width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
                color: Constants.hexStringToColor("#E0E0E0"), width: 1),
          ),
          hintStyle: TextStyle(
              color: Constants.hexStringToColor("#999999"), fontSize: 24),
        ),
      ),
      id: id ?? "default_dark_theme",
      description: "Android Default Dark Theme",
    );
  }

  /// Additional purple theme constructor
  factory Skin.purple({String id}) {
    return Skin(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.purple,
          accentColor: Colors.pink,
        ),
        id: id);
  }

  factory Skin.custom({String id}) {
    return Skin(
      id: id,
      data: ThemeData(
        // Real theme data
        primaryColor: Colors.black,
        accentColor: Colors.red,
      ),
      description: "自定义",
    );
  }

  /// Creates a copy of this [Theme] but with the given fields replaced with the new values.
  /// Id will be replaced by the given [id].
  Skin copyWith({
    @required String id,
    String description,
    ThemeData data,
    SkinOptions options,
  }) {
    return Skin(
      id: id,
      description: description ?? this.description,
      data: data ?? this.data,
      options: options ?? this.options,
    );
  }
}
