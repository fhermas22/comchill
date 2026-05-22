import 'package:flutter/material.dart';
import 'package:comchill_app/utils/colors.dart';
class DeveloperMember {
  final String name;
  final String role;
  final String initials;

  const DeveloperMember({
    required this.name,
    required this.role,
    required this.initials,
  });
}

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  // Liste fictive des membres de l'équipe (À personnaliser avec vos vrais noms)
  final List<DeveloperMember> _teamMembers = const [
    DeveloperMember(name: "Chef de Projet", role: "Project Manager & UI/UX", initials: "CP"),
    DeveloperMember(name: "Développeur Lead", role: "Lead Flutter Developer", initials: "DL"),
    DeveloperMember(name: "Développeur Backend", role: "API & Base de données", initials: "DB"),
    DeveloperMember(name: "Développer Mobile", role: "Flutter Frontend UI", initials: "DM"),
    
  ];

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
                    icon: const Icon(Icons.arrow_back_ios_new, color: darkSurfaceColor, size: 22),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "L'Équipe de Dév",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkSurfaceColor,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: surfaceColor),

            // 2. CONTENU DE LA PAGE
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bannière du Groupe
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: primaryColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groupe 2 - IMeN',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Institut des Métiers de l\'Excellence Numérique',
                            style: TextStyle(fontSize: 14, color: darkSurfaceColor, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Une équipe passionnée dédiée à la création d\'une expérience académique connectée et fluide.',
                            style: TextStyle(fontSize: 14, color: darkSurfaceColor, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 28),
                    
                    const Text(
                      'LES MEMBRES',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: secondaryTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Grille adaptative des membres
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _teamMembers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 colonnes
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85, // Ratio hauteur/largeur de chaque carte
                      ),
                      itemBuilder: (context, index) {
                        final member = _teamMembers[index];
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: surfaceColor),
                            boxShadow: [
                              BoxShadow(
                                color: darkSurfaceColor.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar en cercle avec initiales
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: secondaryTextColor.withValues(alpha: 0.4),
                                child: Text(
                                  member.initials,
                                  style: const TextStyle(
                                    color: secondaryTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              // Nom du membre
                              Text(
                                member.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Rôle
                              Text(
                                member.role,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: secondaryTextColor,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
}
