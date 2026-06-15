package com.st_ones.batch.nhebatch;

import java.util.List;
import java.util.Map;

public interface BNH0010_Mapper {
	int tbtCmReqInfo(Map<String, String> gridData);//IT Portal 계약의뢰정보 HD
	int tbtCmReqRelBzPart(Map<String, String> gridData);//IT Portal 계약의뢰 HD - 사용법인




	List<Map<String,String>> gettbtCmReqDetD1(Map<String, String> gridData);




	int tbtCmReqDetD1(Map<String, String> gridData);//IT Portal 계약의뢰 DET - 세부추진내역-검수자정보
	int tbtCmReqDetM(Map<String, String> gridData);//IT Portal 계약의뢰 DET - 세부추진내역
	int tbtCmReqDetStnd_not_find(Map<String, String> gridData);//IT Portal 계약의뢰 DET - 세부추진내역-표준물품명세서(IT자산)
	int tbtCmReqDetStndMnt(Map<String, String> gridData);//IT Portal 계약의뢰 DET - 세부추진내역-표준물품명세서(유지보수용)

	int tbtCmReqMulpumAcqui(Map<String, String> gridData);//TBT_CM_REQ_MULPUM_ACQUI
	int tbtCmReqMulpumBdgt(Map<String, String> gridData);//IT Portal 계약의뢰 DT - 표준물품-예산부서
	int tbtCmReqMulpumPay(Map<String, String> gridData);//IT Portal 계약의뢰 DT - 표준물품-대금집행부서
	int tbtCmReqMulpumSpec(Map<String, String> gridData);//IT Portal 계약의뢰 DT - 표준물품명세서
	int tbtCmWf(Map<String, String> gridData);//IT Portal 계약 상태정보
	int tbtPtCode(Map<String, String> gridData);//IT Portal 코드테이블


	int tbtCmReqD2(Map<String, String> gridData);//IT Portal 계약의뢰 HD - 업체정보 및 첨부파일
	int tbtCmAttach(Map<String, String> gridData);//IT Portal 첨부파일 정보(견적서, 방침문서등)



	List<Map<String,String>> getTragetPrReqList(Map<String, String> gridData);
	Map<String,String> getPrReqInfo(Map<String, String> gridData);
	int changeLongTermNonUser(Map<String, String> gridData);
	int changeLongTermNonUserUsap(Map<String, String> gridData);
	int changeLongTermNonUserBacp(Map<String, String> gridData);
	int deleteChangeLongTermNonUser(Map<String, String> gridData);
	
	
	List<Map<String,String>> getTragetPrList(Map<String, String> gridData);
	int makePrhd(Map<String, String> gridData);
	int makePrdt(Map<String, String> gridData);
	int completeTarget(Map<String, String> gridData);

	Map<String,String> getPrInfo(Map<String, String> gridData);
	int delPrhd(Map<String, String> gridData);
	int delPrdt(Map<String, String> gridData);

}