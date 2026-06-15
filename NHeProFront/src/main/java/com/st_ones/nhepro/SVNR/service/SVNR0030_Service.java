package com.st_ones.nhepro.SVNR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.util.EverString;
import com.st_ones.eversrm.manager.auth.service.MAUA0010_Service;
import com.st_ones.eversrm.master.user.service.MTUA0010_Service;
import com.st_ones.nhepro.SVNR.SVNR0030_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
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
 * @File Name : SVNR0030_Service.java
 * @date 2018. 01. 30.
 * @version 1.0
 */

@Service(value = "SVNR0030_Service")
public class SVNR0030_Service extends BaseService {

    @Autowired MessageService msg;
    @Autowired SVNR0030_Mapper svnr0030_mapper;
    @Autowired LargeTextService largeTextService;
    @Autowired MTUA0010_Service mtua0010_service;
    @Autowired MAUA0010_Service maua0010_service;

    /**
     * 화면명 : 사용자현황
     * 처리내용 : 사용자를 등록 및 수정하는 화면.
     * 경로 : 협력업체 > 관리자 > 사용자관리 > 사용자현황
     */
    public List<Map<String, Object>> svnr0030_doSearch(Map<String, String> param) {
        return svnr0030_mapper.svnr0030_doSearch(param);
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String svnr0030_doSave(List<Map<String, Object>> gridDatas) throws Exception {
        for(Map<String, Object> gridData : gridDatas) {
            svnr0030_mapper.svnr0030_doSave(gridData);
        }

        return msg.getMessage("0031");
    }

    // 삭제
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String svnr0030_doDelete(List<Map<String, Object>> gridDatas) throws Exception {
        for(Map<String, Object> gridData : gridDatas) {
            svnr0030_mapper.svnr0030_doDelete(gridData);
            svnr0030_mapper.svnr0030_doDeleteUserComm(gridData);
        }

        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 협력업체별 사용자 상세
     * 처리내용 : 사용자 상세 정보 조회 및 수정(Block), 비밀번호 초기화 하는 화면.
     * 경로 : 운영사 > 회원사 관리 > 협력업체 관리 > 협력업체별 사용자현황 > 협력업체별 사용자 상세 (팝업)
     */
    public Map<String, Object> svnr0031_doSearch(Map<String, String> param) {

        return svnr0030_mapper.svnr0031_doSearch(param);
    }

    // 저장
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> svnr0031_doSave(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        String orgUserId = EverString.nullToEmptyString(formData.get("ORG_USER_ID"));
        String userId = EverString.nullToEmptyString(formData.get("USER_ID"));

        List<Map<String, Object>> grid = new ArrayList<>();
        Map<String, Object> map = new HashMap<>();

        map.put("USER_ID", userId);
        map.put("BUYER_CD", formData.get("COMPANY_CD"));
        map.put("SELECTED", "1");
        map.put("USE_FLAG", "1");
        
        if("".equals(orgUserId)) {
            // 입력받은 비밀번호로 업데이트
            formData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("PASSWORD")));
            svnr0030_mapper.svnr0031_doInsertCVUR(formData);

            map.put("AUTH_CD", "PF0132");
            System.out.println("formData.get(\"NMNG_YN\")====>"+formData.get("MNG_YN"));
            if("1".equals(formData.get("MNG_YN"))) {
                map.put("CTRL_CD_S", "SR020");
            } else {
                map.put("CTRL_CD_S", "SR010");
            }
            grid.add(map);

            mtua0010_service.doSaveAuth(userId, grid);
            maua0010_service.doSaveTaskUser(map, grid);
            
            svnr0030_mapper.svnr0031_doInsertUserComm(formData);
            svnr0030_mapper.svnr0031_doInsertUserBasic(formData);
            svnr0030_mapper.svnr0031_doInsertBrcDetail(formData);
        }
        else {
            String PASSWORD = EverString.nullToEmptyString(formData.get("PASSWORD"));
            if(!"".equals(PASSWORD)) {
                formData.put("PASSWORD", EverEncryption.getEncryptedUserPassword(formData.get("PASSWORD")));

                int checkPW = svnr0030_mapper.svnr0031_dupChkPassword(formData);
                if (checkPW > 0) {
                    throw new Exception(msg.getMessage("0153"));
                }

                formData.put("PW_RESET_FLAG", "1");
            }

            svnr0030_mapper.svnr0031_doUpdateCVUR(formData);

            if("1".equals(formData.get("MNG_YN"))) {
                map.put("CTRL_CD_S", "SR020");
                map.put("USE_FLAG", "1");
                grid.add(map);
                maua0010_service.doSaveTaskUser(map, grid);

                map.put("CTRL_CD_S", "SR010");
                map.put("USE_FLAG", "0");
                grid.clear();
                grid.add(map);
                maua0010_service.doSaveTaskUser(map, grid);
            } else {
                map.put("CTRL_CD_S", "SR010");
                map.put("USE_FLAG", "1");
                grid.add(map);
                maua0010_service.doSaveTaskUser(map, grid);

                map.put("CTRL_CD_S", "SR020");
                map.put("USE_FLAG", "0");
                grid.clear();
                grid.add(map);
                maua0010_service.doSaveTaskUser(map, grid);
            }
            svnr0030_mapper.svnr0031_doUpdateUserComm(formData);
        }

        rtnMap.put("USER_ID", userId);
        rtnMap.put("rtnMsg", msg.getMessage("0031"));

        return rtnMap;
    }

    // 사용자ID 중복체크
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, String> svnr0031_doDupChkUserId(Map<String, String> formData) throws Exception {
        Map<String, String> rtnMap = new HashMap<>();

        String msgCode;
        String userId = EverString.nullToEmptyString(formData.get("USER_ID"));

        String dupCheckYN = svnr0030_mapper.svnr0031_doDupChkUserId(formData);

        if("Y".equals(dupCheckYN)) {
            msgCode = msg.getMessageByScreenId("SVNR0031", "006");
        } else {
            msgCode = msg.getMessageByScreenId("SVNR0031", "005");
        }

        rtnMap.put("USER_ID", userId);
        rtnMap.put("DUP_CHECK_ID_YN", dupCheckYN);
        rtnMap.put("rtnMsg", msgCode);

        return rtnMap;
    }

}
