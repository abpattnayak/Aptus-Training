<%@ page
	import="java.io.IOException, java.math.BigInteger, java.net.URLEncoder, java.security.SecureRandom"%>
<%@ page
	import="java.sql.Timestamp, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec, javax.servlet.ServletException"%>
<%@ page
	import="javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse"%>
<%@ page
	import="org.apache.commons.codec.binary.Base64, com.squareup.okhttp.OkHttpClient, com.squareup.okhttp.Request, com.squareup.okhttp.Response"%>
<%!private static SecureRandom random = new SecureRandom();

	public static String nextSessionId() {
		String nonce = new BigInteger(130, random).toString(32);
		return (nonce + nonce).substring(0, 32);
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
	}%>
<%
		String consumer_key = "LhN3je9WSj4EZ5J3wIh8td15x";
		String consumer_secret = "epPorjUBk3FNg80U4BjsIBsNzr69FUZrM4vCQkD56eAacZEcVj";
		String token = "86327591-X6pC9fGMzICscDtUaTQogohiR7bMWDBfi7uDBPfH0";
		String token_secret = "VQGKOatxBV0QHPZN7jlrc2qMKlsnbZE7yYMRjSBC1lCaD";
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
				+ URLEncoder.encode(consumer_key, "UTF-8") + "&"
				+ URLEncoder.encode("oauth_nonce", "UTF-8") + "=" + URLEncoder.encode(nonce, "UTF-8") + "&"
				+ URLEncoder.encode("oauth_signature_method", "UTF-8") + "="
				+ URLEncoder.encode("HMAC-SHA1", "UTF-8") + "&" + URLEncoder.encode("oauth_timestamp", "UTF-8")
				+ "=" + URLEncoder.encode(timestamp, "UTF-8") + "&" + URLEncoder.encode("oauth_token", "UTF-8")
				+ "=" + URLEncoder.encode(token, "UTF-8") + "&"
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
				+ "oauth_signature_method=\"HMAC-SHA1\"," + "oauth_timestamp=\"" + timestamp + "\","
				+ "oauth_nonce=\"" + nonce + "\"," + "oauth_version=\"1.0\"," + "oauth_signature=\"" + signature
				+ "\"";

		OkHttpClient client = new OkHttpClient();

		Request req = new Request.Builder().url("https://api.twitter.com/oauth/request_token").get()
				.addHeader("authorization", authHeader)
				.addHeader("oauth_callback", "oob")
				.addHeader("cache-control", "no-cache")
				.build();
		System.out.println(authHeader);
		Response res = client.newCall(req).execute();

		String response_string = res.body().string();

		System.out.println("\n**********\n"+response_string);
		String oauth_token = "";
		String chara = "";
		int i = 0;
		while (response_string.charAt(i) != '&') {
			chara = "" + response_string.charAt(i);
			oauth_token = oauth_token.concat(chara);
			i++;

		}
		System.out.println(oauth_token);
		//out.write(oauth_token);
		req = new Request.Builder().url("https://api.twitter.com/oauth/authorize?" + oauth_token).get()
				.addHeader("authorization", authHeader)
				.addHeader("cache-control", "no-cache").build();

		res = client.newCall(req).execute();
		//System.out.println(res.body().string());
		out.write(res.body().string());
	%>
	