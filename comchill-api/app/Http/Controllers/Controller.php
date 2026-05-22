<?php

namespace App\Http\Controllers;

use OpenApi\Attributes as OA;

#[OA\Info(
    title: "ComChill Core API Documentation",
    version: "1.0.0",
    description: "REST API endpoints for ComChill student messaging platform",
    contact: new OA\Contact(email: "franciscohermas@gmail.com")
)]
#[OA\Server(
    url: "http://127.0.0.1:8000",
    description: "ComChill Local Development API Server"
)]
#[OA\SecurityScheme(
    securityScheme: "sanctum",
    type: "http",
    scheme: "bearer",
    bearerFormat: "JWT",
    description: "Enter your Sanctum token to access protected routes"
)]
abstract class Controller
{
    //
}
