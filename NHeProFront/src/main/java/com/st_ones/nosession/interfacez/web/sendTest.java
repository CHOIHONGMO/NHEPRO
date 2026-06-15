package com.st_ones.nosession.interfacez.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class sendTest {

	public static void main(String[] args) throws Exception {

    	String pURL = "http://localhost:8381/nheproif/pms.so";
//    	String pURL = "http://test.first-epro.com/nheproif/pms.so";
    	URL url = new URL(pURL);
    	HttpURLConnection http = (HttpURLConnection)url.openConnection();
    	http.setDefaultUseCaches(false);
    	http.setDoInput(true);
    	http.setDoOutput(true);
    	http.setRequestMethod("POST");
    	http.setRequestProperty("content-type", "application/x-www-form-urlencoded");


    	String paramstr = "SEND_DATA={\"IF_ID\":\"IF-NI-0020\",\"MSTDATA\":[{\"VCBUSSSALESTEAMNAME\":\"�̷����������\",\"PROJECT_CD\":\"2062002\",\"CUR\":\"KRW\",\"PROJECT_SQ\":0,\"ITEM_RMK\":\"\",\"SUBJECT\":\"�����ϳ��������ϳ���APP����\",\"RMK_TEXT\":\"- ���� App ���� ����� �����а���� ��ȭ�� ������ ���� Ȱ��ȭ-App��ɰ�ȭ�� ���� �̿��� �߽��� ȯ��(���Ǽ�) ����- One �÷��� ����� ������ �ȴ�ä�� ���� ����\",\"DELY_TO_NM\":\"���缾�� 2��\",\"PROJECT_TYPE_NM\":\"SM2\",\"CTRL_USER_ID\":\"P0610015\",\"PR_AMT\":199200000,\"INSPECT_USER_ID\":\"P0920012\",\"DUE_DATE\":\"2020-11-28\",\"PROJECT_TYPE\":\"6\",\"REQ_USER_ID\":\"P0920012\"},{\"PURCHASE_TYPE\":\"S\",\"PR_QT\":24,\"ITEM_SPEC\":\"\",\"UNIT_PRC\":8300000,\"ITEM_DESC\":\"\",\"PR_SQ\":1,\"VENDOR_IRS_NUM\":\"2148630830\",\"UNIT_CD\":\"M/M\",\"VENDOR_NM\":\"(��)AMC\",\"ITEM_AMT\":199200000,\"ITEM_CD\":\"\"}]}";

    	OutputStreamWriter outStream = new OutputStreamWriter(http.getOutputStream(),"EUC_KR");
    	PrintWriter wr = new PrintWriter(outStream);
    	wr.write(paramstr);
    	wr.flush();


    	InputStreamReader tmp = new InputStreamReader(http.getInputStream(),"UTF-8");
    	BufferedReader reader = new BufferedReader(tmp);
    	StringBuilder builder = new StringBuilder();
    	String str = "";
    	while((str = reader.readLine()) != null) {
    		builder.append(str);
    	}

    	System.out.println("=================================================1");
    	System.out.println(builder.toString());
    	System.out.println("=================================================2");
	}

}
