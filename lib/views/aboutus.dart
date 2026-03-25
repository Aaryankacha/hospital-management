import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:src/shared/custom_style.dart';

class AboutUs extends StatelessWidget {
  static const routeName = '/aboutus';

  const AboutUs({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("About HMS Pro"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            const SizedBox(height: 32),
            _buildSectionHeader("Core Capabilities"),
            _buildFeatureCard(
              Icons.healing_rounded,
              "Unified Health Records",
              "Complete management of Patient, OPD, IPD, Rx, and Lab results in a single, secure environment.",
              Colors.blue,
            ),
            _buildFeatureCard(
              Icons.vaccines_rounded,
              "Vaccine Distribution",
              "Strategy and record-keeping for large-scale vaccination programs with secure cloud storage.",
              Colors.teal,
            ),
            _buildFeatureCard(
              Icons.security_rounded,
              "Role-Based Security",
              "Granular access control ensuring patients, doctors, and staff only see the data they need.",
              Colors.blueGrey,
            ),
            _buildFeatureCard(
              Icons.analytics_rounded,
              "AI-Driven Insights",
              "Predictive analytics and medical research integration for advanced clinical strategy.",
              Colors.purple,
            ),
            const SizedBox(height: 48),
            _buildContactSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cPrimaryBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.local_hospital_rounded, color: Colors.white, size: 64),
          const SizedBox(height: 20),
          const Text(
            "HMS Pro Community",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Version 2.0.0 - Open Source Healthcare",
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 24),
          const Text(
            "A professional, paperless Hospital Management System built for the future of community healthcare.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(title, style: cHeaderText.copyWith(fontSize: 18, color: cPrimaryBlue)),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600], height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Center(
      child: Column(
        children: [
          Text("Connect with the Developer", style: cHeaderText.copyWith(fontSize: 16)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.code_rounded, "GitHub", "https://github.com/AmitXShukla"),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.play_circle_fill_rounded, "YouTube", "https://www.youtube.com/amitshukla_ai"),
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.language_rounded, "Web", "https://amitxshukla.github.io"),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "For enterprise inquiries: info@elishconsulting.com",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String label, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: cPrimaryBlue),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
