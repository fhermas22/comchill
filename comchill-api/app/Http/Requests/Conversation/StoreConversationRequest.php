<?php

namespace App\Http\Requests\Conversation;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StoreConversationRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            // Ensure the receiver exists and is not the authenticated user itself
            'receiver_id' => 'required|exists:users,id|not_in:' . auth()->id(),
        ];
    }
}
