package com.st_ones.common.util.clazz;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverFile.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class EverFile {

	private static Logger logger = LoggerFactory.getLogger(EverFile.class);

	/**
	 * 전체 파일을 읽어 파일의 내용을 String 으로 반환
	 * return contents of file as string
	 * @param filename
	 * @return String
	 * @throws IOException
	 */
	public static String fileReadByOffset(String filename) throws IOException {
		File file = null;
		BufferedReader in = null;
		StringWriter out = null;
		String contents = "";
		char[] buf = new char[1024];
		int len = 0;

		try {
			file = new File(filename);

			if (file.exists()) {
				in = new BufferedReader(new FileReader(file));
				out = new StringWriter();

				while ((len = in.read(buf, 0, buf.length)) != -1) {
					out.write(buf, 0, len);
				}

				contents = out.toString();
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(in != null) {
				in.close();
			}
		}

		return contents;
	}

	/**
	 * 파일 복사
	 * fileCopy
	 * @param sourceFileName
	 * @param targetFileName
	 * @throws Exception
	 */
	public static void copyFile(String sourceFileName, String targetFileName) throws Exception {

		byte[] buf = new byte[1000];
		FileInputStream fis = null;
		FileOutputStream fos = null;

		try {

			fis = new FileInputStream(sourceFileName);
			fos = new FileOutputStream(targetFileName);

			int cou = 0;

			while (((cou = fis.read(buf, 0, 1000)) > 0)) {
				fos.write(buf, 0, cou);
			}

		} catch (IOException e) {
			logger.error(e.getMessage(), e);
			throw e;
		} finally {
			if(fos != null) {
				fos.close();
			}
			if(fis != null) {
				fis.close();
			}
		}
	}

	/**
	 * 2008.10.22 이대규 한글 처리 관련 추가
	 * korean handle process
	 * @param filename
	 * @param encoding
	 * @return String
	 * @throws IOException
	 */
	public static String fileReadByOffsetByEncoding(String filename, String encoding) throws IOException {

		File file;
		BufferedReader bufferedReader = null;
		FileInputStream fileInputStream = null;
		StringWriter out;
		String contents = "";
		char[] buf = new char[1024];
		int len;

		try {

			file = new File(filename);
			fileInputStream = new FileInputStream(file);

			if (file.exists()) {
				bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream, encoding));
				out = new StringWriter();

				while ((len = bufferedReader.read(buf, 0, buf.length)) != -1) {
					out.write(buf, 0, len);
				}

				contents = out.toString();
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(bufferedReader != null) {
				bufferedReader.close();
			}
			if(fileInputStream != null) {
				fileInputStream.close();
			}
		}

		return contents;
	}

	/**
	 * 파일에 내용을 Write
	 * write to file
	 * @param filename
	 * @param contents
	 * @return boolean
	 * @throws IOException
	 */
	public static boolean fileWrite(String filename, StringBuffer contents) throws IOException {

		boolean rtn = true;
		FileWriter fw = null;

		try {
			fw = new FileWriter(filename);
			fw.write(contents.toString());
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(fw != null) {
				fw.close();
			}
		}

		return rtn;
	}

	/**
	 * 파일에 내용을 Write
	 * write to file
	 * @param filename
	 * @param contents
	 * @return boolean
	 * @throws IOException
	 */
	public static boolean fileWrite(String filename, String contents) throws IOException {

		boolean rtn = true;
		FileWriter fw = null;

		try {
			fw = new FileWriter(filename);
			fw.write(contents.toString());
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(fw != null) {
				fw.close();
			}
		}

		return rtn;
	}

	/**
	 * 파일에 내용을 주어진 인코딩으로 Write
	 * write to file with specific Encoding
	 * @param filename
	 * @param contents
	 * @param encoding
	 * @throws IOException
	 */
	public void fileWriteByEncoding(String filename, String contents, String encoding) throws IOException {

		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(filename), false), encoding));
			bw.write(contents);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(bw != null) {
				bw.close();
			}
		}
	}

	/**
	 * 파일의 전체 내용을 읽어 String buffer로 반환
	 * return contents of file as StringBuffer
	 * @param fileName
	 * @return StringBuffer
	 * @throws IOException
	 */
	public StringBuffer fileReadByAll(String fileName) throws IOException {
		StringBuffer sb = new StringBuffer();
		File fi = new File(fileName);
		BufferedReader in = null;
		FileReader fr = null;

		try {
			if (fi.exists()) {
				fr = new FileReader(fi);
				in = new BufferedReader(fr);

				String aaa = "";

				while ((aaa = in.readLine()) != null) {
					sb.append(aaa + "\n");
				}
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(in != null) in.close();
			if(fr != null) fr.close();
		}

		return sb;
	}

	/**
	 * 파일 삭제
	 * delete File
	 * @param filename
	 */
	public static void deleteFile(String filename) throws Exception {

		try {
			File fi = new File(filename);
			if (fi.exists()) {
				fi.delete();
			}
		} catch (Exception ie) {
			logger.error(ie.getMessage());
			throw new Exception(ie.getMessage());
		}
	}

	/**
	 * 파일 끝에 내용을 추가
	 * append to file
	 * @param fileName
	 * @param Contents
	 * @throws IOException
	 */
	public void appendFile(String fileName, String Contents) throws IOException {

		BufferedWriter bw = null;

		try {
			bw = new BufferedWriter(new FileWriter(fileName, true));
			bw.write(Contents, 0, Contents.length());
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if(bw != null) {
				bw.close();
			}
		}
	}

	public static void makeDir(String path) {
		File file = new File(path);

		if (!file.exists()) {
			file.mkdirs();
		}
	}

	/**
	 * 파일의 사이즈를 계산
	 * append to file
	 * @param filePath
	 * @param fileName
	 * @throws IOException
	 */
	public static String getFileSize(String filePath, String fileName){
		String size = "";

		File mFile = new File(filePath + "/" + fileName);
		if (mFile.exists()) {
			long lFileSize = mFile.length();
			size = Long.toString(lFileSize); // bytes;

		} else {
			size = "0";
		}
		return size;
	}

	/**
	 * 파일 해쉬 값을 받아온다.
	 */
	public static String fileToBinary(String filePath, String fileNm) throws Exception {
		File file = new File(filePath + fileNm);
		byte[] originfileByte = Files.readAllBytes(file.toPath()); //원본파일을 바이트배열로 변환.
		byte[] fileEncoding =  Base64.encodeBase64(originfileByte);
		String fileString = new String(fileEncoding);

		return fileString;
	}

	/**
	 * 바이너리 스트링을 파일로 변환
	 *
	 * @param binaryFile
	 * @param filePath
	 * @param fileNm
	 * @return
	 * @throws IOException
	 */
	public static File binaryToFile(String binaryFile, String filePath, String fileNm) throws IOException {

		if ((binaryFile == null || "".equals(binaryFile)) || (filePath == null || "".equals(filePath))
				|| (fileNm == null || "".equals(fileNm))) { return null; }

		FileOutputStream fos = null;

		File fileDir = new File(filePath);  //파일을 저장할 경로가 없으면 만들어 준다.
		if (!fileDir.exists()) {
			fileDir.mkdirs();
		}

		File destFile = new File(filePath + fileNm); //파일경로와 파일명을 합치고 파일 객체를 만든다.

		byte[] buff = binaryFile.getBytes();  //Base64로 인코딩된 바이너리 스트링을 Base64로 디코딩 한 후 String으로 캐스팅한다.
		String toStr = new String(buff);
		byte[] b64dec = Base64Coder.decode(toStr);

		try {
			fos = new FileOutputStream(destFile);  //바이너리 스트링을 생성한 파일객체에 써서 파일로 만든다.
			fos.write(b64dec);
			fos.close();
		} catch (IOException e) {
			logger.error("Exception position : FileUtil(IOException) - binaryToFile(String binaryFile, String filePath, String fileName)");
			throw e;
		} finally {
			if(fos != null) try { fos.close();} catch(IOException e) {
				logger.error("Exception position : FileUtil(IOException) - binaryToFile(String binaryFile, String filePath, String fileName)");
				throw e;
			}
		}

		return destFile;
	}

	/**
	 * 파일 정보를 해쉬값으로 변환
	 *
	 * @param filePath
	 * @param fileNm
	 * @throws IOException
	 */
	public static String fileToHash(File file) throws Exception {
		String hashData = "";

		BufferedInputStream fis = new BufferedInputStream(new FileInputStream(file));
		hashData = DigestUtils.sha256Hex(fis);

		// BufferedInputStream을 닫아준다.
		IOUtils.closeQuietly(fis);

		return hashData;
	}
}
