// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_show/common/constants.dart';
import 'package:movie_show/domain/entities/series.dart';
import 'package:movie_show/domain/entities/series_detail.dart';
import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/presentation/provider/series/series_detail_notifier.dart';
import 'package:movie_show/presentation/provider/series/series_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_show/presentation/provider/series/watchlist_series_notifier.dart';
import 'package:provider/provider.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-series';

  final int id;
  const SeriesDetailPage({super.key, required this.id});

  @override
  SeriesDetailPageState createState() => SeriesDetailPageState();
}

class SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SeriesDetailNotifier>(context, listen: false)
          .fetchSeriesDetail(widget.id);
      Provider.of<WatchlistSeriesNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<SeriesDetailNotifier, WatchlistSeriesNotifier>(
        builder: (context, detail, watchlist, _) {
          if (detail.recommendationState == RequestState.Loading ||
              detail.seriesDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (detail.recommendationState == RequestState.Loaded ||
              detail.seriesDetailState == RequestState.Loaded) {
            final seriesRecommendation = detail.seriesRecommendations;
            final seriesDetail = detail.seriesDetail;
            final isAddedWatchlist = watchlist.isAddedToWatchlist;
            return SafeArea(
              child: DetailContent(
                seriesDetail,
                seriesRecommendation,
                isAddedWatchlist,
              ),
            );
          } else {
            return Text('${detail.message}\n${detail.message}');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final SeriesDetail series;
  final List<Series> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.series, this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name!,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<WatchlistSeriesNotifier>(
                                          context,
                                          listen: false)
                                      .addWatchlist(series);
                                } else {
                                  await Provider.of<WatchlistSeriesNotifier>(
                                          context,
                                          listen: false)
                                      .removeFromWatchlist(series);
                                }

                                final message =
                                    Provider.of<WatchlistSeriesNotifier>(
                                            context,
                                            listen: false)
                                        .message;

                                if (message ==
                                        WatchlistSeriesNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        WatchlistSeriesNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Text(message),
                                        );
                                      });
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              _showGenres(series.genres),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${series.numberOfSeasons} Season •',
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${series.numberOfEpisodes} Episode',
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Episode run time : ',
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: series.episodeRunTime!
                                  .map(
                                    (e) => Text(
                                      _showDuration(e as int)!,
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: series.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<SeriesListNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final series = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                SeriesDetailPage.ROUTE_NAME,
                                                arguments: series.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${series.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<GenreSeries> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String? _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '$hours Hourse $minutes Mintues';
    } else {
      return '$minutes Mintues';
    }
  }
}
