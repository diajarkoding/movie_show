import 'dart:io';

import 'package:movie_show/common/certificate.dart';
import 'package:movie_show/common/constants.dart';
import 'package:movie_show/common/utils.dart';
import 'package:movie_show/presentation/pages/about_page.dart';
import 'package:movie_show/presentation/pages/movie_detail_page.dart';
import 'package:movie_show/presentation/pages/home_movie_page.dart';
import 'package:movie_show/presentation/pages/now_playing_movies_page.dart';
import 'package:movie_show/presentation/pages/popular_movies_page.dart';
import 'package:movie_show/presentation/pages/search_page.dart';
import 'package:movie_show/presentation/pages/series/now_playing_series_page.dart';
import 'package:movie_show/presentation/pages/series/popular_series_page.dart';
import 'package:movie_show/presentation/pages/series/search_series_page.dart';
import 'package:movie_show/presentation/pages/series/series_detail_page.dart';
import 'package:movie_show/presentation/pages/series/series_page.dart';
import 'package:movie_show/presentation/pages/series/top_rated_series_page.dart';
import 'package:movie_show/presentation/pages/splash_page.dart';
import 'package:movie_show/presentation/pages/top_rated_movies_page.dart';
import 'package:movie_show/presentation/provider/movie_detail_notifier.dart';
import 'package:movie_show/presentation/provider/movie_list_notifier.dart';
import 'package:movie_show/presentation/provider/movie_search_notifier.dart';
import 'package:movie_show/presentation/provider/popular_movies_notifier.dart';
import 'package:movie_show/presentation/provider/series/popular_series_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_detail_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_list_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_search_notifier.dart';
import 'package:movie_show/presentation/provider/series/top_rated_series_notifier.dart';
import 'package:movie_show/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_show/injection.dart' as di;

void main() {
  di.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Movie
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),

        // Series
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<SeriesSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularSeriesNotifier>(),
        ),

        ChangeNotifierProvider(
          create: (_) {
            di.locator<SeriesListNotifier>();
            di.locator<SeriesDetailNotifier>();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const SplashPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case NowPlayingMoviePage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const NowPlayingMoviePage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            // series
            case SeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const SeriesPage());
            case SeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => SeriesDetailPage(id: id),
                settings: settings,
              );
            case PopularSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const PopularSeriesPage());
            case TopRatedSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const TopRatedSeriesPage());
            case SearchSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const SearchSeriesPage());

            case NowPlayingSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const NowPlayingSeriesPage());
            // default
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
