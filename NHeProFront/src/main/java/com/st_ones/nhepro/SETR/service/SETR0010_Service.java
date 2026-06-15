package com.st_ones.nhepro.SETR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.nhepro.SETR.SETR0010_Mapper;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SETR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SETR0010_Service")
public class SETR0010_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private SETR0010_Mapper setr0010_Mapper;

    @AuthorityIgnore
    public HashMap<String, String> selectUser(Map<String, String> param) throws UserInfoNotFoundException {

        String userType = UserInfoManager.getUserInfo().getUserType();
        HashMap<String, String> rtn;

        // 운영사
        if (userType.equals("O")) {
            rtn = setr0010_Mapper.selectUser(param);
            // 협력사, 고객사
        } else {
            rtn = setr0010_Mapper.selectUserCS(param);
        }
        return rtn;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String saveUser(Map<String, String> formData) throws Exception {

        String newPass1 = formData.get("PASSWORD_CHECK1");
        String newPass2 = formData.get("PASSWORD_CHECK2");
        formData.put("P_PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("P_PASSWORD")));

        // 비밀번호 업데이트 x
        if(newPass1.equals("") && newPass2.equals("")){

        } else {

            // 사용자정보체크(현재비밀번호체크)
            HashMap<String, String> originalUserInfo = this.selectUser(formData);
            // 현재 비밀번호가 빈 값이 아닐 때는 비밀번호를 변경하려는 것으로 간주하고 기존 비밀번호를 제대로 입력했는지 확인한다.
            if(StringUtils.isNotEmpty(formData.get("PASSWORD_CHECK1"))) {

                if(originalUserInfo == null){
                    // 비밀번호가 틀리면 저장하지 않고 리턴한다.
                    throw new EverException(msg.getMessageByScreenId("MY01_005", "005"));
                }
                if(!StringUtils.equals(newPass1, newPass2)) {
                    throw new EverException(msg.getMessage("0028"));
                }
                formData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("PASSWORD_CHECK1")));
            }
        }

        String userType = UserInfoManager.getUserInfo().getUserType();
        // 운영사
        if (userType.equals("O")) {
            setr0010_Mapper.doUpdate(formData);
            // 협력사, 고객사
        } else {
            setr0010_Mapper.doUpdateCS(formData);
        }
        return msg.getMessage("0031");
    }

    public HashMap<String, String> getUserDateFormat(Map<String, String> formData) throws Exception {
        return setr0010_Mapper.getDateFormatValue(formData);
    }

}