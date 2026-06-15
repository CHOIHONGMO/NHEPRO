package com.st_ones.common.file.web;

import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletException;
import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
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
 * @File Name : ImageDispatcher.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
public class ImageDispatcher  {

    private Logger logger = LoggerFactory.getLogger(ImageDispatcher.class);

    @Autowired FileAttachService fileAttachService;

    @RequestMapping(value = {"/common/images/*.jpeg", "/common/images/*.jpg",
                             "/common/images/*.png", "/common/images/*.gif",
                             "/common/images/*.tif"})
    protected void processImage(EverHttpRequest req, EverHttpResponse resp) throws ServletException, IOException {

        String uuid = req.getParameter("uuid");
        String uuid_seq = req.getParameter("uuid_sq");

        Map<String, String> fileInfo = fileAttachService.getFileInfo(uuid, uuid_seq);

        try {

            String bizType = fileInfo.get("BIZ_TYPE");
            String fileUploadPath = PropertiesManager.getString("everf.fileUpload.path");

            if(StringUtils.equals(bizType, "IMG")) {
                fileUploadPath = PropertiesManager.getString("everf.imageUpload.path");
            }
            String filename = fileUploadPath + bizType + "/" + fileInfo.get("FILE_NM") + "." + fileInfo.get("FILE_EXTENSION");

            BufferedInputStream bis = new BufferedInputStream(new FileInputStream(filename));
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(512);

            int imageByte;
            while((imageByte = bis.read()) != -1) {
                byteArrayOutputStream.write(imageByte);
            }

            bis.close();

            byteArrayOutputStream.writeTo(resp.getOutputStream());

//            resp.setContentType("image/" + StringUtils.lowerCase(fileInfo.get("FILE_EXTENSION")));
            resp.setContentType("image/*");
            resp.setContentLength(imageByte);
            resp.setHeader("Content-Disposition", "inline; filename=\"" + fileInfo.get("REAL_FILE_NM")+"\"");

        } catch(Exception e) {
            logger.error(e.getMessage(), e);
        }
    }
}
