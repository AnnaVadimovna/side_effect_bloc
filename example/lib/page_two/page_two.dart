import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'cubit/page_two_cubit.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  State<PageTwo> createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageTwoCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Page Two'),
        ),
        body: Builder(
          builder: (context) => BlocSideEffectListener<PageTwoCubit, PageTwoShowDialogEvent>(
            listener: (context, event) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(event.label),
                  actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
                ),
              );
            },
            child: Center(
              child: ElevatedButton(
                  onPressed: () => context.read<PageTwoCubit>().processData(), child: const Text('Process data')),
            ),
          ),
        ),
      ),
    );
  }
}
