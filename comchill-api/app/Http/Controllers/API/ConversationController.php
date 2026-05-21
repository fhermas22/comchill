<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Conversation\StoreConversationRequest;
use App\Http\Resources\ConversationResource;
use App\Models\Conversation;
use App\Services\ConversationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

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
