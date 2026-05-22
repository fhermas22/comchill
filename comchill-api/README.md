# ComChill Core API Backend

Welcome to the **ComChill Core API** backend engine. This repository drives the high-performance messaging, student networking, and AI integration systems for the ComChill platform. Built with Laravel, it leverages native PHP 8+ attributes for seamless OpenAPI/Swagger documentation generation.

---

## 👤 Author & Maintainer
* **Author:** Hermas Francisco
* **Position:** Core Backend Engineer / Architect
* **Project Branch:** Development Core API V1

---

## 🛠️ Tech Stack & Requirements
* **Framework:** Laravel 13.x
* **Language:** PHP 8.x+
* **Database:** MySQL / PostgreSQL
* **Authentication:** Laravel Sanctum (Token-Based Authorization)
* **Documentation Engine:** L5-Swagger (OpenAPI 3.0 via native PHP Attributes)

---

## 🚀 Quick Start & Installation

### 1. Clone & Dependencies Installation
```bash
git clone <your-repository-url>
cd comchill-api
composer install

```

### 2. Environment Configuration

Copy the `.env.example` file and configure your local environment details (Database credentials, App URL, etc.):

```bash
cp .env.example .env
php artisan key:generate

```

### 3. Run Migrations & Seeders

```bash
php artisan migrate --seed

```

### 4. Clear Cache & Generate Interactive API Docs

```bash
php artisan config:clear
php artisan l5-swagger:generate

```

*The interactive Swagger UI will be instantly accessible locally at: `http://127.0.0.1:8000/api/documentation*`

---

## 🔐 Core Authentication Strategy

The ComChill platform adopts a pragmatic, mobile-first approach. **Authentication strictly prioritizes User Phone Numbers over email addresses.**

* The `phone` field is required and acts as the unique identifier during registration and login.
* The `email` field is fully **nullable** across user schemas and database layers.

---

## 🗺️ Detailed API Route Reference

*Note: All endpoints below are prefixed automatically by the framework with `/api`.*

### 📂 1. Public Authentication Endpoints

#### `POST /api/register`

* **Description:** Register a new student profile on ComChill.
* **Headers:** `Content-Type: application/json`, `Accept: application/json`
* **Request Payload Example:**

```json
{
  "name": "Hermas Francisco",
  "phone": "+22901000000",
  "password": "SecurePassword123",
  "password_confirmation": "SecurePassword123",
  "email": null 
}

```

* **Success Response (201 Created):**

```json
{
  "success": true,
  "token": "1|sanctum_generated_token_string",
  "user": {
    "id": 1,
    "name": "Hermas Francisco",
    "phone": "+22901000000",
    "email": null,
    "created_at": "2026-05-22T12:00:00.000000Z"
  }
}

```

#### `POST /api/login`

* **Description:** Authenticate using phone credentials to obtain a Sanctum Bearer token.
* **Request Payload Example:**

```json
{
  "phone": "+22901000000",
  "password": "SecurePassword123"
}

```

* **Success Response (200 OK):**

```json
{
  "success": true,
  "token": "2|sanctum_generated_token_string",
  "message": "Authenticated successfully"
}

```

#### `POST /api/auth/oauth`

* **Description:** Handle external decentralized OAuth provider authentication pipelines.
* **Request Payload Example:**

```json
{
  "provider": "google",
  "access_token": "oauth_provider_returned_token_string"
}

```

---

### 🦺 2. Protected Infrastructure (Sanctum Bearer Token Required)

*All routes below require the following HTTP Header:*
`Authorization: Bearer <your_sanctum_token>`

#### 🔴 Auth Controls

##### `POST /api/logout`

* **Description:** Revoke the current authenticated session bearer token.
* **Response (200 OK):**

```json
{
  "success": true,
  "message": "Tokens revoked and logged out successfully"
}

```

#### 👤 Student User Profile Management

##### `GET /api/user`

* **Description:** Fetch the low-overhead runtime object data of the authenticated user.
* **Response (200 OK):**

```json
{
  "success": true,
  "message": "User profile retrieved successfully",
  "data": {
    "id": 1,
    "name": "Hermas Francisco",
    "phone": "+22901000000",
    "email": null
  }
}

```

##### `GET /api/user/profile`

* **Description:** Get extended profile settings, details, and context of the active authenticated user.

##### `PUT /api/user/profile`

* **Description:** Update profile meta structures, statuses, or configurations.
* **Request Body Parameter Examples:** `name`, `email` (nullable).

##### `GET /api/users/{user_id}`

* **Description:** Query and view external student directory profiles using their explicit binding reference keys.

---

#### 🤖 Interactive AI Engine Endpoints

##### `POST /api/ai/chat`

* **Description:** Interact with the ComChill AI Contextual Assistant.
* **Request Payload Example:**

```json
{
  "message": "Can you explain the next IMeN Boost Day schedule?"
}

```

* **Response (200 OK):**

```json
{
  "success": true,
  "response": "The upcoming IMeN Boost Day is dedicated to career optimization...",
  "sentiment": "positive"
}

```

---

#### 📁 Multipart File Assets Upload System

##### `POST /api/upload/image`

* **Description:** Server-side asset handler for multi-format imagery uploads (Avatars, chat attachments).
* **Content-Type:** `multipart/form-data`
* **Payload Binary:** `image` (Valid file constraint required)

##### `POST /api/upload/document`

* **Description:** Raw file processing pipeline for documents, attachments, and student reports.
* **Content-Type:** `multipart/form-data`
* **Payload Binary:** `document` (Valid file constraint required)

---

#### 💬 Chat & Conversation Management System

##### `GET /api/conversations`

* **Description:** Retrieve the index list of active conversation instances linked to the authenticated user.

##### `POST /api/conversations`

* **Description:** Initialize and spin up a new conversation thread (Direct message setup or Group layout context).
* **Request Payload Example:**

```json
{
  "recipient_id": 2,
  "title": "Project ComChill Collaboration"
}

```

##### `GET /api/conversations/{conversation_id}`

* **Description:** Inspect details and status parameters of a single explicit conversation container instance.

##### `DELETE /api/conversations/{conversation_id}`

* **Description:** Destroy, tear down, or leave a specified chat conversation channel.

---

#### ✉️ Message Stream Processing (Nested Resources)

##### `GET /api/conversations/{conversation_id}/messages`

* **Description:** Fetch historical paginated message sequences flowing inside a specific conversation instance.

##### `POST /api/conversations/{conversation_id}/messages`

* **Description:** Stream and broadcast a text message payload into a chosen targeted conversation container.
* **Request Payload Example:**

```json
{
  "body": "Hello team, let's verify the latest server deployments."
}

```

##### `POST /api/conversations/{conversation_id}/messages/read`

* **Description:** Issue a direct marker event updating message read statuses for synchronization flags.

---

## 🧪 Development Workflow commands

When implementing new endpoints or updating metadata parameters, always maintain local consistency:

```bash
# Clear routing configurations cache
php artisan route:clear

# Regenerate fresh Swagger specs files
php artisan l5-swagger:generate

```
