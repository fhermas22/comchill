<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Exception;

/**
 * @author Hermas Francisco
 */
class AIService
{
    protected string $baseUrl;

    public function __construct()
    {
        $this->baseUrl = config('services.ai.url');
    }

    /**
     * Send a prompt to the Python FastAPI instance and return the response with sentiment.
     */
    public function textChat(int $userId, string $message): array
    {
        try {
            // Generate a unique session token based on the user ID to preserve contextual history
            $response = Http::withHeaders([
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
            ])->post("{$this->baseUrl}/chat", [
                'session_id' => 'comchill_user_' . $userId,
                'message' => $message,
            ]);

            if ($response->successful()) {
                return $response->json();
            }

            // Fallback response inside Laravel if the Python service responds with an error code
            return [
                'response' => 'Sorry, I am currently processing too many requests. Please try again in a moment.',
                'sentiment' => 'neutral'
            ];

        } catch (Exception $e) {
            // Safe fallback if the FastAPI server is completely offline or crashing
            return [
                'response' => 'The AI gateway is temporarily unreachable. Please check back shortly.',
                'sentiment' => 'neutral'
            ];
        }
    }
}
