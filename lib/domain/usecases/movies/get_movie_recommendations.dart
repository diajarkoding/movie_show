import 'package:dartz/dartz.dart';
import 'package:movie_show/domain/entities/movie.dart';
import 'package:movie_show/domain/repositories/movie_repository.dart';
import 'package:movie_show/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
