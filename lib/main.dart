// ignore_for_file: deprecated_member_use
import 'package:flutter_nav_bloc/bloc/my_bloc.dart';
import 'package:flutter_nav_bloc/main.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/my_bloc.dart';
import 'main.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => MyBloc(),
      child: const MyApp(),
    ),
  );
}

enum MyEvent { eventA, eventB }

@immutable
abstract class MyState {}

class StateA extends MyState {}

class StateB extends MyState {}

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(StateA()) {
    on<MyEvent>((event, emit) => emit(StateA()));
    //  on<MyEvent>((event, emit) => emit(StateB()));
  }
  @override
  MyState get initialState => StateA();

  @override
  Stream<MyState> mapEventToState(MyEvent event) async* {
    switch (event) {
      case MyEvent.eventA:
        yield StateA();
        break;
      case MyEvent.eventB:
        yield StateB();
        break;
    }
  }
  /* MyBloc() : super(StateA()) {
    on<EventA>((event, state) => emit(StateA()));
    on<EventB>((event, emit) => emit(StateB()));
  } */
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<MyBloc, MyState>(
        builder: (_, state) => state is StateA ? const PageA() : const PageB(),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page A'),
      ),
      body: Center(
        child: RaisedButton(
            child: const Text('Go to Page B!'),
            onPressed: () {
              BlocProvider.of<MyBloc>(context).add(MyEvent.eventB);
            }),
      ),
    );
  }
}

class PageB extends StatelessWidget {
  const PageB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page B'),
      ),
      body: Center(
        child: FloatingActionButton(
            child: const Text('Go to Page A'),
            onPressed: () {
              BlocProvider.of<MyBloc>(context).add(MyEvent.eventA);
            }),
      ),
    );
  }
}
