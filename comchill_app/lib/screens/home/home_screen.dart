import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:comchill_app/utils/colors.dart';

// Modèle de données pour une discussion
class ChatItem {
  final String title;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String initials;

  const ChatItem({
    required this.title,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.initials,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0; // Index pour le BottomNavigationBar

  // Couleur orange thématique ComChill
  

  // Données de la liste de l'image
  final List<ChatItem> _chats = [
    const ChatItem(
      title: "Groupe d'Étude",
      lastMessage: "Rendez-vous à 15h aujourd'hui ?",
      time: "2m",
      unreadCount: 3,
      isOnline: true,
      initials: "GE",
    ),
    const ChatItem(
      title: "Cours de Maths",
      lastMessage: "Devoirs à rendre demain",
      time: "15m",
      unreadCount: 0,
      isOnline: false,
      initials: "CM",
    ),
    const ChatItem(
      title: "Équipe Projet",
      lastMessage: "Excellent travail à tous !",
      time: "1h",
      unreadCount: 5,
      isOnline: true,
      initials: "EP",
    ),
    const ChatItem(
      title: "Binôme Info",
      lastMessage: "Tu peux m'aider avec le devoir ?",
      time: "2h",
      unreadCount: 0,
      isOnline: true,
      initials: "BI",
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 4 onglets : Discussions, Communautés, Assistant IA, Appels
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. EN-TÊTE PERSONNALISÉ (Remplace l'AppBar)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 8.0),
              child: Row(
                children: [
                  // Logo ComChill Orange
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: thirdColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  // Titre principal
                  const Text(
                    'ComChill',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: secondaryTextColor,
                    ),
                  ),
                  const Spacer(),
                  // Icônes d'actions à droite
                  IconButton(
                    icon: const Icon(Icons.groups_outlined, color: secondaryTextColor, size: 26),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: secondaryTextColor, size: 26),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 2. BARRE DE RECHERCHE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher des messages...',
                  hintStyle: const TextStyle(color: secondaryTextColor, fontSize: 15),
                  prefixIcon: const Icon(Icons.search, color: secondaryTextColor),
                  filled: true,
                  fillColor: const Color(0xFF6B7280).withValues(alpha: 0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 3. BARRE D'ONGLETS (TabBar)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: primaryColor,
              unselectedLabelColor: primaryTextColor,
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
              tabs: const [
                Tab(text: "Discussions"),
                Tab(text: "Communautés"),
                Tab(text: "Assistant IA"),
                Tab(text: "Appels"),
              ],
            ),

            // 4. CONTENU DES ONGLETS (Ici focus sur l'onglet Discussions)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Vue 1 : Liste des discussions
                  ListView.separated(
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: _chats.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 76, color: Color(0xFFF0F0F0)),
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return ListTile(
                        onTap: () {
                          // Action au clic sur une discussion
                        },
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: const Color(0xFF6B7280).withValues(alpha: 0.1),
                              child: Text(
                                chat.initials,
                                style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (chat.isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: thirdColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              )

                          ],
                        ),
                        title: Text(
                          chat.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: secondaryTextColor, fontSize: 14),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              chat.time,
                              style: const TextStyle(color: secondaryTextColor, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            if (chat.unreadCount > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${chat.unreadCount}',
                                  style: const TextStyle(color: thirdColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  ),
                  // Vues suivantes vides pour l'exemple
                  const Center(child: Text("Espace Communautés")),
                  const Center(child: Text("Assistant IA")),
                  const Center(child: Text("Historique des Appels")),
                ],
              ),
            ),
          ],
        ),
      ),

      // 5. BOUTON FLOTTANT D'ACTION (+)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: thirdColor, size: 28),
      ),

      // 6. BOTTOM NAVIGATION BAR (Trois boutons requis)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Discussion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            activeIcon: Icon(Icons.contacts),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}
