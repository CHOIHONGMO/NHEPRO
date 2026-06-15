package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0010_Mapper;
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
 * @File Name : MAUA0010_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0010_Service")
public class MAUA0010_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private MAUA0010_Mapper maua0010_Mapper;

    /**
     * 화면명 : 직무관리/직무별-사용자매핑
     * 처리내용 : 직무를 조회/관리하며, 등록된 직무에 사용자를 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 직무관리/직무별-사용자매핑
     */
    public List<Map<String, Object>> selectTaskCode(Map<String, String> param) {
    	
        return maua0010_Mapper.selectTaskCode(param);
    }
    
    public List<Map<String, Object>> selectMappingCust(Map<String, String> param) {
    	
        return maua0010_Mapper.selectMappingCust(param);
    }
    
    public List<Map<String, Object>> selectMappingUser_add(Map<String, String> param) {
    	
        return maua0010_Mapper.selectMappingUser_add(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String saveTaskCode(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            int chk = maua0010_Mapper.checkTaskCode(gridData);

            if (chk == 0) {
                maua0010_Mapper.insertTaskCode(gridData);
            } else {
                maua0010_Mapper.updateTaskCode(gridData);
            }
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String deleteTaskCode(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            maua0010_Mapper.deleteTaskCode(gridData);

            maua0010_Mapper.deleteTaskPersonInCharge2(gridData);

            // 매핑삭제시직무 History 저장
            gridData.put("CH_TYPE","D");
            maua0010_Mapper.saveHistoryBACH2(gridData);
        }
        return msg.getMessage("0017");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String doSaveTaskUser(Map formData, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	// 고객사 사용자 테이블에서 MNG_YN = '1'로 변경할 직무 가져오기
        String[] ctrlCdList = PropertiesManager.getString("eversrm.customer.admin.ctrlCd", "").split(";");
    	String ctrlCd = String.valueOf(formData.get("CTRL_CD_S"));
    	
        for (Map<String, Object> gridData : gridDatas) {

            gridData.put("CTRL_CD", ctrlCd);
            gridData.put("CTRL_USER_ID", gridData.get("USER_ID"));

            int chk = maua0010_Mapper.checkTaskPersonInCharge(gridData);
            if (chk == 0) {
                gridData.put("CH_TYPE","C");
                maua0010_Mapper.insertTaskPersonInCharge(gridData);
            } else {
                gridData.put("CH_TYPE","U");
                maua0010_Mapper.updateTaskPersonInCharge(gridData);
            }
            
            // 고객사_관리자 직무인 경우 STOCCVUR의 MNG_YN = '1'로 변경
            for (String code : ctrlCdList) {
            	if (code.equalsIgnoreCase(ctrlCd)) {
            		maua0010_Mapper.updateCustomerMngYn(gridData);
            	}
            }

            // 매핑저장시 직무 History 저장
            maua0010_Mapper.saveHistoryBACH(gridData);
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String doDeleteTaskUser(Map formData, List<Map<String, Object>> gridDatas) throws Exception {
    	
    	// 고객사 사용자 테이블에서 MNG_YN = '1'로 변경할 직무 가져오기
        String[] ctrlCdList = PropertiesManager.getString("eversrm.customer.admin.ctrlCd", "").split(";");
        String ctrlCd = String.valueOf(formData.get("CTRL_CD_S"));
        
        for (Map<String, Object> gridData : gridDatas) {

            gridData.put("BUYER_CD_ORI", formData.get("BUYER_CD_S"));
            gridData.put("BUYER_CD_BACP", gridData.get("BUYER_CD"));
            gridData.put("CTRL_CD_ORI", ctrlCd);
            gridData.put("CTRL_USER_ID_ORI", gridData.get("USER_ID"));
            maua0010_Mapper.deleteTaskPersonInCharge(gridData);

            // 고객사_관리자 직무인 경우 STOCCVUR의 MNG_YN = '0'로 변경
            for (String code : ctrlCdList) {
            	if (code.equalsIgnoreCase(ctrlCd)) {
            		gridData.put("DEL_FLAG", "1");
            		maua0010_Mapper.updateCustomerMngYn(gridData);
            	}
            }
            
            // 매핑삭제시직무 History 저장
            gridData.put("BUYER_CD", formData.get("BUYER_CD_S"));
            gridData.put("CTRL_CD", ctrlCd);
            gridData.put("CTRL_USER_ID", gridData.get("USER_ID"));
            gridData.put("CH_TYPE","D");
            maua0010_Mapper.saveHistoryBACH(gridData);
        }
        return msg.getMessage("0017");
    }

}