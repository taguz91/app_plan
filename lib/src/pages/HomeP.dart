import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plan/src/models/PeriodoM.dart';
import 'package:plan/src/providers/CarreraPV.dart';
import 'package:plan/src/providers/CursoPV.dart';
import 'package:plan/src/providers/PeriodoPV.dart';


class HomeP extends StatefulWidget {
  @override
  _HomePState createState() => _HomePState();
}

class _HomePState extends State<HomeP> {

  final CarreraPV carpv = new CarreraPV();
  final PeriodoPV perpv = new PeriodoPV();
  final CursoPV curpv = new CursoPV();
  final DropdownMenuItem<String> itemInicio = DropdownMenuItem(child: _stlItem(''),value: '0',);

  List<DropdownMenuItem<String>> listPeriodo;
  List<DropdownMenuItem<String>> listCurso;
  Future<List<CarreraM>> carreras;
  Future<List<PeriodoM>> periodos;
  Future<List<CursoM>> cursos;
  String _query = '';
  String _carreraSelec = '0';
  String _periodoSelec = '0';
  String _cursoSelec = '0';
  bool _carrerasCargado = false;

  

  @override
  Widget build(BuildContext context) {
    //Cargamos el item inicial de todos los combos
    listPeriodo = new List();
    //listCurso = new List();
    //iniciarCombos();
    if(!_carrerasCargado){
      carreras = carpv.getTodos();
      _carrerasCargado = true;
    }

    if(_carreraSelec != '0'){
      periodos = perpv.getPorCarrera(int.parse(_carreraSelec));
    }else{
      periodos = null;
    }

    if(_periodoSelec == '0'){
      cursos = null;;
    }

    if(_periodoSelec != '0' && _cursoSelec == '0'){
      cursos = curpv.getPorPeriodo(int.parse(_periodoSelec));
    }
    
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _paginaPrincipal(),
          _paginaSecundaria(),
          _terceraPagina()
        ],
      ),
    );
  }

  
  Widget _paginaPrincipal() {
    return Stack(
      children: <Widget>[
        _colorFondo(),
        _imgFondo(),
        _txtInicio()
      ],
    );
  }

  Widget _colorFondo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(20, 82, 139, 0.8),
    );
  }

  Widget _imgFondo() {
    return Container(
      width: double.infinity,
      height: double.infinity/2,
      child: Image(
        image: AssetImage('assets/logoISTA.png'),
        //fit: BoxFit.cover,
      ),
    );
  }

  Widget _txtInicio(){
    return SafeArea(
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Text('P L A N', style: 
            TextStyle(
              color: Colors.white, 
              fontSize: 50.0),
          ),
          Expanded(child: Container(),),
          Icon(
            Icons.keyboard_arrow_down, 
            size: 70.0, 
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _paginaSecundaria() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0,),
            Text('Plan', 
            style: TextStyle(fontSize: 50.0),),
            SizedBox(height: 20.0,),

            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide()
                      ),
                    ),
                    autofocus: false,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    onChanged: (input){
                      _query = input.replaceAll(' ', '');
                    },
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(Icons.search, ),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, 'curso', arguments: _query);
                  },
                )
              ],
            ),
            SizedBox(height: 40.0,),
            _comboCarreras(),
            SizedBox(height: 20.0,),
            _comboPeriodoFuture(),
            SizedBox(height: 20.0,),
            _comboCursoFuture(),
            SizedBox(height: 40.0,),
          ],
        ),
      ),
    );
  }

  Widget _comboCarreras(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder(
          future: carreras,
          builder: (BuildContext ct, AsyncSnapshot<List<CarreraM>> snapshot){
            if(snapshot.hasData){
              return DropdownButton(

                value: _carreraSelec,
                items: getCarreras(snapshot.data),
                onChanged: ((s){
                  setState(() {
                    _carreraSelec = s;  
                    _periodoSelec = '0';
                  });
                }),
                isExpanded: true,
                icon: Icon(Icons.content_paste),
                iconSize: 40.0,
              );
            }else{
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ),
    );
  }

  Widget _comboPeriodoFuture() {
    if(periodos == null){
      return SizedBox(height: 40.0,);
    }else{
      return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder(
          future: periodos,
            builder: (BuildContext ct, AsyncSnapshot<List<PeriodoM>> snapshot){
              if(snapshot.hasData){
                return DropdownButton(

                  value: _periodoSelec,
                  items: getPeriodos(snapshot.data),
                  onChanged: ((s){
                    setState(() {
                      _periodoSelec = s;  
                      _cursoSelec = '0';
                    });
                  }),
                  isExpanded: true,
                  icon: Icon(Icons.content_paste),
                  iconSize: 40.0,
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ),
      );
    }
  }

  Widget _comboCursoFuture() {
    if(cursos == null){
      return SizedBox(height: 40.0,);
    }else{
      return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder(
          future: cursos,
            builder: (BuildContext ct, AsyncSnapshot<List<CursoM>> snapshot){
              if(snapshot.hasData){
                return DropdownButton(

                  value: _cursoSelec,
                  items: getCursos(snapshot.data),
                  onChanged: ((s){
                    setState(() {
                      _cursoSelec = s;  
                    });
                  }),
                  isExpanded: true,
                  icon: Icon(Icons.content_paste),
                  iconSize: 40.0,
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ),
      );
    }
  }

  
  List<DropdownMenuItem<String>> getCarreras(List<CarreraM> carreras) {
    List<DropdownMenuItem<String>> listCarreras = new List();
    listCarreras.add(
      DropdownMenuItem(
         child: _stlItem('Seleccione una carrera'),
         value: '0',
      )
    );
    carreras.forEach((c){
      listCarreras.add(
        DropdownMenuItem(
          child: _stlItem(c.nombre),
          value: c.id.toString(),
        )
      );
    });
    return listCarreras; 
  }

  List<DropdownMenuItem<String>> getPeriodos(List<PeriodoM> periodo) {
    List<DropdownMenuItem<String>> listPeriodo = new List();
    listPeriodo.add(
      DropdownMenuItem(
         child: _stlItem('Seleccione un periodo'),
         value: '0',
      )
    );
    periodo.forEach((p){
      listPeriodo.add(
        DropdownMenuItem(
          child: _stlItem(p.nombre),
          value: p.id.toString(),
        )
      );
    });
    return listPeriodo; 
  }

  List<DropdownMenuItem<String>> getCursos(List<CursoM> cursos) {
    List<DropdownMenuItem<String>> listCurso = new List();
    listCurso.add(
      DropdownMenuItem(
         child: _stlItem('Seleccione una materia por curso'),
         value: '0',
      )
    );
    cursos.forEach((c){
      listCurso.add(
        DropdownMenuItem(
          child: _stlItem(c.nombre+" | "+c.materiaNombre),
          value: c.idCurso.toString(),
        )
      );
    });
    return listCurso; 
  }

  static Widget _stlItem(String item){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 5.0
      ),
      child: Text(item, 
        style: TextStyle(fontSize: 15.0),
      ),
    );
  }

  Widget _terceraPagina(){
    final logo = Image(image: AssetImage('assets/logoISTA.png'),);

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          Center(child: logo,),
          _opciones(),
        ],
      ),
    );
  }

  Widget _opciones(){
    return ListView(
      children: <Widget>[
        SizedBox(height: 400,),
        _estiloBtn('Cursos'),
        SizedBox(height: 20.0,),
        _estiloBtn('Silabos'),
        SizedBox(height: 20.0,),
        SizedBox(height: 20.0,),
        _estiloBtn('Silabos'),
        SizedBox(height: 20.0,),
        SizedBox(height: 20.0,),
      ],
    );
  }

  Widget _estiloBtn(String opt){
    return Center(
      child: Container(
        width: 350.0,
        child: RaisedButton(        
          shape: StadiumBorder(),
          color: Color.fromRGBO(20, 82, 139, 0.8),
          textColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0
            ),
            child: Text(opt, 
            style: TextStyle(fontSize: 25.0),
            ),
          ),
          onPressed: (){},
        ),
      )
    );
  }

}