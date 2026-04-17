# RABS Connect CRM - Backend API Documentation

## Architecture

**Multi-Database Tenant Isolation** — Each client gets their own MySQL database:
- `rabsconnect_aarohan` → Aarohan Realty
- `rabsconnect_client2` → Client 2
- No `company_id` needed — the database itself IS the isolation.

The mobile app sends the database name via `x-client-db` header (obtained during the client code verification step).

---

## Setup

```bash
# 1. Install dependencies
npm install

# 2. Copy env file and fill in values
cp .env.example .env

# 3. Import the schema into your client database
mysql -u root -p rabsconnect_aarohan < user_system_schema_v2.sql

# 4. Create your first user (generates the INSERT SQL)
node utils/seed.js admin admin123 1

# 5. Run the INSERT in MySQL, then start the server
npm run dev
```

---

## Authentication Flow

```
┌─────────────┐     ┌─────────────┐     ┌──────────────┐
│  Mobile App  │────▶│ POST /login │────▶│   Database   │
│              │     │             │     │ (per client) │
│  Stores:     │◀────│  Returns:   │◀────│              │
│  - access    │     │  - tokens   │     │  Validates   │
│  - refresh   │     │  - user     │     │  password    │
│  - user data │     │  - perms    │     │  + stores    │
└─────────────┘     └─────────────┘     │  refresh tok │
                                         └──────────────┘
```

1. App verifies client code → gets `backendUrl` + `dbName`
2. App calls `POST /api/auth/login` with `x-client-db` header
3. Server returns `access_token` (24h) + `refresh_token` (30d)
4. All subsequent API calls include `Authorization: Bearer {access_token}`
5. When access token expires, call `POST /api/auth/refresh` with the refresh token
6. Refresh token rotation: old refresh token is revoked, new one is issued

---

## Endpoints

### Health Check
```
GET /api/health
```

### Login
```
POST /api/auth/login
Headers:
  x-client-db: rabsconnect_aarohan

Body:
{
  "username": "admin",
  "password": "admin123",
  "device_token": "fcm_token_here",      // optional
  "device_platform": "android",           // optional: android|ios|web
  "device_name": "Samsung Galaxy S24"     // optional
}

Response (200):
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "username": "admin",
      "email": "admin@company.com",
      "branch_id": null,
      "branch_name": null,
      "role_id": 1,
      "role_name": "Master",
      "role_slug": "master",
      "role_level": 1,
      "first_name": "Admin",
      "last_name": "User",
      "full_name": "Admin User",
      "phone": "",
      "profile_image": "",
      "designation": "",
      ...
    },
    "permissions": [
      "leads.view", "leads.add", "leads.edit", ...
    ],
    "tokens": {
      "access_token": "eyJhbG...",
      "refresh_token": "eyJhbG...",
      "token_type": "Bearer"
    },
    "crm": {
      "company_name": "Aarohan Realty",
      "timezone": "Asia/Dubai",
      ...
    }
  }
}

Error Responses:
  401 - Invalid username or password
  403 - Account deactivated
  423 - Account locked (too many attempts)
  429 - Rate limited
```

### Refresh Token
```
POST /api/auth/refresh
Body:
{
  "refresh_token": "eyJhbG..."
}

Response (200):
{
  "success": true,
  "message": "Token refreshed",
  "data": {
    "tokens": {
      "access_token": "new_eyJhbG...",
      "refresh_token": "new_eyJhbG...",
      "token_type": "Bearer"
    }
  }
}
```

### Get Current User
```
GET /api/auth/me
Headers:
  Authorization: Bearer {access_token}

Response (200):
{
  "success": true,
  "message": "User profile fetched",
  "data": {
    "user": { ... },
    "permissions": [ ... ]
  }
}
```

### Logout
```
POST /api/auth/logout
Headers:
  Authorization: Bearer {access_token}
Body:
{
  "refresh_token": "eyJhbG..."   // optional but recommended
}
```

### Logout All Devices
```
POST /api/auth/logout-all
Headers:
  Authorization: Bearer {access_token}
```

### Change Password
```
POST /api/auth/change-password
Headers:
  Authorization: Bearer {access_token}
Body:
{
  "current_password": "old_pass",
  "new_password": "new_pass123"
}
```

---

## Security Features

| Feature | Detail |
|---------|--------|
| Password Hashing | bcrypt with 12 salt rounds |
| Account Locking | After 5 failed attempts → locked 30 min |
| Rate Limiting | 20 login attempts per IP per 15 min |
| Token Rotation | Refresh token changes on every refresh call |
| Login History | Every attempt logged (success/failure) |
| Helmet | Security headers enabled |
| CORS | Configurable origins |

---

## File Structure

```
backend/
├── server.js              # Entry point
├── package.json
├── .env.example
├── config/
│   └── database.js        # Multi-DB pool manager
├── controllers/
│   └── authController.js  # Login, refresh, logout, me, change-password
├── middleware/
│   ├── auth.js            # JWT verification + role checks
│   └── dbResolver.js      # Multi-tenant DB resolution
├── models/
│   └── User.js            # All user-related DB queries
├── routes/
│   └── auth.js            # Auth route definitions
├── utils/
│   ├── jwt.js             # Token generation/verification
│   ├── response.js        # Standardized API responses
│   └── seed.js            # Create first user utility
└── uploads/               # File uploads directory
```
