package com.st_ones.nhepro.CCBR;

import org.springframework.stereotype.Repository;

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
 * @File Name : CCBR0010_Mapper.java
 * @date 2024. 4. 01.
 * @version 1.0
 */
@Repository
public interface CCBR0010_Mapper {

	/**
     * 화면명 : 계약수수료청구내역
     * 처리내용 : 계약수수료청구내역 조회(농협파트너스 외 고객사)
     * 경로 : 고객사 > 마감관리 > 마감관리 > 계약수수료청구내역
     */
    List<Map<String, Object>> ccbr0010_doSearch(Map<String, String> param);
    
    Map<String, Object> ccbr0010_doSearchSUM(Map<String, String> param);
    
    /**
     * 화면명 : 계약수수료청구내역
     * 처리내용 : 계약수수료청구내역 조회(농협파트너스 고객사)
     * 경로 : 고객사 > 마감관리 > 마감관리 > 계약수수료청구내역
     */
    List<Map<String, Object>> ccbr0010_doSearchPT(Map<String, String> param);
    
    Map<String, Object> ccbr0010_doSearchPTSUM(Map<String, String> param);
    
    /**
     * 화면명 : SMS수수료청구내역
     * 처리내용 : SMS수수료청구내역
     * 경로 : 경로 : 고객사 > 마감관리 > 마감관리 > SMS수수료청구내역
     */
    List<Map<String, Object>> ccbr0020_doSearchSMS(Map<String, String> param);
    
    Map<String, Object> ccbr0020_doSearchSMSSUM(Map<String, String> param);
    
    /**
     * 화면명 : SMS수수료청구내역
     * 처리내용 : SMS수수료청구내역
     * 경로 : 경로 : 고객사 > 마감관리 > 마감관리 > SMS수수료청구내역
     */
    List<Map<String, Object>> ccbr0020_doSearchSMSPT(Map<String, String> param);
    
    Map<String, Object> ccbr0020_doSearchSMSPTSUM(Map<String, String> param);

}