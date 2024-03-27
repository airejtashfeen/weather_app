import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey = "bee209c39f3476e6b65cf3564101d969";
  String apiUrl =
      "https://api.openweathermap.org/data/2.5/weather?units=metric&q=";
  TextEditingController searchController = TextEditingController();
  String city = "New York";
  int temperature = 22;
  int humidity = 50;
  int windSpeed = 15;
  String weatherIconUrl = "images/rain.png";

  void fetchWeather(String cityName) async {
    final response =
        await http.get(Uri.parse(apiUrl + cityName + "&appId=$apiKey"));
    final data = jsonDecode(response.body);

    setState(() {
      city = data['name'];
      temperature = data['main']['temp'].round();
      humidity = data['main']['humidity'];
      windSpeed = data['wind']['speed'].round();

      String weatherCondition = data['weather'][0]['main'];
      if (weatherCondition == "Clouds") {
        weatherIconUrl = "images/clouds.png";
      } else if (weatherCondition == "Rain") {
        weatherIconUrl = "images/rain.png";
      } else if (weatherCondition == "Clear") {
        weatherIconUrl = "images/clear.png";
      } else if (weatherCondition == "Drizzle") {
        weatherIconUrl = "images/drizzle.png";
      } else if (weatherCondition == "Mist") {
        weatherIconUrl = "images/mist.png";
      } else if (weatherCondition == "Snow") {
        weatherIconUrl = "images/snow.png";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(186, 7, 90, 129), 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Card(
            elevation: 5, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.black, 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: searchController,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Enter City Name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            fetchWeather(searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Image.asset(weatherIconUrl, height: 150), 
                      Text(
                        '$temperature°C',
                        style: TextStyle(fontSize: 80, color: Colors.white),
                      ),
                      Text(
                        city,
                        style: TextStyle(fontSize: 45, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildDetailColumn('Humidity', '$humidity%'),
                          SizedBox(width: 24.0),
                          _buildDetailColumn('Wind Speed', '$windSpeed km/h'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}
