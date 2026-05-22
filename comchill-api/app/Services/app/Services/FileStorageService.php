<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

/**
 * @author Hermas Francisco
 */
class FileStorageService
{
    /**
     * Store an uploaded image file.
     */
    public function storeImage(UploadedFile $file): array
    {
        // Store inside storage/app/public/uploads/images
        $path = $file->store('uploads/images', 'public');

        return [
            'file_path' => Storage::url($path),
            'file_type' => 'image',
            'file_size' => $file->getSize(),
        ];
    }

    /**
     * Store an uploaded document file.
     */
    public function storeDocument(UploadedFile $file): array
    {
        // Store inside storage/app/public/uploads/documents
        $path = $file->store('uploads/documents', 'public');

        return [
            'file_path' => Storage::url($path),
            'file_type' => 'document',
            'file_size' => $file->getSize(),
        ];
    }
}
