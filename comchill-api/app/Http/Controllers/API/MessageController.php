<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Message\StoreMessageRequest;
use App\Http\Resources\MessageResource;
use App\Models\Conversation;
use App\Services\MessageService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Auth\Access\AuthorizationException;

/**
 * @author Hermas Francisco
 */
class MessageController extends Controller
{
    protected $messageService;

    public function __construct(MessageService $messageService)
    {
        $this->messageService = $messageService;
    }

    /**
     * Get a paginated list of messages from a specific conversation.
     */
    public function index(Request $request, Conversation $conversation): JsonResponse
    {
        // Check authorization
        if (!$conversation->users()->where('users.id', $request->user()->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized access to this conversation.'
            ], 403);
        }

        // Paginate messages to optimize mobile performance (Offline-first / Cache friendly)
        $messages = $conversation->messages()
            ->latest()
            ->paginate(30);

        return response()->json([
            'success' => true,
            'message' => 'Messages retrieved successfully',
            'data' => MessageResource::collection($messages)->response()->getData(true)
        ]);
    }

    /**
     * Store and send a new message.
     */
    public function store(StoreMessageRequest $request, Conversation $conversation): JsonResponse
    {
        try {
            $message = $this->messageService->sendTextMessage(
                $conversation->id,
                $request->user()->id,
                $request->content
            );

            return response()->json([
                'success' => true,
                'message' => 'Message sent successfully',
                'data' => new MessageResource($message)
            ], 201);

        } catch (AuthorizationException $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 403);
        }
    }

    /**
     * Mark all messages in the conversation as read.
     */
    public function markAsRead(Request $request, Conversation $conversation): JsonResponse
    {
        if (!$conversation->users()->where('users.id', $request->user()->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized action.'
            ], 403);
        }

        $this->messageService->markMessagesAsRead($conversation->id, $request->user()->id);

        return response()->json([
            'success' => true,
            'message' => 'Messages marked as read',
            'data' => []
        ]);
    }
}
