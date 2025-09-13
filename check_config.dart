import 'dart:io';
import 'dart:convert';

void main() async {
  print('╔════════════════════════════════════════════════════════════════╗');
  print('║           Google Sign-In Configuration Checker                 ║');
  print('╚════════════════════════════════════════════════════════════════╝\n');

  // Check google-services.json
  print('📱 Checking google-services.json...');
  final googleServicesFile = File('android/app/google-services.json');
  
  if (!googleServicesFile.existsSync()) {
    print('❌ google-services.json NOT FOUND at android/app/');
    print('   Please download it from Firebase Console');
    return;
  }

  final jsonContent = await googleServicesFile.readAsString();
  final config = json.decode(jsonContent);
  
  print('✅ google-services.json found\n');
  
  // Project info
  print('🔥 Firebase Project:');
  print('   Project ID: ${config['project_info']['project_id']}');
  print('   Project Number: ${config['project_info']['project_number']}\n');
  
  // Check OAuth clients
  print('🔐 OAuth Clients:');
  final clients = config['client'][0]['oauth_client'] as List;
  
  String? androidClientId;
  String? androidSha1;
  String? webClientId;
  
  for (var client in clients) {
    if (client['client_type'] == 1) {
      androidClientId = client['client_id'];
      androidSha1 = client['android_info']?['certificate_hash'] ?? 'N/A';
      print('   ✅ Android OAuth Client:');
      print('      Client ID: ${androidClientId.substring(0, 40)}...');
      print('      SHA-1: ${_formatSha1(androidSha1)}');
    } else if (client['client_type'] == 3) {
      webClientId = client['client_id'];
      print('   ✅ Web OAuth Client:');
      print('      Client ID: ${webClientId.substring(0, 40)}...');
    }
  }
  
  if (androidClientId == null) {
    print('   ❌ MISSING Android OAuth Client!');
    print('      This is required for Google Sign-In on Android');
  }
  
  print('\n🔑 Your Debug SHA-1:');
  print('   Run this command to get your SHA-1:');
  print('   cd android && .\\gradlew signingReport\n');
  
  print('📋 Configuration Status:');
  if (androidClientId != null) {
    print('   ✅ Android OAuth client configured');
    print('   ⚠️  SHA-1 in config: ${_formatSha1(androidSha1 ?? "")}');
    print('   ⚠️  Make sure this matches YOUR debug SHA-1');
  } else {
    print('   ❌ Android OAuth client MISSING');
  }
  
  print('\n🔧 Common Issues and Solutions:\n');
  
  print('1. SHA-1 Mismatch (Most Common):');
  print('   • Your local SHA-1 doesn\'t match Firebase');
  print('   • Solution: Add YOUR SHA-1 to Firebase Console\n');
  
  print('2. Wrong OAuth Client:');
  print('   • Using Web client ID instead of Android');
  print('   • Solution: Don\'t specify clientId in GoogleSignIn()\n');
  
  print('3. Google Sign-In Not Enabled:');
  print('   • Firebase Console → Authentication → Sign-in method');
  print('   • Enable Google provider\n');
  
  print('4. Package Name Mismatch:');
  print('   • Current: ${config['client'][0]['client_info']['android_client_info']['package_name']}');
  print('   • Must match your AndroidManifest.xml\n');
  
  print('═══════════════════════════════════════════════════════════════');
  print('📌 NEXT STEPS:');
  print('1. Run: cd android && .\\gradlew signingReport');
  print('2. Copy the SHA1 value from "Variant: debug"');
  print('3. Go to Firebase Console → Project Settings');
  print('4. Add YOUR SHA-1 to the Android app');
  print('5. Download new google-services.json');
  print('6. Run: flutter clean && flutter pub get');
  print('7. Run: flutter run');
  print('═══════════════════════════════════════════════════════════════');
}

String _formatSha1(String sha1) {
  if (sha1.length == 40) {
    // Convert to colon format
    return sha1.toUpperCase().replaceAllMapped(
      RegExp(r'.{2}'),
      (match) => '${match.group(0)}:',
    ).substring(0, 59);
  }
  return sha1;
}
