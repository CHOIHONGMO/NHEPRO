package com.st_ones.batch.nhebatch;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class InterFaceCommon {

	private static Logger logger = LoggerFactory.getLogger(InterFaceCommon.class);

	public static List<Map<String,String>> parseFile(String completeFolder, File file, String dlim, int paramCount, String param) throws Exception {

		List<Map<String,String>> returnMap = new ArrayList<Map<String,String>>();
		FileInputStream fileinputstrem = new FileInputStream(file);
		InputStreamReader fileReader = new InputStreamReader(fileinputstrem,"EUC-KR");
		BufferedReader bufReader = new BufferedReader(fileReader);
		try {

			String line = "";
			String[] para = param.split(",");
			//System.err.println("=====================================para="+para.length);
			while((line = bufReader.readLine()) != null) {
				line = line.replaceAll("'", "");
				//System.err.println("=============line=="+line);
				String[] sp = line.split(dlim,paramCount);
				//System.err.println("======================================="+sp.length);
	//			if(sp.length != paramCount) {
	//				continue;
	//			}

				Map<String,String> orgData = new HashMap<String,String>();
				int cou = 0;
				for(String name : para) {
					orgData.put(name,sp[cou++]);
				}
				returnMap.add(orgData);
			}
		} catch (Exception e) {
			e.printStackTrace();
//			System.err.println("============================================================BAD======="+completeFolder+"/BAD/"+file.getName());
//			file.renameTo(new File(completeFolder+"/BAD/"+file.getName()));
			returnMap = new ArrayList<Map<String,String>>();
		} finally {
			if(bufReader != null) { bufReader.close(); }
			if(fileReader != null) { fileReader.close(); }
		}
		return returnMap;
	}

	public static List<Map<String,String>> parseFileInsa(File file,String dlim,int paramCount,String param) throws Exception {
		List<Map<String,String>> returnMap = new ArrayList<Map<String,String>>();
		FileInputStream fileinputstrem = new FileInputStream(file);
		InputStreamReader fileReader = new InputStreamReader(fileinputstrem,"EUC-KR");
		BufferedReader bufReader = new BufferedReader(fileReader);
		String line = "";
		Set<String> userIdSet = new HashSet<>();
		try {
			String[] para = param.split(",");
			while ((line = bufReader.readLine()) != null) {

				if (line.indexOf("퇴직자") != -1) continue;


				line = line.replaceAll("'", "");
				String[] sp = line.split(dlim);
				if (sp.length != paramCount) {
					continue;
				}

				Map<String, String> orgData = new HashMap<String, String>();
				int cou = 0;
				boolean addFlag=true;
				
				for (String name : para) {
					if(name.equals("USER_ID")) {
						// 중복 사번 -> 제거 
						if(userIdSet.contains(sp[cou])) {
							addFlag = false;
							break;
						}
						userIdSet.add(sp[cou]);
					}
					orgData.put(name, sp[cou++]);
					
				}
				
				if(addFlag) {
					returnMap.add(orgData);
				}
			}
		} catch(Exception e) {
			logger.error(e.getMessage());
		} finally {
			bufReader.close();
			fileReader.close();
		}
		return returnMap;
	}
	
	/*
	 * chk파일은 패스, 일반파일도 chk파일이 존재한건만 처리
	 * 파일은 dat와 chk 파일이 두개가 쌍으로 존재하여야 한다.
	 */
	public static boolean escapeChkFile(File file) throws Exception {
		String fullFileName = file.getName();
		String pathFileName = file.getAbsolutePath();
		String fileName = pathFileName.substring(0, pathFileName.indexOf("."));
		String ext = fullFileName.substring(fullFileName.indexOf(".")+1,fullFileName.length());

//		System.err.println("========================================fileName=="+fileName);
//		System.err.println("========================================ext=="+ext);

		if("chk".equals(ext)) return false;

		File chkFile = new File(fileName+".chk");
//		System.err.println(chkFile.getAbsolutePath()+"========================================chkFile.exists=="+chkFile.exists());
		if(!chkFile.exists()) {
			return false;
		}
		return true;
	}


}