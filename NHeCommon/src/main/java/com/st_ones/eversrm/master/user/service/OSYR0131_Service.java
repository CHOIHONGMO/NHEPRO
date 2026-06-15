package com.st_ones.eversrm.master.user.service;

import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.master.user.OSYR0131_Mapper;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

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
 * @File Name : OSYR0131_Service.java
 * @date 2020.02.17
 * @version 1.0
 * @see
 */
@Service(value = "osyr0131_Service")
public class OSYR0131_Service extends BaseService {

    @Autowired private MessageService msg;

    @Autowired private DocNumService docNumService;

    @Autowired private OSYR0131_Mapper osyr0131_Mapper;

    /**
     * 화면명 : 개인정보 열람요청
     * 처리내용 : 개인정보 열람을 요청하는 화면
     * 경로 : Popup
     */
    public Map<String, String> osyr0131_doSearech(Map<String, String> map) {
        return osyr0131_Mapper.osyr0131_doSearech(map);
    }

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String osyr0131_doMaskApproval(Map<String, String> formData) throws Exception {

        osyr0131_Mapper.osyr0131_doMaskApproval(formData);

        return osyr0131_Mapper.osyr0131_doSearchMaskSq(formData);
    }

    public void osyr0131_doMaskApprovalCancel(Map<String, String> formData) {

        if ("C".equals(formData.get("MASK_FLAG"))) {
            formData.put("RMK", "개인정보열람요청 취소");
        }
        osyr0131_Mapper.osyr0131_doMaskApprovalCancel(formData);
    }

    public Map<String, String> osyr0131_doMaskView(Map<String, String> formData) {

        Map<String, String> maskView = osyr0131_Mapper.osyr0131_doMaskView(formData);

        if (maskView != null && "E".equals(maskView.get("MASK_APPROVAL"))) {
            formData.putAll(maskView);

            // SCREEN_CRUD 값을 조회로 업데이트 한다.
            osyr0131_Mapper.osyr0131_doUpdate(formData);
        }
        return maskView;
    }

}