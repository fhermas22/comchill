<?php

namespace App\Services;

use App\Models\Message;
use App\Models\Conversation;
use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Support\Facades\DB;

/**
 * @author Hermas Francisco
 */
class MessageService
{
    /**
     * Send a message (text or media) within a specific conversation.
     *
     * @throws AuthorizationException
     */
    public function sendMessage(int $conversationId, int $senderId, ?string $content, array $files = []): Message
    {
        $conversation = Conversation::findOrFail($conversationId);

        if (!$conversation->users()->where('users.id', $senderId)->exists()) {
            throw new AuthorizationException('You are not a participant in this conversation.');
        }

        return DB::transaction(function () use ($conversationId, $senderId, $content, $files) {
            // Determine primary message type based on payload
            $messageType = 'text';
            if (empty($content) && !empty($files)) {
                $messageType = $files[0]['file_type'];
            }

            $message = Message::create([
                'conversation_id' => $conversationId,
                'sender_id' => $senderId,
                'content' => $content,
                'message_type' => $messageType,
                'is_seen' => false,
            ]);

            // Attach files to the created message if any
            foreach ($files as $file) {
                $message->files()->create([
                    'file_path' => $file['file_path'],
                    'file_type' => $file['file_type'],
                    'file_size' => $file['file_size'],
                ]);
            }

            return $message;
        });
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
