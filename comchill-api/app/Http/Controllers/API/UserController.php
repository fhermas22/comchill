<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use OpenApi\Attributes as OA;

/**
 * @author Hermas Francisco
 */
class UserController extends Controller
{
    /**
     * Get the authenticated user's profile details.
     */
    #[OA\Get(
        path: "/api/user/profile",
        summary: "Get authenticated user's profile",
        description: "Returns the current authenticated user's profile data.",
        tags: ["Users"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Profile retrieved successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
        ]
    )]
    public function profile(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Profile retrieved successfully',
            'data' => new UserResource($request->user())
        ]);
    }

    /**
     * Update the authenticated user's profile details.
     */
    #[OA\Put(
        path: "/api/user/profile",
        summary: "Update authenticated user's profile",
        description: "Updates the current authenticated user's profile using validated input.",
        tags: ["Users"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Profile updated successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
    public function updateProfile(UpdateProfileRequest $request): JsonResponse
    {
        $user = $request->user();

        // Fill and save validated data safely
        $user->update($request->validated());

        return response()->json([
            'success' => true,
            'message' => 'Profile updated successfully',
            'data' => new UserResource($user)
        ]);
    }

    /**
     * Get a specific user's public profile (e.g., when clicking on a contact or chat recipient).
     */
    #[OA\Get(
        path: "/api/users/{user}",
        summary: "Get a user's public profile",
        description: "Returns the public profile for a specific user.",
        tags: ["Users"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "User public profile retrieved successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 404, description: "User not found"),
        ]
    )]
    public function show(User $user): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'User public profile retrieved successfully',
            'data' => new UserResource($user)
        ]);
    }
}

