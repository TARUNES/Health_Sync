import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';
import 'package:health_sync_client/features/medication/data/service/pillScheduleService.dart';

class MedicationRepository {
  final MedicationService _service = MedicationService();

  Future<List<PillScheduleModel>> getMedications() async {
    return await _service.fetchMedications();
  }
}
