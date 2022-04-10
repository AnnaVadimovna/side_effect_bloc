import 'package:example/page_one/bloc/page_one_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class PageOne extends StatefulWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    final bloc = PageOneBloc();
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Page one")),
        body: BlocSideEffectListener<PageOneBloc, PageOneCommand>(
          listener: (BuildContext context, PageOneCommand sideEffect) {
            sideEffect.when(
                goToNext: () => Navigator.of(context).pushNamed("/sub"),
                openSnackbar: () {
                  const snackBar = SnackBar(
                    content: Text('Yay! A SnackBar!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
          },
          child: BlocBuilder<PageOneBloc, PageOneState>(
            builder: (BuildContext context, state) => Column(
              children: [
                ElevatedButton(
                  child: const Text("To second page"),
                  onPressed: () => context
                      .read<PageOneBloc>()
                      .add(const PageOneEvent.nextClick()),
                ),
                ElevatedButton(
                  child: const Text("Show scankbar"),
                  onPressed: () => context
                      .read<PageOneBloc>()
                      .add(const PageOneEvent.openSnackbarClick()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
