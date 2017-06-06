package twitterConnector;

import java.io.IOException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.security.SecureRandom;
import java.sql.Timestamp;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.codec.binary.Base64;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.Response;

public class Oauth extends HttpServlet {
	public static void main(String[] args) throws IOException {

		Oauth tr = new Oauth();
		tr.sendGetRequest();

	}

	private static SecureRandom random = new SecureRandom();

	public static String nextSessionId() {
		String nonce = new BigInteger(130, random).toString(32);
		return (nonce + nonce).substring(0, 32);
	}

	private void sendGetRequest() throws IOException {

		String consumer_key = "j1euJt0W15A2qPuXUzu04F0IN";
		String consumer_secret = "1HaTCBDG9NjGFBOWgxZl9XtRyqHT0zBecrzrKDjp3rzGiDzyWx";
		String token = "86327591-MUuvybGO3g2BvirO3sWSzz3Xda4teSu1wX2ruxbCb";
		String token_secret = "poemcWYilnJb8vhWidaTEnXlABhFZsplne7qbVnnE7Op3";
		// String signature_method = "HMAC-SHA1";
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		long oauth_timestamp = ts.getTime() / 1000;
		String timestamp = Long.toString(oauth_timestamp);
		// System.out.println("Timestamp = " + timestamp);
		String nonce = nextSessionId();
		// System.out.println("Nonce = " + nonce + "\nNonce Length" +
		// nonce.length());

		// https://api.twitter.com/oauth/authorize?oauth_token=86327591-MUuvybGO3g2BvirO3sWSzz3Xda4teSu1wX2ruxbCb

		// parameter string
		String parameter_string = URLEncoder.encode("oauth_consumer_key", "UTF-8") + "="
				+ URLEncoder.encode("j1euJt0W15A2qPuXUzu04F0IN", "UTF-8") + "&"
				+ URLEncoder.encode("oauth_nonce", "UTF-8") + "=" + URLEncoder.encode(nonce, "UTF-8") + "&"
				+ URLEncoder.encode("oauth_signature_method", "UTF-8") + "=" + URLEncoder.encode("HMAC-SHA1", "UTF-8")
				+ "&" + URLEncoder.encode("oauth_timestamp", "UTF-8") + "=" + URLEncoder.encode(timestamp, "UTF-8")
				+ "&" + URLEncoder.encode("oauth_token", "UTF-8") + "="
				+ URLEncoder.encode("86327591-MUuvybGO3g2BvirO3sWSzz3Xda4teSu1wX2ruxbCb", "UTF-8") + "&"
				+ URLEncoder.encode("oauth_version", "UTF-8") + "=" + URLEncoder.encode("1.0", "UTF-8");

		// System.out.println("Parameter String = " + parameter_string + "\n");

		// creating signature
		String signature_base_string = "GET&"
				+ URLEncoder.encode("https://api.twitter.com/oauth/request_token", "UTF-8") + "&"
				+ URLEncoder.encode(parameter_string, "UTF-8");
		// System.out.println("signature_base_string = " + signature_base_string
		// + "\n\n");

		String oauth_signature = "";
		oauth_signature = computeSignature(signature_base_string, consumer_secret, token_secret);
		String signature = URLEncoder.encode(oauth_signature, "UTF-8");
		// System.out.println(signature + "\n\n");

		// Authorization Header
		String authHeader = "OAuth oauth_consumer_key=\"" + consumer_key + "\"," + "oauth_token=\"" + token + "\","
				+ "oauth_signature_method=\"HMAC-SHA1\"," + "oauth_timestamp=\"" + timestamp + "\"," + "oauth_nonce=\""
				+ nonce + "\"," + "oauth_version=\"1.0\"," + "oauth_signature=\"" + signature + "\"";

		OkHttpClient client = new OkHttpClient();

		Request request = new Request.Builder().url("https://api.twitter.com/oauth/request_token").get()
				.addHeader("authorization", authHeader)
				.addHeader("cache-control", "no-cache").build();

		Response response = client.newCall(request).execute();
		// System.out.println(response.body().string());

		String response_string = response.body().string();

		// System.out.println(response_string);
		String oauth_token = "";
		String chara = "";
		int i = 0;
		while (response_string.charAt(i) != '&') {
			chara = "" + response_string.charAt(i);
			oauth_token = oauth_token.concat(chara);
			i++;

		}
		System.out.println(oauth_token);

		request = new Request.Builder().url("https://api.twitter.com/oauth/authorize?" + oauth_token).get()
				.addHeader("authorization", authHeader).addHeader("screen_name", "JstAAbhishekh")
				.addHeader("cache-control", "no-cache").build();

		response = client.newCall(request).execute();
		System.out.println(response.body().string());
		
		/*
		 * System.out.println(response); request = new Request.Builder().url(
		 * "https://api.twitter.com/1.1/statuses/user_timeline.json").get()
		 * .addHeader("authorization", authHeader).addHeader("screen_name",
		 * "JstAAbhishekh") .addHeader("cache-control", "no-cache").build();
		 * 
		 * response = client.newCall(request).execute();
		 * 
		 * System.out.println(response.body().string());
		 */
	}


	private String computeSignature(String signatueBaseStr, String oAuthConsumerSecret, String oAuthTokenSecret) {

		byte[] byteHMAC = null;
		try {
			Mac mac = Mac.getInstance("HmacSHA1");
			SecretKeySpec spec;
			if (null == oAuthTokenSecret) {
				String signingKey = URLEncoder.encode(oAuthConsumerSecret, "UTF-8") + '&';
				spec = new SecretKeySpec(signingKey.getBytes(), "HmacSHA1");
			} else {
				String signingKey = URLEncoder.encode(oAuthConsumerSecret, "UTF-8") + '&'
						+ URLEncoder.encode(oAuthTokenSecret, "UTF-8");
				spec = new SecretKeySpec(signingKey.getBytes(), "HmacSHA1");
			}
			mac.init(spec);
			byteHMAC = mac.doFinal(signatueBaseStr.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new String(Base64.encodeBase64(byteHMAC));
	}
}