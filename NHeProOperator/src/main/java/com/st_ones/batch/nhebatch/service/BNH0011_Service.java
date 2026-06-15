package com.st_ones.batch.nhebatch.service;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0011_Mapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
/**
 *
 * @author divin
 *
 */
@Service(value = "BNH0011_Service")
public class BNH0011_Service {

	private static Logger logger = LoggerFactory.getLogger(BNH0011_Service.class);

	@Autowired private MessageService msg;
	@Autowired private BNH0011_Mapper bnh0011mapper;
    @Autowired private DocNumService docNumService;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0011_Service===================================================");
		
    	List<Map<String,String>> ecctListITA = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecmtListITA = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecpcListITA = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecpyListITA = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecbvListITA = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> atchListITA = new ArrayList<Map<String,String>>();
    	
    	List<Map<String,String>> ecctListITB = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecmtListITB = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecpcListITB = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecpyListITB = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> ecbvListITB = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> atchListITB = new ArrayList<Map<String,String>>();
    	
		// 대상가져오기
		List<Map<String, String>> contList = null;
		System.err.println("============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv============================="+param.get("CONT_NUM"));
		if (!"".equals(param.get("CONT_NUM")) && !"null".equals(param.get("CONT_NUM")) && param.get("CONT_NUM") != null) {
			contList = bnh0011mapper.getTragetContListXXXXX(param);
		} else {
			contList = bnh0011mapper.getTragetContList(new HashMap<String,String>());
		}
		
		for(Map<String, String> cont : contList) {
			
			cont.put("IF_TYPE", "ITA");
    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================-10");
	    	Map<String,Object> ITAdata = makeData(cont);
    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================0");
	    	if(ITAdata!=null) {
	    		ecctListITA.add((Map<String,String>)ITAdata.get("ecct"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================1");
	    		ecmtListITA.addAll((List<Map<String, String>>)ITAdata.get("ecmt"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================2");
	    		ecpcListITA.addAll((List<Map<String, String>>)ITAdata.get("ecpc"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================3");
	    		ecpyListITA.addAll((List<Map<String, String>>)ITAdata.get("ecpy"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================4");
	    		ecbvListITA.addAll((List<Map<String, String>>)ITAdata.get("ecbv"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================5");
	    		atchListITA.addAll((List<Map<String, String>>)ITAdata.get("atch"));
	    		System.err.println("A============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================6");
	    	}

	    	cont.put("IF_TYPE", "ITB");
    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================-1");
	    	Map<String,Object> ITBdata = makeData(cont);
    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================0");
	    	if(ITBdata!=null) {
	    		ecctListITB.add((Map<String,String>)ITBdata.get("ecct"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================1");
	    		ecmtListITB.addAll((List<Map<String, String>>)ITBdata.get("ecmt"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================2");
	    		ecpcListITB.addAll((List<Map<String, String>>)ITBdata.get("ecpc"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================3");
	    		ecpyListITB.addAll((List<Map<String, String>>)ITBdata.get("ecpy"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================4");
	    		ecbvListITB.addAll((List<Map<String, String>>)ITBdata.get("ecbv"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================5");
	    		atchListITB.addAll((List<Map<String, String>>)ITBdata.get("atch"));
	    		System.err.println("B============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================6");
	    	}
		}

		System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================1");
		if(ecctListITA.size()!=0 || ecctListITB.size()!=0) {
			Map<String, String> fileInfo = bnh0011mapper.getFileSeq(new HashMap<String,String>());
			System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================2");
			String fileSq = docNumService.getDocNumber("1000", "FI");
			System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================3");
			fileInfo.put("SEQ", fileSq.substring(4,fileSq.length()));
			System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================4");
			makeFile("ITA",fileInfo, ecctListITA,ecmtListITA,ecpcListITA,ecpyListITA,ecbvListITA,atchListITA);
			System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================5");
			makeFile("ITB",fileInfo, ecctListITB,ecmtListITB,ecpcListITB,ecpyListITB,ecbvListITB,atchListITB);
			System.err.println("FileWriter============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================6");
		}
		System.err.println("Finsh============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================6");
		
		// 완료처리
		for(Map<String, String> cont : contList) {
			System.err.println("Finsh============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================7");
			bnh0011mapper.completeTarget(cont);
		}
		
		return msg.getMessage("0001");
	}


    public Map<String,Object> makeData( Map<String,String> param ) throws Exception {
    	Map<String,Object> returnMap = new HashMap<String,Object>();
    	
    	// 해당 IF_TYPE (ITA,ITB) 체크 없으면 NULL 리턴
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================1");
    	List<Map<String, String>> ecmtData = bnh0011mapper.getContTarget(param);
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================2");
    	if (ecmtData.size() == 0) return null;
    	Map<String,String> ecct = bnh0011mapper.makeEcct(param);
    	
    	if (!EverString.isEmpty(ecct.get("CONT_DESC"))){
			ecct.put("CONT_DESC", EverString.replace(ecct.get("CONT_DESC"), ">", ")"));
		}
		if (!EverString.isEmpty(ecct.get("DELAY_RMK"))) {
    		ecct.put("DELAY_RMK", EverString.replace(ecct.get("DELAY_RMK"), ">", ")"));
    	}
		
    	System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================3");
    	List<Map<String, String>> ecmt = bnh0011mapper.makeEcmt(param);
    	
    	for(int i = 0; i < ecmt.size(); i++) {
            if (!EverString.isEmpty(ecmt.get(i).get("ITEM_DESC"))) {
            	ecmt.get(i).put("ITEM_DESC", EverString.replace(ecmt.get(i).get("ITEM_DESC"), ">", ")"));
        	}
            
            if (!EverString.isEmpty(ecmt.get(i).get("ITEM_SPEC"))) {
            	ecmt.get(i).put("ITEM_SPEC", EverString.replace(ecmt.get(i).get("ITEM_SPEC"), ">", ")"));
        	}
    	}
    	
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================4");

    	long CONT_AMT_5 = Long.parseLong(String.valueOf(ecct.get("5_CONT_AMT")));
    	long CONT_AMT_1 = Long.parseLong(String.valueOf(ecct.get("1_CONT_AMT")));

    	if (CONT_AMT_5>0 && CONT_AMT_1>0) {
        	param.put("IF_TYPE2","ALL");
    	} else if (CONT_AMT_5>0) {
        	param.put("IF_TYPE2","ITA");
    	} else if (CONT_AMT_1>0) {
        	param.put("IF_TYPE2","ITB");
    	} else {
        	param.put("IF_TYPE2","ALL");
    	}

    	System.err.println("=======================================================CONT_AMT_5="+CONT_AMT_5);
    	System.err.println("=======================================================CONT_AMT_1="+CONT_AMT_1);
    	System.err.println("=======================================================IF_TYPE2="+param.get("IF_TYPE2"));

		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================5");
    	List<Map<String, String>> ecpc = bnh0011mapper.makeEcpc(param);
    	
    	for(int i = 0; i < ecpc.size(); i++) {
            if (!EverString.isEmpty(ecpc.get(i).get("RMK"))) {
            	ecpc.get(i).put("RMK", EverString.replace(ecpc.get(i).get("RMK"), ">", ")"));
        	}
    	}
    	
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================6");
    	List<Map<String, String>> ecpy = bnh0011mapper.makeEcpy(param);
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================7");


    	param.put("VENDOR_CD", ecct.get("VENDOR_CD"));
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================8");
    	List<Map<String, String>> ecbv = bnh0011mapper.makeEcbv(param);
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================9");
    	List<Map<String, String>> atch = bnh0011mapper.makeAtch(param);
		System.err.println("K============================================vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv=============================10");
    	
		// 농협정보소속이면서 중앙회 소속인 'EP' 가 붙은 ID들은 주재현차장님 ID로 변경하여 MCA데이터 전송해야함
		List<Map<String,String>>  mapList = new LinkedList<Map<String,String>>();
		List<Map<String, String>> targetIdList= bnh0011mapper.getTargetRegUserId();
		List<String> epIdList = new ArrayList<String>(); 
		for(Map<String,String> map : targetIdList) {
			epIdList.add(map.get("CODE"));
		}
		
		if ( targetIdList != null && targetIdList.size() != 0) {
			changeRegUserId(ecct,targetIdList,epIdList);
	    	changeRegUserId(ecmt,targetIdList,epIdList);
	    	changeRegUserId(ecpc,targetIdList,epIdList);
	    	changeRegUserId(ecpy,targetIdList,epIdList);
	    	changeRegUserId(ecbv,targetIdList,epIdList);
	    	changeRegUserId(atch,targetIdList,epIdList);
		}
		
		// 계약서 파일의 BIZ_TYPE은 ECE여야함. 현재 EC로 저장되고있어 이를 치환
		String contNum = param.get("CONT_NUM");
		String contCnt = String.valueOf(param.get("CONT_CNT"));
		changeBizType(atch, contNum, contCnt);
		
		
		returnMap.put("ecct", ecct); 
    	returnMap.put("ecmt", ecmt); 
    	returnMap.put("ecpc", ecpc); 
    	returnMap.put("ecpy", ecpy); 
    	returnMap.put("ecbv", ecbv); 
    	returnMap.put("atch", atch);
    	
    	return returnMap;
    }
    
    
    private void changeBizType(List<Map<String,String>> atchMap, String ECNum, String ECCnt){
    	for( Map<String,String> target : atchMap) {
    		String companyCd = target.get("BUYER_CD");
    		String fileExtension = target.get("FILE_EXTENSION");
    		// fileNm: "${ses.companyCd}" + contNum + contCnt
    		boolean isECE = target.get("BIZ_TYPE").equals("EC") && 
    						target.get("REAL_FILE_NM").equals( companyCd + ECNum + ECCnt + "." + fileExtension);
    		
    		// ECE로 바꿔야하는 파일인 경우 (계약서)
    		if(isECE) {
    			target.put("BIZ_TYPE", "ECE");
    		}
    		
		}
    }
    
    private void changeRegUserId(Map<String, String> param, List<Map<String, String>> targetIdList, List<String> epIdList) {
    	// 주재현 차장님 ID
    	
    	Set<String> keys = param.keySet();
    	for(String key : keys ) {
    		String value = String.valueOf(param.get(key));
    		
    		// 계약에포함된 value값이 EP가 들어간 ID일경우 (P0610023EP, P1810022EP 등) -> 주재현차장님ID(04301524)로 치환
			if( epIdList.contains(value) ) {
				// 해당 EP ID와 매핑된 ID(현재는 모두 04301524) 로 치환
				for( Map<String,String> target : targetIdList) {
					if( target.get("CODE").equals(value) ) {
						String toChangeId = target.get("CODE_DESC");
						param.put(key, toChangeId);
					}
				}
			}
    	}
	}

	private void changeRegUserId(List<Map<String, String>> param, List<Map<String, String>> targetIdList, List<String> epIdList) {
		// TODO Auto-generated method stub
		
		for (Map<String, String> item : param) {
			Set<String> keys = item.keySet();
	    	for(String key : keys ) {
	    		String value = String.valueOf(item.get(key));
	    		
	    		// 계약에포함된 value값이 EP가 들어간 ID일경우 (P0610023EP, P1810022EP 등) -> 주재현차장님ID(04301524)로 치환
				if( epIdList.contains(value) ) {
					// 해당 EP ID와 매핑된 ID(현재는 모두 04301524) 로 치환
					for( Map<String,String> target : targetIdList) {
						if( target.get("CODE").equals(value) ) {
							String toChangeId = target.get("CODE_DESC");
							item.put(key, toChangeId);
						}
					}
				}
	    	}
		}
	}

	public void makeFile(
    			 String type
    			,Map<String, String> fileInfo
    			,List<Map<String,String>> ecctList
    			,List<Map<String,String>> ecmtList
    			,List<Map<String,String>> ecpcList
    			,List<Map<String,String>> ecpyList
    			,List<Map<String,String>> ecbvList
    			,List<Map<String,String>> atchList
    		) throws Exception {

        String tempFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0011.temp");
        String completeFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0011");

        System.err.println("=====================tempFolder="+tempFolder);
        System.err.println("=====================completeFolder="+completeFolder);

    	if (ecctList.size()!=0) {// 계약마스터가 존재하지 않으면 패스
	        String fileName = "";
	        String tempFileName = "";
	        String completeFileName = "";
	        String seq = fileInfo.get("SEQ");
	        String today = fileInfo.get("TODAY");
	        String totime = fileInfo.get("TOTIME");

	        if ("ITA".equals(type)) {
	        	fileName="EPNCXXXX_"+today+"_"+today+"_"+seq+"_FDC6.dat";
	        } else {
	        	fileName="EPNBXXXX_"+today+"_"+today+"_"+seq+"_FDA3.dat";
	        }

	        if(ecctList.size()!=0) {
	        	String[] ecctArray = {
	        			"GATE_CD","BUYER_CD","CONT_NUM","CONT_CNT","REG_DATE","REG_USER_ID","MOD_DATE"
	        			,"MOD_USER_ID","DEL_FLAG","PROGRESS_CD","CONT_DATE","CONT_START_DATE","CONT_END_DATE","CONT_DESC"
	        			,"CONT_REQ_CD","CUR","CONT_AMT","VAT_TYPE","SUPPLY_AMT","VAT_AMT","DEPT_CD","CONT_USER_ID","VENDOR_CD","VENDOR_PIC_USER_NM"
	        			,"VENDOR_PIC_USER_EMAIL","VENDOR_PIC_USER_CELL_NUM","DELAY_RMK","DELAY_NUME_RATE","DELAY_DENO_RATE","STAMP_DUTY_FLAG"
	        			,"STAMP_DUTY_AMT","STAMP_ATT_FILE_NUM","CONT_RMK","ATT_FILE_NUM","VENDOR_ATT_FILE_NUM","BUNDLE_NUM"
	        			,"SEND_DATE","CONT_CLOSE_DATE","CONT_CLOSE_RMK","CERT_TYPE","AMT_TYPE","MANUAL_CONT_FLAG","VENDOR_EDIT_FLAG","ORIGIN_CONT_START_DATE"
	        			,"AUTO_RENEW_FLAG","AUTO_RENEW_DATE","AUTO_RENEW_CNT","APPROVAL_FLAG","APP_DOC_NUM","APP_DOC_CNT","SIGN_STATUS","SIGN_DATE"
	        			,"IRS_NO","BUSINESS_SIZE","VENDOR_NM","FINAL_ESTM_PRC","RECEIPT_DATE","CONT_USER_NM","VOTE_CNT","ENTER_MAN_ID","ENTER_MAN_NM"
	        			,"ENTER_MAN_DEPT_ID","ENTER_MAN_DEPT_NM","5_CONT_AMT","1_CONT_AMT","3_CONT_AMT","2_CONT_AMT","A_CONT_AMT","B_CONT_AMT","D_CONT_AMT"
	        			,"C_CONT_AMT","5_VAT_AMT","1_VAT_AMT","3_VAT_AMT","2_VAT_AMT","A_VAT_AMT","B_VAT_AMT","D_VAT_AMT","C_VAT_AMT","BID_DATE","ARB_APP_NM"
	        	};

	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECCT");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECCT");
	        	fileWrite(tempFileName,completeFileName,ecctArray,totime,ecctList,false);
	        }
	        if(ecmtList.size()!=0) {
	        	String[] ecmtArray = {
	        			 "GATE_CD","BUYER_CD","CONT_NUM","CONT_CNT","PR_BUYER_CD","PR_DEPT_CD","VENDOR_CD","ITEM_SQ","REG_DATE","REG_USER_ID","MOD_DATE","MOD_USER_ID"
	        			,"DEL_FLAG","IRS_NO","CONT_WT_NUM","EXEC_NUM","EXEC_SQ","PURCHASE_TYPE","ITEM_CD","ITEM_DESC","ITEM_SPEC","MAKER_CD","MAKER_NM","MAKER_PART_NO"
	        			,"ORIGIN_CD","ITEM_QT","UNIT_CD","ITEM_PRC","ITEM_AMT","SW_BIZ_AMT","MNT_SANGJU_YN","CONSUMER_AMT","FC_MNT_TERM","CH_RATE","DOIB_AMOUNT","MNT_RATE"
	        			,"MNT_SDAY","MNT_EDAY","MNT_GUR_MONTH","RT_INSP_PERIOD","FALT_RC_TG_TIME","DUE_DATE","IV_BUYER_CD","IV_DEPT_CD","IV_USER_ID","PR_NUM","PR_SQ","CM_REQ_ID"
	        			,"CM_REQ_DET_ID","MULPUM_ID","VENDOR_OPEN_TYPE","SUBMIT_TYPE","DISCOUNT_RATE","5_CONT_AMT","1_CONT_AMT","3_CONT_AMT","2_CONT_AMT","A_CONT_AMT","B_CONT_AMT"
	        			,"D_CONT_AMT","C_CONT_AMT","5_VAT_AMT","1_VAT_AMT","3_VAT_AMT","2_VAT_AMT","A_VAT_AMT","B_VAT_AMT","D_VAT_AMT","C_VAT_AMT","CORP_TYPE"
	        	};
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECMT");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECMT");
	        	fileWrite(tempFileName,completeFileName,ecmtArray,totime,ecmtList,false);
	        }
	        if(ecpcList.size()!=0) {
	        	String[] ecpcArray = {
	        			 "GATE_CD","BUYER_CD","CONT_NUM","CONT_CNT","PR_BUYER_CD","PR_DEPT_CD","VENDOR_CD","PAY_CNT","PY_BUYER_CD","PY_DEPT_CD"
	        			,"REG_DATE","REG_USER_ID","MOD_DATE","MOD_USER_ID","DEL_FLAG","IRS_NO","PAY_AMT","GUAR_TYPE","GUAR_PERCENT","GUAR_QT"
	        			,"VAT_FLAG","GUAR_AMT","ATT_FILE_NUM","GUAR_NUM","INSU_STATUS","RMK","GUAR_TYPE2","GUARANTEER","CORP_TYPE","PY_CORP_TYPE"
	        	};
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECPC");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECPC");
	        	fileWrite(tempFileName,completeFileName,ecpcArray,totime,ecpcList,false);
	        }
	        if(ecpyList.size()!=0) {
	        	String[] ecpyArray = {
	        			"GATE_CD","BUYER_CD","CONT_NUM","CONT_CNT","PR_BUYER_CD","PR_DEPT_CD","VENDOR_CD","PAY_CNT","REG_DATE","REG_USER_ID"
	        			,"MOD_DATE","MOD_USER_ID","DEL_FLAG","PAY_CNT_TYPE","PAY_CNT_NM","PAY_PERCENT","PAY_AMT","PAY_METHOD_TYPE","PAY_METHOD_NM"
	        			,"PAY_DUE_DATE","IRS_NO","CORP_TYPE"
	        	};
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECPY");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECPY");
	        	fileWrite(tempFileName,completeFileName,ecpyArray,totime,ecpyList,false);
	        }
	        if(ecbvList.size()!=0) {
	        	String[] ecbvArray = {
	        			 "GATE_CD","BUYER_CD","CONT_NUM","CONT_CNT","VENDOR_CD","REG_DATE","REG_USER_ID","SELECT_FLAG","VENDOR_NM"
	        			,"IRS_NO","VENDOR_PIC_USER_NM","VENDOR_PIC_USER_EMAIL","VENDOR_PIC_USER_CELL_NUM"
	        	};
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECBV");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECBV");
	        	fileWrite(tempFileName,completeFileName,ecbvArray,totime,ecbvList,false);
	        }
	        if(atchList.size()!=0) {
	        	String[] atchArray = {
	        			"GATE_CD","UUID","UUID_SQ","FILE_NM","FILE_PATH","FILE_SIZE","FILE_EXTENSION","REAL_FILE_NM"
	        			,"BIZ_TYPE","REG_DATE","REG_USER_ID","MOD_DATE","MOD_USER_ID","FILE_SQ","DEL_FLAG","ENC_FLAG"
	        			,"BUYER_CD","CONT_NUM","CONT_CNT","PR_BUYER_CD","PR_DEPT_CD"
	        	};
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ACTH");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ACTH");
	        	fileWrite(tempFileName,completeFileName,atchArray,totime,atchList,true);
	        }

	        // 모둔 파일 생성후 complete Copy 한다.
	        if(ecctList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECCT");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECCT");
	    		copyFile(tempFileName, completeFileName,ecctList.size(),totime);
	        }
	        if(ecmtList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECMT");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECMT");
	    		copyFile(tempFileName, completeFileName,ecmtList.size(),totime);
	        }
	        if(ecpcList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECPC");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECPC");
	    		copyFile(tempFileName, completeFileName,ecpcList.size(),totime);
	        }
	        if(ecpyList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECPY");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECPY");
	    		copyFile(tempFileName, completeFileName,ecpyList.size(),totime);
	        }
	        if(ecbvList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ECBV");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ECBV");
	    		copyFile(tempFileName, completeFileName,ecbvList.size(),totime);
	        }
	        if(atchList.size()!=0) {
	        	tempFileName = tempFolder+fileName.replace("XXXX", "ACTH");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ACTH");
	    		copyFile(tempFileName, completeFileName,atchList.size(),totime);

	        	tempFileName = tempFolder+fileName.replace("XXXX", "ACTZ");
	        	completeFileName = completeFolder+fileName.replace("XXXX", "ACTZ");
	        	tempFileName = tempFileName.substring( 0, tempFileName.lastIndexOf("."))+".dat";
	        	completeFileName = completeFileName.substring( 0, completeFileName.lastIndexOf("."))+".dat";
	        	copyFile(tempFileName, completeFileName,0,totime);
	        }
    	}
    }

    public void fileWrite(String tempFileName,String completeFileName,String[] names,String totime,List<Map<String,String>> dataList,boolean attachYn) throws Exception {
//    	File file = new File(tempFileName);
//		FileWriter fw = new FileWriter(file);
		FileOutputStream fileoutputstream = null;
		OutputStreamWriter outputstreamwriter  = null;
        BufferedWriter  bufferedwriter  = null;

    	try {
			fileoutputstream = new FileOutputStream(tempFileName);
			outputstreamwriter = new OutputStreamWriter(fileoutputstream,"EUC-KR");
	        bufferedwriter = new BufferedWriter(outputstreamwriter);
	        for(int i=0;i<dataList.size();i++) {
				Map<String,String> data = dataList.get(i);
				for(int k=0;k < names.length;k++) {
					String value = data.get(names[k]) == null ? "" : String.valueOf(data.get(names[k]));
					if (k==0) {
						bufferedwriter.write(value);
					} else {
						bufferedwriter.write(">>>>"+value);
					}
				}
				if(i!=dataList.size()-1) {
					bufferedwriter.write("\n");
				}
			}
			//fw.close();
		} catch (Exception e) {
			e.printStackTrace();
    		logger.error(e.getMessage());
			throw e;
		} finally {
			bufferedwriter.close();
			outputstreamwriter.close();
			fileoutputstream.close();
		}

		// 계약서 첨부파일 압축하기
		if (attachYn) {
			ZipOutputStream zipOut = null;
			FileOutputStream fos = null;
			try {
				String zipFile = tempFileName.replace("ACTH", "ACTZ").substring( 0, tempFileName.lastIndexOf("."))+".dat";
				fos = new FileOutputStream(zipFile);
				zipOut = new ZipOutputStream(fos);
				for(int i=0;i<dataList.size();i++) {

					Map<String,String> data = dataList.get(i);
					File fileToZip = new File(data.get("FILE_PATH")+"/"+data.get("FILE_NM")+"."+data.get("FILE_EXTENSION"));
					System.err.println("==================================================================fileToZip="+fileToZip);
					if (fileToZip.exists()) {
						FileInputStream fis = null;
						try {
							fis = new FileInputStream(fileToZip);
//							ZipEntry zipEntry = new ZipEntry(data.get("REAL_FILE_NM"));
							ZipEntry zipEntry = new ZipEntry(data.get("FILE_NM")+"."+data.get("FILE_EXTENSION"));
							zipOut.putNextEntry(zipEntry);
							byte[] bytes = new byte[1024];
							int length;
							while ((length = fis.read(bytes)) >= 0) {
								zipOut.write(bytes, 0, length);
							}
						} catch (Exception e) {
							logger.error(e.getMessage());
						} finally {
							fis.close();
						}
					}
				}
			} catch (Exception e) {
				logger.error(e.getMessage());
				throw e;
			} finally {
				zipOut.close();
				fos.close();
			}
		}
    }

	public void copyFile(String sourceFileName, String targetFileName,int lineCou,String totime) throws Exception {
		byte[] buf = new byte[1000];
		FileInputStream fis = null;
		FileOutputStream fos = null;
		System.err.println(sourceFileName+"=======================copyFilecopyFilecopyFilecopyFilecopyFilecopyFilecopyFile====================="+targetFileName);
		try {
	        String completeFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0011");
	        File sourceFile = new File(EverString.cleanString(sourceFileName));
	        if (sourceFile.exists()) {
				fis = new FileInputStream(EverString.cleanString(sourceFileName));
				fos = new FileOutputStream(targetFileName);

				int cou=0;
				while (((cou=fis.read(buf, 0, 1000)) > 0)) {
					fos.write(buf, 0, cou);
				}

				String chkText = "";
//				파일명|파일Size(byte단위)|생성일자(HHMMSS)|라인수||||||
				File file = new File(sourceFileName);
				chkText = file.getName()+"|"+file.length()+"|"+totime+"|"+lineCou+"||||||";
				String chkFileName = completeFolder
						+file.getName().substring(0,file.getName().lastIndexOf("."))
						+".chk";
				//System.err.println(chkText+"===================="+chkFileName);
				File chkFile = new File(chkFileName);
				FileWriter fw = new FileWriter(chkFile);
				fw.write(chkText);
				fw.close();
	        }
		} catch (IOException e) {
			e.printStackTrace();
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
}

