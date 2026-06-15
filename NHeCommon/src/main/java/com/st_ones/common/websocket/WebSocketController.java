package com.st_ones.common.websocket;

import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : WebSocketController.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/common/webSocket/")
public class WebSocketController {

    @RequestMapping(value="webSocketClient/view")
    public String webSocketClient(EverHttpRequest req) throws Exception {

        /*
        String userAgent = req.getHeader("User-Agent");
        boolean ie = (userAgent.indexOf("MSIE") > -1) || (userAgent.indexOf("Trident") > -1);

        req.setAttribute("ieFlag", ie);
        */

        return "/common/webSocket/webSocketClient";
    }

    @RequestMapping(value="fileManager/view")
    public String fileManager(EverHttpRequest req) throws Exception {
        return "/common/webSocket/fileManager";
    }

}