// ignore_for_file: constant_identifier_names

import 'package:movie_show/common/state_enum.dart';
import 'package:movie_show/presentation/provider/movie_list_notifier.dart';
import 'package:movie_show/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/now-playing-movies';

  const NowPlayingMoviePage({super.key});

  @override
  NowPlayingMoviePageState createState() => NowPlayingMoviePageState();
}

class NowPlayingMoviePageState extends State<NowPlayingMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MovieListNotifier>(context, listen: false)
            .fetchNowPlayingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<MovieListNotifier>(
          builder: (context, data, child) {
            if (data.nowPlayingState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.nowPlayingState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.nowPlayingMovies[index];
                  return MovieCard(movie);
                },
                itemCount: data.nowPlayingMovies.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
