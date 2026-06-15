package com.st_ones.nhepro.SBDR;

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
 * @File Name : SBDR0010_Mapper.java
 * @date 2020. 4. 29.
 * @version 1.0
 */

@Repository
public interface SBDR0010_Mapper {

    /**
     * 화면명 : 입찰참가신청
     * 처리내용 : 입찰공고 및 입찰참가신청 중인 입찰건의 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청
     */
    List<Map<String, Object>> sbdr0010_doSearch(Map<String, String> param);

    /**
     * 화면명 : 참가신청등록
     * 처리내용 : 협력업체에서 참가신청서를 제출하는 화면 (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰참가신청 > 참가신청등록
     */
    Map<String, String> sbdi0013_doSearch(Map<String, String> param);
    
    Map<String, String> sbdr0010_doCheckProgressCd(Map<String, String> param);
    
    Map<String, String> sbdi0013_getPossibleFlag(Map<String, String> param);

    void sbdi0013_doSubmit(Map<String, String> formData);
    
    /**
     * 2021.10.21 입찰신청취소 추가
     * @param formData
     */
    void sbdi0013_doCancelReq(Map<String, String> formData);
    
    void sbdi0013_doDeleteReq(Map<String, String> formData);

    Map<String, String> sbdr0014_doSearch(Map<String, String> param);

    /**
     * 화면명 : 가격입찰
     * 처리내용 : 입찰서 제출 전부터 개찰 전까지의 입찰 목록이 조회하는 화면.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰
     */
    List<Map<String, Object>> sbdr0020_doSearch(Map<String, String> param);

    /**
     * 화면명 : 입찰서제출
     * 처리내용 : 협력업체에서 입찰서를 제출하는 화면. (제출시 공인인증서를 이용하여 전자서명을 진행해야 한다)
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 가격입찰 > 입찰서제출
     */
    Map<String, String> sbdi0021_doSearchHD(Map<String, String> param);

    List<Map<String, Object>> sbdi0021_doSearch(Map<String, String> param);
    
    Map<String, String> sbdr0020_doCheckProgressCd(Map<String, String> param);
    
    List<Map<String, Object>> getCheckChoiceNum(Map<String, String> param);

    String getSendPossibleFlag(Map<String, String> param);

    String getSendPossibleFlagPrc(Map<String, String> param);

    void sbdi0021_doInsertVO(Map<String, String> formData);

    void sbdi0021_doInsertVD(Map<String, Object> gridData);

    void sbdi0021_doUpdateVO(Map<String, String> formData);

    void sbdi0021_doUpdateVD(Map<String, Object> gridData);

    /**
     * 화면명 : 입찰결과
     * 처리내용 : 협력업체에서 참여한 입찰의 개찰결과 목록이 조회된다.
     * 경로 : 협력업체 > 구매관리 > 입찰관리 > 입찰결과
     */
    List<Map<String, Object>> sbdr0030_doSearch(Map<String, String> param);
    
    void sbdi0013_doBidGuarCancel(Map<String, String> param);
    
    Map<String, String> sbdi0013_getguarInformation(Map<String, String> param);

}