import 'package:flutter/material.dart';

class BotMessage {
  final String text;
  final bool isMe;
  final String time;

  const BotMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class IaTabScreen extends StatefulWidget {
  const IaTabScreen({super.key});

  @override
  State<IaTabScreen> createState() => _IaTabScreenState();
}

class _IaTabScreenState extends State<IaTabScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final Color primaryOrange = const Color(0xFFE57C38);
  final Color botBubbleColor = const Color(0xFFE9EBEF);

  final List<BotMessage> _messages = [
    const BotMessage(
      text: "Bonjour ! Je suis votre Assistant IA ComChill. Comment puis-je vous aider dans vos révisions aujourd'hui ?",
      isMe: false,
      time: "14:00",
    ),
  ];

  final List<String> _suggestions = const [
    "Résumer mes cours",
    "Créer un quiz de révision",
    "Expliquer un concept difficile",
  ];

  void _sendMessage([String? customText]) {
    final text = customText ?? _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    setState(() {
      _messages.add(BotMessage(text: text, isMe: true, time: timeString));
      if (customText == null) _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulation de la réponse automatique du Bot après 1.5 seconde
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          BotMessage(
            text: "C'est une excellente question ! Je prépare une réponse détaillée pour vous aider.",
            isMe: false,
            time: timeString,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. EN-TÊTE DU BOT (Sans AppBar)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: primaryOrange.withValues(alpha: 0.1),
                    child: Icon(Icons.smart_toy, color: primaryOrange, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assistant ComChill IA",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "En ligne • Répond instantanément",
                        style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. ZONE DE MESSAGES
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Indicateur d'écriture de l'IA
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "L'IA est en train d'écrire...",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500, ),
                  ),
                ),
              ),

            // 3. SUGGESTIONS RAPIDES (S'affiche uniquement s'il y a peu de messages)
            if (_messages.length == 1 && !_isTyping)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text(_suggestions[index]),
                        labelStyle: TextStyle(color: primaryOrange, fontWeight: FontWeight.w600, fontSize: 13),
                        backgroundColor: primaryOrange.withValues(alpha: 0.08),
                        side: BorderSide(color: primaryOrange.withValues(alpha: 0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: () => _sendMessage(_suggestions[index]),
                      ),
                    );
                  },
                ),
              ),

            // 4. BARRE DE SAISIE DU MESSAGE
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: "Posez votre question à l'IA...",
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic_none, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: primaryOrange,
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BotMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
            decoration: BoxDecoration(
              color: message.isMe ? primaryOrange : botBubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                bottomRight: Radius.circular(message.isMe ? 4 : 18),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isMe ? Colors.white : const Color(0xFF2C3238),
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 6.0),
            child: Text(
              message.time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
