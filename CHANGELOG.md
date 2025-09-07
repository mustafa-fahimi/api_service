## 2.1.0

### 🔐 Security Enhancements
- **Secure Token Storage**: Integrate `database_service` package for encrypted token persistence
- **Platform-Native Security**: Use Flutter Secure Storage with platform-specific implementations:
  - iOS/macOS: Keychain with `first_unlock` accessibility
  - Android: Encrypted SharedPreferences with AES encryption
  - Windows: Native Credential Store API
- **Automatic Encryption**: All tokens are now encrypted at rest automatically
- **Singleton Pattern**: TokenManager now uses singleton pattern for consistent state management

### 🛠️ API Changes
- **New Method**: `ApiService.initialize()` - Must be called before using the service
- **Simplified Constructor**: Removed `tokenManager` parameter from `ApiServiceImpl`
- **Automatic Token Interceptor**: Token interceptor is now always enabled since secure storage is built-in
- **Enhanced Token Operations**: Added batch operations for better performance

### 🐛 Bug Fixes
- Fixed token persistence across app restarts
- Improved error handling for secure storage operations
- Enhanced token expiration checks with secure storage

### 🔧 Technical Improvements
- **Enhanced ApiServiceHeader**: Fixed hardcoded boundary in form-data content-type with dynamic generation, standardized factory naming conventions, and added comprehensive documentation
- Replaced in-memory storage with encrypted persistent storage
- Improved token refresh flow with secure storage integration
- Added proper initialization guards to prevent uninitialized access
- Enhanced exception handling with descriptive error messages

## 2.0.0

### Features
- Implement ApiService with HTTP methods, token management, and response handling

### Documentation
- Enhance README with detailed features, installation instructions, and usage examples
- Add token management and error handling sections

### Changes
- Refactor API request methods to use a unified request handler
- Update analysis options and bump dependencies
- Enhance pattern matching in ApiService classes
