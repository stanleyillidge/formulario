import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

part 'main.g.dart';

// Modelo para almacenar los datos generales y la lista de respuestas
@HiveType(typeId: 0)
class FormResponse extends HiveObject {
  @HiveField(0)
  String edad;

  @HiveField(1)
  String gradoEscolar;

  @HiveField(2)
  String lenguaMaterna;

  @HiveField(3)
  String idiomaCasa;

  @HiveField(4)
  List<int> answers;

  FormResponse({
    required this.edad,
    required this.gradoEscolar,
    required this.lenguaMaterna,
    required this.idiomaCasa,
    required this.answers,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FormResponseAdapter());
  await Hive.openBox<FormResponse>('responses');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Wayuu',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Caja de Hive para almacenar respuestas
  final Box<FormResponse> responseBox = Hive.box<FormResponse>('responses');

  // Variables para Datos Generales del Estudiante
  String? _selectedEdad;
  String? _selectedGrado;
  String? _selectedLenguaMaterna;
  String? _selectedIdiomaCasa;

  final List<String> edadOptions = ["11-13", "14-16", "16-19", "Más de 19"];
  final List<String> gradoOptions = ["Noveno", "Décimo", "Undécimo"];
  final List<String> lenguaMaternaOptions = ["Sí", "No"];
  final List<String> idiomaCasaOptions = [
    "Solo wayuunaiki",
    "Más wayuunaiki que español",
    "Ambos por igual",
    "Más español que wayuunaiki",
    "Solo español",
  ];

  // Sección 1: Preguntas de Educación y Cultura
  final List<String> section1Questions = [
    "¿Las clases incluyen información sobre la historia y cultura wayuu?",
    "¿Aprendo sobre conocimientos ancestrales en las asignaturas del colegio?",
    "¿En las clases se habla sobre la importancia de la comunidad wayuu?",
    "¿Ha tenido la oportunidad de sugerir contenidos que considera relevantes para tu cultura?",
    "¿Los profesores usan ejemplos y actividades relacionadas con la cultura wayuu?",
    "¿Puedo participar en clase hablando en wayuunaiki si lo deseo?",
    "¿En las clases se utilizan métodos de enseñanza que se parecen a las formas en que aprendemos en la comunidad wayuu?",
    "¿En las clases se combinan métodos de enseñanza occidentales y tradicionales?",
    "¿Los docentes valoran el conocimiento oral y las historias de los mayores?",
    "¿Los docentes valoran el conocimiento oral y las historias de los mayores?",
    "¿Los profesores demuestran respeto por las costumbres wayuu?",
    "¿Los profesores demuestran conocimiento de las costumbres wayuu?",
    "¿Los docentes saben hablar wayuunaiki?",
    "¿En el colegio hay maestros indígenas que enseñan en wayuunaiki?",
    "¿Los profesores enseñan sobre la cosmovisión wayuu junto con los contenidos académicos?",
    "¿En el colegio hay libros en wayuunaiki?",
    "¿Se utilizan materiales educativos que incluyen información sobre la cultura wayuu?",
    "¿Hay acceso a videos, audios o tecnología que enseñan sobre la tradición wayuu?",
    "¿Se usan guías y textos escolares que respetan la identidad wayuu?",
    "¿Hay materiales diseñados por miembros de la comunidad wayuu para el aprendizaje?",
    "¿La escuela permite y fomenta el uso del wayuunaiki dentro del aula?",
    "¿Los líderes de la comunidad wayuu participan en decisiones sobre la educación?",
    "¿La institución respeta los tiempos y prácticas tradicionales de la comunidad?",
    "¿Se promueven festividades y eventos culturales wayuu dentro del colegio?",
    "¿Las reglas del colegio respetan la cultura wayuu y su forma de aprendizaje?",
  ];

  // Sección 2: Preguntas sobre uso del wayuunaiki y Tradición
  final List<String> section2Questions = [
    "¿Hablo wayuunaiki en casa con mi familia?",
    "¿Hablo wayuunaiki con mis amigos en la escuela?",
    "¿Uso el wayuunaiki en mis actividades escolares (oral o escrito)?",
    "¿Prefiero comunicarme en wayuunaiki en situaciones cotidianas?",
    "¿Me siento orgulloso de hablar wayuunaiki?",
    "¿Participo en festividades tradicionales wayúu como la Majayura?",
    "¿Conozco los rituales y normas del sistema de clanes wayuu?",
    "¿Mi familia celebra eventos tradicionales propios de la cultura wayuu?",
    "¿Conozco y practico las normas de respeto dentro de la comunidad wayuu?",
    "¿Me interesa aprender sobre las ceremonias wayuu y su significado?",
    "¿Conozco y puedo explicar mitos e historias wayuu?",
    "¿Aprendo sobre la medicina tradicional de la comunidad?",
    "¿Sé cómo se elaboran los tejidos wayuu (mochilas, chinchorros)?",
    "¿Participo en conversaciones con los mayores sobre conocimientos ancestrales?",
    "¿Sé cómo se construyen las viviendas tradicionales de la comunidad?",
    "¿Me identifico como miembro de la comunidad wayuu?",
    "¿Me siento orgulloso de mis raíces wayuu?",
    "¿Conozco el significado de mi clan y su importancia en la comunidad?",
    "¿Valoro y respeto las normas de convivencia wayuu?",
    "¿Me esfuerzo por aprender y preservar la cultura wayuu?",
    "¿Uso vestimenta tradicional wayuu en eventos culturales?",
    "¿Prefiero la comida tradicional wayuu sobre la comida occidental?",
    "¿Ayudo a mi familia en actividades tradicionales como la recolección de agua o la cría de animales?",
    "¿Me gusta compartir tiempo con mi comunidad y participar en sus actividades?",
    "¿Conozco y sigo las costumbres wayuu en mi vida diaria?",
  ];

  late int totalQuestions;
  late List<int?> answers;
  final List<Map<String, dynamic>> scaleOptions = [
    {"value": 5, "label": "Siempre"},
    {"value": 4, "label": "Casi siempre"},
    {"value": 3, "label": "Algunas veces"},
    {"value": 2, "label": "Rara vez"},
    {"value": 1, "label": "Nunca"},
  ];

  // Controlador de Scroll para desplazar el formulario
  final ScrollController _scrollController = ScrollController();

  // Variable para almacenar la ruta del archivo exportado
  String? exportedFilePath;

  @override
  void initState() {
    super.initState();
    totalQuestions = section1Questions.length + section2Questions.length;
    answers = List<int?>.filled(totalQuestions, null);
  }

  // Construye cada widget de pregunta. Cambia el color si ya se contestó.
  Widget _buildQuestion(String question, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 4,
      color: (answers[index] != null) ? Colors.grey[300] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pregunta ${index + 1}: $question",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children:
                  scaleOptions.map((option) {
                    return ChoiceChip(
                      label: Text("${option['value']} (${option['label']})"),
                      selected: answers[index] == option['value'],
                      onSelected: (selected) {
                        setState(() {
                          answers[index] = option['value'];
                        });
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Botón para borrar la base de datos de Hive
  // Botón para borrar la base de datos de Hive con confirmación
  Widget _buildDeleteDatabaseButton() {
    return IconButton(
      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
      tooltip: "Borrar base de datos de Hive",
      onPressed: () async {
        final bool? confirm = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Confirmar borrado"),
                content: const Text("¿Estás seguro de que deseas borrar la base de datos?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Borrar", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
        );
        if (confirm == true) {
          await Hive.deleteBoxFromDisk('responses');
          // Reabrir la caja para continuar usando la app
          await Hive.openBox<FormResponse>('responses');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Base de datos borrada")));
          setState(() {
            exportedFilePath = null;
          });
        }
      },
    );
  }

  // Guarda la respuesta, resetea el formulario y desplaza el scroll al inicio
  Future<void> _saveResponse() async {
    if (_selectedEdad == null ||
        _selectedGrado == null ||
        _selectedLenguaMaterna == null ||
        _selectedIdiomaCasa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa los Datos Generales del Estudiante.")),
      );
      return;
    }
    if (answers.contains(null)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Por favor, responde todas las preguntas.")));
      return;
    }
    final response = FormResponse(
      edad: _selectedEdad!,
      gradoEscolar: _selectedGrado!,
      lenguaMaterna: _selectedLenguaMaterna!,
      idiomaCasa: _selectedIdiomaCasa!,
      answers: answers.cast<int>(),
    );
    await responseBox.add(response);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Respuesta guardada localmente.")));
    setState(() {
      // Reiniciar datos generales y respuestas
      _selectedEdad = null;
      _selectedGrado = null;
      _selectedLenguaMaterna = null;
      _selectedIdiomaCasa = null;
      answers = List<int?>.filled(totalQuestions, null);
    });
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Exporta las respuestas a XLS y muestra la ruta en pantalla
  Future<void> _exportToExcel() async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Respuestas'];

    // Encabezados: Datos generales + Pregunta 1, Pregunta 2, ...
    List<CellValue?> headers = [
      TextCellValue("Edad"),
      TextCellValue("Grado Escolar"),
      TextCellValue("Lengua Materna"),
      TextCellValue("Idioma en Casa"),
    ];
    headers.addAll(
      List.generate(totalQuestions, (index) => TextCellValue("Pregunta ${index + 1}")),
    );
    sheet.appendRow(headers);

    // Agregar cada respuesta almacenada
    for (final response in responseBox.values) {
      List<CellValue?> row = [
        TextCellValue(response.edad),
        TextCellValue(response.gradoEscolar),
        TextCellValue(response.lenguaMaterna),
        TextCellValue(response.idiomaCasa),
      ];
      row.addAll(response.answers.map((e) => IntCellValue(e)).toList());
      sheet.appendRow(row);
    }

    Directory? directory;
    if (Platform.isAndroid || Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getTemporaryDirectory();
    }
    String outputFile = "${directory.path}/respuestas_wayuu.xlsx";
    final fileBytes = excel.encode();
    if (fileBytes != null) {
      File(outputFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      setState(() {
        exportedFilePath = outputFile;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Datos exportados a $outputFile")));
    }
  }

  // Widget para construir un Dropdown con título
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
          value: value,
          items:
              options
                  .map((opcion) => DropdownMenuItem<String>(value: opcion, child: Text(opcion)))
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calcular el progreso según las respuestas dadas
    int answeredCount = answers.where((e) => e != null).length;
    double progress = answeredCount / totalQuestions;
    int missing = totalQuestions - answeredCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Formulario Wayuu')),
      body: Column(
        children: [
          // Encabezado fijo con imagen, progreso, botones y mensaje de preguntas pendientes
          Container(
            color: Colors.white,
            child: Wrap(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset(
                      'imagenes/logoUCAGS2021.png', // Verifica que la imagen esté en assets y declarada en pubspec.yaml
                      // fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LinearProgressIndicator(value: progress, minHeight: 8),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    answeredCount < totalQuestions
                        ? "Faltan $missing preguntas por responder"
                        : "Todas las preguntas respondidas",
                    style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width: 200,
                        child: Row(
                          children: [
                            ElevatedButton(
                              onPressed: _saveResponse,
                              child: const Text("Guardar Respuesta"),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.lightGreenAccent.shade100,
                                ),
                              ),
                              onPressed: _exportToExcel,
                              child: const Text("Exportar a XLS"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          children: [
                            if (exportedFilePath != null)
                              IconButton(
                                icon: Icon(
                                  Icons.file_copy,
                                  size: 20,
                                  color: Colors.lightGreenAccent.shade700,
                                ),
                                tooltip: "Mostrar ubicación del archivo XLS",
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text("Ubicación del archivo XLS"),
                                          content: SelectableText(exportedFilePath!),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Clipboard.setData(
                                                  ClipboardData(text: exportedFilePath!),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Ruta copiada al portapapeles"),
                                                  ),
                                                );
                                              },
                                              child: const Text("Copiar"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cerrar"),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            // Botón pequeño para borrar la base de datos, aparece si ya se exportó el XLS
                            if (exportedFilePath != null) _buildDeleteDatabaseButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Formulario desplazable
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Datos Generales del Estudiante
                    const Text(
                      "Datos Generales del Estudiante",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildDropdownField(
                      label: "Edad (Años)",
                      value: _selectedEdad,
                      options: edadOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedEdad = value;
                        });
                      },
                    ),
                    _buildDropdownField(
                      label: "Grado escolar",
                      value: _selectedGrado,
                      options: gradoOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedGrado = value;
                        });
                      },
                    ),
                    _buildDropdownField(
                      label: "¿El wayuunaiki es tu lengua materna?",
                      value: _selectedLenguaMaterna,
                      options: lenguaMaternaOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedLenguaMaterna = value;
                        });
                      },
                    ),
                    _buildDropdownField(
                      label: "¿En casa hablas más wayuunaiki o español?",
                      value: _selectedIdiomaCasa,
                      options: idiomaCasaOptions,
                      onChanged: (value) {
                        setState(() {
                          _selectedIdiomaCasa = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Sección 1: Educación y Cultura
                    const Text(
                      "Sección 1: Educación y Cultura",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ...List.generate(section1Questions.length, (index) {
                      return _buildQuestion(section1Questions[index], index);
                    }),
                    const SizedBox(height: 16),
                    // Sección 2: Uso del wayuunaiki y Tradición
                    const Text(
                      "Sección 2: Uso del wayuunaiki y Tradición",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ...List.generate(section2Questions.length, (i) {
                      int index = section1Questions.length + i;
                      return _buildQuestion(section2Questions[i], index);
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
