package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0021_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * *****************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * *****************************************************************************
 * </pre>
 *
 * @File Name : CCUR0021_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "CCUR0021_Service")
public class CCUR0021_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private CCUR0021_Mapper ccur0021_mapper;

    /**
     * 화면명 : 직무관리/직무별-사용자매핑
     * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
     */
    public List<Map<String, Object>> ccur0021_selectTaskCode(Map<String, String> param) {
        return ccur0021_mapper.ccur0021_selectTaskCode(param);
    }

    public List<Map<String, Object>> ccur0021_selectMappingUser_add(Map<String, String> param) {
        return ccur0021_mapper.ccur0021_selectMappingUser_add(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0021_saveTaskCode(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            int chk = ccur0021_mapper.ccur0021_checkTaskCode(gridData);

            if (chk == 0) {
                ccur0021_mapper.ccur0021_insertTaskCode(gridData);
            } else {
                ccur0021_mapper.ccur0021_updateTaskCode(gridData);
            }
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0021_deleteTaskCode(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            ccur0021_mapper.ccur0021_deleteTaskCode(gridData);

            ccur0021_mapper.ccur0021_deleteTaskPersonInCharge2(gridData);

            // 매핑삭제시직무 History 저장
            gridData.put("CH_TYPE","D");
            ccur0021_mapper.ccur0021_saveHistoryBACH2(gridData);
        }
        return msg.getMessage("0017");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0021_doSaveTaskUser(Map formData, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	// 고객사 사용자 테이블에서 MNG_YN = '1'로 변경할 직무 가져오기
        String[] ctrlCdList = PropertiesManager.getString("eversrm.customer.admin.ctrlCd", "").split(";");
    	String ctrlCd = String.valueOf(formData.get("CTRL_CD_S"));
    	
        for (Map<String, Object> gridData : gridDatas) {

            gridData.put("BUYER_CD", formData.get("BUYER_CD_S"));
            gridData.put("CTRL_CD", ctrlCd);
            gridData.put("CTRL_USER_ID", gridData.get("USER_ID"));

            int chk = ccur0021_mapper.ccur0021_checkTaskPersonInCharge(gridData);
            if (chk == 0) {
                gridData.put("CH_TYPE","C");
                ccur0021_mapper.ccur0021_insertTaskPersonInCharge(gridData);
            } else {
                gridData.put("CH_TYPE","U");
                ccur0021_mapper.ccur0021_updateTaskPersonInCharge(gridData);
            }
            
            // 고객사_관리자 직무인 경우 STOCCVUR의 MNG_YN = '1'로 변경
            for (String code : ctrlCdList) {
            	if (code.equalsIgnoreCase(ctrlCd)) {
            		ccur0021_mapper.ccur0021_updateCustomerMngYn(gridData);
            	}
            }

            // 매핑저장시 직무 History 저장
            ccur0021_mapper.ccur0021_saveHistoryBACH(gridData);
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0021_doDeleteTaskUser(Map formData, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	// 고객사 사용자 테이블에서 MNG_YN = '1'로 변경할 직무 가져오기
        String[] ctrlCdList = PropertiesManager.getString("eversrm.customer.admin.ctrlCd", "").split(";");
        String ctrlCd = String.valueOf(formData.get("CTRL_CD_S"));
        
        for (Map<String, Object> gridData : gridDatas) {
            
            gridData.put("BUYER_CD_ORI", formData.get("BUYER_CD_S"));
            gridData.put("CTRL_CD_ORI", formData.get("CTRL_CD_S"));
            gridData.put("CTRL_USER_ID_ORI", gridData.get("USER_ID"));
            ccur0021_mapper.ccur0021_deleteTaskPersonInCharge(gridData);
            
            // 고객사_관리자 직무인 경우 STOCCVUR의 MNG_YN = '0'로 변경
            for (String code : ctrlCdList) {
            	if (code.equalsIgnoreCase(ctrlCd)) {
            		gridData.put("DEL_FLAG", "1");
            		ccur0021_mapper.ccur0021_updateCustomerMngYn(gridData);
            	}
            }
            
            // 매핑삭제시직무 History 저장
            gridData.put("BUYER_CD", formData.get("BUYER_CD_S"));
            gridData.put("CTRL_CD", formData.get("CTRL_CD_S"));
            gridData.put("CTRL_USER_ID", gridData.get("USER_ID"));
            gridData.put("CH_TYPE","D");
            ccur0021_mapper.ccur0021_saveHistoryBACH(gridData);
        }
        return msg.getMessage("0017");
    }

    /**
     * 화면명 : 사용자별-직무매핑
     * 처리내용 : 시스템에 등록된 직무를 사용자에게 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑
     */
    public List<Map<String, Object>> ccur0022_selectTaskPersonInCharge(Map<String, String> param) throws Exception {
        return ccur0021_mapper.ccur0022_selectTaskPersonInCharge(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0022_saveTaskPersonInCharge(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            int chk = ccur0021_mapper.ccur0022_checkTaskPersonInCharge(gridData);

            if (chk == 0) {
                gridData.put("CH_TYPE","C");
                ccur0021_mapper.ccur0022_insertTaskPersonInCharge(gridData);
            } else {
                gridData.put("CH_TYPE","U");
                ccur0021_mapper.ccur0022_updateTaskPersonInCharge(gridData);
            }

            // 매핑저장시 직무 History 저장
            ccur0021_mapper.ccur0022_saveHistoryBACH(gridData);
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String ccur0022_deleteTaskPersonInCharge(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            ccur0021_mapper.ccur0022_deleteTaskPersonInCharge(gridData);

            // 매핑삭제시직무 History 저장
            gridData.put("CH_TYPE","D");
            ccur0021_mapper.ccur0022_saveHistoryBACH(gridData);
        }
        return msg.getMessage("0017");
    }
}