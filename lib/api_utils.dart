class ApiUtils {
   static String getApiBaseUrl() {
    bool isProduction = false; // Set to true for production, false for development
    if (isProduction) {
      return 'http://gatorbazaarbackend3-env.eba-t4uqy2ys.us-east-1.elasticbeanstalk.com';
    } else {
      return 'http://localhost:5000';
    }
  }

  static Uri buildApiUrl(String endpoint) {
    final String baseUrl = getApiBaseUrl();
    return Uri.parse('$baseUrl$endpoint');
  }
}