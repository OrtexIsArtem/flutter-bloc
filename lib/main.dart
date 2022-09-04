import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_1/counter_bloc.dart';
import 'package:flutter_bloc_1/user_bloc/user_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => counterBloc,
        ),
        BlocProvider(
          create: (context) => UserBloc(counterBloc),
        ),
      ],
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      floatingActionButton: BlocConsumer<CounterBloc, int>(
        buildWhen: (prev, current) => prev > current,
        listenWhen: (prev, current) => prev > current,
        listener: (context, state) {
          if (state == 0) {
            Scaffold.of(context).showBottomSheet(
                  (context) => Container(
                color: Colors.blue,
                width: double.infinity,
                height: 30,
                child: Text('State is 0'),
              ),
            );
          }
        },
        builder: (context, state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.toString()),
            IconButton(
              onPressed: () {
                counterBloc.add(CounterIncEvent());
              },
              icon: const Icon(Icons.plus_one),
            ),
            IconButton(
              onPressed: () {
                counterBloc.add(CounterDecEvent());
              },
              icon: const Icon(Icons.exposure_minus_1),
            ),
            IconButton(
              onPressed: () {
                final userBloc = context.read<UserBloc>();
                userBloc
                    .add(UserGetUsersEvent(context.read<CounterBloc>().state));
              },
              icon: const Icon(Icons.person),
            ),
            IconButton(
              onPressed: () {
                final userBloc = context.read<UserBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Job(),
                  ),
                );
                userBloc.add(
                    UserGetUsersJobEvent(context.read<CounterBloc>().state));
              },
              icon: const Icon(Icons.work),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              BlocBuilder<CounterBloc, int>(
                // bloc: counterBloc,
                builder: (context, state) {
                  final users =
                      context.select((UserBloc bloc) => bloc.state.users);
                  return Column(
                    children: [
                      Text(state.toString(), style: TextStyle(fontSize: 33)),
                      if (users.isNotEmpty) ...users.map((e) => Text(e.name)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Job extends StatelessWidget {
  const Job({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final job = state.job;
          return Column(
            children: [
              if (state.isLoading) const CircularProgressIndicator(),
              if (job.isNotEmpty) ...job.map((e) => Text(e.name)),
            ],
          );
        },
      ),
    );
  }
}
