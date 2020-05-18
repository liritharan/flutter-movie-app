import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/movies_bloc.dart';
import 'package:movie/model/movie.dart';
import 'package:movie/pages/router.gr.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  MoviesBloc moviesBloc;

  @override
  void initState() {
    super.initState();
    moviesBloc = BlocProvider.of<MoviesBloc>(context);
    moviesBloc.add(WatchNowEvent());
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(onChangeTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    moviesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {},
        ),
        title: Text('Movies'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.local_movies), text: 'Watch now'),
            Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
            Tab(icon: Icon(Icons.update), text: 'Upcoming'),
            Tab(icon: Icon(Icons.stars), text: 'Top Rated'),
            Tab(icon: Icon(Icons.group), text: 'Popular'),
          ],
        ),
       actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.format_list_bulleted,
              color: Colors.white,
            ),
            onPressed: (){}
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (BuildContext context, MoviesState state) {
          if (state is MoviesLoadedState) {
            List<Movie> movies = state.movies;
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                movies.length,
                (index) => InkWell(
                  onTap: () => {
                    ExtendedNavigator.of(context).pushNamed(
                      Routes.moviePage,
                      arguments: MoviePageArguments(
                        movie: state.movies[index],
                      ),
                    ),
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          movies[index].posterPath,
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${movies[index].originalTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                20,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 135.0,
                        height: 150.0,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ), //            child: ListView.builder(
//              itemBuilder: (_, __) => ,
//              itemCount: 6,
//            ),
          );
        },
      ),
    );
  }

  void onChangeTab() {
    switch (_tabController.index) {
      case 0:
        moviesBloc.add(WatchNowEvent());
        break;
      case 1:
        moviesBloc.add(TrendingEvent());
        break;
      case 2:
        moviesBloc.add(UpcomingEvent());
        break;
      case 3:
        moviesBloc.add(TopRatedEvent());
        break;
      case 4:
        moviesBloc.add(PopularEvent());
        break;
    }
  }
}
