<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\UpdateProfileRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * @author Hermas Francisco
 */
class UserController extends Controller
{
    /**
     * Get the authenticated user's profile details.
     */
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
    public function show(User $user): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'User public profile retrieved successfully',
            'data' => new UserResource($user)
        ]);
    }
}
