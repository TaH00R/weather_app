import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/additional_info.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}



class _WeatherScreenState extends State<WeatherScreen> {
String cityName = 'Hyderabad';
Future<Map<String, dynamic>> getCurrentWeather() async {
  try {
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$OpenWeatherAPIKey',
      ),
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    if (data['cod'] != "200") {
      throw 'Unexpected Error';
    }
    return data;
  } catch (e) {
    throw Exception(e.toString());
  }
}

final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(onPressed: (){
            setState(() {});
          },
           icon: const Icon(Icons.refresh_sharp))
        ]
      ),


      body: 
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:_controller,
                  decoration: const InputDecoration(
                    hintText: "Enter City Name",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                ),
              ),
              IconButton(onPressed:(){
                final city = _controller.text.trim();

                if(_controller.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Enter a City Name")),
                  );
                  return;
                }

                setState(() {
                   cityName = city;
                });
              },
               icon: Icon(Icons.search))
            ],
          ),
          FutureBuilder(
            future: getCurrentWeather(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator.adaptive()
                  );
              }
              if (snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()));
              }
          
              final data = snapshot.data!;
              final CurrentTemp = data['list'][0]['main']['temp'] - 273.15;
              final CurrentWeather = data['list'][0]['weather'][0]['main'];
              final Pressure = data['list'][0]['main']['pressure'];
              final Humidity = data['list'][0]['main']['humidity'];
              final WindSpeed = data['list'][0]['wind']['speed'];
          
              return Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      //Current Weather
                      SizedBox(height:20),
                       SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(25)),
                             elevation: 5,
                             color: const Color.fromARGB(246, 74, 78, 78),
                             child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                               child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                 child: Padding(
                                   padding: const EdgeInsets.symmetric(horizontal:16.0,vertical:10),
                                   child: Column(
                                    children: [
                                      Text('${CurrentTemp.toStringAsFixed(2)}°C',
                                      style: GoogleFonts.poppins(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      )
                                        ),
                                        const SizedBox(height: 5,),
                                        Icon(
                                        CurrentWeather == 'Clouds' || CurrentWeather == 'Rain' 
                                        ?Icons.cloud 
                                        :Icons.sunny,
                                        size: 100),
                                        const SizedBox(height: 5,),
                                        Text(CurrentWeather,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 25,
                                        ),
                                        ),
                                        const SizedBox(height: 20,),
                                    ],
                                   ),
                                 ),
                               ),
                             ),
                          ),
                        ),
                  
              
              
                      //Hourly Weather
                      const SizedBox(height: 10),
                        Text('Hourly Forecast',
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index){
          final HourlyForecast = data['list'][index+1];
          final HourlySky = HourlyForecast['weather'][0]['main'];
          final Hourlytemp = '${(HourlyForecast['main']['temp']-273.15).toStringAsFixed(2)}°C';
          
          final time = DateTime.parse(
            HourlyForecast['dt_txt']
          );
          return HourlyForecastItem(
            time: DateFormat.Hm().format(time),
           temperature: Hourlytemp,
            weather: HourlySky == 'Clouds'
            || HourlySky == 'Rain' ? Icons.cloud
            : Icons.sunny
            );
              }
              ),
          ),
              
                      //Additional Info
                      const SizedBox(height:10),
                        Text('Additional Information',
                        style: GoogleFonts.lato(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                                  AdditionalInfoItem(
                                    icon: Icons.water_drop,
                                    label: 'Humidity',
                                    value: Humidity.toString(),
                                  ),
                                  const SizedBox(width: 50,),
                                  AdditionalInfoItem(
                                    icon: Icons.wind_power,
                                    label: 'Wind Speed',
                                    value: WindSpeed.toString(),
                                  ),
                                  const SizedBox(width: 50,),
                                  AdditionalInfoItem(
                                    icon: Icons.speed,
                                    label: 'Pressure',
                                    value: Pressure.toString(),
                                  ),
                                ],
                              ),
                            )
                            ],
                          ),
                  );
            },
          ),
        ],
      ),
        );
  }
}