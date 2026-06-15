package com.st_ones.nosession.front.service;

import com.st_ones.common.file.FileAttachMapper;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nosession.front.Front_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class Front_Service extends BaseService {

    @Autowired
    Front_Mapper front_mapper;

    @Autowired
    FileAttachMapper fileAttachMapper;

    @Autowired
    LargeTextService largeTextService;

    @Autowired
    EverSmsService everSmsService;
    
    @Autowired  
    EverMailService evermailservice;
    
    public Map<String, String> doIrsNumCheck(Map<String, String> param) throws Exception {
        return front_mapper.doIrsNumCheck(param);
    }

    public Map<String, String> doIdSearch(Map<String, String> param) throws Exception {
        Map<String, String> userInfo = null;

        if("O".equals(param.get("I_USER_TYPE"))) {
            userInfo = front_mapper.operIdSearch(param);
        } else if("B".equals(param.get("I_USER_TYPE"))) {
            userInfo = front_mapper.custIdSearch(param);
        } else if("S".equals(param.get("I_USER_TYPE"))) {
            userInfo = front_mapper.vendorIdSearch(param);
        }

        return userInfo;
    }

    public Map<String, String> doPwInfo(Map<String, String> param) throws Exception {
        return front_mapper.doPwInfo(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String doPwSend(Map<String, String> param) throws Exception {
        try {
            String ppdd = EverString.getRandomPassword(8); // Random 8자리

            String subject = "[전자구매시스템] 임시비밀번호가 도착하였습니다. 임시비밀번호(" + ppdd + ")";
            String mailSubject = "[전자구매시스템] 임시비밀번호가 도착하였습니다.";
            // SMS
            Map<String,String> smsMap = new HashMap<String,String>();
            smsMap.put("CONTENTS", subject);
            smsMap.put("REF_MODULE_CD", "SPW01");
            smsMap.put("RECV_USER_ID", param.get("P_USER_ID"));
            everSmsService.sendSmsNhe(smsMap);
            
            // 2021.02.05 기존 사용자 휴대전화번호가 변경이 된 경우 변경된 비밀번호를 알 수 없기때문에 메일전송 추가
            // Email
            Map<String,String> mailMap = new HashMap<>();
            mailMap.put("SUBJECT", mailSubject);
            	
            String content = "<BR> [전자구매시스템] 임시비밀번호가 도착하였습니다. 임시비밀번호(" + ppdd + ")";
            mailMap.put("CONTENTS", content);
            mailMap.put("REF_MODULE_CD", "MPW01");
            mailMap.put("RECV_USER_ID", param.get("P_USER_ID"));
            mailMap.put("REF_NUM", "");
            evermailservice.SendMail(mailMap);
            
            // 메일 전송 완료 후 패스워드 UPDATE
            //String password = EverEncryption.getEncryptedUserPassword(ppdd);
            //System.out.println("=====>ppdd : " + ppdd);
            //System.out.println("=====>password : " + password);
            param.put("PPDD", EverEncryption.getEncryptedUserPassword(ppdd));

            // 사용자 타입에 따라 패스워드 업데이트
            //if(!"O".equals(param.get("USER_TYPE"))) {
                front_mapper.doUpdateCVUR(param);
            //} else {
            //    front_mapper.doUpdateUSER(param);
            //}

            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

}