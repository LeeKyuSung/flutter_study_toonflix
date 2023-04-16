import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<MovieModel>> popularMovies = ApiService.getPopularMovies();
  final Future<List<MovieModel>> nowPlayingMovies =
      ApiService.getNowPlayingMovies();
  final Future<List<MovieModel>> comingSoonMovies =
      ApiService.getComingSoonMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Popular Movies",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: FutureBuilder(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return makePopularList(snapshot);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Now in Cinemas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: FutureBuilder(
                future: nowPlayingMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return makeNowPlayingList(snapshot);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                "Coming Soon",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 250,
              child: FutureBuilder(
                future: comingSoonMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: 300,
                      child: makeComingSoonList(snapshot),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

ListView makePopularList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    padding: const EdgeInsets.all(20),
    itemBuilder: (context, index) {
      var webtoon = snapshot.data![index];
      return PopularMovieWidget(
        id: webtoon.id,
        title: webtoon.title,
        voteAverage: webtoon.voteAverage,
        backdropPath: webtoon.backdropPath,
        posterPath: webtoon.posterPath,
        releaseDate: webtoon.releaseDate,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(
        width: 15,
      );
    },
  );
}

class PopularMovieWidget extends StatelessWidget {
  final int id;
  final String title;
  final int voteAverage;
  final String backdropPath;
  final String posterPath;
  final String releaseDate;

  const PopularMovieWidget({
    super.key,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.backdropPath,
    required this.posterPath,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return DetailScreen(
                id: id.toString(),
              );
            }),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
            child: Image.network(
              backdropPath,
              fit: BoxFit.cover,
              height: 160,
              width: 230,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              for (var i = 0; i < voteAverage; i++)
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 15,
                ),
              for (var i = 0; i < 5 - voteAverage; i++)
                const Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: 15,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

ListView makeNowPlayingList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    padding: const EdgeInsets.all(20),
    itemBuilder: (context, index) {
      var webtoon = snapshot.data![index];
      return NowPlayingMovieWidget(
        id: webtoon.id,
        title: webtoon.title,
        voteAverage: webtoon.voteAverage,
        backdropPath: webtoon.backdropPath,
        posterPath: webtoon.posterPath,
        releaseDate: webtoon.releaseDate,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(
        width: 12,
      );
    },
  );
}

class NowPlayingMovieWidget extends StatelessWidget {
  final int id;
  final String title;
  final int voteAverage;
  final String backdropPath;
  final String posterPath;
  final String releaseDate;

  const NowPlayingMovieWidget({
    super.key,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.backdropPath,
    required this.posterPath,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return DetailScreen(
                id: id.toString(),
              );
            }),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
            child: Image.network(
              backdropPath,
              fit: BoxFit.cover,
              height: 110,
              width: 110,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              for (var i = 0; i < voteAverage; i++)
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 15,
                ),
              for (var i = 0; i < 5 - voteAverage; i++)
                const Icon(
                  Icons.star,
                  color: Colors.grey,
                  size: 15,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

ListView makeComingSoonList(AsyncSnapshot<List<MovieModel>> snapshot) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    padding: const EdgeInsets.all(20),
    itemBuilder: (context, index) {
      var webtoon = snapshot.data![index];
      return ComingSoonMovieWidget(
        id: webtoon.id,
        title: webtoon.title,
        voteAverage: webtoon.voteAverage,
        backdropPath: webtoon.backdropPath,
        posterPath: webtoon.posterPath,
        releaseDate: webtoon.releaseDate,
      );
    },
    separatorBuilder: (context, index) {
      return const SizedBox(
        width: 12,
      );
    },
  );
}

class ComingSoonMovieWidget extends StatelessWidget {
  final int id;
  final String title;
  final num voteAverage;
  final String backdropPath;
  final String posterPath;
  final String releaseDate;

  const ComingSoonMovieWidget({
    super.key,
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.backdropPath,
    required this.posterPath,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return DetailScreen(
                id: id.toString(),
              );
            }),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.4),
                ),
              ],
            ),
            child: Image.network(
              backdropPath,
              fit: BoxFit.cover,
              height: 110,
              width: 110,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            releaseDate,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromARGB(255, 67, 67, 67),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;
  final Future<MovieDetailModel> movie;

  DetailScreen({
    super.key,
    required this.id,
  }) : movie = ApiService.getMovieDetail(id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(-1, -1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(1, -1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(-1, 1),
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Back to list",
            style: TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: const Offset(-1, -1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(1, -1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(1, 1),
                  color: Colors.black.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(-1, 1),
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
          )),
      body: FutureBuilder<MovieDetailModel>(
        future: movie,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return makeDetail(
              snapshot.data!,
              MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

Widget makeDetail(MovieDetailModel movie, double height, double width) {
  onButtonTap() async {
    await launchUrlString(movie.homepage);
  }

  return Stack(
    children: [
      Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(movie.posterPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height / 3,
              ),
              Text(
                movie.title,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(-1, -1),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(1, -1),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(1, 1),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(-1, 1),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  for (var i = 0; i < movie.voteAverage; i++)
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 23,
                      shadows: [
                        Shadow(
                          offset: const Offset(-1, -1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(1, -1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(-1, 1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                  for (var i = 0; i < 5 - movie.voteAverage; i++)
                    Icon(
                      Icons.star,
                      color: Colors.grey,
                      size: 23,
                      shadows: [
                        Shadow(
                          offset: const Offset(-1, -1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(1, -1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(1, 1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Shadow(
                          offset: const Offset(-1, 1),
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${movie.runtime} | ${movie.genres}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      offset: const Offset(-1, -1),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    Shadow(
                      offset: const Offset(1, -1),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    Shadow(
                      offset: const Offset(1, 1),
                      color: Colors.black.withOpacity(0.2),
                    ),
                    Shadow(
                      offset: const Offset(-1, 1),
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        shadows: [
                          Shadow(
                            offset: const Offset(-0.4, -0.4),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          Shadow(
                            offset: const Offset(0.4, -0.4),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          Shadow(
                            offset: const Offset(0.4, 0.4),
                            color: Colors.black.withOpacity(0.2),
                          ),
                          Shadow(
                            offset: const Offset(-0.4, 0.4),
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      movie.overview,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        shadows: [
                          Shadow(
                            offset: const Offset(-0.3, -0.3),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Shadow(
                            offset: const Offset(0.3, -0.3),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Shadow(
                            offset: const Offset(0.3, 0.3),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          Shadow(
                            offset: const Offset(-0.3, 0.3),
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
        height: height,
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              maximumSize: Size(width * 0.6, height * 0.1),
              minimumSize: Size(width * 0.6, height * 0.05),
            ),
            onPressed: onButtonTap,
            child: const Text(
              "Buy Ticket",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";
  static const String popular = "popular";
  static const String nowPlaying = "now-playing";
  static const String comingSoon = "coming-soon";
  static const String movieDetail = "movie";

  static Future<List<MovieModel>> getPopularMovies() async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse("$baseUrl/$popular");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      for (var movie in movies) {
        final movieInstance = MovieModel.fromJson(movie);
        movieInstances.add(movieInstance);
      }
      return movieInstances;
    }
    return Future.error(response.toString());
  }

  static Future<List<MovieModel>> getNowPlayingMovies() async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse("$baseUrl/$nowPlaying");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      for (var movie in movies) {
        final movieInstance = MovieModel.fromJson(movie);
        movieInstances.add(movieInstance);
      }
      return movieInstances;
    }
    return Future.error(response.toString());
  }

  static Future<List<MovieModel>> getComingSoonMovies() async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse("$baseUrl/$comingSoon");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> movies = json['results'];
      for (var movie in movies) {
        final movieInstance = MovieModel.fromJson(movie);
        movieInstances.add(movieInstance);
      }
      return movieInstances;
    }
    return Future.error(response.toString());
  }

  static Future<MovieDetailModel> getMovieDetail(String id) async {
    final url = Uri.parse("$baseUrl/$movieDetail?id=$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final movieInstance = MovieDetailModel.fromJson(json);
      return movieInstance;
    }
    return Future.error(response.toString());
  }
}

class MovieModel {
  static const String imgBaseUrl = "https://image.tmdb.org/t/p/w500";

  int id;
  String title;
  int voteAverage;
  String releaseDate;
  String backdropPath;
  String posterPath;

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        voteAverage = (json['vote_average'].toDouble() / 2).round().toInt(),
        backdropPath = imgBaseUrl + json['backdrop_path'],
        posterPath = imgBaseUrl + json['poster_path'],
        releaseDate = json['release_date'];
}

class MovieDetailModel {
  static const String imgBaseUrl = "https://image.tmdb.org/t/p/w500";

  int id;
  String title;
  int voteAverage;
  String runtime;
  String genres;
  String overview;
  String backdropPath;
  String posterPath;
  String releaseDate;
  String homepage;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        voteAverage = (json['vote_average'].toDouble() / 2).round().toInt(),
        runtime = json['runtime'] / 60 > 1
            ? "${(json['runtime'] / 60).toInt()}h ${json['runtime'] % 60}m"
            : "${json['runtime']}m",
        genres = json['genres'].map((x) => x['name']).join(", "),
        overview = json['overview'],
        backdropPath = imgBaseUrl + json['backdrop_path'],
        posterPath = imgBaseUrl + json['poster_path'],
        releaseDate = json['release_date'],
        homepage = json['homepage'];
}
