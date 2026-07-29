import '../models/life_models.dart';

part 'life_types_employee.dart';
part 'life_types_already_retired.dart';
part 'life_types_freelancer.dart';
part 'life_types_business.dart';
part 'life_types_rural_profile.dart';

RetirementScenario _scenario({
  required String id,
  required String title,
  required String situation,
  required String firstChanges,
  required List<String> easyToMissRisks,
  required String preparedVsUnprepared,
  required List<String> responseOrder,
  required String recoveryPath,
}) {
  return RetirementScenario(
    id: id,
    title: title,
    situation: situation,
    firstChanges: firstChanges,
    easyToMissRisks: easyToMissRisks,
    preparedVsUnprepared: preparedVsUnprepared,
    responseOrder: responseOrder,
    recoveryPath: recoveryPath,
  );
}

class LifeTypesData {
  LifeTypesData._();

  static final all = <LifeTypeProfile>[
    _employeeRetiree,
    _alreadyRetired,
    _freelancer,
    _businessOwner,
    _ruralLife,
  ];
}
