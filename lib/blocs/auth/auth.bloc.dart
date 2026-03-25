import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:src/blocs/validators.dart';
import 'package:src/models/datamodel.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc extends Object with Validators {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference person = FirebaseFirestore.instance.collection('person');
  CollectionReference appointments =
      FirebaseFirestore.instance.collection('appointments');
  CollectionReference vaccine =
      FirebaseFirestore.instance.collection('vaccine');

  isSignedIn() {
    return auth.currentUser != null;
  }

  getUID() {
    return auth.currentUser!.uid;
  }

  signInWithEmail(LoginDataModel formData) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: formData.email!, password: formData.password!);
      return "";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future signUpWithEmail(LoginDataModel model, {String role = 'patient'}) async {
    try {
      final res = await auth.createUserWithEmailAndPassword(email: model.email!, password: model.password!);
      if (res.user != null) {
        // Create the user profile in Firestore immediately with the selected role
        await users.doc(res.user!.uid).set({
          'email': model.email,
          'role': role,
          'status': 'verified',
          'author': res.user!.uid,
        });
      }
      return "";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  logout() {
    try {
      return FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<DocumentSnapshot?> getData() async {
    if (auth.currentUser != null) {
      final uidSnapshot = await users.doc(auth.currentUser!.uid).get();
      if (uidSnapshot.exists) return uidSnapshot;
      
      // Fallback: check if doc exists with email ID (admin-created)
      if (auth.currentUser!.email != null) {
        final emailSnapshot = await users.doc(auth.currentUser!.email).get();
        if (emailSnapshot.exists) {
           // Auto-link: Copy data to UID doc
           await users.doc(auth.currentUser!.uid).set(emailSnapshot.data() as Map<String, dynamic>);
           // Update author to UID for future consistency
           await users.doc(auth.currentUser!.uid).update({'author': auth.currentUser!.uid, 'status': 'verified'});
           return users.doc(auth.currentUser!.uid).get();
        }
      }
      return uidSnapshot;
    }
    return null;
  }

  Future getUserData(String filter) async {
    if (auth.currentUser != null) {
      if (filter == "person") return person.doc(auth.currentUser!.uid).get();
      if (filter == "appointments")
        return appointments.doc(auth.currentUser!.uid).get();
    }
    return false;
  }

  Future getDocData(String filter, String docId) async {
    if (auth.currentUser != null) {
      if (filter == "users") return users.doc(docId).get();
    }
    return false;
  }

  Future getPatientData(String id) async {
    if (auth.currentUser != null) {
      return person.doc(id).get();
    }
    return false;
  }

  Future getVaccineData(String id) async {
    if (auth.currentUser != null) {
      return vaccine.doc(id).get();
    }
    return false;
  }

  getAppointments() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('appointmentDate', isGreaterThan: DateTime.now())
        .where('appointmentDate',
            isLessThan: DateTime.now().add(new Duration(days: 2)))
        .snapshots();
  }

  Future setUserData(String filter, formData) async {
    if (filter == "person")
      return person.doc(auth.currentUser!.uid).set({
        'name': formData.name,
        'idType': formData.idType,
        'id': formData.id,
        'sir': formData.sir,
        'occupation': formData.occupation,
        'warrior': formData.warrior,
        'dob': formData.name,
        'gender': formData.gender,
        'medicalHistory': formData.medicalHistory,
        'race': formData.race,
        'address': formData.address,
        'zipcode': formData.zipcode,
        'citiesTravelled': formData.citiesTravelled,
        'siblings': formData.siblings,
        'familyMembers': formData.familyMembers,
        'socialActiveness': formData.socialActiveness,
        'declineParticipation': formData.declineParticipation,
        'author': auth.currentUser!.uid // uid
      });
    if (filter == "appointments")
      return appointments.doc(auth.currentUser!.uid).set({
        'appointmentDate': formData.appointmentDate,
        'name': formData.name,
        'phone': formData.phone,
        'comments': formData.comments,
        'author': auth.currentUser!.uid, // uid
        'status': formData.status // uid
      });
    if (filter == "vaccine")
      return vaccine.doc(formData.author).set({
        'appointmentDate': formData.appointmentDate,
        'newAppointmentDate': formData.newAppointmentDate,
        'name': formData.name,
        'idType': formData.idType,
        'id': formData.id,
        'sir': formData.sir,
        'occupation': formData.occupation,
        'warrior': formData.warrior,
        'dob': formData.name,
        'gender': formData.gender,
        'medicalHistory': formData.medicalHistory,
        'race': formData.race,
        'address': formData.address,
        'zipcode': formData.zipcode,
        'citiesTravelled': formData.citiesTravelled,
        'siblings': formData.siblings,
        'familyMembers': formData.familyMembers,
        'socialActiveness': formData.socialActiveness,
        'declineParticipation': formData.declineParticipation,
        'author': formData.author // uid
      });
  }

  Future<void> setVaccineData(VaccineDataModel formData) async {
    await person.doc(formData.patientId).collection("Vaccine").add({
      'appointmentDate': formData.appointmentDate,
      'newAppointmentDate': formData.newAppointmentDate,
      'author': formData.patientId
    });
  }

  Future<void> setOPDData(OPDDataModel formData) async {
    await person.doc(formData.patientId).collection("OPD").add({
      'opdDate': Timestamp.now(),
      'symptoms': formData.symptoms,
      'diagnosis': formData.diagnosis,
      'treatment': formData.treatment,
      'rx': formData.rx,
      'lab': formData.lab,
      'comments': formData.comments,
      'author': formData.patientId
    });
  }

  Future<void> setMessagesData(MessagesDataModel formData) async {
    await person.doc(formData.patientId).collection("Messages").add({
      'messagesDate': Timestamp.now(),
      'from': formData.from,
      'status': formData.status,
      'message': formData.message,
      'readReceipt': formData.readReceipt,
      'author': formData.patientId
    });
  }

  Future<void> setRxData(RxDataModel formData) async {
    await person.doc(formData.patientId).collection("Rx").add({
      'rxDate': Timestamp.now(),
      'from': formData.from,
      'status': formData.status,
      'rx': formData.rx,
      'results': formData.results,
      'descr': formData.descr,
      'comments': formData.comments,
      'author': formData.patientId
    });
  }

  Future<void> setLABData(LabDataModel formData) async {
    await person.doc(formData.patientId).collection("Lab").add({
      'labDate': Timestamp.now(),
      'from': formData.from,
      'status': formData.status,
      'lab': formData.lab,
      'results': formData.results,
      'descr': formData.descr,
      'comments': formData.comments,
      'author': formData.patientId
    });
  }

  Future<void> setData(SettingsDataModel formData) async {
    return users.doc(auth.currentUser!.uid).set({
      'name': formData.name, // John Doe
      'phone': formData.phone, // Phone
      'email': formData.email,
      'role': formData.role,
      'author': auth.currentUser!.uid // uid
    });
  }

  Future<void> updData(SettingsDataModel formData) async {
    return users.doc(formData.author).set({
      'name': formData.name, // John Doe
      'phone': formData.phone, // Phone
      'email': formData.email,
      'role': formData.role,
      'author': formData.author // uid
    });
  }

  // API: dispose/cancel observables/subscriptions
  dispose() {}
}

final authBloc = AuthBloc();
