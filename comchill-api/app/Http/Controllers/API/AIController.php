<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\AI\AIChatRequest;
use App\Services\AIService;
use Illuminate\Http\JsonResponse;
use OpenApi\Attributes as OA;


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
    #[OA\Post(
        path: "/api/ai/chat",
        summary: "Chat with the AI assistant",
        description: "Processes a student message through the AI pipeline and returns the generated reply.",
        tags: ["AI"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "AI response generated successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
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
