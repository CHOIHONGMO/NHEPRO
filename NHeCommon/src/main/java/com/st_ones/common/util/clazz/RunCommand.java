package com.st_ones.common.util.clazz;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : RunCommand.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class RunCommand {

	/**
	 * 콘솔 명령어 실행
	 * excute console command
	 * @param cmd
	 * @return C:\Users\Administrator\Downloads
	 * @throws IOException
	 */
	Escape escape = new Escape();
	
	public static String runCommand(String cmd) throws IOException {
		Escape.setEscape(cmd);
		Process p = Runtime.getRuntime().exec(cmd);
		InputStream in = p.getInputStream();
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		String s = "";
		String temp = "";

		while ((temp = br.readLine()) != null) {
			s += (temp + "n");
		}

		br.close();
		in.close();
		return s;
	}
}
