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
use OpenApi\Attributes as OA;


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
    #[OA\Get(
        path: "/api/conversations/{conversation}/messages",
        summary: "List messages in a conversation",
        description: "Returns a paginated list of messages for the specified conversation.",
        tags: ["Messages"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Messages retrieved successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 403, description: "Unauthorized access to this conversation"),
        ]
    )]
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
            ->with('files') // Crucial for MessageResource to catch them
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
    #[OA\Post(
        path: "/api/conversations/{conversation}/messages",
        summary: "Send a new message",
        description: "Stores and sends a new message to the specified conversation.",
        tags: ["Messages"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 201, description: "Message sent successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 403, description: "Unauthorized access to this conversation"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
    public function store(StoreMessageRequest $request, Conversation $conversation): JsonResponse

    {
        try {
            $message = $this->messageService->sendMessage(
                $conversation->id,
                $request->user()->id,
                $request->content,
                $request->input('files', [])
            );

            $message->load('files'); // Ensure files relation is loaded before transformation

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
    #[OA\Post(
        path: "/api/conversations/{conversation}/messages/read",
        summary: "Mark conversation messages as read",
        description: "Marks all messages in the specified conversation as read.",
        tags: ["Messages"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Messages marked as read"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 403, description: "Unauthorized action"),
        ]
    )]
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
