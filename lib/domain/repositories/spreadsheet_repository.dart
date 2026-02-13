import '../../data/models/day_model.dart';

abstract class SpreadSheetRepository {
  Future<List<DayModel>> getPrepareDays(String mes, int ano);
  Future<bool> generateCustomReport(Map<String, dynamic> data);
  Future<bool> sendSimpleInput(double horas, String mesVigente);
}