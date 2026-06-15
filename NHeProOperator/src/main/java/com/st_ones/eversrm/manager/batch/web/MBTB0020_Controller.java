package com.st_ones.eversrm.manager.batch.web;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.st_ones.batch.nhebatch.service.BNH0011_Service;
import com.st_ones.batch.nhebatch.service.BNH0012_Service;
import com.st_ones.batch.nhebatch.service.UserMig_Service;
import com.st_ones.batch.nhebatch.service.BNH0021_Service;
import com.st_ones.batch.nhebatch.web.BNH0001;
import com.st_ones.batch.nhebatch.web.BNH0010;
import com.st_ones.batch.nhebatch.web.BNH0011;
import com.st_ones.batch.nhebatch.web.BNH0012;
import com.st_ones.batch.nhebatch.web.BNH0013;
import com.st_ones.batch.nhebatch.web.BNH0014;
import com.st_ones.batch.nhebatch.web.BNH0015;
import com.st_ones.batch.nhebatch.web.BNH0016;
import com.st_ones.batch.nhebatch.web.BNH0017;
import com.st_ones.batch.nhebatch.web.BNH0018;
import com.st_ones.batch.nhebatch.web.BNH0019;
import com.st_ones.batch.nhebatch.web.BNH0020;
import com.st_ones.batch.nhebatch.web.UserMig;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.manager.batch.service.MBTB0020_Service;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : MBTB0020_Controller.java
 * @date 2013. 07. 22.
 * @version 1.0
 */

@Controller
@RequestMapping(value = "/eversrm/manager/batch")
public class MBTB0020_Controller extends BaseController {

	@Autowired private MessageService msg;
	@Autowired private BNH0011_Service bnh0011_service;
	@Autowired private BNH0012_Service bnh0012_service;
    @Autowired private UserMig_Service usermig_service;
    @Autowired private MBTB0020_Service mbtb0020Service;
	@Autowired private BNH0021_Service bnh0021_service;
	
    

	/**
	 * 화면명 : BATCH 실행
	 * 처리내용 : 시스템에 등록된 Batch를 수동으로 실행시키는 화면.
	 * 경로 : 시스템관리 > 시스템 > BATCH 실행
	 */
	@RequestMapping("/MBTB0020/view")
	public String MBTB0020(EverHttpRequest req) throws Exception {
		return "/eversrm/manager/batch/MBTB0020";
	}

	@RequestMapping(value = "/MBTB0010/doDownload")
	public void doDownload(EverHttpRequest req, EverHttpResponse resp) throws IOException {
		Map<String, String> formData = req.getFormData();
		String logFile = formData.get("logFile");
	}

	@Autowired private BNH0001 BNH0001;
	@Autowired private BNH0010 BNH0010;
	@Autowired private BNH0011 BNH0011;
	@Autowired private BNH0012 BNH0012;
	@Autowired private BNH0013 BNH0013;
	@Autowired private BNH0014 BNH0014;
	@Autowired private BNH0015 BNH0015;
	@Autowired private BNH0016 BNH0016;
	@Autowired private BNH0017 BNH0017;
	@Autowired private BNH0018 BNH0018;
	@Autowired private BNH0019 BNH0019;
	@Autowired private BNH0020 BNH0020;


	@Autowired private UserMig UserMig;

	@RequestMapping(value = "/MBTB0020/doExecute")
	public void doExecute(EverHttpRequest req, EverHttpResponse resp) throws Exception {

		Map<String, String> param = req.getFormData();
		String execCd = param.get("EXEC_CD");
		String rtnMsg = "";

        try {
			if( "BNH0001".equals(execCd) ){						// 아리오피스(조직인사)]
				BNH0001.execute(null);
			}
			else if ( "BNH0010".equals(execCd) ){				// IT Portal(계약서)의뢰
				BNH0010.execute(null);
			}
			else if ( "BNH0011".equals(execCd) ){				// IT Portal(계약서전송)의뢰
				bnh0011_service.doExecService(param);
			}
			else if ("UserMig".equals(execCd)) {				//UserMig 사용자
				UserMig.execute(null);
			}
			else if ("CustMig".equals(execCd)) {				//CustMig 고객사
				usermig_service.createCust(null);
			}
			else if ( "BNH0012".equals(execCd) ){				// 사용자SYNC
				bnh0012_service.doExecService(param);
			}
			else if ( "BNH0013".equals(execCd) ){				// 첨부파일 과금
				BNH0013.execute(null);
			}
			else if ( "BNH0014".equals(execCd) ){				// 예가마감 사전안내
				BNH0014.execute(null);
			}
			else if ( "BNH0015".equals(execCd) ){				// 입찰 제출기한 및 마감 안내
				BNH0015.execute(null);
			}
			else if ( "BNH0016".equals(execCd) ){ 				// 11개월 시점에 휴먼전환 안내메일 발송
				BNH0016.execute(null);
			}
			else if ( "BNH0017".equals(execCd) ){
				BNH0017.execute(null);
			}
			else if ( "BNH0018".equals(execCd) ){ 				// 11개월 시점에 휴먼전환 안내SMS 발송(개인근로자)
				BNH0018.execute(null);
			}
			else if ( "BNH0019".equals(execCd) ){				// 12개월 이후에 휴먼계정전환 및 72개월 경과시 삭제처리(개인근로자)
				BNH0019.execute(null);
			}
			else if ( "BNH0020".equals(execCd) ){				// 검수 및 대금지급 요청 지연 안내
				BNH0020.execute(null);
			}
			else if ( "BNH0021".equals(execCd) ){				// SMS계약번호매핑
				bnh0021_service.doExecService(param);
			}			
			else if ( "CLOB".equals(execCd) ){
				mbtb0020Service.doChangeClob(null);
			}
			rtnMsg = msg.getMessage("0001");

        } catch (Exception e) {
			getLog().error(e.getMessage(), e);
        	rtnMsg = msg.getMessage("0003");
        }
		resp.setResponseMessage(rtnMsg);
	}


}

