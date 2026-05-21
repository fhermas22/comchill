<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ConversationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $currentUserId = auth()->id();

        // Find the other participant in the conversation
        $participant = $this->users->first(function ($user) use ($currentUserId) {
            return $user->id !== $currentUserId;
        });

        return [
            'id' => $this->id,
            'type' => $this->type,
            'archived' => $this->archived,
            'participant' => $participant ? [
                'id' => $participant->id,
                'full_name' => $participant->full_name,
                'profile_photo' => $participant->profile_photo,
            ] : null,
            'last_message' => $this->messages->first() ? [
                'id' => $this->messages->first()->id,
                'content' => $this->messages->first()->content,
                'message_type' => $this->messages->first()->message_type,
                'is_seen' => $this->messages->first()->is_seen,
                'created_at' => $this->messages->first()->created_at,
            ] : null,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
