import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/notes_repository.dart';
import 'bloc/auth/auth_cubit.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/notes/notes_bloc.dart';
import 'bloc/notes/notes_event.dart';
import 'ui/auth/login_screen.dart';
import 'ui/notes/notes_list_screen.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = AuthRepository();
    final notesRepo = NotesRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: notesRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(authRepo)),
          BlocProvider(create: (_) => NotesBloc(notesRepo)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                context.read<NotesBloc>().add(NotesStarted(state.uid));
                return const NotesListScreen();
              }
              if (state is Unauthenticated) return const LoginScreen();
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            },
          ),
        ),
      ),
    );
  }
}
