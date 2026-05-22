<?php

namespace App\Http\Requests\User;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class UpdateProfileRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return false;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        $userId = $this->user()->id;

        return [
            'full_name' => 'sometimes|required|string|max:255',
            'phone_number' => 'sometimes|required|string|unique:users,phone_number,' . $userId,
            'email' => 'nullable|email|unique:users,email,' . $userId, // Explicitly nullable
            'bio' => 'nullable|string|max:1000',
            'profile_photo' => 'nullable|string', // Expects a valid URL string returned by FileUploadController
        ];
    }
}
