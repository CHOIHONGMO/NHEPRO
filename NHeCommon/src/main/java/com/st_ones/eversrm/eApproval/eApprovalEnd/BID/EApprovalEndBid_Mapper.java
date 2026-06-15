package com.st_ones.eversrm.eApproval.eApprovalEnd.BID;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2014 ST-Ones CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EApprovalEndBid_Mapper.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
public interface EApprovalEndBid_Mapper {

	/**
	 * 모듈명 : 입찰공고 [BID]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	Map<String, String> getBidNum(Map<String, String> param);

	void setBidSignStatus(Map<String, String> param);

	void setBidStatus(Map<String, String> param);
	
	// 2021.01.25 입찰서 결재완료 후 PRDT의 구매진행상태=2350(입찰/견적 진행중)
	void setPrProgressCd(Map<String, String> param);
	
	Map<String, String> costSmsInfo(Map<String, String> param);

	Map<String, String> getRltBidNum(Map<String, String> param);

	void setRltSignStatus(Map<String, String> param);

	Map<String, String> getNegoBidNum(Map<String, String> param);

	void setNegoSignStatus(Map<String, String> param);

	List<Map<String, String>> getMailTargetList(Map<String, String> param);
	
	// 2021.03.03 우선협상 협력사 가져오기
	List<Map<String, String>> getMailNegoList(Map<String, String> param);

}