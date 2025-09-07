/// Example demonstrating secure token storage with api_service
/// 
/// This example shows how to use the new secure token storage
/// integration with the database_service package.
// ignore_for_file: avoid_print

library;

import 'package:api_service/api_service.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

void main() async {
  await secureTokenExample();
}

Future<void> secureTokenExample() async {
  // 1. Create Dio instance with base configuration
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // 2. Create API service with secure token management
  final apiService = ApiServiceImpl(
    dio: dio,
    tokenRefreshCallback: _refreshToken,
    onTokenExpired: _handleTokenExpired,
  );

  try {
    // 3. Initialize secure storage (REQUIRED)
    print('🔄 Initializing secure storage...');
    await apiService.initialize();
    print('✅ Secure storage initialized successfully');

    // 4. Simulate login and store tokens securely
    print('\n🔐 Storing tokens securely...');
    final tokenPair = TokenPair(
      accessToken: 'sample_access_token_12345',
      refreshToken: 'sample_refresh_token_67890',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );

    await apiService.setTokens(tokenPair);
    print('✅ Tokens stored securely');

    // 5. Check authentication status
    final isAuthenticated = await apiService.isAuthenticated;
    print('🔍 Authentication status: $isAuthenticated');

    final currentTokens = await apiService.currentTokens;
    print('📝 Current tokens stored: ${currentTokens != null}');

    // 6. Make authenticated API calls
    print('\n🌐 Making authenticated API request...');
    final result = await apiService.getMethod('/user/profile');

    result.fold(
      (error) {
        print('❌ API Error: ${error.message}');
        if (error.response?.statusCode == 401) {
          print('🔑 Token may be invalid - automatic refresh will be attempted');
        }
      },
      (response) {
        print('✅ API Success: Status ${response.statusCode}');
        print('📄 Response data: ${response.data}');
      },
    );

    // 7. Demonstrate token expiration check
    final isExpired = await apiService.isTokenExpired;
    print('\n⏰ Token expired: $isExpired');

    // 8. Simulate logout - clear all tokens securely
    print('\n🚪 Logging out - clearing all tokens...');
    await apiService.clearTokens();
    
    final isAuthenticatedAfterClear = await apiService.isAuthenticated;
    print('✅ Tokens cleared. Authenticated: $isAuthenticatedAfterClear');

  } catch (e) {
    print('❌ Error in secure token example: $e');
  }
}

/// Token refresh callback implementation
Future<Either<String, TokenPair>> _refreshToken(String refreshToken) async {
  print('🔄 Attempting to refresh token...');
  
  try {
    // Simulate token refresh API call
    final dio = Dio();
    final response = await dio.post(
      'https://api.example.com/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      final newTokenPair = TokenPair(
        accessToken: response.data['accessToken'] ?? 'new_access_token',
        refreshToken: response.data['refreshToken'] ?? refreshToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      
      print('✅ Token refreshed successfully');
      return right(newTokenPair);
    } else {
      print('❌ Token refresh failed: ${response.statusCode}');
      return left('Token refresh failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Token refresh error: $e');
    return left('Token refresh failed: $e');
  }
}

/// Handle token expiration
void _handleTokenExpired() {
  print('🚨 Token expired! User needs to log in again.');
  // In a real app, you would:
  // - Navigate to login screen
  // - Show authentication required dialog
  // - Clear user state
  // - Notify user of session expiration
}

/// Advanced example showing direct token manager usage
Future<void> advancedTokenManagement() async {
  print('\n🔧 Advanced Token Management Example');
  
  // Get direct access to token manager (if needed)
  final tokenManager = TokenManager.instance;
  
  try {
    // Initialize
    await tokenManager.initialize();
    
    // Check if tokens exist
    final existingTokens = await tokenManager.tokenPair;
    if (existingTokens != null) {
      print('📋 Found existing tokens:');
      print('   Access token: ${existingTokens.accessToken.substring(0, 10)}...');
      print('   Has refresh token: ${existingTokens.refreshToken != null}');
      print('   Expires at: ${existingTokens.expiresAt}');
      print('   Is expired: ${existingTokens.isExpired}');
    } else {
      print('❌ No tokens found');
    }
    
    // Store new tokens
    final newTokens = TokenPair(
      accessToken: 'advanced_access_token',
      refreshToken: 'advanced_refresh_token',
      expiresAt: DateTime.now().add(const Duration(minutes: 30)),
    );
    
    await tokenManager.setTokenPair(newTokens);
    print('✅ New tokens stored');
    
    // Get individual token values
    final accessToken = await tokenManager.accessToken;
    final refreshToken = await tokenManager.refreshToken;
    
    print('🔑 Access Token: ${accessToken?.substring(0, 10)}...');
    print('🔄 Refresh Token: ${refreshToken?.substring(0, 10)}...');
    
  } catch (e) {
    print('❌ Advanced token management error: $e');
  }
}
