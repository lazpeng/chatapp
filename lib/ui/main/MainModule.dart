import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:chatapp/ui/main/MainBloc.dart';
import 'package:chatapp/ui/main/MainPage.dart';
import 'package:flutter/material.dart';

class MainModule extends ModuleWidget {
  @override
  List<Bloc<BlocBase>> get blocs => [
    Bloc((i) => MainBloc())
  ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => MainPage();

  static Inject get to => Inject<MainModule>.of();
}