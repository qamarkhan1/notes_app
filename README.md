Flutter Notes App – Firebase + BLoC

This repository contains a **Flutter Notes application** built as part of a technical assignment.  
The app demonstrates authentication, secure CRUD operations, clean UI, and state management using **BLoC**.

---

Features

- Email & Password Authentication (Firebase Auth)
- Secure Notes CRUD (Cloud Firestore)
- User-specific data isolation (notes are private per user)
- Persistent login session
- Material 3 UI with card-based layout
- State management using BLoC
- Android APK build provided

Additional Features Implemented
- ✅ Client-side search notes by title (**Option B**)
- ✅ Graceful error handling when offline or when data cannot be fetched (**Option A**)

> Although the assignment required only one option, both were implemented without affecting core functionality.  
> Each feature can be evaluated independently.

---

Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- flutter_bloc (BLoC pattern)
- Android (APK build)

No backend services other than Firebase were used.

---

Authentication

- Email & password based authentication using **Firebase Auth**
- Login session persists across app restarts using Firebase’s built-in session handling
- Logout functionality included

---

Notes Data Model

Collection:

Each note document contains:

| Field        | Type       |
|-------------|------------|
| `id`        | String (Firestore document ID) |
| `title`     | String     |
| `content`   | String     |
| `created_at`| Timestamp |
| `updated_at`| Timestamp |
| `user_id`   | String (Firebase Auth UID) |

---

Data Security & Access Control

- Notes are queried using `user_id == auth.uid`
- Firestore Security Rules enforce:
  - Users can **only read/write/update/delete their own notes**
  - Cross-user data access is blocked at the database level

Firestore Rule (summary):
allow read, write: if request.auth != null
&& resource.data.user_id == request.auth.uid;
