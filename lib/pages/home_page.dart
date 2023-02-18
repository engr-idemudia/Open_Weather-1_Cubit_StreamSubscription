import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_cubit/pages/search_page.dart';
import 'package:open_weather_cubit/widgets/error_dialog.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_weather_cubit/repositories/weather_repository.dart';
// import 'package:open_weather_cubit/services/weather_api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  ////create a call for testing
  // @override
  // void initState() {
  //   super.initState();
  //   _fetchWeather();
  // }

  // _fetchWeather() {
  //   //   WeatherRepository(
  //   //           weatherApiServices: WeatherApiServices(httpClient: http.Client()))
  //   //       .fetchWeather('london');

  //   ////context.read<WeatherCubit>().fetchWeather('london');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather'), actions: [
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }),
              );
              print('city: $_city');
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            })
      ]),
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
      if (state.status == WeatherStatus.initial) {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      if (state.status == WeatherStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.status == WeatherStatus.error && state.weather.name == '') {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }

      return Center(
        child: Text(
          state.weather.name,
          style: const TextStyle(fontSize: 18.0),
        ),
      );
    }, listener: (context, state) {
      if (state.status == WeatherStatus.error) {
        errorDialog(context, state.error.errMsg);

        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       content: Text(state.error.errMsg),
        //     );
        //   },
        // );
      }
    });
  }
}
