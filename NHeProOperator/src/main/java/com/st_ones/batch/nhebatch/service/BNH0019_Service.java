package com.st_ones.batch.nhebatch.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0019_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.common.file.FileAttachMapper;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;



/**
 * 12개월 미접속 사용자 정보 이관(삭제계정 포함)
 * 6년 미접속 사용자 정보 삭제(삭제계정 포함)
 * @author 
 */
@Service(value = "BNH0019_Service")
public class BNH0019_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0019_Mapper bnh0019mapper;
	@Autowired private FileAttachMapper fileAttachMapper;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0019_Service===================================================");

		/** 12개월 미접속 사용자 정보 SLEEP_ACC (N->Y) */
		param.put("minusMonth", "-12");
		List<Map<String,String>> tagrgetData1 = bnh0019mapper.getTargetData1(param);
		for (Map<String, String> data : tagrgetData1) {
			
			// 휴먼계정여부(SLEEP_ACC) Y로 변경(STOCTVUR)
			bnh0019mapper.updateSTOCTVUR(data);
			
		}

		/** 6년 미접속 사용자 정보 삭제(삭제계정 포함) */
		param.put("minusMonth", "-72");
		List<Map<String,String>> targetList2 = bnh0019mapper.getTargetData1(param);
		for (Map<String, String> data : targetList2) {

			//휴먼계정 삭제-첨부파일테이블(STOCATCH):계약서 및 첨부파일 
			deleteFile(data);
			afterDeleteFile();
			
			
			// 휴먼계정 삭제-첨부파일테이블(STOCATCH)
			//bnh0019mapper.deleteSTOCATCH(data);
			
			// 휴먼계정 삭제-첨부파일테이블(STOCATCH)
			//bnh0019mapper.deleteSTOCATCH_VENDOR(data);
			
			
			// 휴먼계정 삭제-계약서테이블_상세(STOCTCRL)
			bnh0019mapper.deleteSTOCTCRL(data);

			// 휴먼계정 삭제-계약서테이블(STOCTCCT)
			bnh0019mapper.deleteSTOCTCCT(data);
			
			// 휴먼계정 삭제-사용자테이블(STOCTUPW)
			bnh0019mapper.deleteSTOCTUPW(data);
						
			// 휴먼계정 삭제-사용자테이블(STOCTVUR)
			bnh0019mapper.deleteSTOCTVUR(data);
			
						
		}
		
		return msg.getMessage("0001");
	}
	
	
	   /**
     * UUID와 UUID_SQ로 파일을 지정해 삭제합니다.
     * @param fileObjMap
     * @throws Exception
     */
    public void deleteFile(Map<String, String> param) throws Exception {
    	
    	Map<String, String> paramMap = new HashMap<String, String>();
    	
    	//1.계약서작성PDF userId값으로 UUID, UUID_SQ 값을 가져온다. 
    	List<Map<String,String>> uuidInfo = bnh0019mapper.getUUIDInfo(param);
    	
    	for (Map<String, String> data : uuidInfo) {
    	
   	
	        paramMap.put("UUID", data.get("UUID"));
	        paramMap.put("UUID_SQ",data.get("UUID_SQ"));
	        
	        Map<String, String> fileInfo = fileAttachMapper.getFileInfo(paramMap);
	
	        if(fileInfo != null) {
	            String filePath = fileInfo.get("FILE_PATH");
	            String fileName = fileInfo.get("FILE_NM");
	            String fileExtension = fileInfo.get("FILE_EXTENSION");
	
	            File file = new File(filePath + "/" + fileName + "." + fileExtension);
	
	            // FIXME: LATER 이 부분은 신세계아이앤씨에서 실제삭제를 원하지 않아 주석처리됨 ('17.10.24)
	            boolean deleteStatus = file.delete();
	            
	            if (deleteStatus) {
	                logger.info("[{}] 파일이 삭제되었습니다.", filePath + "/" + fileName + "." + fileExtension);
	            } else {
	            	logger.info("[{}] 파일이 삭제되지 않았습니다.", filePath + "/" + fileName + "." + fileExtension);
	            }

	            /* This parameter is use for sync of each database server. */
	            paramMap.put("TABLE_NM", "STOCATCH");
	            fileAttachMapper.deleteFile(paramMap);
	        }
    	}   
    	
    	List<Map<String,String>> uuidInfo2 = bnh0019mapper.getUUIDInfo2(param);
    	
    	for (Map<String, String> data : uuidInfo2) {
    	
   	
	        paramMap.put("UUID", data.get("UUID"));
	        paramMap.put("UUID_SQ",data.get("UUID_SQ"));
	        
	        Map<String, String> fileInfo = fileAttachMapper.getFileInfo(paramMap);
	
	        if(fileInfo != null) {
	            String filePath = fileInfo.get("FILE_PATH");
	            String fileName = fileInfo.get("FILE_NM");
	            String fileExtension = fileInfo.get("FILE_EXTENSION");
	
	            File file = new File(filePath + "/" + fileName + "." + fileExtension);
	
	            // FIXME: LATER 이 부분은 신세계아이앤씨에서 실제삭제를 원하지 않아 주석처리됨 ('17.10.24)
	            boolean deleteStatus = file.delete();
	            
	            if (deleteStatus) {
	                logger.info("[{}] 파일이 삭제되었습니다.", filePath + "/" + fileName + "." + fileExtension);
	            } else {
	            	logger.info("[{}] 파일이 삭제되지 않았습니다.", filePath + "/" + fileName + "." + fileExtension);
	            }

	            /* This parameter is use for sync of each database server. */
	            paramMap.put("TABLE_NM", "STOCATCH");
	            fileAttachMapper.deleteFile(paramMap);
	        }
    	} 
}
    
    public void afterDeleteFile() throws Exception{
		
    	File tempDirectory = new File(getTempFilePath());
		if (tempDirectory.isDirectory()) {
			File[] listFiles = tempDirectory.listFiles();
			if(listFiles != null) {
                for (File file : listFiles) {
                    if (file.canWrite()) {
                        file.delete();
                    }
                }
            }
		}
    }
    
	private String getTempFilePath() {
		return PropertiesManager.getString("everf.fileUpload.tempPath");
	}
    
    
    
}
