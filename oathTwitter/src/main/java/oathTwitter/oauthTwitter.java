package oathTwitter;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.sql.Timestamp;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;

public class oauthTwitter {
	public static void main(String[] args) throws IOException {

		oauthTwitter tr = new oauthTwitter();
		tr.sendGetRequest();

	}

	private static SecureRandom random = new SecureRandom();

    public static String nextSessionId() {
        return new BigInteger(130, random).toString(32);
    }

	@SuppressWarnings("deprecation")
	private void sendGetRequest() throws IOException {

		String oauth_consumer_key = "jzNP2E9SkKI3Ae3TUZSttxJvi";
	    String oauth_nonce = nextSessionId();
	    String oauth_signature_method = "HMAC-SHA1";
	    Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	    long oauth_timestamp = timestamp.getTime();
	    // the parameter string must be in alphabetical order
	    String parameter_string = "oauth_consumer_key=" + oauth_consumer_key + "&oauth_nonce=" + 
	    	oauth_nonce + "&oauth_signature_method=" + oauth_signature_method + "&oauth_timestamp=" + oauth_timestamp + "&oauth_version=1.0";		
	    System.out.println("parameter_string=" + parameter_string);

	    //creating signature
	    String signature_base_string = "POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&" + URLEncoder.encode(parameter_string, "UTF-8");
	    System.out.println("signature_base_string=" + signature_base_string);

	    String oauth_signature = "";
	    try {
	    	oauth_signature = computeSignature(signature_base_string, "3yasdfasmyconsumersecretfasd53&");  // note the & at the end. Normally the user access_token would go here, but we don't know it yet for request_token
			System.out.println("oauth_signature=" + URLEncoder.encode(oauth_signature, "UTF-8"));
		} catch (GeneralSecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    String authorization_header_string = "OAuth oauth_consumer_key=\"" + oauth_consumer_key + "\",oauth_signature_method=\"HMAC-SHA1\",oauth_timestamp=\"" + 
	    		oauth_timestamp + "\",oauth_nonce=\"" + oauth_nonce + "\",oauth_version=\"1.0\",oauth_signature=\"" + URLEncoder.encode(oauth_signature, "UTF-8") + "\"";
	    System.out.println("authorization_header_string=" + authorization_header_string);
	     

	    String oauth_token = "";
	    HttpClient httpclient = new DefaultHttpClient();
		 try {
			 HttpPost httppost = new HttpPost("https://api.twitter.com/oauth/request_token");
			 httppost.setHeader("Authorization",authorization_header_string);
			 ResponseHandler<String> responseHandler = new BasicResponseHandler();
			 String responseBody = httpclient.execute(httppost, responseHandler);
			 oauth_token = responseBody.substring(responseBody.indexOf("oauth_token=") + 12, responseBody.indexOf("&oauth_token_secret="));
			 System.out.println(responseBody);
	     } 
		 catch(ClientProtocolException cpe)  {	System.out.println(cpe.getMessage());  }
		 catch(IOException ioe) {	System.out.println(ioe.getMessage());  }
		 finally { httpclient.getConnectionManager().shutdown();}
	}
	
	private static String computeSignature(String baseString, String keyString) throws GeneralSecurityException, UnsupportedEncodingException {

	    SecretKey secretKey = null;

	    byte[] keyBytes = keyString.getBytes();
	    secretKey = new SecretKeySpec(keyBytes, "HmacSHA1");

	    Mac mac = Mac.getInstance("HmacSHA1");

	    mac.init(secretKey);

	    byte[] text = baseString.getBytes();

	    return new String(Base64.encodeBase64(mac.doFinal(text))).trim();
	}

}
