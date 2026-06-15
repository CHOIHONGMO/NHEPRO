package com.st_ones.eversrm.eApproval.eApprovalEnd.PR;

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
public interface EApprovalEndPr_Mapper {

	/**
	 * 모듈명 : 구매의뢰 [PR]
	 * 처리내용 : SIGN_STATUS, SIGN_DATE, PROGRESS_CD 변경.
	 */
	public String getPrNum(Map<String, String> param);

	public void setPrSignStatus(Map<String, String> param);

	public void setPrProgressCd(Map<String, String> param);



    //직발주 대상 pr item 가져오기 order by vendor_cd
    public List<Map<String, Object>> getDirectPoTargetVendor(Map<String, String> map);

    public List<Map<String, Object>> getDirectPoTarget(Map<String, Object> map);


    // 직발주 나간건 PROGRESS_CD 업데이트  --5200 발주완료 M062
	public void setDirectPoProgressCd(Map<String, Object> param);

	// 직발주건 생성
	public void insertPohd(Map<String, Object> param);
	public void insertPodt(Map<String, Object> param);

    public Map<String, String> getPrhd(Map<String, Object> map);




}