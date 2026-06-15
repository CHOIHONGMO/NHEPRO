package com.st_ones.common.mail.web;

import com.st_ones.common.util.clazz.EverFile;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

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
 * @File Name : MailTemplate.java
 * @date 2013. 09. 10.
 * @version 1.0
 * @see
 */
@Component(value = "mailTemplate")
public class MailTemplate {
	private Logger logger = LoggerFactory.getLogger(MailTemplate.class);
	public String getMailTemplate(String templateFileNm, String subject, String contents) throws Exception {
		if (1==1) return contents;
		try {
			String domainNm = PropertiesManager.getString("eversrm.system.domainName");
			String domainPort = PropertiesManager.getString("eversrm.system.domainPort");
			String templatePath = PropertiesManager.getString("eversrm.system.mailTemplatePath");

			if (domainPort.equals("80")) {
				domainPort = "";
			} else {
				domainPort = ":" + domainPort;
			}

			String realUrl = "http://"+domainNm + domainPort;

			if (templateFileNm.trim().length() <= 0) {
				templateFileNm = templatePath + PropertiesManager.getString("eversrm.system.mailSimpleTemplateFileName");
			}
			String fileContents = "";
			fileContents = EverFile.fileReadByOffsetByEncoding(templateFileNm, "UTF-8");
			fileContents = EverString.replace(fileContents, "$SUBJECT$", subject);
			fileContents = EverString.replace(fileContents, "$CONTENTS$", EverString.nToBr(contents));
			fileContents = EverString.replace(fileContents, "$realUrl$", realUrl);

			System.err.println("===============================================================================================fileContents="+fileContents);

			return fileContents;
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw e;
		}
	}

}
