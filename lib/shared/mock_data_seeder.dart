import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockDataSeeder {
  static Future<void> seed() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    // We can't seed if no user is truly logged in, as Firestore rules usually block anonymous writes.
    if (currentUser == null) {
      print('Mock Data Seeder Exception: You must be logged in to seed data.');
      return;
    }

    String currentUserId = currentUser.uid;
    
    try {
      // 1. Make the currently logged in user an "Admin" so they can access the dashboard
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).set({
        'name': 'Admin User',
        'email': currentUser.email ?? 'admin@demo.com',
        'role': 'admin',
        'author': currentUserId
      });
      
      // 2. Create a dummy patient user ID for data association
      String patientId = 'dummy_patient_123';
      
      // 3. Create Patient Personal Data payload
      await FirebaseFirestore.instance.collection('person').doc(patientId).set({
        'name': 'John Doe',
        'idType': 'SSN',
        'id': '123-456',
        'occupation': 'Teacher',
        'medicalHistory': 'No prior illnesses, healthy',
        'address': '123 Main St, Springfield',
        'author': currentUserId
      });

      // 4. Create an Appointment
      await FirebaseFirestore.instance.collection('appointments').add({
        'name': 'John Doe',
        'phone': '555-0199',
        'comments': 'Checkup for cough and fever',
        'appointmentDate': DateTime.now().add(const Duration(days: 1)).toString(),
        'status': 'New',
        'author': patientId
      });

      // 5. Seed Vaccine (Sub-collection)
      await FirebaseFirestore.instance.collection('person').doc(patientId).collection('Vaccine').add({
        'appointmentDate': '2026-03-21',
        'newAppointmentDate': '2026-04-21',
        'vaccineName': 'COVID-19 Booster',
        'author': patientId,
      });

      // 6. Seed OPD (Sub-collection)
      await FirebaseFirestore.instance.collection('person').doc(patientId).collection('OPD').add({
        'opdDate': Timestamp.now(),
        'symptoms': 'Mild headache, slight fever',
        'diagnosis': 'Seasonal Flu',
        'treatment': 'Rest and hydration',
        'rx': 'Paracetamol 500mg',
        'lab': 'Blood Test',
        'author': patientId,
      });

      // 7. Seed Rx (Sub-collection)
      await FirebaseFirestore.instance.collection('person').doc(patientId).collection('Rx').add({
        'rxDate': Timestamp.now(),
        'rx': 'Paracetamol',
        'results': '500mg TDS for 3 days',
        'from': 'Dr. Smith',
        'status': 'Prescribed',
        'author': patientId,
      });

      // 8. Seed Lab (Sub-collection)
      await FirebaseFirestore.instance.collection('person').doc(patientId).collection('Lab').add({
        'labDate': Timestamp.now(),
        'lab': 'Blood Test',
        'results': 'WBC count normal, no infection detected',
        'status': 'Verified',
        'author': patientId,
      });

      // 9. Seed Messages (Sub-collection)
      await FirebaseFirestore.instance.collection('person').doc(patientId).collection('Messages').add({
        'messagesDate': Timestamp.now(),
        'message': 'Welcome to HMS Pro! Your first clinical records have been synchronized.',
        'from': 'Healthcare Admin',
        'status': 'Normal',
        'author': patientId,
      });

      // 10. SCM - Vendors
      await FirebaseFirestore.instance.collection('scm_vendors').doc('VND001').set({
        'name': 'ABC Medical Supplies',
        'type': 'Manufacturer',
        'contact': 'contact@abcmed.com',
        'author': currentUserId
      });

      // 11. SCM - Warehouses
      await FirebaseFirestore.instance.collection('scm_warehouses').doc('WH001').set({
        'name': 'Main Warehouse',
        'type': 'Storage',
        'address': 'Industrial Zone 1',
        'author': currentUserId
      });

      // 12. SCM - Centers
      await FirebaseFirestore.instance.collection('scm_centers').doc('CTR001').set({
        'name': 'East City Distribution Center',
        'type': 'Distribution',
        'author': currentUserId
      });

      // 13. SCM - Items
      await FirebaseFirestore.instance.collection('scm_items').doc('ITM001').set({
        'name': 'Paracetamol 500mg',
        'category': 'Medicine',
        'qty': 5000,
        'author': currentUserId
      });

      // 14. SCM - Purchase Orders
      await FirebaseFirestore.instance.collection('scm_purchase_orders').add({
        'poId': 'PO-2026-001',
        'vendorId': 'VND001',
        'orderDate': Timestamp.now(),
        'status': 'Ordered',
        'author': currentUserId
      });

      // 15. SCM - Material Service Requests (MSR)
      await FirebaseFirestore.instance.collection('scm_msrs').add({
        'msrId': 'MSR-2026-001',
        'fromWh': 'WH001',
        'toCenter': 'CTR001',
        'requestDate': Timestamp.now(),
        'status': 'Pending',
        'author': currentUserId
      });

      print('Mock data seeding completed!');
    } catch (e) {
      print("Mock Data Seeder Exception: $e");
    }
  }
}
