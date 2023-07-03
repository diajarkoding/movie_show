import 'package:movie_show/data/datasources/movie_local_data_source.dart';
import 'package:movie_show/data/datasources/movie_remote_data_source.dart';
import 'package:movie_show/data/datasources/series_local_data_source.dart';
import 'package:movie_show/data/db/database_helper_movie.dart';
import 'package:movie_show/data/db/database_helper_series.dart';
import 'package:movie_show/data/repositories/movie_repository_impl.dart';
import 'package:movie_show/domain/repositories/movie_repository.dart';
import 'package:movie_show/domain/usecases/movies/get_movie_detail.dart';
import 'package:movie_show/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:movie_show/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:movie_show/domain/usecases/movies/get_popular_movies.dart';
import 'package:movie_show/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:movie_show/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:movie_show/domain/usecases/movies/get_watchlist_status.dart';
import 'package:movie_show/domain/usecases/movies/remove_watchlist.dart';
import 'package:movie_show/domain/usecases/movies/save_watchlist.dart';
import 'package:movie_show/domain/usecases/movies/search_movies.dart';
import 'package:movie_show/domain/usecases/series/get_series_detail.dart';
import 'package:movie_show/domain/usecases/series/get_series_recommendations.dart';
import 'package:movie_show/domain/usecases/series/get_watchlist_series.dart';
import 'package:movie_show/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:movie_show/domain/usecases/series/remove_watchlist_series.dart';
import 'package:movie_show/domain/usecases/series/save_watchlist_series.dart';
import 'package:movie_show/presentation/provider/movie_detail_notifier.dart';
import 'package:movie_show/presentation/provider/movie_list_notifier.dart';
import 'package:movie_show/presentation/provider/movie_search_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_detail_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_list_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_search_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movie_show/presentation/provider/series/watchlist_series_notifier.dart';
import 'package:movie_show/presentation/provider/watchlist_movie_notifier.dart';
import 'data/datasources/series_remote_data_source.dart';
import 'data/repositories/series_repository_impl.dart';
import 'domain/repositories/series_repository.dart';
import 'domain/usecases/series/get_now_playing_series.dart';
import 'domain/usecases/series/get_popular_series.dart';
import 'domain/usecases/series/get_top_rated_series.dart';
import 'domain/usecases/series/search_series.dart';

final locator = GetIt.instance;

void init() {
  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  // provider series
  locator.registerFactory(
    () => SeriesListNotifier(
      getNowPlayingSeries: locator(),
      getPopularSeries: locator(),
      getTopRatedSeries: locator(),
      getSeriesRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesDetailNotifier(
      getSeriesDetail: locator(),
      getSeriesRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => SeriesSearchNotifier(
      searchSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistSeriesNotifier(
      getWatchlistSeries: locator(),
      getWatchListSeriesStatus: locator(),
      removeWatchlistSeries: locator(),
      saveWatchlistSeries: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case series
  locator.registerLazySingleton(() => GetNowPlayingSeries(locator()));
  locator.registerLazySingleton(() => GetPopularSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedSeries(locator()));
  locator.registerLazySingleton(() => GetSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListSeriesStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository series
  locator.registerLazySingleton<SeriesRepository>(
    () => SeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // data sources series
  locator.registerLazySingleton<SeriesRemoteDataSource>(
      () => SeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<SeriesLocalDataSource>(
      () => SeriesLocalDataSourceImpl(
            databaseHelperSeries: locator(),
          ));

  // helper
  locator
      .registerLazySingleton<DatabaseHelperMovie>(() => DatabaseHelperMovie());

  // helper series
  locator.registerLazySingleton<DatabaseHelperSeries>(
      () => DatabaseHelperSeries());

  // external
  locator.registerLazySingleton(() => http.Client());
}
