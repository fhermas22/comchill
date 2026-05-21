import 'package:flutter/material.dart';

class ContactItem {
  final String name;
  final String subtitle;
  final String initials;
  final bool? isOnline; 
  final bool isGroup; 

  const ContactItem({
    required this.name,
    required this.subtitle,
    required this.initials,
    this.isOnline,
    this.isGroup = false,
  });
}

class ContactsTabScreen extends StatelessWidget {
  const ContactsTabScreen({super.key});

  final Color primaryOrange = const Color(0xFFE57C38);
  final Color greyBg = const Color(0xFFF3F4F6);

  final List<ContactItem> _suggestions = const [
    ContactItem(name: "Groupe Maths", subtitle: "12 membres", initials: "Gr", isGroup: true),
    ContactItem(name: "Équipe Projet Info", subtitle: "8 membres", initials: "Éq", isGroup: true),
  ];

  final List<ContactItem> _allContacts = const [
    ContactItem(name: "Alice Johnson", subtitle: "@alice.j", initials: "Al", isOnline: true),
    ContactItem(name: "Bob Smith", subtitle: "@bobsmith", initials: "Bo", isOnline: false),
    ContactItem(name: "Carol Williams", subtitle: "@carolw", initials: "Ca", isOnline: true),
    ContactItem(name: "David Brown", subtitle: "@dbrown", initials: "Da", isOnline: false), // jaune/occupé dans l'image
    ContactItem(name: "Emma Davis", subtitle: "@emmad", initials: "Em", isOnline: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80.0), // Espace pour le FAB
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. EN-TÊTE PERSONNALISÉ (Pas d'AppBar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Contacts',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. BARRE DE RECHERCHE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher des contacts...',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
                        filled: true,
                        fillColor: greyBg,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. SECTION SUGGESTIONS
                  _buildSectionTitle('SUGGESTIONS'),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _suggestions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 76, color: Color(0xFFF0F0F0)),
                    itemBuilder: (context, index) {
                      final item = _suggestions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFFC8CED6),
                          child: Text(
                            item.initials,
                            style: const TextStyle(color: Color(0xFF5A6575), fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(item.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryOrange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ajouter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),
                  Container(height: 8, color: const Color(0xFFF4F6FA)), // Séparateur de section bleuté
                  const SizedBox(height: 16),

                  // 4. SECTION TOUS LES CONTACTS
                  _buildSectionTitle('TOUS LES CONTACTS (${_allContacts.length + 1})'), // Ajusté selon l'image (6)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allContacts.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 76, color: Color(0xFFF0F0F0)),
                    itemBuilder: (context, index) {
                      final item = _allContacts[index];
                      return ListTile(
                        onTap: () {},
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFC8CED6),
                              child: Text(
                                item.initials,
                                style: const TextStyle(color: Color(0xFF5A6575), fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  // Vert si connecté, orange/jaune pour David Brown index 3
                                  color: index == 3 
                                      ? const Color(0xFFFFB300) 
                                      : (item.isOnline! ? Colors.green : Colors.transparent),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(item.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 5. BOUTON FLOTTANT D'AJOUT (FAB)
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: primaryOrange,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 26),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 12.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
