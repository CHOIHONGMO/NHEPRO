package com.st_ones.nhepro.SRQR;

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
 * @File Name : SRQR0010_Mapper.java
 * @date 2020.06.10
 * @version 1.0
 * @see
 */
public interface SRQR0010_Mapper {

	/**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    List<Map<String,Object>> srqr0010_doSearch(Map<String, String> param) throws Exception;
    String checkVendorRfxProgressCode(Map<String, Object> param);
	void doWaiveRfqReceiptStatus(Map<String, Object> gridData);
	String getCompulsionFlag(Map<String, Object> gridData);
	void doAcceptRfx(Map<String, Object> gridData);
	void doCompulsionCloseRFX(Map<String, Object> gridData);
	
	/** ******************************************************************************************
     * 견적서 작성(협력업체)
     * @param req
     * @return
     * @throws Exception
     */
	List<Map<String, String>> getVendorQtaCreation(Map<String, String> param);
	Map<String, String> doSearchQtaCreation_F(Map<String, String> param);
	List<Map<String, Object>> doSearchQtaCreation_G(Map<String, String> param);
	String getRfqCloseFlag(Map<String, String> formData);
	int checkValidVendor(Map<String, String> formData);
	void doUpdateQtaCreation_RQVN(Map<String, String> formData);
	int checkExistsQtaCreation_QTHD(Map<String, String> formData);
	void doInsertQtaCreation_QTHD(Map<String, String> formData);
	void doUpdatePreviousLastFlag_QTHD(Map<String, String> formData);
	int checkCompanyCode(Map<String, String> formData);
	void doUpdateQtaCreation_QTHD(Map<String, String> formData);
	int checkExistsQtaCreation_QTDT(Map<String, Object> formData);
	int getQtaSq(Map<String, Object> gridData);
	void doInsertQtaCreation_QTDT(Map<String, Object> gridData);
	void doUpdateQtaCreation_QTDT(Map<String, Object> gridData);
	void doUpdateQtaCreation_SendDate(Map<String, String> formData);
	
    /**
	 * 화면명 : 견적현황
	 * 처리내용 : 협력업체 견적현황
	 * 경로 : 계약관리 > 견적관리 > 견적현황
	 */
    Map<String,Object> srqr0012_doSearchRQHD(Map<String, String> param) throws Exception;
    List<Map<String,Object>> srqr0012_doSearchRQDT(Map<String, String> param) throws Exception;
    
    /**
	 * 화면명 : 견적결과
	 * 처리내용 : 협력업체 견적결과
	 * 경로 : 계약관리 > 견적관리 > 견적결과
	 */
    List<Map<String,Object>> srqr0020_doSearch(Map<String, String> param) throws Exception;
    
    /**
	 * 메일 발송 담당자 가져오기
	 */
    //Map<String, String> getMailInfo(Map<String, String> param);
    List<Map<String, String>> getMailInfo(Map<String, String> param);
}

