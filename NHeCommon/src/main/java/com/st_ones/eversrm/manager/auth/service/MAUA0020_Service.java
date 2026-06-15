package com.st_ones.eversrm.manager.auth.service;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.manager.auth.MAUA0020_Mapper;
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
 * @File Name : MAUA0020_Service.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Service(value = "MAUA0020_Service")
public class MAUA0020_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private MAUA0020_Mapper maua0020_Mapper;

    /**
     * 화면명 : 사용자별-직무매핑
     * 처리내용 : 시스템에 등록된 직무를 사용자에게 매핑하여 권한을 부여할 수 있다.
     * 경로 : 시스템관리 > 기본정보 > 사용자별-직무매핑
     */
    public List<Map<String, Object>> selectTaskPersonInCharge(Map<String, String> param) throws Exception {
        return maua0020_Mapper.selectTaskPersonInCharge(param);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String saveTaskPersonInCharge(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            int chk = maua0020_Mapper.checkTaskPersonInCharge(gridData);

            if (chk == 0) {
                gridData.put("CH_TYPE","C");
                maua0020_Mapper.insertTaskPersonInCharge(gridData);
            } else {
                gridData.put("CH_TYPE","U");
                maua0020_Mapper.updateTaskPersonInCharge(gridData);
            }

            // 매핑저장시 직무 History 저장
            maua0020_Mapper.saveHistoryBACH(gridData);
        }
        return msg.getMessage("0001");
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String deleteTaskPersonInCharge(List<Map<String, Object>> gridDatas) throws Exception {

        for (Map<String, Object> gridData : gridDatas) {

            maua0020_Mapper.deleteTaskPersonInCharge(gridData);

            // 매핑삭제시직무 History 저장
            gridData.put("CH_TYPE","D");
            maua0020_Mapper.saveHistoryBACH(gridData);
        }
        return msg.getMessage("0017");
    }

}