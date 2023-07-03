import 'package:flutter/foundation.dart';
import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/domain/entities/series.dart';
import 'package:movie_show/domain/entities/series_detail.dart';
import 'package:movie_show/domain/usecases/series/get_watchlist_series.dart';
import 'package:movie_show/domain/usecases/series/get_watchlist_series_status.dart';
import 'package:movie_show/domain/usecases/series/remove_watchlist_series.dart';
import 'package:movie_show/domain/usecases/series/save_watchlist_series.dart';

class WatchlistSeriesNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistSeries getWatchlistSeries;
  final GetWatchListSeriesStatus getWatchListSeriesStatus;
  final SaveWatchlistSeries saveWatchlistSeries;
  final RemoveWatchlistSeries removeWatchlistSeries;

  WatchlistSeriesNotifier({
    required this.getWatchlistSeries,
    required this.getWatchListSeriesStatus,
    required this.saveWatchlistSeries,
    required this.removeWatchlistSeries,
  });

  var _watchlistSeries = <Series>[];
  List<Series> get watchlistSeries => _watchlistSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchWatchlistSeries() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistSeries.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistSeries = seriesData;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(SeriesDetail series) async {
    final result = await saveWatchlistSeries.execute(series);

    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );

    await loadWatchlistStatus(series.id);
  }

  Future<void> removeFromWatchlist(SeriesDetail series) async {
    final result = await removeWatchlistSeries.execute(series);

    await result.fold(
      (failure) async {
        _message = failure.message;
      },
      (successMessage) async {
        _message = successMessage;
      },
    );

    await loadWatchlistStatus(series.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListSeriesStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
