# Implementation Plan - Admin Mode & Dynamic Portfolio

Enable the client (2M STUDIO) to manage their portfolio (add, edit, delete albums) directly through the website without touching the code.

## User Review Required

> [!IMPORTANT]
> This requires **Firebase Firestore** and **Firebase Authentication** to be enabled in your [Firebase Console](https://console.firebase.google.com/).
>
> 1.  **Authentication**: Enable "Email/Password" sign-in provider.
> 2.  **Firestore**: Create a database in "Production Mode" or "Test Mode" and add a collection named `projects`.

## Proposed Changes

### 1. Data Model Refactor (`lib/models/project.dart`)
- Add `fromMap` and `toMap` methods to the `Project` class for Firebase synchronization.
- Transition the app from `mockProjects` to a dynamic stream from Firestore.

### 2. Admin Authentication (`lib/features/admin/admin_provider.dart`)
- Create a Riverpod provider to manage the Admin state.
- Implement login/logout logic using `firebase_auth`.

### 3. Admin Dashboard (`lib/pages/admin/dashboard_page.dart`)
- A new protected route (`/admin`) that only the client can access.
- List all current projects with "Edit" and "Delete" actions.
- An "Add Project" button that opens a professional editor.

### 4. Project Editor (`lib/pages/admin/edit_project_page.dart`)
- A form to input:
    - Title
    - Category (Fashion/Product)
    - Sub-Category (Indoor, Outdoor, Flatlay, Shoes)
    - Image URL
    - Description
    - Tags
    - Premium Status (Switch)

### 5. Routing Update (`lib/main.dart`)
- Add the new admin routes.
- Redirect to login if a non-authenticated user tries to access `/admin`.

---

## Verification Plan

### Manual Verification
- **Login Test**: Verify that you can log in as an admin.
- **Add Project**: Create a new test project and verify it appears immediately in the Portfolio.
- **Edit Project**: Change a project's title and see it update in real-time.
- **Delete Project**: Remove a test project and confirm it's gone from the gallery.
- **Security**: Verify that regular visitors cannot access the `/admin` dashboard.
