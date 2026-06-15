package com.st_ones.batch.nhebatch.web;

import java.util.HashMap;
import java.util.Map;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.st_ones.batch.EverJob;
import com.st_ones.batch.nhebatch.service.BNH0001_Service;
import com.st_ones.batch.nhebatch.service.BNH0010_Service;
import com.st_ones.batch.nhebatch.service.UserMig_Service;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.util.SpringContextUtil;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
@Service
public class UserMig extends EverJob {
    @Autowired private BNH0001_Service bnh0001_service;
    @Autowired private UserMig_Service usermig_service;

    /**
     * 화면명 : Batch 실행
     * 처리내용 : 아리오피스(조직인사)
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
            usermig_service = SpringContextUtil.getBean(UserMig_Service.class);

            String msg = "";
            int totalCount = 0;

            try {
                msg = usermig_service.doExecService(new HashMap<String, String>());
                jobRlt = "S";
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                msg = getMessageAsString(e);
                throw new JobExecutionException();
            } finally {
                try {
                    Map<String, Object> logData = new HashMap<String, Object>();
                    logData.put("JOB_DATE", startDate.substring(0, 19));
                    logData.put("JOB_TYPE", "Batch");
                    logData.put("JOB_ID", "UserMig");
                    logData.put("JOB_NM", "USER MIG");
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