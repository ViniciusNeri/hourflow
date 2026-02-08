class DayModel {
  final DateTime data;
  final String diaSemana;
  final String tipo;
  final double sugestaoHoras;

  DayModel({
    required this.data,
    required this.diaSemana,
    required this.tipo,
    required this.sugestaoHoras,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      data: DateTime.parse(json['data']),
      diaSemana: json['diaSemana'] ?? '',
      tipo: json['tipo'] ?? '',
      sugestaoHoras: (json['sugestaoHoras'] as num).toDouble(),
    );
  }
}