import 'package:flutter/material.dart';

class DiscussionTabScreen extends StatefulWidget {
  const DiscussionTabScreen({super.key});

  @override
  State<DiscussionTabScreen> createState() => _DiscussionTabScreenState();
}

class _DiscussionTabScreenState extends State<DiscussionTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryOrange = const Color(0xFFE57C38);

  final List<Map<String, dynamic>> _chats = [
    {
      "title": "Groupe d'Étude",
      "message": "Rendez-vous à 15h aujourd'hui ?",
      "time": "2m",
      "unread": 3,
      "online": true,
      "initials": "GE"
    },
    {
      "title": "Cours de Maths",
      "message": "Devoirs à rendre demain",
      "time": "15m",
      "unread": 0,
      "online": false,
      "initials": "CM"
    },
    {
      "title": "Équipe Projet",
      "message": "Excellent travail à tous !",
      "time": "1h",
      "unread": 5,
      "online": true,
      "initials": "EP"
    },
    {
      "title": "Binôme Info",
      "message": "Tu peux m'aider avec le devoir ?",
      "time": "2h",
      "unread": 0,
      "online": true,
      "initials": "BI"
    },
  ];

  @override
  void initState() {
    super.initState();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. EN-TÊTE SANS APPBAR
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ComChill',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.groups_outlined, color: Colors.black87, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.black87, size: 28),
                    onPressed: () {
                      
                    },
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
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 24),
                  filled: true,
                  fillColor: const Color(0xFFF3F4F6),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 3. SOUS-ONGLETS (Discussions, Communautés, Assistant IA, Appels)
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: primaryOrange,
              unselectedLabelColor: Colors.black54,
              indicatorColor: primaryOrange,
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

            // 4. LISTE DES DISCUSSIONS SÉPARÉES
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.separated(
                    padding: const EdgeInsets.only(top: 8.0),
                    itemCount: _chats.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, indent: 82, color: Color(0xFFF0F0F0)),
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        onTap: () {},
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFFC8CED6),
                              child: Text(
                                chat["initials"],
                                style: const TextStyle(
                                  color: Color(0xFF5A6575), 
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: chat["online"] ? Colors.green : const Color(0xFFC8CED6),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          chat["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            chat["message"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              chat["time"],
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            if (chat["unread"] > 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${chat["unread"]}',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              )
                            else
                              const SizedBox(height: 22),
                          ],
                        ),
                      );
                    },
                  ),
                  const Center(child: Text("Espace Communautés")),
                  const Center(child: Text("Assistant IA")),
                  const Center(child: Text("Historique des Appels")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
