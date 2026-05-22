<?php

namespace App\Http\Requests\Message;

use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;

class StoreMessageRequest extends FormRequest
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
            'content' => 'required_without:files|nullable|string|min:1|max:5000',
            'files' => 'nullable|array',
            'files.*.file_path' => 'required|string',
            'files.*.file_type' => 'required|string|in:image,document',
            'files.*.file_size' => 'required|integer',
        ];
    }
}
