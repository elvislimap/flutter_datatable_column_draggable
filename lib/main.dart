import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<List<ObjectGrid>> _propsInColumns;
  late List<DataColumn> _columns;
  late List<DataRow> _rows;
  final List<GlobalKey> _keys = <GlobalKey>[];

  @override
  void initState() {
    super.initState();

    _propsInColumns = PropsGrid.getListObjectGrid(PropsGrid.getList());
    setColumnsAndRows();
  }

  setColumnsAndRows() {
    _keys.clear();
    _columns = _getColumns();
    _rows = _getRows();
  }

  onDragEndColumnDataTable(DraggableDetails details, GlobalKey key) {
    final listXPositionColumns = <double>[];

    for (var keyGlobal in _keys) {
      final box = keyGlobal.currentContext?.findRenderObject() as RenderBox;
      listXPositionColumns.add(box.localToGlobal(Offset.zero).dx);
    }

    final currentBox = key.currentContext?.findRenderObject() as RenderBox;
    final valueCurrrentColumn = currentBox.localToGlobal(Offset.zero).dx;
    final valueNewPositionColumn = listXPositionColumns.reduce(
        (num1, num2) =>
            (num1 - details.offset.dx).abs() < (num2 - details.offset.dx).abs()
                ? num1
                : num2);

    final indexCurrentColumn = listXPositionColumns.indexOf(valueCurrrentColumn);
    final indexNewPositionColumn =
        listXPositionColumns.indexOf(valueNewPositionColumn);

    for (var propColumns in _propsInColumns) {
      propColumns.insert(
          indexNewPositionColumn, propColumns.removeAt(indexCurrentColumn));
    }

    setState(() {
      setColumnsAndRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            DataTable(
              columns: _columns,
              rows: _rows,
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _getColumns() {
    final dataColumns = <DataColumn>[];

    for (var prop in _propsInColumns.first) {
      var key = GlobalKey(debugLabel: prop.name);
      _keys.add(key);

      dataColumns.add(
        DataColumn(
          label: Draggable(
            key: key,
            data: prop.name,
            feedback: Container(
              width: 100,
              height: 30,
              color: Colors.white.withOpacity(0.8),
              child: Text(
                prop.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
            child: Container(
              color: Colors.transparent,
              child: Text(
                prop.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ),
            onDragEnd: (details) {
              onDragEndColumnDataTable(details, key);
            },
          ),
        ),
      );
    }

    return dataColumns;
  }

  List<DataRow> _getRows() {
    return _propsInColumns
        .map(
          (propsColumn) => DataRow(
            color: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }

              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.08);
              }

              if (_propsInColumns.indexOf(propsColumn).isEven) {
                return Colors.grey.withOpacity(0.3);
              }

              return null;
            }),
            cells: _getCells(propsColumn),
          ),
        )
        .toList();
  }

  List<DataCell> _getCells(List<ObjectGrid> propsColumn) {
    final dataCells = <DataCell>[];

    for (var prop in propsColumn) {
      dataCells.add(
        DataCell(
          TextField(
            controller: TextEditingController(
              text: prop.value,
            ),
          ),
        ),
      );
    }

    return dataCells;
  }
}

class PropsGrid {
  String colunaA;
  String colunaB;
  String colunaC;
  String colunaD;

  PropsGrid(this.colunaA, this.colunaB, this.colunaC, this.colunaD);

  static List<PropsGrid> getList() {
    return <PropsGrid>[
      PropsGrid("Valor A1", "Valor B1", "Valor C1", "Valor D1"),
      PropsGrid("Valor A2", "Valor B2", "Valor C2", "Valor D2"),
      PropsGrid("Valor A3", "Valor B3", "Valor C3", "Valor D3"),
      PropsGrid("Valor A4", "Valor B4", "Valor C4", "Valor D4"),
      PropsGrid("Valor A5", "Valor B5", "Valor C5", "Valor D5"),
      PropsGrid("Valor A6", "Valor B6", "Valor C6", "Valor D6"),
      PropsGrid("Valor A7", "Valor B7", "Valor C7", "Valor D7"),
      PropsGrid("Valor A8", "Valor B8", "Valor C8", "Valor D8"),
      PropsGrid("Valor A9", "Valor B9", "Valor C9", "Valor D9"),
      PropsGrid("Valor A10", "Valor B10", "Valor C10", "Valor D10"),
    ];
  }

  static List<List<ObjectGrid>> getListObjectGrid(List<PropsGrid> propsGrid) {
    final result = <List<ObjectGrid>>[];

    for (var prop in propsGrid) {
      result.add(_getObjectGrid(prop));
    }

    return result;
  }

  static List<ObjectGrid> _getObjectGrid(PropsGrid prop) {
    return <ObjectGrid>[
      ObjectGrid("Coluna A", prop.colunaA),
      ObjectGrid("Coluna B", prop.colunaB),
      ObjectGrid("Coluna C", prop.colunaC),
      ObjectGrid("Coluna D", prop.colunaD)
    ];
  }
}

class ObjectGrid {
  String name;
  String value;

  ObjectGrid(this.name, this.value);
}
