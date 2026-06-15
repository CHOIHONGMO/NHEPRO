package com.st_ones.common.eversrm.system;

import com.st_ones.common.cache.data.CacheUtil;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.io.File;
import java.io.RandomAccessFile;
import java.util.Iterator;
import java.util.Map;

@Controller
@RequestMapping(value = "/eversrm/system/management")
public class WatcherController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(WatcherController.class);

    @RequestMapping("/watcher/view")
    public String watcher(EverHttpRequest req) throws Exception {
        return "/eversrm/system/management/watcher";
    }

    @RequestMapping("/watcher/doSearch")
    public void doSearch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> reqMap = req.getParamDataMap();

        if (!PropertiesManager.getBoolean("eversrm.system.localserver")) {
            // [고도화변경] 2026.06.15 JEUS 7 -> JEUS 8 업그레이드 대응을 위해 하드코딩된 로그 경로를 nhepro.properties로 이관
            String path = PropertiesManager.getString("eversrm.log.path.front");

            File file = new File(path);
            if(file.isFile()) {

                RandomAccessFile randomAccessFile = null;

                try {

                    randomAccessFile = new RandomAccessFile(path, "r");
                    long totalLength = randomAccessFile.length();
                    // throw new Exception(reqMap.get("logType") + " 파일이 존재하지 않습니다.");
                    long startPoint = totalLength - 300000 > 0 ? totalLength - 300000 : 0;
                    randomAccessFile.seek(startPoint);

                    long endPoint;
                    String str;
                    StringBuilder sb = new StringBuilder();
                    while ((str = randomAccessFile.readLine()) != null) {
                        sb.append("").append(new String(str.getBytes("ISO-8859-1"), "EUC-KR").replaceAll("<", "&lt;")).append("\n");
                        endPoint = randomAccessFile.getFilePointer();
                        randomAccessFile.seek(endPoint);
                    }

                    String resultString = sb.toString();
                    resultString = resultString.replaceAll(" ", "&nbsp;");
                    resultString = resultString.replaceAll("\t", "&nbsp;&nbsp;&nbsp;");
                    resultString = resultString.replaceAll("INFO", "<span style='color:#0a8eeb;'>INFO</span>");
                    resultString = resultString.replaceAll("WARN", "<span style='color:orange;'>WARN</span>");
                    resultString = resultString.replaceAll("ERROR", "<span style='color:red;'>ERROR</span>");
                    reqMap.put("logString", resultString);

                } catch (Exception e) {
                    logger.error(e.getMessage());
                } finally {
                    randomAccessFile.close();
                }

            } else {
                reqMap.put("logString", reqMap.get("logType") + " 파일이 존재하지 않습니다.");
            }
            resp.sendJSON(reqMap);
        }
    }
}