package com.st_ones.nhepro.CETR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.info.UserInfoNotFoundException;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.clazz.AuthorityIgnore;
import com.st_ones.nhepro.CETR.CETR0010_Mapper;
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
 * @File Name : CETR0010_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "CETR0010_Service")
public class CETR0010_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private CETR0010_Mapper cetr0010_mapper;

    /**
     * 화면명 : 개인정보
     * 처리내용 : 사용자의 개인정보(전화번호, E-Mail, 비밀번호 등)를 관리하는 화면
     * 경로 : 고객사 > My Page > My Page > 개인정보
     * 배송지, 그리드 조회
     */
    public List<Map<String, Object>> cetr0010_doSearchG(Map<String, String> param) {
        return cetr0010_mapper.cetr0010_doSearchG(param);
    }

    @AuthorityIgnore
    public HashMap<String, String> selectUser(Map<String, String> param) throws UserInfoNotFoundException {

        String userType = UserInfoManager.getUserInfo().getUserType();
        HashMap<String, String> rtn;

        // 운영사
        if (userType.equals("O")) {
            rtn = cetr0010_mapper.selectUser(param);
        // 협력사, 고객사
        } else {
            rtn = cetr0010_mapper.selectUserCS(param);
        }
        return rtn;
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String saveUser(Map<String, String> formData) throws Exception {

        String newPass1 = formData.get("PASSWORD_CHECK1");
        String newPass2 = formData.get("PASSWORD_CHECK2");
        formData.put("P_PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("P_PASSWORD")));

        // 비밀번호 업데이트 x
        if(newPass1.equals("")&&newPass2.equals("")){

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
            cetr0010_mapper.doUpdate(formData);
        // 협력사, 고객사
        } else {
            cetr0010_mapper.doUpdateCS(formData);
        }
        return msg.getMessage("0031");
    }

    public HashMap<String, String> getUserDateFormat(Map<String, String> formData) throws Exception {
        return cetr0010_mapper.getDateFormatValue(formData);
    }

    // 배송지 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0010_doSaveG(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            cetr0010_mapper.cetr0010_doSaveG(gridData);
        }
        return msg.getMessage("0031");
    }

    // 배송지, 그리드 행삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String cetr0010_doDeleteG(List<Map<String, Object>> gridDatas) throws Exception {

        for(Map<String, Object> gridData : gridDatas) {
            cetr0010_mapper.cetr0010_doDeleteG(gridData);
        }
        return msg.getMessage("0017");
    }

}
