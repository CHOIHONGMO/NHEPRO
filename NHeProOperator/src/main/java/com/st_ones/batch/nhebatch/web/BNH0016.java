package com.st_ones.batch.nhebatch.web;

import com.st_ones.batch.EverJob;
import com.st_ones.batch.nhebatch.service.BNH0001_Service;
import com.st_ones.batch.nhebatch.service.BNH0016_Service;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.SpringContextUtil;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class BNH0016 extends EverJob {
    @Autowired private BNH0001_Service bnh0001_service;
    @Autowired private BNH0016_Service bnh0016_service;
    @Autowired private EverSmsService everSmsService;
    
    /**
     * 화면명 : Batch 실행
     * 처리내용 : 휴면계정 전환
     * 경로 : 시스템관리 > 시스템 > Batch 실행
     */
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {

        if (super.isAllowedToRunBatch(context)) {
            printJobStartLog(context);

            String jobRlt = "E";
            String startDate = EverDate.getTimeStampString();

            UserInfo baseinfo = new UserInfo();
            baseinfo.setGateCd(PropertiesManager.getString("eversrm.gateCd.default"));
            baseinfo.setUserId(PropertiesManager.getString("eversrm.userId.default"));
            baseinfo.setLangCd(PropertiesManager.getString("eversrm.langCd.default"));
            baseinfo.setIpAddress("127.0.0.1");
            UserInfoManager.createUserInfo(baseinfo);
            bnh0001_service = SpringContextUtil.getBean(BNH0001_Service.class);
            bnh0016_service = SpringContextUtil.getBean(BNH0016_Service.class);

            String msg = "";
            int totalCount = 0;

            try {
                msg = bnh0016_service.doExecService(new HashMap<String, String>());
                jobRlt = "S";
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                
                // 2021.01.25 배치 오류 발생시 SMS 보내기
                String strTelNums = PropertiesManager.getString("quartz.batch.error.receive.telNo");
            	String[] telNums  = (strTelNums==null)?null:strTelNums.split(";");
            	if( telNums != null ) {
	            	for (String telNum : telNums) {
	                    try {
	    	                Map<String,String> smsMap = new HashMap<String,String>();
	    	                smsMap.put("CONTENTS", "[전자구매Batch] 11개월 장기 미사용자 휴면계정 전환(BNH0016) I/F시 오류가 발생");
	    					smsMap.put("REF_MODULE_CD", "BATCH");
	    					smsMap.put("DIRECT_TARGET", telNum);
	    					smsMap.put("DIRECT_USER_NM", "Batch담당자");
	    					everSmsService.sendSmsNhe(smsMap);
	                    } catch (Exception e1) {
	                    	logger.error(e1.getMessage(), e1);
	                    }
	                }
            	}
                
                msg = getMessageAsString(e);
                throw new JobExecutionException();
            } finally {
                try {
                    Map<String, Object> logData = new HashMap<String, Object>();
                    logData.put("JOB_DATE", startDate.substring(0, 19));
                    logData.put("JOB_TYPE", "Batch");
                    logData.put("JOB_ID", "BNH0016");
                    logData.put("JOB_NM", "11개월 장기 미사용자 휴면계정 전환 메일 발송");
                    logData.put("JOB_KEY", "");
                    logData.put("JOB_RLT", jobRlt);
                    logData.put("JOB_RLT_CD", "");
                    logData.put("JOB_RLT_MSG", msg);
                    logData.put("JOB_END_DATE", EverDate.getTimeStampString().substring(0, 19));
                    //배치로그에 해당메세지 저장.
                    bnh0001_service.doSaveBatchLog(logData);
                } catch (Exception e2) {
                    logger.error(e2.getMessage(), e2);
                }
            }
            printJobEndLog(context, msg, totalCount);
        } else {
            printJobNotRunningLog(context);
        }
    }



}