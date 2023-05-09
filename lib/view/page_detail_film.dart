import 'package:flutter/material.dart';
import '../controller/api_data_source.dart';
import '../model/detail_film.dart';

class PageDetailFilm extends StatefulWidget {
  final String imdbID;

  const PageDetailFilm({required this.imdbID, Key? key}) : super(key: key);

  @override
  State<PageDetailFilm> createState() => _PageDetailFilmState();
}

class _PageDetailFilmState extends State<PageDetailFilm> {
  late Future<DetailFilm> _futureFilmDetail;

  @override
  void initState() {
    super.initState();
    _futureFilmDetail = ApiDataSource.instance
        .loadDetailFilm(widget.imdbID)
        .then((json) => DetailFilm.fromJson(json));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DetailFilm>(
          future: _futureFilmDetail,
          builder: (BuildContext context, AsyncSnapshot<DetailFilm> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title!);
            } else {
              return Text("Loading...");
            }
          },
        ),
      ),
      body: _buildDetailBody(),
    );
  }

  Widget _buildDetailBody() {
    return Center(
      child: FutureBuilder<DetailFilm>(
        future: _futureFilmDetail,
        builder: (BuildContext context, AsyncSnapshot<DetailFilm> snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          if (snapshot.hasData) {
            DetailFilm detailModel = snapshot.data!;
            return Column(
              children: [
                SizedBox(height: 15.0),
                Container(
                  width: 150.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      detailModel.poster!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  detailModel.title!,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 600,
                  padding: EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date Released : ${detailModel.released!}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Genre                : ${detailModel.genre!}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Director             : ${detailModel.director!}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Actor                 : ${detailModel.actors!}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        "Plot                    : ${detailModel.plot!}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
