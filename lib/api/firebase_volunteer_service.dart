/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'abstract_volunteer_service.dart';

class FirebaseVolunteerService implements AbstractVolunteerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
 
 //mock up for compiler
  get volunteerOpportunityModel => null;

  @override
  Stream<List<VolunteerOpportunity>> streamLocalOpportunities(
    String municipalityL1,
  ) {
    // Direct Firestore stream for snappy, offline-ready interface
    return _firestore
        .collection('opportunities')
        .where('location.l1Municipality', isEqualTo: municipalityL1)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => volunteerOpportunityModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<void> checkInToOpportunity({
    required String opportunityId,
    required String memberId,
  }) async {
    // Sensitive write action insulated via Cloud Function API
    final callable = _functions.httpsCallable('processVolunteerCheckIn');
    await callable.call({'opportunityId': opportunityId, 'memberId': memberId});
  }
}

class VolunteerOpportunity {
  //mock up for the compiler at this stage
}
 */
