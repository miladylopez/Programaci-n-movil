import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TemperatureScreen extends StatefulWidget {
  @override
  _TemperatureScreenState createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  String _temperature = "Esperando..."; // Para mostrar la temperatura
  bool _isLoading = false;

  // Función para obtener la temperatura desde la API
  Future<void> fetchTemperature() async {
    setState(() {
      _isLoading = true;
      _temperature = "Cargando...";
    });

    try {
      final lat = double.parse(_latController.text);
      final long = double.parse(_longController.text);

      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$long&current_weather=true',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temp = data['current_weather']['temperature'];
        setState(() {
          _temperature = '${temp.toStringAsFixed(1)} °C';
        });
      } else {
        setState(() {
          _temperature = "Error al obtener datos";
        });
      }
    } catch (e) {
      setState(() {
        _temperature = "Error en la conexión, temperatura promedio: 17 °C";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Consultar Temperatura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              SizedBox(height: 4),
              
              SizedBox(height: 20),
              
              Text(
                '$_temperature',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              
              // Icono del sol
              Icon(
                FontAwesomeIcons.soundcloud,  // Usa el ícono de sol de FontAwesome
                size: 150,
                color: Color.fromARGB(255, 52, 144, 230),
              ),
              SizedBox(height: 20),
              
              SizedBox(height: 30),
              
              // Inputs de latitud y longitud
              TextField(
                controller: _latController,
                decoration: InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _longController,
                decoration: InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
              
              // Botón para obtener temperatura
              ElevatedButton(
                onPressed: _isLoading ? null : fetchTemperature,
                child: _isLoading
                    ? CircularProgressIndicator(color: Color.fromARGB(255, 53, 168, 235))
                    : Text('Obtener Temperatura'),
                    
              ),
              // Visualización de la temperatura
              
              // Desarrollado por
              SizedBox(height: 20),
              Text(
                'Desarrollado por: Milady Lopez & Karolyne Renteria',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

