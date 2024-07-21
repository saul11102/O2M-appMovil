import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class Monitoringscreen extends StatefulWidget {
  const Monitoringscreen({Key? key}) : super(key: key);

  @override
  _MonitoringscreenState createState() => _MonitoringscreenState();
}

class _MonitoringscreenState extends State<Monitoringscreen> {
  Map<String, dynamic> chartDataAire = {};
  Map<String, dynamic> chartDataAgua = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/monitoring/promedio/todo'));
      if (response.statusCode == 200) {
        final datos = json.decode(response.body);
        if (datos['code'] == 200) {
          final aireData = datos['datos']['aire'];
          final aguaData = datos['datos']['agua'];

          // Procesa los datos del aire
          final labelsAire = aireData
              .map<String>((item) => '${item['dia']}/${item['mes']}/${item['año']}')
              .toList();
          final dataAire = aireData
              .map<double>((item) => (item['promedioCalidadDato'] as num).toDouble())
              .toList();
          setState(() {
            chartDataAire = {
              'labels': labelsAire,
              'datasets': [
                {
                  'label': 'Calidad del Aire',
                  'data': dataAire,
                  'backgroundColor': Colors.blue,
                },
              ],
            };
          });

          // Procesa los datos del agua
          final labelsAgua = aguaData
              .map<String>((item) => '${item['dia']}/${item['mes']}/${item['año']}')
              .toList();
          final dataAgua = aguaData
              .map<double>((item) => (item['promedioCalidadDato'] as num).toDouble())
              .toList();
          setState(() {
            chartDataAgua = {
              'labels': labelsAgua,
              'datasets': [
                {
                  'label': 'Calidad del Agua',
                  'data': dataAgua,
                  'backgroundColor': Colors.purple,
                },
              ],
            };
          });
        } else {
          Fluttertoast.showToast(msg: 'Error en la respuesta del servidor');
        }
      } else {
        Fluttertoast.showToast(msg: 'Error al cargar los datos');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Excepción: $e');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoreo de los sensores'),
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Eje X: Fecha de recolección de datos\nEje Y: Nivel de contaminación (PPM)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.blueGrey[800], // Color de fondo para el cuadro de los títulos
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Calidad del Aire',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            chartDataAire.isNotEmpty
                ? LineChartSample(chartData: chartDataAire)
                : CircularProgressIndicator(),
            const SizedBox(height: 40),
            Container(
              color: Colors.blueGrey[800], // Color de fondo para el cuadro de los títulos
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Calidad del Agua',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            chartDataAgua.isNotEmpty
                ? LineChartSample(chartData: chartDataAgua)
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}


class LineChartSample extends StatelessWidget {
  final Map<String, dynamic> chartData;

  const LineChartSample({required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0), 
      child: FittedBox(
        fit: BoxFit.contain, 
        child: SizedBox(
          height: 350,
          width: MediaQuery.of(context).size.width,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 80, // Ajusta el tamaño reservado para el título del eje X
                    interval: chartData['labels'].length > 10
                        ? (chartData['labels'].length / 10).ceil().toDouble()
                        : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < chartData['labels'].length) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Transform.rotate(
                            angle: -0.385398, // Inclina los títulos ligeramente
                            child: Text(
                              chartData['labels'][index],
                              style: TextStyle(
                                fontSize: 13, // Tamaño de la fuente ajustado
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final valueString = value.toStringAsFixed(0);
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          valueString,
                          style: TextStyle(
                            fontSize: 14, // Tamaño de la fuente ajustado
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Oculta los títulos del eje Y en el lado derecho
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    chartData['datasets'][0]['data'].length,
                    (index) => FlSpot(index.toDouble(), chartData['datasets'][0]['data'][index]),
                  ),
                  isCurved: true,
                  color: chartData['datasets'][0]['backgroundColor'],
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

