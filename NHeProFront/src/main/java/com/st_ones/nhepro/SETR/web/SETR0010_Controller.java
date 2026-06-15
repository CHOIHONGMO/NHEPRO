package com.st_ones.nhepro.SETR.web;

import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.exception.EverException;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.nhepro.SETR.service.SETR0010_Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
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
 * @File Name : SETR0010_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/nhepro/SETR")
public class SETR0010_Controller extends BaseController {

    @Autowired private MessageService msg;

    @Autowired private SETR0010_Service setr0010_Service;

    /**
     * 화면명 : 개인정보
     * 처리내용 : 사용자의 개인정보(전화번호, E-Mail, 비밀번호 등)를 관리하는 화면
     * 경로 : 협력업체 > My Page > My Page > 개인정보
     */
    @RequestMapping(value="/SETR0010/view")
    public String SETR0010(EverHttpRequest req) throws Exception {

        BaseInfo userInfo = UserInfoManager.getUserInfo();
        String userId = userInfo.getUserId();

        Map<String, String> param = new HashMap<>();
        param.put("userId", userId);

        req.setAttribute("form", setr0010_Service.selectUser(param));
        req.setAttribute("everSslUseFlag", PropertiesManager.getString("ever.ssl.use.flag"));
        req.setAttribute("eversrmSystemDomainPort", PropertiesManager.getString("eversrm.system.domainPort"));
        req.setAttribute("eversrmSystemDomainUrl", PropertiesManager.getString("eversrm.system.domainUrl"));
        req.setAttribute("realDomainUrl", (PropertiesManager.getString("eversrm.system.developmentFlag").equals("false") ? PropertiesManager.getString("eversrm.system.domainUrl") : PropertiesManager.getString("eversrm.system.domainUrl") + ":" + PropertiesManager.getString("eversrm.system.domainPort")));
        req.setAttribute("eversrmSystemDomainPortHttp", PropertiesManager.getString("eversrm.system.domainPort.http"));
        req.setAttribute("userType", userInfo.getUserType());

        return "/nhepro/SETR/SETR0010";
    }

    @RequestMapping(value = "/setr0010_saveUser")
    public void setr0010_saveUser(EverHttpRequest req, EverHttpResponse resp) throws Exception {

        Map<String, String> formData = req.getFormData();

        String pwd = EverString.nullToEmptyString(formData.get("PASSWORD_CHECK1")).trim();
        String pwdChk = EverString.nullToEmptyString(formData.get("PASSWORD_CHECK2")).trim();

        if(!pwd.equals("") && !pwdChk.equals("")){
            if(pwd.length() <= 0 || pwdChk.length() <= 0) {
                throw new EverException(msg.getMessageByScreenId("MY01_005", "028"));
            }
            if(! pwd.equals(pwdChk)) {
                throw new EverException(msg.getMessageByScreenId("MY01_005", "027"));
            }
        }

        String strMsg = setr0010_Service.saveUser(formData);

        HttpSession httpSession = req.getSession();
        UserInfo baseInfo = UserInfoManager.getUserInfoImpl();
        baseInfo.setUserNmEng(formData.get("USER_NM_ENG"));
        baseInfo.setUserNm(formData.get("USER_NM"));
        baseInfo.setEmail(formData.get("EMAIL"));
        baseInfo.setTelNum(formData.get("TEL_NUM"));
        baseInfo.setCellNum(formData.get("CELL_NUM"));
        baseInfo.setLangCd(formData.get("LANG_CD"));
        baseInfo.setUserGmt(formData.get("GMT_CD"));
        baseInfo.setFaxNum(formData.get("FAX_NUM"));
        String userType = UserInfoManager.getUserInfo().getUserType();

        if (userType.equals("O")) { // 운영사
            baseInfo.setDateFormat(setr0010_Service.getUserDateFormat(formData).get("USER_DATE_FORMAT_VALUE"));
            baseInfo.setNumberFormat(setr0010_Service.getUserDateFormat(formData).get("USER_NUMBER_FORMAT_VALUE"));
        }

        httpSession.setAttribute("ses", baseInfo);
        UserInfoManager.createUserInfo(baseInfo);
        msg.setCommonMessage(httpSession);

        resp.setParameter("chkFlag", "0001");
        resp.setResponseMessage(strMsg);
    }

}
