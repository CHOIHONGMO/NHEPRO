package com.st_ones.nosession.interfacez.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.util.clazz.EverConverter;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nosession.interfacez.PmsMapper;

@Service
public class PmsService extends BaseService {

    @Autowired
    PmsMapper pmsmapper;

    @Autowired private DocNumService docNumService;
    @Autowired private LargeTextService largeTextService;



    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void pms_doSave(Map<String, Object> param) throws Exception {
    	Map<String,Object> pr_header = null;
    	List<Map<String,Object>> pr_itemList = new ArrayList<Map<String,Object>>();

    	List<Map<String, Object>> eiLists = new ObjectMapper().readValue(EverConverter.getJsonString(param.get("MSTDATA")), List.class);

    	if (eiLists.size()==1) {
    		pr_header = eiLists.get(0);
    	} else {
    		pr_header = eiLists.get(0);
        	for(int k = 0; k < eiLists.size(); k++) {
        		if(k != 0) {
        			Map<String,Object> pr_item = eiLists.get(k);
        			pr_item.put("DELY_TO_NM",pr_header.get("DELY_TO_NM"));
        			pr_item.put("ITEM_RMK",pr_header.get("ITEM_RMK"));
        			pr_item.put("CTRL_USER_ID",pr_header.get("CTRL_USER_ID"));
        			pr_itemList.add(pr_item);
        		}
        	}
    	}
    	System.out.println("=================pr_header="+pr_header);
    	System.out.println("=================pr_item="+pr_itemList);

    	Map<String, String> chk = pmsmapper.prCheck(pr_header);
    	String chk_exist_yn    = chk.get("EXIST_YN");
    	String chk_sign_status = chk.get("SIGN_STATUS");
    	String chk_buyer_cd    = chk.get("BUYER_CD");
    	String chk_pr_num      = chk.get("PR_NUM");
    	
    	String rmkText = largeTextService.saveLargeText(null, String.valueOf(pr_header.get("RMK_TEXT")));
    	pr_header.put("RMK_TEXT_NUM", rmkText);

    	if (!"P".equals(chk_sign_status) && !"E".equals(chk_sign_status)) {// 결재중이거나 결재완료건은 반영하지 않는다.

    		if ("N".equals(chk_exist_yn)) { // 없으면 INSERT
	    		String buyer_cd = "C00007";
	        	String prNo = docNumService.getDocNumber(buyer_cd, "PR");// 일단 BUYER_CD C00007으로 고정
	        	pr_header.put("BUYER_CD", buyer_cd);
	        	pr_header.put("PR_NUM", prNo);
	        	pmsmapper.insPrhd(pr_header);
	        	
	        	int prSq = 1;
	        	for(Map<String,Object> item: pr_itemList ) {
	        		item.put("BUYER_CD", buyer_cd);
	        		item.put("PR_NUM", prNo);
	        		item.put("PR_SQ", prSq++);
	        		item.put("REQ_USER_ID", pr_header.get("REQ_USER_ID"));
	        		item.put("PROJECT_CD", pr_header.get("PROJECT_CD"));
	        		item.put("PROJECT_SQ", pr_header.get("PROJECT_SQ"));
	        		item.put("PROJECT_TYPE", pr_header.get("PROJECT_TYPE"));
	        		item.put("PB_BUYER_CD", buyer_cd);
	            	pmsmapper.insPrdt(item);
	        	}
    		} else {
	        	pr_header.put("BUYER_CD", chk_buyer_cd);
	        	pr_header.put("PR_NUM", chk_pr_num);
	        	pmsmapper.upsPrhd(pr_header);
	        	
	        	pmsmapper.delPrdt(chk);
	        	int prSq = 1;
	        	for(Map<String,Object> item: pr_itemList ) {
	        		item.put("BUYER_CD", chk_buyer_cd);
	        		item.put("PR_NUM", chk_pr_num);
	        		item.put("PR_SQ", prSq++);
	        		item.put("REQ_USER_ID", pr_header.get("REQ_USER_ID"));
	        		item.put("PROJECT_CD", pr_header.get("PROJECT_CD"));
	        		item.put("PROJECT_SQ", pr_header.get("PROJECT_SQ"));
	        		item.put("PROJECT_TYPE", pr_header.get("PROJECT_TYPE"));
	        		item.put("PB_BUYER_CD", chk_buyer_cd);
	            	pmsmapper.insPrdt(item);
	        	}
    		}
    	}

    	pmsmapper.insPmsPrhd(pr_header);
    	int prSq = 1;
    	for(Map<String,Object> item: pr_itemList ) {
    		item.put("PROJECT_CD", pr_header.get("PROJECT_CD"));
    		item.put("PROJECT_SQ", pr_header.get("PROJECT_SQ"));
    		item.put("PR_SQ", prSq++);
        	pmsmapper.insPmsPrdt(item);
    	}
    }
}


