
class AsistenciaOfflineM {

  int id;
  int idCurso; 
  int idAlmnCurso;
  String alumno; 
  int horas; 
  String fecha; 

  AsistenciaOfflineM({
    this.id,
    this.idCurso,
    this.idAlmnCurso,
    this.alumno,
    this.horas,
    this.fecha
  }); 

  AsistenciaOfflineM.fromJSONMap(Map<String, dynamic> json){
    id = json['id'];
    idCurso = json['id_curso'];
    idAlmnCurso = json['id_almn_curso'];
    alumno = json['alumno'];
    horas = json['horas'];
    fecha = json['fecha'];
  }

  factory AsistenciaOfflineM.getFromJson(Map<String, dynamic> json) => new AsistenciaOfflineM(
    id: json['id'],
    idCurso: json['id_curso'],
    idAlmnCurso: json['id_almn_curso'],
    alumno: json['alumno'],
    horas: json['horas'],
    fecha: json['fecha']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_curso": idCurso,
    "id_almn_curso": idAlmnCurso,
    "alumno": alumno,
    "horas": horas,
    "fecha": fecha
  };
    
}