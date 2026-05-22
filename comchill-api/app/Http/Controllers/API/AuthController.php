<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\RegisterUserRequest;
use App\Http\Requests\Auth\LoginUserRequest;
use App\Http\Requests\Auth\OAuthLoginRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Socialite\Socialite;
use OpenApi\Attributes as OA;
use Exception;

/**
 * @author Hermas Francisco
 */
class AuthController extends Controller
{
    /**
     * Register a new user with phone number and generate a Sanctum token.
     */
    #[OA\Post(
        path: "/api/register",
        summary: "Register user and generate Sanctum token",
        description: "Create a new user account using phone number and return an access token.",
        tags: ["Authentication"],
        responses: [
            new OA\Response(response: 201, description: "User registered successfully"),
            new OA\Response(response: 422, description: "Validation failed")
        ]
    )]
    public function register(RegisterUserRequest $request): JsonResponse
    {

        $user = User::create([
            'full_name' => $request->full_name,
            'phone_number' => $request->phone_number,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'User registered successfully with phone number',
            'data' => [
                'user' => $user,
                'token' => $token
            ]
        ], 201);
    }

    /**
     * Handle incoming login request via phone number.
     */
    #[OA\Post(
        path: "/api/login",
        summary: "Authenticate user and generate Sanctum token",
        tags: ["Authentication"],
        responses: [
            new OA\Response(response: 200, description: "Login successful"),
            new OA\Response(response: 401, description: "Invalid credentials"),
            new OA\Response(response: 422, description: "Validation failed")
        ]
    )]
    public function login(LoginUserRequest $request): JsonResponse

    {
        $user = User::where('phone_number', $request->phone_number)->first();

        // Verify user exists and credentials match
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid credentials',
                'errors' => [
                    'phone_number' => ['The provided credentials do not match our records.']
                ]
            ], 401);
        }

        // Revoke older tokens for security
        $user->tokens()->delete();

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'data' => [
                'user' => $user,
                'token' => $token
            ]
        ], 200);
    }

    /**
     * Authenticate or register a user securely via a social provider token.
     * * @author Hermas Francisco
     */
    #[OA\Post(
        path: "/api/auth/oauth",
        summary: "Authenticate or register user via OAuth",
        description: "Validates the provided social access token and returns a Sanctum token.",
        tags: ["Authentication"],
        responses: [
            new OA\Response(response: 200, description: "OAuth authentication successful"),
            new OA\Response(response: 401, description: "Invalid or expired provider credentials"),
            new OA\Response(response: 422, description: "Validation failed")
        ]
    )]
    public function oauthLogin(OAuthLoginRequest $request): JsonResponse
    {

        $provider = $request->provider;
        $accessToken = $request->access_token;

        try {
            // Securely fetch user data from the provider using the configured client keys
            $socialUser = Socialite::driver($provider)->stateless()->userFromToken($accessToken);



        } catch (Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid or expired credentials from provider.',
                'errors' => ['access_token' => ['The token verification failed.']]
            ], 401);
        }

        // Find or link account using the verified unique provider ID
        $user = User::where('provider', $provider)
                    ->where('provider_id', $socialUser->getId())
                    ->first();

        if (!$user) {
            // Check if a manual account already exists with the verified email
            if ($socialUser->getEmail()) {
                $user = User::where('email', $socialUser->getEmail())->first();
            }

            if ($user) {
                // Securely link provider profile to existing manual user
                $user->update([
                    'provider' => $provider,
                    'provider_id' => $socialUser->getId(),
                    'profile_photo' => $user->profile_photo ?? $socialUser->getAvatar(),
                ]);
            } else {
                // Register a brand new user profile using verified data
                $user = User::create([
                    'full_name' => $socialUser->getName() ?? $socialUser->getNickname(),
                    'email' => $socialUser->getEmail(),
                    'profile_photo' => $socialUser->getAvatar(),
                    'provider' => $provider,
                    'provider_id' => $socialUser->getId(),
                    'password' => null, // Password is not required for OAuth sessions
                ]);
            }
        } else {
            // Keep user avatar synchronized with the provider profile
            if ($socialUser->getAvatar() && $user->profile_photo !== $socialUser->getAvatar()) {
                $user->update(['profile_photo' => $socialUser->getAvatar()]);
            }
        }

        // Revoke older sessions and issue a fresh Sanctum access token
        $user->tokens()->delete();
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'OAuth authentication successful',
            'data' => [
                'user' => $user,
                'token' => $token
            ]
        ], 200);
    }

    /**
     * Handle user logout.
     */
    #[OA\Post(
        path: "/api/logout",
        summary: "Logout the authenticated user",
        description: "Deletes the current Sanctum access token.",
        tags: ["Authentication"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 200, description: "Logged out successfully"),
            new OA\Response(response: 401, description: "Unauthenticated")
        ]
    )]
    public function logout(Request $request): JsonResponse

    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logged out successfully',
            'data' => []
        ], 200);
    }
}
