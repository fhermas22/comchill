<?php

namespace App\Services;

use App\Models\Conversation;
use Illuminate\Support\Facades\DB;

class ConversationService
{
    /**
     * Get an existing private conversation or create a new one.
     */
    public function getOrCreatePrivateConversation(int $userId, int $receiverId): Conversation
    {
        // Check if a private conversation already exists between these two users
        $conversation = Conversation::where('type', 'private')
            ->whereHas('users', function ($query) use ($userId) {
                $query->where('users.id', $userId);
            })
            ->whereHas('users', function ($query) use ($receiverId) {
                $query->where('users.id', $receiverId);
            })
            ->first();

        if ($conversation) {
            return $conversation;
        }

        // Create a new private conversation if none exists
        return DB::transaction(function () use ($userId, $receiverId) {
            $conversation = Conversation::create([
                'type' => 'private',
                'archived' => false,
            ]);

            // Attach both users to the pivot table
            $conversation->users()->attach([$userId, $receiverId]);

            return $conversation;
        });
    }
}
