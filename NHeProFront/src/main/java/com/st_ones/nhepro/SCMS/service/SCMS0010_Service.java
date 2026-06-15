package com.st_ones.nhepro.SCMS.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.enums.econtract.ContStringUtil;
import com.st_ones.common.enums.system.Code;
import com.st_ones.common.file.service.FileAttachService;
import com.st_ones.common.mail.service.EverMailService;
import com.st_ones.common.mail.web.MailTemplate;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.sms.service.EverSmsService;
import com.st_ones.common.util.clazz.EverCert;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.service.LargeTextService;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.eApproval.eApprovalModule.service.BAPM_Service;
import com.st_ones.nhepro.CCTR.CCTR0020_Mapper;
import com.st_ones.nhepro.SCTR.SCTR0010_Mapper;

import io.netty.util.internal.StringUtil;
import kica.sgic.util.DataToXml;
import kica.sgic.util.SGIxLinker;
import kica.sgic.util.XmlToData;


/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 St-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : SCMS_Service.java
 * @author
 * @date 2018. 03. 27.
 * @version 1.0
 * @see
 */

@Service(value = "SCMS0010_Service")
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class SCMS0010_Service extends BaseService {

    Logger logger = LoggerFactory.getLogger(this.getClass());
    
    @Autowired MessageService msg;
	@Autowired private SCTR0010_Mapper scms0010_mapper;
	@Autowired private CCTR0020_Mapper ccms0010_mapper;
	@Autowired private EverMailService everMailService;
	@Autowired private LargeTextService largeTextService;
	@Autowired private MessageService messageService;
	@Autowired private EverSmsService everSmsService;
    @Autowired private DocNumService docNumService;
    @Autowired BAPM_Service approvalService;
	@Autowired private FileAttachService fileAttachService;
	
	
	
    

	
	
	
}