<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Requests\File\UploadImageRequest;
use App\Http\Requests\File\UploadDocumentRequest;
use App\Services\FileStorageService;
use Illuminate\Http\JsonResponse;

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
