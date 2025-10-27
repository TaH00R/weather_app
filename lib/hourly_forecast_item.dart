import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData weather;
  const HourlyForecastItem({super.key,
  required this.time,
  required this.temperature,
  required this.weather});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                width: 120,
                height: 135,
                child: Card(
                  color: const Color.fromARGB(246, 74, 78, 78),
                  elevation: 6  ,
                    child: Column(
                    children: [
                      SizedBox(width: 25,height: 5),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal:10.0),
                       child: Text(time,
                        style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,),
                                        ),
                     ),
                 const SizedBox(height: 8),
                 Icon(weather,
                 size: 32),
                
                 const SizedBox(height: 8),
                 Text(temperature,
                  style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  ),
                  ),
                   ],
                  ),
                     ),
              );
  }
}