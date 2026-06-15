package com.st_ones.common.util;

import com.st_ones.everf.serverside.config.PropertiesManager;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : AES128.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class AES128 {
	
	public static String key = PropertiesManager.getString("siis.aes128.key");


	public static byte[] hexToByteArray(String hex) {
		
		if ((hex == null) || (hex.length() == 0)) {			
			return null;			
		}

		byte[] ba = new byte[hex.length() / 2];

		for (int i = 0; i < ba.length; ++i) {			
			ba[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);			
		}

		return ba;	
		
	}

	public static String byteArrayToHex(byte[] ba) {
		
		if ((ba == null) || (ba.length == 0)) {			
			return null;			
		}

		StringBuffer sb = new StringBuffer(ba.length * 2);

		for (int x = 0; x < ba.length; ++x) {			
			String hexNumber = "0" + Integer.toHexString(0xFF & ba[x]);			
			sb.append(hexNumber.substring(hexNumber.length() - 2));			
		}

		return sb.toString();

	}

	public static String encrypt(String message) throws Exception {
		
		if( message == null ) message = "";

		SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES");

		Cipher cipher = Cipher.getInstance("AES");
		
		cipher.init(1, skeySpec);

		byte[] encrypted = cipher.doFinal(message.getBytes());

		return byteArrayToHex(encrypted);

	}

	public static String decrypt(String encrypted) throws Exception {
		
		if( encrypted == null ) encrypted = "";

		SecretKeySpec skeySpec = new SecretKeySpec(key.getBytes(), "AES");

		Cipher cipher = Cipher.getInstance("AES");
		
		cipher.init(2, skeySpec);

		byte[] original = cipher.doFinal(hexToByteArray(encrypted));

		String originalString = new String(original);

		return originalString;

	}
	
}