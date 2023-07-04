import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/domain/entities/series.dart';
import 'package:movie_show/domain/entities/series_detail.dart';
import 'package:movie_show/domain/usecases/series/get_series_detail.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_show/domain/usecases/series/get_series_recommendations.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
  });

  late SeriesDetail _seriesDetail;
  SeriesDetail get seriesDetail => _seriesDetail;

  RequestState _seriesDetailState = RequestState.Empty;
  RequestState get seriesDetailState => _seriesDetailState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getSeriesDetail.execute(id);
    final recommendationResult = await getSeriesRecommendations.execute(id);

    detailResult.fold(
      (failure) {
        _seriesDetailState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (seriesDetail) {
        _recommendationState = RequestState.Loading;
        _seriesDetail = seriesDetail;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (series) {
            _recommendationState = RequestState.Loaded;
            _seriesRecommendations = series;
            notifyListeners();
          },
        );
        _seriesDetailState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
