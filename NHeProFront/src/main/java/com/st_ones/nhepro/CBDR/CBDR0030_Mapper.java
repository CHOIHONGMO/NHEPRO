package com.st_ones.nhepro.CBDR;

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
 * @File Name : CBDR0030_Mapper.java
 * @date 2020. 5. 18.
 * @version 1.0
 */
@Repository
public interface CBDR0030_Mapper {

    /**
     * 화면명 : 입찰진행
     * 처리내용 : 입찰공고 마감 이후 개찰전까지의 입찰공고 목록이 조회하는 화면.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행
     */
    List<Map<String, Object>> cbdr0030_doSearch(Map<String, String> param);

    void cbdr0030_doUserChange(Map<String, Object> data);

    void cbdr0030_doFinishEvel(Map<String, Object> data);

    List<Map<String, Object>> cbdr0030_getEtResults(Map<String, Object> gridData);

    void cbdr0030_doInsertSP(Map<String, Object> data);

    /**
     * 화면명 : 규격평가등록결과 등록
     * 처리내용 : 2단계(분리)경쟁의 규격평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 규격평가등록결과 등록
     */
    Map<String, String> cbdi0031_doSearchHD(Map<String, String> param);

    List<Map<String, Object>> cbdi0031_doSearch(Map<String, String> param);

    String cbdi0031_getEvPossibleFlag(Map<String, String> param);

    void cbdi0031_doConfirm(Map<String, Object> data);

    /**
     * 화면명 : 입찰시간 알림
     * 처리내용 : 2단계(분리)경쟁 또는 재입찰시 입찰서 제출일시 및 개찰일시를 지정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰시간 알림
     */
    Map<String, String> cbdi0032_doSearchHD(Map<String, String> param);

    String getBidTimePossibleFlag(Map<String, String> param);

    String getReBidTimePossibleFlag(Map<String, String> param);

    void cbdi0032_doConfirm(Map<String, String> formData);

    void cbdi0032_doInsertNewVote(Map<String, String> formData);

    void cbdi0032_doMergeNewVote(Map<String, String> formData);

    /**
     * 화면명 : 입찰신청자조서 및 입찰비교표
     * 처리내용 : 입찰에 참여한 협력업체 입찰정보를 참고하여 낙찰자를 선정하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표
     */
    Map<String, String> checkOpenPossible(Map<String, Object> data);

    List<Map<String, Object>> checkSignDataList(Map<String, Object> param);

    void setDecVO(Map<String, String> data);

    void setDecVD(Map<String, String> data);

    void setDecES(Map<String, String> data);

    String getEstmType(Map<String, String> data);

    void setFinalEstmPrcSE(Map<String, String> data);

    List<Map<String, Object>> getVendorChoiceList(Map<String, String> data);

    List<Map<String, String>> getChoiceRankList(Map<String, Object> data);

    List<Map<String, Object>> getEstmPrcList(Map<String, Object> data);

    void setFinalEstm(Map<String, Object> data);

    Map<String, String> cbdr0033_doSearchHD(Map<String, String> param);

    Map<String, String> getSettleVendor(Map<String, String> param);

    List<Map<String, Object>> cbdr0033_doSearchVendorVO_LPTD(Map<String, Object> param);

    List<Map<String, Object>> cbdr0033_doSearchVendorVO_Etc(Map<String, Object> param);

    List<Map<String, Object>> cbdr0033_doSearchVendorVO_Individual(Map<String, Object> param);

    void setBidRank(Map<String, Object> data);

    void doSuccessfulOrFailBid(Map<String, Object> data);

    void doCleanBidStatus(Map<String, Object> data);

    void doCleanBidStatus2(Map<String, Object> data);

    List<Map<String, Object>> getVendorList(Map<String, Object> param);

    /**
     * 화면명 : 종합낙찰제결과 등록
     * 처리내용 : 종합낙찰제의 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 종합낙찰제결과 등록
     */
    List<Map<String, String>> cbdi0034_doSearchIndividualFlag(Map<String, String> param);

    List<Map<String, Object>> cbdi0034_doSearchVendorVO(Map<String, String> param);

    List<Map<String, Object>> cbdi0034_doSearchVendorVoIndividual(Map<String, Object> param);

    void doMergePrcScore(Map<String, Object> gridData);

    List<Map<String, Object>> getRankList(Map<String, String> param);

    void cbdi0034_doUpdateAppNum(Map<String, String> param);

    /**
     * 화면명 : 기술평가결과 등록
     * 처리내용 : 협상에 의한 계약 입찰에서 기술평가구분이 “평가결과등록” 인 경우 평가 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 기술평가결과 등록
     */
    List<Map<String, Object>> cbdi0035_doSearch(Map<String, String> param);

    String cbdi0035_getEvPossibleFlag(Map<String, String> param);

    void cbdi0035_doMergeSP(Map<String, Object> gridData);

    /**
     * 화면명 : 적격심사결과 등록
     * 처리내용 : 적격심사 결과를 등록하는 화면
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰진행 > 입찰신청자조서 및 입찰비교표 > 적격심사결과 등록
     */
    Map<String, String> cbdri036_doSearchHD(Map<String, String> param);

    List<Map<String, Object>> cbdi0036_doSearchVendorVO(Map<String, String> param);

    List<Map<String, Object>> cbdi0036_doSearchVendorVoIndividual(Map<String, Object> param);

    void doUpdateScore(Map<String, Object> gridData);

    String getFailVendorCnt(Map<String, Object> param);

    String getFailVendorCntNE(Map<String, Object> param);
    
    /**
     * 2021.03.23 추가
     * 기술평가결과등록, 종합낙찰제에서 기술협상결과 및 비고 추가하기
     * @param gridData
     */
    void doUpdateNegoHeader(Map<String, String> param);
    void doUpdateNegoInfo(Map<String, Object> gridData);
    
    /**
     * 화면명 : 입찰결과
     * 처리내용 : 개찰 이후의 입찰공고 목록이 조회된다.
     * 경로 : 고객사 > 구매관리 > 입찰관리 > 입찰결과
     */
    List<Map<String, Object>> cbdr0040_doSearch(Map<String, Object> param);

    void cbdr0040_doUpdateAppNum(Map<String, Object> gridData);

    /**
     * 공통모듈
     */
    void setBidStatus(Map<String, String> data);

    void setBidStatusVO(Map<String, String> data);

    String getBidStatus(Map<String, Object> param);

    String getOriBidStatus(Map<String, Object> param);

    List<Map<String, Object>> getPrList(Map<String, String> param);

    void setPrProgressCd(Map<String, Object> data);

    List<Map<String, Object>> getCnWtList(Map<String, String> param);

    void doInsertCNHB(Map<String, Object> data);

    List<Map<String, String>> getBidMailTargetList(Map<String, String> param);

}