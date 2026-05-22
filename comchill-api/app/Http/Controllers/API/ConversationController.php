<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Conversation\StoreConversationRequest;
use App\Http\Resources\ConversationResource;
use App\Models\Conversation;
use App\Services\ConversationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use OpenApi\Attributes as OA;

/**
 * @author Hermas Francisco
 */
class ConversationController extends Controller
{
    protected $conversationService;

    public function __construct(ConversationService $conversationService)
    {
        $this->conversationService = $conversationService;
    }

    /**
     * Display a listing of the user's conversations.
     */
    #[OA\Get(
        path: "/api/conversations",
        summary: "List authenticated user's conversations",
        description: "Returns the authenticated user's conversations.",
        tags: ["Conversations"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Conversations retrieved successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
        ]
    )]
    public function index(Request $request): JsonResponse
    {
        $conversations = $request->user()
            ->conversations()
            ->with(['users', 'messages' => function ($query) {
                $query->latest()->limit(1);
            }])
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Conversations retrieved successfully',
            'data' => ConversationResource::collection($conversations)
        ]);
    }

    /**
     * Store or retrieve a private conversation.
     */
    #[OA\Post(
        path: "/api/conversations",
        summary: "Create or retrieve a private conversation",
        description: "Creates a new private conversation or returns the existing one.",
        tags: ["Conversations"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 201, description: "Conversation initialized successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
    public function store(StoreConversationRequest $request): JsonResponse
    {
        $conversation = $this->conversationService->getOrCreatePrivateConversation(
            $request->user()->id,
            $request->receiver_id
        );

        $conversation->load(['users', 'messages' => function ($query) {
            $query->latest()->limit(1);
        }]);

        return response()->json([
            'success' => true,
            'message' => 'Conversation initialized successfully',
            'data' => new ConversationResource($conversation)
        ], 201);
    }

    /**
     * Display the specified conversation details.
     */
    #[OA\Get(
        path: "/api/conversations/{conversation}",
        summary: "Get conversation details",
        description: "Returns details for a single conversation the authenticated user belongs to.",
        tags: ["Conversations"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Conversation details retrieved successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 403, description: "Unauthorized access to this conversation"),
        ]
    )]
    public function show(Conversation $conversation): JsonResponse
    {
        // Check if the authenticated user is part of this conversation
        if (!$conversation->users()->where('users.id', auth()->id())->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to this conversation.'
            ], 403);
        }

        $conversation->load(['users', 'messages' => function ($query) {
            $query->latest()->limit(1);
        }]);

        return response()->json([
            'success' => true,
            'message' => 'Conversation details retrieved successfully',
            'data' => new ConversationResource($conversation)
        ]);
    }

    /**
     * Remove the specified conversation from storage.
     */
    #[OA\Delete(
        path: "/api/conversations/{conversation}",
        summary: "Delete conversation",
        description: "Deletes a conversation if the authenticated user is part of it.",
        tags: ["Conversations"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Conversation deleted successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 403, description: "Unauthorized action"),
        ]
    )]
    public function destroy(Conversation $conversation): JsonResponse
    {
        if (!$conversation->users()->where('users.id', auth()->id())->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized action.'
            ], 403);
        }

        $conversation->delete();

        return response()->json([
            'success' => true,
            'message' => 'Conversation deleted successfully',
            'data' => []
        ]);
    }
}

