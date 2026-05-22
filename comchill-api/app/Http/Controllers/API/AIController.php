<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\AI\AIChatRequest;
use App\Services\AIService;
use Illuminate\Http\JsonResponse;

/**
 * @author Hermas Francisco
 */
class AIController extends Controller
{
    protected AIService $aiService;

    public function __construct(AIService $aiService)
    {
        $this->aiService = $aiService;
    }

    /**
     * Route the student's message to the AI pipeline and deliver the processed response.
     */
    public function chat(AIChatRequest $request): JsonResponse
    {
        $userId = $request->user()->id;

        // Pass payload securely to the AI Service
        $aiResult = $this->aiService->textChat($userId, $request->input('message'));

        return response()->json([
            'success' => true,
            'message' => 'AI response generated successfully',
            'data' => [
                'reply' => $aiResult['response'] ?? $aiResult['reply'], // Handles both field mapping variations safely
                'sentiment' => $aiResult['sentiment'] ?? 'neutral'
            ]
        ], 200);
    }
}
