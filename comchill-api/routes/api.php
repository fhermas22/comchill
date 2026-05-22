<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ConversationController;
use App\Http\Controllers\API\FileUploadController;
use App\Http\Controllers\API\MessageController;
use App\Http\Controllers\API\UserController;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Public Auth Routes
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/auth/oauth', [AuthController::class, 'oauthLogin']);

/*
|--------------------------------------------------------------------------
| Protected Core API Routes
|--------------------------------------------------------------------------
| These routes require a valid Sanctum token.
*/
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::get('/user', function (Request $request) {
        return response()->json([
            'success' => true,
            'message' => 'User profile retrieved successfully',
            'data' => $request->user()
        ]);
    });

    /*
    |--------------------------------------------------------------------------
    | User & Profile Routes
    |--------------------------------------------------------------------------
    */
    Route::get('/user/profile', [UserController::class, 'profile']);
    Route::put('/user/profile', [UserController::class, 'updateProfile']);
    Route::get('/users/{user}', [UserController::class, 'show']); // To check other student profiles

    /*
    |--------------------------------------------------------------------------
    | File Upload Routes
    |--------------------------------------------------------------------------
    */
    Route::post('/upload/image', [FileUploadController::class, 'uploadImage']);
    Route::post('/upload/document', [FileUploadController::class, 'uploadDocument']);

    /*
    |--------------------------------------------------------------------------
    | Conversations Routes
    |--------------------------------------------------------------------------
    */
    Route::apiResource('conversations', ConversationController::class)->except(['update']);

    /*
    |--------------------------------------------------------------------------
    | Messages Routes (Nested under conversations)
    |--------------------------------------------------------------------------
    */
    Route::get('conversations/{conversation}/messages', [MessageController::class, 'index']);
    Route::post('conversations/{conversation}/messages', [MessageController::class, 'store']);
    Route::post('conversations/{conversation}/messages/read', [MessageController::class, 'markAsRead']);
});
