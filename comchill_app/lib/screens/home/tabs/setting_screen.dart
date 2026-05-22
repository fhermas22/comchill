import 'package:comchill_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:comchill_app/screens/home/tabs/about_screen.dart';
import 'package:comchill_app/screens/home/tabs/team_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: primaryTextColor, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Paramètres',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: surfaceColor),

              // 2. BLOC PROFIL UTILISATEUR
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: surfaceColor,
                      child: Text(
                        'JD',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@johndoe',
                          style: TextStyle(
                            fontSize: 15,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. SECTION COMPTE
              _buildSectionHeader('COMPTE'),
              _buildSettingsTile(
                icon: Icons.person,
                iconColor: bestColor,
                title: 'Modifier le Profil',
                onTap: () {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfilScreen()),
                },
              ),

              // 4. SECTION À PROPOS
              _buildSectionHeader('À PROPOS'),
              _buildSettingsTile(
                icon: Icons.info_outline,
                iconColor: darkSurfaceColor.withValues(alpha: 0.2),
                title: 'À Propos de ComChill',
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AboutScreen()));
                },
              ),
              const Divider(height: 1, indent: 56, color: surfaceColor),
              _buildSettingsTile(
                icon: Icons.groups_outlined,
                iconColor: primaryColor,
                title: 'Équipe',
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  const TeamScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper pour les titres de section grisé
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: secondaryTextColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: secondaryTextColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // Helper pour les lignes d'options épurées
  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkSurfaceColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: darkSurfaceColor,
        size: 16,
      ),
    );
  }
}
