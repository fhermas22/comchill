<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\File\UploadImageRequest;
use App\Http\Requests\File\UploadDocumentRequest;
use App\Services\FileStorageService;
use Illuminate\Http\JsonResponse;
use OpenApi\Attributes as OA;

/**

 * @author Hermas Francisco
 */
class FileUploadController extends Controller
{
    protected $fileStorageService;

    public function __construct(FileStorageService $fileStorageService)
    {
        $this->fileStorageService = $fileStorageService;
    }

    /**
     * Upload and store an image.
     */
    #[OA\Post(
        path: "/api/upload/image",
        summary: "Upload an image",
        description: "Uploads an image file and stores it using the configured storage service.",
        tags: ["Files"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 201, description: "Image uploaded successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
    public function uploadImage(UploadImageRequest $request): JsonResponse

    {
        $fileData = $this->fileStorageService->storeImage($request->file('image'));

        return response()->json([
            'success' => true,
            'message' => 'Image uploaded successfully',
            'data' => $fileData
        ], 201);
    }

    /**
     * Upload and store a document.
     */
    #[OA\Post(
        path: "/api/upload/document",
        summary: "Upload a document",
        description: "Uploads a document file and stores it using the configured storage service.",
        tags: ["Files"],
        security: [["sanctum" => []]],
        responses: [
            new OA\Response(response: 201, description: "Document uploaded successfully"),
            new OA\Response(response: 401, description: "Unauthenticated"),
            new OA\Response(response: 422, description: "Validation failed"),
        ]
    )]
    public function uploadDocument(UploadDocumentRequest $request): JsonResponse

    {
        $fileData = $this->fileStorageService->storeDocument($request->file('document'));

        return response()->json([
            'success' => true,
            'message' => 'Document uploaded successfully',
            'data' => $fileData
        ], 201);
    }
}
