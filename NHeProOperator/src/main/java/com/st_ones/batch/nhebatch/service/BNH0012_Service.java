package com.st_ones.batch.nhebatch.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0012_Mapper;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverEncryption;

/**
 * 사용자,부서SYNC
 * @author divin
 *
 */
@Service(value = "BNH0012_Service")
public class BNH0012_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0012_Mapper bnh0012mapper;

    String tempFolder = null;
    String completeFolder = null;

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		
		System.err.println("==========================================BNH0012_Service===================================================");
		List<Map<String, String>> custList = bnh0012mapper.getTagrgetCust(param);
		int cou = 0;
		for(Map<String, String> cust : custList) {
			
			System.err.println("=====================cou="+cou++);
			bnh0012mapper.delOgdp(cust);
			bnh0012mapper.insOgdp(cust);

			List<Map<String, String>> targetuserList = bnh0012mapper.getCoUserList(cust);
			for(Map<String, String> targetuser : targetuserList) {
				targetuser.put("CUST_CD", cust.get("CUST_CD"));
				
				Map<String, String> chkUser = bnh0012mapper.chkStocUser(targetuser);
				if( chkUser == null || chkUser.size() == 0 ) {
					// 2021.11.03 퇴사한 사용자인 경우 등록하지 않음
					if(StringUtils.isNotEmpty(targetuser.get("EMP_STSC")) && !"4".equals(targetuser.get("EMP_STSC"))) {
						// 2023.01.04 사용자 테이블에 존재하지 않으면 휴먼계정 테이블에서도 조회하여 휴먼계정이면 휴먼사용자 정보 업데이트
						Map<String, String> humanChkUser = bnh0012mapper.chkStohUser(targetuser);
						if( humanChkUser == null || humanChkUser.size() == 0 ) {
							targetuser.put("PASSWORD",EverEncryption.getEncryptedUserPassword(targetuser.get("USER_ID").toUpperCase()));
							// 2021.02.26 로직 추가
							// 지역농축협(CORP_TYPE=2) 주무서무(GNAF_DSC=1)이면 관리자여부(MNG_YN)를 'Y'로 변경하고 ELSE 'N'으로 변경함
							targetuser.put("CORP_TYPE", cust.get("CORP_TYPE"));
							bnh0012mapper.insCvur(targetuser);
							bnh0012mapper.insUsap(targetuser);
							bnh0012mapper.insBacp(targetuser);
						} else {
							targetuser.put("COMPANY_CD", cust.get("CUST_CD"));
							// 지역농축협(CORP_TYPE=2) 주무서무(GNAF_DSC=1)이면 관리자여부(MNG_YN)를 'Y'로 변경하고 ELSE 'N'으로 변경함
							targetuser.put("CORP_TYPE", cust.get("CORP_TYPE"));
							bnh0012mapper.upsHvur(targetuser);
							bnh0012mapper.upsBacp(targetuser);
						}
					} else {
						// 2023.01.04 휴먼계정이면서 퇴사한 경우 삭제 처리
						Map<String, String> stohChkUser = bnh0012mapper.chkStohUser(targetuser);
						if( stohChkUser == null || stohChkUser.size() == 0 ) {
							
						} else {
							bnh0012mapper.delHvur(targetuser);
							bnh0012mapper.delUsap(targetuser);
							bnh0012mapper.delBacp(targetuser);
						}
					}
				} else {
					// 2021.11.03 퇴사한 사용자인 경우 삭제 처리함
					if(StringUtils.isNotEmpty(targetuser.get("EMP_STSC")) && "4".equals(targetuser.get("EMP_STSC"))) {
						bnh0012mapper.delCvur(targetuser);
						bnh0012mapper.delUsap(targetuser);
						bnh0012mapper.delBacp(targetuser);
					} else {
						targetuser.put("COMPANY_CD", cust.get("CUST_CD"));
						// 2021.02.26 로직 추가
						// 지역농축협(CORP_TYPE=2) 주무서무(GNAF_DSC=1)이면 관리자여부(MNG_YN)를 'Y'로 변경하고 ELSE 'N'으로 변경함
						targetuser.put("CORP_TYPE", cust.get("CORP_TYPE"));
						bnh0012mapper.upsCvur(targetuser);
						// 2024.05.31 로직 추가
						// 기존 사용자가 인사발령등으로 인하여 고객사가 변경되는 경우 기존 사용자의 권한 테이블의 고객사도 변경 해주어야 로그인시 기본 권한 메뉴가 조회됨
						bnh0012mapper.upsBacp(targetuser);
					}
				}
			}
		}
		return msg.getMessage("0001");
	}

}
