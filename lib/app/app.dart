import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/places/bloc/places_bloc.dart';
import 'package:places_surf/router/app_router.dart';
import 'package:places_surf/uikit/themes/app_theme_data.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlacesBloc>(
          create:
              (context) =>
                  PlacesBloc(getIt<IPlacesRepository>())
                    ..add(FetchPlacesEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
