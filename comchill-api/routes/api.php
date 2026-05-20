<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;

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

    // Future endpoints (Conversations, Messages, etc.) will go here
    Route::get('/user', function (\Illuminate\Http\Request $request) {
        return response()->json([
            'success' => true,
            'message' => 'User profile retrieved successfully',
            'data' => $request->user()
        ]);
    });
});
