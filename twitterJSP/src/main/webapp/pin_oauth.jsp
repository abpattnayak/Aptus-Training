<%@ page import="java.util.Locale.Category, org.json.simple.*, org.json.simple.parser.*"%>
<%@ page import="com.squareup.okhttp.*, java.io.IOException,org.apache.commons.codec.binary.Base64"%>
<%@ page import="java.math.BigInteger, java.net.URLEncoder, java.security.SecureRandom, com.google.gson.JsonElement"%>
<%@ page import="java.sql.Timestamp, javax.crypto.Mac, javax.crypto.spec.SecretKeySpec, javax.servlet.ServletException"%>
<%@ page import="javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse"%>
<%@ page import="java.net.URL,java.net.URLConnection," %>

	
	
<%!private static SecureRandom random = new SecureRandom();

	public static String nextSessionId() {
		String nonce = new BigInteger(130, random).toString(32);
		return (nonce + nonce).substring(0, 32);
	}

	private String computeSignature(String signatureBaseStr, String oAuthConsumerSecret, String oAuthTokenSecret) {

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
			byteHMAC = mac.doFinal(signatureBaseStr.getBytes());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new String(Base64.encodeBase64(byteHMAC));
	}%>
<%
	OkHttpClient client = new OkHttpClient();

	Request req = new Request.Builder().url("https://api.twitter.com/oauth/access_token?oauth_token="
			+ request.getParameter("oauth_token") + "&oauth_verifier=" + request.getParameter("oauth_verifier"))
			.build();

	Response res = client.newCall(req).execute();
	//System.out.println(res + "\n" + res.body().string());
	String authenticationData = res.body().string();
	out.write(authenticationData);

	req = new Request.Builder().url("https://api.twitter.com/1.1/statuses/user_timeline.json").get()
			.addHeader("authorization", "oauth_token=" + request.getParameter("oauth_token")
					+ "&oauth_verifier=" + request.getParameter("oauth_verifier"))
			.build();
	res = client.newCall(req).execute();
	//System.out.println(res.body().string());
	String[] data = authenticationData.split("&");
	out.write("<br>");
	for(String k : data){
		out.write(k + "<br>");
	}
	
	
	String consumer_key = "LhN3je9WSj4EZ5J3wIh8td15x";
	String consumer_secret = "epPorjUBk3FNg80U4BjsIBsNzr69FUZrM4vCQkD56eAacZEcVj";
	
	/*
	String token = "86327591-X6pC9fGMzICscDtUaTQogohiR7bMWDBfi7uDBPfH0";
	String token_secret = "VQGKOatxBV0QHPZN7jlrc2qMKlsnbZE7yYMRjSBC1lCaD";
	*/
	String token = data[0].split("=")[1];
	String token_secret = data[1].split("=")[1];
	String screen_name = data[3].split("=")[1];
	out.write("<br>token = " + token +
			"<br>token secret = " + token_secret +
			"<br>screen name = " + screen_name);
	
	
	Timestamp ts = new Timestamp(System.currentTimeMillis());
	long oauth_timestamp = ts.getTime() / 1000;
	String timestamp = Long.toString(oauth_timestamp);
	String nonce = nextSessionId();
	
	
	String parameter_string = URLEncoder.encode("oauth_consumer_key", "UTF-8") + "="
			+ URLEncoder.encode(consumer_key, "UTF-8") + "&"
			+ URLEncoder.encode("oauth_nonce", "UTF-8") + "=" + URLEncoder.encode(nonce, "UTF-8") + "&"
			+ URLEncoder.encode("oauth_signature_method", "UTF-8") + "="
			+ URLEncoder.encode("HMAC-SHA1", "UTF-8") + "&" + URLEncoder.encode("oauth_timestamp", "UTF-8")
			+ "=" + URLEncoder.encode(timestamp, "UTF-8") + "&" + URLEncoder.encode("oauth_token", "UTF-8")
			+ "=" + URLEncoder.encode(token, "UTF-8") + "&"
			+ URLEncoder.encode("oauth_version", "UTF-8") + "=" + URLEncoder.encode("1.0", "UTF-8");

	// creating signature
	String signature_base_string = "GET&"
			+ URLEncoder.encode("https://api.twitter.com/1.1/statuses/home_timeline.json", "UTF-8") + "&"
			+ URLEncoder.encode(parameter_string, "UTF-8");
	
	String oauth_signature = "";
	oauth_signature = computeSignature(signature_base_string, consumer_secret, token_secret);
	String signature = URLEncoder.encode(oauth_signature, "UTF-8");
	System.out.println("Signature: "+signature);
	
	//created signature	
	String authHeader = "OAuth oauth_consumer_key=\"" + consumer_key + "\"," + "oauth_token=\"" + token + "\","
			+ "oauth_signature_method=\"HMAC-SHA1\"," + "oauth_timestamp=\"" + timestamp + "\","
			+ "oauth_nonce=\"" + nonce + "\"," + "oauth_version=\"1.0\"," + "oauth_signature=\"" + signature
			+ "\"";
	
	
	//Requesting timeline
	System.out.println("Auth Header = " + authHeader);
	req = new Request.Builder().url("https://api.twitter.com/1.1/statuses/home_timeline.json").get()
			.addHeader("authorization", authHeader)
			.addHeader("cache-control", "no-cache").build();
	res = client.newCall(req).execute();
	

	JSONParser parser = new JSONParser();
	//Processing JSON Data Fetched in response
	String timelineData = res.body().string();
	
	JSONArray restDataArray = new JSONArray();
	restDataArray = (JSONArray) parser.parse(timelineData);
	JSONObject restData = new JSONObject();
	String created_at = new String();
	String text = new String();
	
			
	for(int i=0;i<restDataArray.size();i++){
		restData = (JSONObject)restDataArray.get(i);
		created_at = restData.get("created_at").toString();
		text = restData.get("text").toString();
		out.write("Created At : "+created_at +"<br>");
		out.write("Text : "+text +"<br>");
	}
	
	
%>