import 'dart:convert';
import 'dart:io';

void main() async {
  print('Checking google-services.json configuration...\n');
  
  try {
    // Read the google-services.json file
    final file = File('android/app/google-services.json');
    if (!file.existsSync()) {
      print('❌ google-services.json not found!');
      print('   Location: android/app/google-services.json');
      return;
    }
    
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString);
    
    // Check project info
    print('Project Info:');
    print('  Project ID: ${jsonData['project_info']['project_id']}');
    print('  Project Number: ${jsonData['project_info']['project_number']}');
    print('');
    
    // Check OAuth clients
    final clients = jsonData['client'][0]['oauth_client'] as List;
    
    bool hasAndroidClient = false;
    bool hasWebClient = false;
    
    print('OAuth Clients Found:');
    for (var client in clients) {
      final clientType = client['client_type'];
      final clientId = client['client_id'];
      
      if (clientType == 1) {
        hasAndroidClient = true;
        print('  ✅ Android Client: ${clientId.substring(0, 30)}...');
      } else if (clientType == 3) {
        hasWebClient = true;
        print('  ✅ Web Client: ${clientId.substring(0, 30)}...');
      }
    }
    
    print('\nConfiguration Status:');
    if (hasAndroidClient) {
      print('  ✅ Android OAuth client is configured');
    } else {
      print('  ❌ Android OAuth client is MISSING!');
      print('     This is required for Google Sign-In on Android');
      print('     Follow the steps in GOOGLE_SIGNIN_FIX.md');
    }
    
    if (hasWebClient) {
      print('  ✅ Web OAuth client is configured');
    }
    
    // Check package name
    final packageName = jsonData['client'][0]['client_info']['android_client_info']['package_name'];
    print('\nPackage Name: $packageName');
    
    if (packageName == 'com.example.flutter_phone_app') {
      print('  ✅ Package name matches');
    } else {
      print('  ⚠️  Package name mismatch!');
    }
    
  } catch (e) {
    print('Error reading google-services.json: $e');
  }
}
