<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ConversationController;
use App\Http\Controllers\API\MessageController;
use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Public Routes
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

/*
|--------------------------------------------------------------------------
| Protected Routes
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
