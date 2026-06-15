package com.st_ones.eversrm.eApproval.eApprovalEnd.ESTM;

import org.apache.ibatis.annotations.Param;

import java.util.HashMap;
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
 * @File Name : EApprovalEndPr_Mapper.java
 * @date 2020. 4. 02.
 * @version 1.0
 */
public interface EApprovalEndESTM_Mapper {

	/**
	 * 모듈명 : 구매의뢰 [PR]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	public Map<String, String> getBdesNum(Map<String, String> param);

	public void setBdesSignStatus(Map<String, String> param);


}