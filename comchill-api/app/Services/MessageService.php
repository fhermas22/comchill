<?php

namespace App\Services;

use App\Models\Message;
use App\Models\Conversation;
use Illuminate\Auth\Access\AuthorizationException;

/**
 * @author Hermas Francisco
 */
class MessageService
{
    /**
     * Send a text message within a specific conversation.
     *
     * @throws AuthorizationException
     */
    public function sendTextMessage(int $conversationId, int $senderId, string $content): Message
    {
        $conversation = Conversation::findOrFail($conversationId);

        // Ensure the sender is actually a participant in this conversation
        if (!$conversation->users()->where('users.id', $senderId)->exists()) {
            throw new AuthorizationException('You are not a participant in this conversation.');
        }

        return Message::create([
            'conversation_id' => $conversationId,
            'sender_id' => $senderId,
            'content' => $content,
            'message_type' => 'text',
            'is_seen' => false,
        ]);
    }

    /**
     * Mark all unread messages in a conversation as read for the current user.
     */
    public function markMessagesAsRead(int $conversationId, int $currentUserId): void
    {
        Message::where('conversation_id', $conversationId)
            ->where('sender_id', '!=', $currentUserId)
            ->where('is_seen', false)
            ->update(['is_seen' => true]);
    }
}
