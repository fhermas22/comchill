<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'full_name' => $this->full_name,
            'phone_number' => $this->phone_number,
            'email' => $this->email, // Email is nullable in database
            'bio' => $this->bio,
            'profile_photo' => $this->profile_photo,
            'provider' => $this->provider, // useful to disable password change fields in Flutter UI if OAuth
            'created_at' => $this->created_at,
        ];
    }
}
