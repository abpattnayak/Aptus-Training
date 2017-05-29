package com.aptus.xyz;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.commons.codec.binary.Base64;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Basic {

	public static String query = "create table JobTable(" + "   _class TEXT, name TEXT, url TEXT, " + "   color TEXT)";

	public static void main(String[] args) throws IOException, ParseException {

		// Function for encoding

		String usrName = "aptus";
		String pwd = "@ptus2016";
		String stringToEncode = usrName + ":" + pwd;

		Base64 base64 = new Base64();
		String encodedString = new String(base64.encode(stringToEncode.getBytes()));
		String finalString = "Basic " + encodedString;
		fetchJSONData(finalString);

		// System.out.println(encodedString);

	}

	public static Connection getConnection() throws Exception {
		// For sql connection

		String driver = "org.gjt.mm.mysql.Driver";
		String url = "jdbc:mysql://localhost/db";
		String username = "root";
		String password = "password";
		Class.forName(driver);
		Connection conn = DriverManager.getConnection(url, username, password);
		return conn;
	}

	public static void fetchJSONData(String creds) throws IOException, ParseException {
		// function for fetching JSONData using credentials

		JSONParser parser = new JSONParser();

		URL myUrl = new URL("http://192.168.1.17:8080/api/json?pretty=true");
		URLConnection urlCon = myUrl.openConnection();
		urlCon.setRequestProperty("Method", "GET");
		urlCon.setRequestProperty("Accept", "application/json");
		urlCon.setConnectTimeout(5000);
		urlCon.addRequestProperty("Authorization", creds);
		// Request prepared

		InputStream is = urlCon.getInputStream();
		InputStreamReader isR = new InputStreamReader(is);
		BufferedReader reader = new BufferedReader(isR);
		StringBuffer buffer = new StringBuffer();
		String line = "";
		while ((line = reader.readLine()) != null) {
			buffer.append(line);
		}
		reader.close();
		JSONObject restData = new JSONObject();
		restData = (JSONObject) parser.parse(buffer.toString());
		System.out.println(restData);
		// Restful Data fetched.

		JSONArray jobsArray = (JSONArray) restData.get("jobs");
		// Jobs JSON Array fetched
		JSONArray viewsArray = (JSONArray) restData.get("views");
		// Jobs JSON Array fetched
		JSONObject primaryViewObject = (JSONObject) restData.get("primaryView");
		// Jobs JSON Object fetched

		System.out.println("Jobs");

		// The sql connection is established

		Connection conn = null;
		Statement stmt = null;
		try {

			conn = getConnection();
			stmt = conn.createStatement();
			stmt.executeUpdate("drop table JobTable");
			stmt.executeUpdate(query);
			stmt.executeUpdate("drop table PrimaryViewTable");
			stmt.executeUpdate("create table PrimaryViewTable (class TEXT, name TEXT, url TEXT)");
			stmt.executeUpdate(
					"insert into PrimaryViewTable (class, name, url) values ('" + primaryViewObject.get("_class")
							+ "','" + primaryViewObject.get("name") + "','" + primaryViewObject.get("url") + "')");

			stmt.executeUpdate("drop table viewsTable");
			stmt.executeUpdate("create table viewsTable (_class TEXT, name TEXT, url TEXT)");

		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		Object className = new Object();
		Object name = new Object();
		Object url = new Object();
		Object color = new Object();
		JSONObject jobsObject = new JSONObject();
		JSONObject viewsObject = new JSONObject();

		for (int i = 0; i < jobsArray.size(); i++) {
			jobsObject = (JSONObject) jobsArray.get(i);

			/* Writing data to mysql database */

			className = jobsObject.get("_class");
			name = jobsObject.get("name");
			url = jobsObject.get("url");
			color = jobsObject.get("color");

			try {
				stmt.executeUpdate("insert into JobTable(_class, name, url, color) values('" + className + "','" + name
						+ "','" + url + "','" + color + "')");
				System.out.println("Data inserted.");
			} catch (SQLException e) {
				System.out.println("error: failed to create a connection object.");
				e.printStackTrace();
			} catch (Exception e) {
				System.out.println("other error:");
				e.printStackTrace();
			}

		}

		for (int i = 0; i < viewsArray.size(); i++) {
			viewsObject = (JSONObject) viewsArray.get(i);

			/* Writing data to mysql database */

			className = viewsObject.get("_class");
			name = viewsObject.get("name");
			url = viewsObject.get("url");

			try {
				stmt.executeUpdate("insert into viewsTable(_class, name, url) values('" + className + "','" + name
						+ "','" + url + "')");
				System.out.println("Data inserted.");
			} catch (SQLException e) {
				System.out.println("error: failed to create a connection object.");
				e.printStackTrace();
			} catch (Exception e) {
				System.out.println("other error:");
				e.printStackTrace();
			}

		}
		// closing query connection
		try {
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}