package com.st_ones.nhepro.CCPR.web;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.CCPR.service.CCPR0900_Service;

import java.io.BufferedReader; 
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.URL;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.*;

import javax.annotation.Resource;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : CCTI0100_Controller.java
 * @date 2020.07.05
 * @version 1.0
 * @see
 */

@Controller
@RequestMapping(value = "/nhepro/CCPR")
public class CCPR0900_Controller extends BaseController{
    @Autowired 
    private MessageService msg;
    @Autowired
    private CCPR0900_Service ccpr0900_Service;
//    @Autowired
//    private CommonComboService commonComboService;

	/**
	 * 화면명 :
	 * 처리내용 :
	 * 경로 :  > >
	 */
    @RequestMapping(value="/CCPR0900/view")
    public String CCPR0900(EverHttpRequest req) throws Exception {
        //req.setAttribute("fromDate", EverDate.formatDate("19000101"));
        //req.setAttribute("toDate", EverDate.formatDate("99991231"));
        return "/nhepro/CCPR/CCPR0900";
//        return "/nhepro/CCTI/CCTI0100";
    }
    
 	@RequestMapping(value = "/CCPR0900/doSearch")
 	public void cctr0100_doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> param = req.getFormData();
 		resp.setGridObject("grid", ccpr0900_Service.cctr0100_doSearch(param));
 	}
 	
  	@RequestMapping(value="/CCPR0900/ccpr0900_doConfirm")
  	public void cctr0120_doConfirm(EverHttpRequest req, EverHttpResponse resp) throws Exception {
  		
  		Map<String, String> param = req.getFormData();
  		String progressCd = EverString.nullToEmptyString(req.getParameter("progressCd"));
  		param.put("PROGRESS_CD", progressCd);
  		List<Map<String, Object>> gridData = req.getGridData("grid");

  		ccpr0900_Service.ccpr0900_doConfirm(param, gridData);
  		resp.setResponseMessage(msg.getMessage("0057"));
  	}
  	
 	@RequestMapping(value = "/CCPR0900/doSave")
 	public void ccti0090_doSave(EverHttpRequest req, EverHttpResponse resp) throws Exception {

 		Map<String, String> dataForm = req.getFormData();

 		List<Map<String, Object>> gridData  = req.getGridData("grid");  // 개인근로자

 		ccpr0900_Service.ccpr0900_doSave(dataForm, gridData);

 		resp.setResponseMessage(msg.getMessage("0021"));
 		resp.setResponseCode("true");
 	}

 	@RequestMapping(value = "/CCPR0900/doUpdate")
    public void getInterface(EverHttpRequest req, EverHttpResponse resp) throws Exception {
 		System.out.println("getInterface::::::::::::START");
        HttpURLConnection conn = null;
        Map<String,Object> result = new HashMap<String,Object>();
        UserInfo userInfo = UserInfoManager.getUserInfo();
        String id = userInfo.getUserId();
        try{
//            String host = InetAddress.getLocalHost().getHostAddress();
            String apiHost = "https://fms.nhpartners.co.kr";

            URL url = new URL(apiHost+"/common/getApiEmp.ajax");
            
//            TrustManager[] trustAllCerts = new TrustManager[] {new X509TrustManager() {
//            
//            	public X509Certificate[] getAcceptedIssuers() {return null;}
//            	public void checkServerTrusted(X509Certificate[] certs, String authType) {};
//            	public void checkClientTrusted(X509Certificate[] certs, String authType) {};            	
//            }};
//            		
//            SSLContext sc = SSLContext.getInstance("SSL");
//            sc.init(null, trustAllCerts, new java.security.SecureRandom());
//            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
//            HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
//				
//				@Override
//				public boolean verify(String arg0, SSLSession arg1) {
//					// TODO Auto-generated method stub
//					return true;
//				}
//			});
           
            System.setProperty("https.protocols", "TLSv1.2");
            System.setProperty("jsse.enableSNIExtension", "false");
            conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
            conn.setDoOutput(true);
            conn.setDoInput(true);
            conn.setUseCaches(false);
            conn.setAllowUserInteraction(true);

            StringBuilder postData = new StringBuilder();
            postData.append("saleSabun");
            postData.append("=");
            postData.append(id);

            PrintWriter pw = new PrintWriter(new OutputStreamWriter(conn.getOutputStream(),"utf-8"));
            pw.write(postData.toString());
            pw.flush();

            int resCode = conn.getResponseCode();
            StringBuffer resps = new StringBuffer();

            if (resCode == 400){
            	//LOGGER.error("400");
            	System.out.println("getInterface::::::::::::"+"400");
                result.put("result", "fail");
            } else if(resCode == 401){
                result.put("result", "fail");
                System.out.println("getInterface::::::::::::"+"401");
                //LOGGER.error("401");
            } else if(resCode == 500){
                result.put("result", "fail");
                System.out.println("getInterface::::::::::::"+"500");
                //LOGGER.error("500");
            }else{
                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
                String line = "";
                while((line = br.readLine()) != null){
                	resps.append(line);
                }
                //System.out.println("getInterface::::::::::::"+resps.toString());
                ObjectMapper mapper = new ObjectMapper();
                List<Map<String, Object>> list = mapper.readValue(resps.toString(), new TypeReference<ArrayList<HashMap<String, Object>>>(){});
                result.put("data", resps.toString());
                result.put("result", "success");
                System.out.println("getInterface::::::::::::FINISH"); 
                //System.out.println(list.get(0));

                pw.close();
                br.close();
                
                ccpr0900_Service.ccpr0900_doUpdate(list);

            }

            result.put("result", "success");
        } catch (Exception e) {
            e.printStackTrace();
            result.put("result", "fail");
            resp.setResponseCode("false");
            return;
        }

        resp.setResponseCode("true");
    } 	 	
 	
}

