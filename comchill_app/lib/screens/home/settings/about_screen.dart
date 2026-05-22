import 'package:comchill_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. EN-TÊTE PERSONNALISÉ (Sans AppBar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'À Propos de ComChill',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            // CONTENU DÉFILANT COMPLET (Regroupe les 3 maquettes)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // SECTION MARQUE (Maquette 1)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: thirdColor,
                              size: 55,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'ComChill',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Version 1.0.0',
                            style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Restez Connecté. Étudiez Ensemble.\nDétendez-vous Intelligemment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    Container(height: 8, color: backgroundColor),

                    // SECTION À PROPOS DU PROJET (Maquette 1 & 2)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'À Propos du Projet',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'ComChill est une application de messagerie académique moderne conçue pour les étudiants, les groupes d\'étude et les communautés académiques. Notre mission est d\'aider les étudiants à communiquer efficacement, à collaborer de manière fluide et à gérer leur vie académique avec des fonctionnalités de productivité intelligentes.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // LISTE DES FONCTIONNALITÉS (Maquette 2)
                          _buildFeatureTile(
                            icon: Icons.chat_bubble_outline,
                            title: 'Communication en Temps Réel',
                            subtitle: 'Restez connecté avec vos camarades et groupes d\'étude',
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureTile(
                            icon: Icons.smart_toy_outlined,
                            title: 'Assistant Propulsé par l\'IA',
                            subtitle: 'Obtenez de l\'aide avec vos notes, emplois du temps et matériel d\'étude',
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureTile(
                            icon: Icons.groups_outlined,
                            title: 'Communautés d\'Étude',
                            subtitle: 'Rejoignez des groupes académiques et collaborez sur des projets',
                          ),
                        ],
                      ),
                    ),

                    Container(height: 8, color: backgroundColor),

                    // SECTION DÉVELOPPEURS (Maquette 3)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Développé Par',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Groupe 2 - IMeN',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Institut des Métiers de l\'Excellence Numérique',
                                  style: TextStyle(fontSize: 14, color: thirdColor, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SECTION LIENS LÉGAUX (Maquette 3)
                    _buildLegalTile('Politique de Confidentialité'),
                    const Divider(height: 1, indent: 20, color: surfaceColor),
                    _buildLegalTile('Conditions d\'Utilisation'),
                    const Divider(height: 1, indent: 20, color: surfaceColor),
                    _buildLegalTile('Licences'),

                    // FOOTER COPYRIGHT (Maquette 3)
                    Container(
                      width: double.infinity,
                      color: backgroundColor.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Text(
                            '© 2026 ComChill. Tous droits réservés.',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Fait avec ', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                              const Icon(Icons.favorite, color: Colors.red, size: 14),
                              Text(' par Groupe 2 IMeN', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Composant pour lister les fonctionnalités clés
  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black87, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Composant pour les lignes de documents juridiques
  Widget _buildLegalTile(String title) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black26, size: 14),
    );
  }
}


