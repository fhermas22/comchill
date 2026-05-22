import 'package:flutter/material.dart';
import 'package:comchill_app/utils/colors.dart';

class ArchivedChat {
  final String title;
  final String lastMessage;
  final String time;
  final String initials;

  const ArchivedChat({
    required this.title,
    required this.lastMessage,
    required this.time,
    required this.initials,
  });
}

class ArchivedChatsScreen extends StatefulWidget {
  const ArchivedChatsScreen({super.key});

  @override
  State<ArchivedChatsScreen> createState() => _ArchivedChatsScreenState();
}

class _ArchivedChatsScreenState extends State<ArchivedChatsScreen> {


  // Liste des discussions archivées
  final List<ArchivedChat> _archivedChats = [
    const ArchivedChat(
      title: "Projet Semestre 1",
      lastMessage: "Le rapport final a été soumis avec succès.",
      time: "12 Janv",
      initials: "P1",
    ),
    const ArchivedChat(
      title: "Ancien Binôme Physique",
      lastMessage: "Merci pour ton aide sur les exercices !",
      time: "25 Déc",
      initials: "BP",
    ),
    const ArchivedChat(
      title: "Groupe Intégration",
      lastMessage: "Bienvenue à tous dans l'établissement !",
      time: "05 Sept",
      initials: "GI",
    ),
  ];

  // Fonction pour simuler la désarchivage d'une discussion
  void _unarchiveChat(int index, String title) {
    setState(() {
      _archivedChats.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$title" a été retiré des archives'),
        action: SnackBarAction(
          label: 'Annuler',
          textColor: primaryColor,
          onPressed: () {
            // Logique pour ré-archiver si nécessaire
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: secondaryColor, size: 22),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Discussions Archivées',
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

            Expanded(
              child: _archivedChats.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.only(top: 8.0),
                      itemCount: _archivedChats.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        indent: 82,
                        color: surfaceColor,
                      ),
                      itemBuilder: (context, index) {
                        final chat = _archivedChats[index];
                        return Dismissible(
                          key: Key(chat.title),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: primaryColor,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.unarchive, color: thirdColor),
                          ),
                          onDismissed: (direction) => _unarchiveChat(index, chat.title),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: backgroundColor.withAlpha(10),
                              child: Text(
                                chat.initials,
                                style: const TextStyle(
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            title: Text(
                              chat.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                chat.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: secondaryTextColor, fontSize: 14),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  chat.time,
                                  style: const TextStyle(color: secondaryTextColor, fontSize: 13),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Vue affichée lorsque la liste des archives est vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.archive_outlined,
            size: 80,
            color: secondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune discussion archivée',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Les discussions que vous archivez s\'afficheront ici pour désencombrer votre écran principal.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
