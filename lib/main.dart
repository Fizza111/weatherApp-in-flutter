

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double temperature = 0.00;
  int humidity = 0;
  int pressure = 0;
  double windSpeed = 0.0;
  TextEditingController cityName = TextEditingController();

  Future<void> fetchWeather() async {
    try {
      final String city = cityName.text.trim();
      if (city.isEmpty) {
        print('City name is empty');
        return;
      }

      final String cityUrl =
          'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=52f13d6caab340101bc8ca46c2ef33f4';
      final responseCity = await http.get(Uri.parse(cityUrl));

      if (responseCity.statusCode == 200) {
        print('Response Body: ${responseCity.body}');

        final List<dynamic> dataCity = jsonDecode(responseCity.body);
        if (dataCity.isEmpty) {
          print('No location found for the city');
          return;
        }

        double latitude = dataCity[0]['lat'];
        double longitude = dataCity[0]['lon'];

        final String apiUrl =
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=52f13d6caab340101bc8ca46c2ef33f4';

        final response = await http.get(Uri.parse(apiUrl));

        if (response.statusCode == 200) {
          print('Response Body: ${response.body}');

          final data = jsonDecode(response.body);
          setState(() {
            // Convert temperature from Kelvin to Celsius
            temperature = data['main']['temp'] - 273.15;
            humidity = data['main']['humidity'];
            pressure = data['main']['pressure'];
            windSpeed = data['wind']['speed'];
          });
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('Error: ${responseCity.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey.shade800,
            title: Center(child: Text('Weather App', style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold))),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cityName,
                    decoration: InputDecoration(
                      hintText: "Enter location here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: Icon(Icons.location_on_sharp),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset('assets/cloudy-day.png'),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Temperature :" + temperature.toStringAsFixed(2) + " °C",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset('assets/humidity.png'),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                               "Humidity :"+ humidity.toString()+"%",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset('assets/rush.png'),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                               "Wind speed :"+windSpeed.toString()+"M/S",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.asset('assets/sun.png'),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "Pressure :"+pressure.toString()+"mb",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: () {
                      fetchWeather();
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
