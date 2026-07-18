// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import '../cloud_functions/un_locode_cron.dart';

void main() async {
  // 1. Tell the Dart framework to route all traffic to the active emulator port
  // Note: Ensure your firebase emulators:start command is running first!
  FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);

  print('🧪 Hooked into local Firestore Emulator (demo-vicinumclub)...');

  // 2. Instantiate and run the pipeline loop
  final engine = UnLocodeDriftEngine(firestore: FirebaseFirestore.instance);
  await engine.checkRegistryDeviations();
}
