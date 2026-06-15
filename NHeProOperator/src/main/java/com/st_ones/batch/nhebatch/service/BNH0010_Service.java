package com.st_ones.batch.nhebatch.service;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.st_ones.batch.nhebatch.BNH0010_Mapper;
import com.st_ones.batch.nhebatch.InterFaceCommon;
import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.config.PropertiesManager;
/**
 *
 * @author divin
 *
 */
@Service(value = "bnh0010_service")
public class BNH0010_Service {
	@Autowired private MessageService msg;
	@Autowired private BNH0010_Mapper BNH0010Mapper;
    @Autowired private DocNumService docNumService;



	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String doExecService(Map<String, String> param) throws Exception {
		System.err.println("==========================================BNH0010_Service===================================================");
        String targetFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0010");
        String completeFolder = PropertiesManager.getString("eversrm.interface.folder.BNH0010.complete");
//		System.err.println("==========================================BNH0010_Service==================================================targetFolder="+targetFolder);
//		System.err.println("==========================================BNH0010_Service==================================================completeFolder="+completeFolder);


        File dir = new File(targetFolder);
		File[] fileList = dir.listFiles();// 타겟폴더에서 파일리스트를 가져온다.


		if(fileList==null) return msg.getMessage("0001"); // 타겟 폴더가 없으면

		String ifType = "";//구매의뢰 I/F 유형 - [NH0029] - PMS, ITA(중앙회 IT Portal), ITB(은행 IT Portal )

//		System.err.println("======================================================fileList.length="+fileList.length);


		for(int k=0;k < fileList.length;k++) {
			File file = fileList[k];
			if (file.isFile() && InterFaceCommon.escapeChkFile(file) ) { //파일만 처리한다.
				if(file.getName().substring(0,1).equals("S")||file.getName().substring(0,1).equals("B")) {
					if (file.getName().substring(0,1).equals("S")) { ifType = "ITA"; }
					if (file.getName().substring(0,1).equals("B")) { ifType = "ITB"; }

					if(file.getName().indexOf("SINF_") > -1 || file.getName().indexOf("BINF_") > -1) {//계약의뢰정보
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",33,"CM_REQ_ID,H_ESTIMATE_AMOUNT,LMOD_USER_ID,L_ESTIMATE_AMOUNT,REQ_DEPT_ID,CM_REQ_NM,REG_USER_ID,REQ_USER_NM,REG_DEPT_ID,REG_USER_NM,MNT_YN,SYSMODTIME,OFFICE_DOCU_NUM,CM_IGWAN_YN,C_ESTIMATE_AMOUNT,F_ESTIMATE_AMOUNT,MNT_TYPE,REQ_DEPT_NM,CM_PROC_USER_NM,ESTIMATE_AMOUNT,B_ESTIMATE_AMOUNT,A_ESTIMATE_AMOUNT,REG_DEPT_NM,D_ESTIMATE_AMOUNT,CM_REQ_ACTING_YN,APPR_PHASE,CM_PROC_USER_ID,REQ_USER_ID,DCSN_AUTH_JNAME,CM_LIMIT_SDAY,E_ESTIMATE_AMOUNT,REG_STIME,LMOD_USER_NAME");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqInfo(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SBZT_") > -1 || file.getName().indexOf("BBZT_") > -1) {//계약의뢰사용법인
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",4,"CM_REQ_ID,BZ_PART_ID,BZ_PART_NM,DEL_FLAG");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqRelBzPart(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SEST_") > -1 || file.getName().indexOf("BEST_") > -1) {//견적서업체정보
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",6,"CM_REQ_ID,REC_NUM,OM_COMP_NM,FILE_ID,OM_COMP_ID,FILE_GBN");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqD2(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SATT_") > -1 || file.getName().indexOf("BATT_") > -1) {//첨부파일정보
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",22,"CM_KEY_ID,REC_NUM,FILE_ID,TYPE,ORG_FILE_NAME,NEW_FILE_NAME,FILE_PATH,FILE_SIZE,WRITTEN_BY_ID,WRITTEN_BY_NM,ATTACH_STIME,BZ_PART_ID,BZ_PART_NM,ATTACH_TITLE,BIGO,LMOD_USER_ID,LMOD_USER_NAME,SYSMODTIME,INSPECT_SDAY,INSP_REQ_SDAY,SUB_CM_ID,CHG_TYPE");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmAttach(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					// >>> 를 >>>> 로 변경해주어야함.
					if(file.getName().indexOf("SDET_") > -1 || file.getName().indexOf("BDET_") > -1) {//계약의뢰_계약체결내용
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",70,"CM_REQ_DET_ID,JUYO_MULPUM_CD,REG_USER_NM,PAY_PERIOD_MTHD,CM_REQ_DET_NM,REG_STIME,MNT_GUR_MONTH,SYSMODTIME,FRT_CLS_MM,OLD_CM_NM,DOIB_AMOUNT,MID_CLS_MM,MAIN_PART_NM,YOYUL,BDGT_AMOUNT,PAY_PERIOD_MTHD2,F_DET_ESTIMATE_AMOUNT,OLD_CM_DET_NM,DOIB_NUM,BDGT_DEPT_NM,MNT_PAY_BY,OLD_CM_NUM,CM_REQ_ID,CM_SAYU,L_DET_ESTIMATE_AMOUNT,DET_ESTIMATE_AMOUNT,A_DET_ESTIMATE_AMOUNT,CM_TYPE,OM_COMP_NM,ACC_DET_NM,CM_PR_CORP,SPC_CLS_MM,OLD_CM_DET_ID,REQ_MODIFY_SAYU,E_DET_ESTIMATE_AMOUNT,CM_STN_SPEC_REG_YN,B_DET_ESTIMATE_AMOUNT,BDGT_NUM,BDGT_AGREE_NUM,ACC_AM_NM,ASSET_ACQ_DEPT_NM,D_DET_ESTIMATE_AMOUNT,MNT_SANGJU_YN,BZ_TIMELINE_EDAY,CM_PROVISION,CM_CLASS_NM,OLD_CM_ID,LMOD_USER_ID,TOT_CLS_MM,LMOD_USER_NAME,ACC_CD,H_DET_ESTIMATE_AMOUNT,ACC_HNG_NM,ACC_MOK_NM,CM_DET_SPEC_REG_YN,ASSET_OWNER_GUBUN,C_DET_ESTIMATE_AMOUNT,PAY_DEPT_NM,BZ_TIMELINE_SDAY,MNT_TOT_HOECHA,HIG_CLS_MM,SUB_CONT_YN,OM_COMP_ID,REG_USER_ID,CM_TR_CORP,GISANIL,BM_DRV_BZ_ID,PRE_BUYER_CD,PRE_CONT_NUM,PRE_CONT_CNT");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqDetM(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SMNT_") > -1 || file.getName().indexOf("BMNT_") > -1) {//계약의뢰_계약체결내용_유지보수
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",27,"MODEL_NM,LMOD_USER_ID,MNT_AMOUNT,DOIB_AMOUNT,CM_PR_CORP,REG_STIME,ASSET_NM,REC_NUM,CM_REQ_DET_ID,YOYUL,REG_USER_NM,MNT_GRADE,GISANIL,REG_USER_ID,SYSMODTIME,CM_AMOUNT,ASSET_NO,LMOD_USER_NAME,INTRO_YONGDO,ACQUI_BZ_PART_INFO,BIGO,AM_CNT,DEL_YN,CM_REQ_ID,MNT_GUR_MONTH,MULPUM_GBN,MAF_COMP");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqDetStndMnt(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SAUT_") > -1 || file.getName().indexOf("BAUT_") > -1) {//계약의뢰_세부추진내역_검수자정보 ("NHEPRO"."TBT_CM_REQ_DET_D1"."CM_REQ_DET_ID") CM_REQ_DET_ID null 인 데이터가 있음
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",11,"DAMDANG_USER_ID,CONTACT_OFFICE,REC_NUM,DAMDANG_DEPT_NM,DAMDANG_USER_NM,JBC_POSI,CM_REQ_DET_ID,DAMDANG_GBN,JBC_JNAME,CM_REQ_ID,DAMDANG_DEPT_ID");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
//							System.err.println("=============data=="+data);
							if (data.get("CM_REQ_DET_ID") == null || "".equals(data.get("CM_REQ_DET_ID"))) continue;


//							List<Map<String,String>> aaaaa = BNH0010Mapper.gettbtCmReqDetD1(data);
//							System.err.println("==========================================================aaaaa="+aaaaa.size());

							BNH0010Mapper.tbtCmReqDetD1(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}
					
					//2022.07.18 표준물품명세서 I/F시 초,중,고,특급 MM필드 삭제 후 개발비등급코드 필드 추가
					if(file.getName().indexOf("SMUL_") > -1 || file.getName().indexOf("BMUL_") > -1) {//계약의뢰_표준물품명세서
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",46,"MULPUM_ID,CM_REQ_ID,CM_AMOUNT,MULPUM_NUM,AM_CNT_DANWI,LMOD_USER_ID,CM_PR_CORP,DOIB_YONGDO,REG_USER_NM,ACC_CD,MULPUM_GBN,MULPUM_NM,USE_BIZ_PART_INFO,ESTIMATE_AMOUNT,L_ESTIMATE_AMOUNT,AM_CATE_TYPE,ACC_MOK_NM,A_ESTIMATE_AMOUNT,MAF_COMP,CONSUME_AMOUNT,CM_REQ_DET_ID,AM_CNT,REL_DOCU_NUM,REG_STIME,REG_USER_ID,E_ESTIMATE_AMOUNT,GIJON_ASSET_MNG_NO,ACC_DET_NM,AM_TYPE,B_ESTIMATE_AMOUNT,LICEN_TYPE,C_ESTIMATE_AMOUNT,CONSUME_BY_AMOUNT,H_ESTIMATE_AMOUNT,CLS_GRADE,TOT_TUIB_GONGSU,F_ESTIMATE_AMOUNT,D_ESTIMATE_AMOUNT,DEL_YN,ACC_HNG_NM,REL_DOCU_NM,ASSET_TYPE,MNG_AM_YN,DOIB_DESC,LMOD_USER_NAME,SYSMODTIME");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							System.err.println("=============data=="+data);
							BNH0010Mapper.tbtCmReqMulpumSpec(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SACQ_") > -1 || file.getName().indexOf("BACQ_") > -1) {//계약의뢰_표준물품_취득부서
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",9,"SYSMODTIME,ACQUI_BUSEO_NM,BZ_PART_ID,ACQUI_BUSEO_ID,REC_NUM,MULPUM_ID,DEL_FLAG,ACQUI_AMOUNT,BZ_PART_NM");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqMulpumAcqui(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SBDT_") > -1 || file.getName().indexOf("BBDT_") > -1) {//계약의뢰_표준물품_예산부서
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",9,"BZ_PART_ID,BDGT_BUSEO_ID,MULPUM_ID,DEL_FLAG,SYSMODTIME,BZ_PART_NM,BDGT_AMOUNT,BDGT_BUSEO_NM,REC_NUM");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqMulpumBdgt(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SPAY_") > -1 || file.getName().indexOf("BPAY_") > -1) {//계약의뢰_표준물품_대금집행부서
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",7,"PAY_BUSEO_ID,MULPUM_ID,REC_NUM,SYSMODTIME,PAY_EXE_AMOUNT,PAY_BUSEO_NM,DEL_FLAG");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmReqMulpumPay(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}

					if(file.getName().indexOf("SCOD_") > -1 || file.getName().indexOf("BCOD_") > -1) {//코드테이블
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",8,"CODE_ID,CODE,CODE_NAME,UPPER_CODE,OUTPRNT_ORD,USE_PART,USE_YN,CODE_DESC");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtPtCode(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}


					if(file.getName().indexOf("SWKF_") > -1 || file.getName().indexOf("BWKF_") > -1) {//계약상태정보
						List<Map<String,String>> list = InterFaceCommon.parseFile(completeFolder,file,">>>>",10,"CM_REQ_ID,CM_REQ_DET_ID,BM_DRV_BZ_ID,CM_ID,CM_DET_ID,CM_PAY_FIX_ID,MNT_SUGI_YN,CM_STATUS,ING_STATUS,SYSMODTIME");
						for( Map<String,String> data : list ) {
							data.put("IF_TYPE", ifType);
							BNH0010Mapper.tbtCmWf(data);
						}
						file.renameTo(new File(completeFolder+file.getName()));
						File chkFileName = new File(file.getAbsolutePath().substring(0, file.getAbsolutePath().indexOf("."))+".chk");
						chkFileName.renameTo(new File(completeFolder+chkFileName.getName()));
					}
				} else {
					System.err.println("========escape file="+file.getName());
				}
			}
		}
		
		//2022.11.28 PRHD, PRDT 구매의뢰 데이터 생성 전 요청자가 전자구매시스템 휴먼계정인경우 휴먼계정 해제 선처리
		List<Map<String,String>> prReqTarget = BNH0010Mapper.getTragetPrReqList(new HashMap<String, String>());
		for( Map<String,String> Reqdata : prReqTarget ) {
			
			Map<String,String> prReqInfo = BNH0010Mapper.getPrReqInfo(Reqdata);
			if (prReqInfo !=null) {
				// 휴먼계정 이관(STOCCVUR)
				BNH0010Mapper.changeLongTermNonUser(Reqdata);
				
				// 휴먼계정 기존 권한프로파일 부여(STOCUSAP)
				BNH0010Mapper.changeLongTermNonUserUsap(Reqdata);
						
				// 휴먼계정 기존 직무권한 부여(STOCBACP)
				BNH0010Mapper.changeLongTermNonUserBacp(Reqdata);
				
				// 휴먼계정 삭제(STOHCVUR)
				BNH0010Mapper.deleteChangeLongTermNonUser(Reqdata);
			} else {
				
			}
		}
		
		// 임시테이블 --> PRHD,PRDT
		List<Map<String,String>> prTarget = BNH0010Mapper.getTragetPrList(new HashMap<String, String>());
		for( Map<String,String> data : prTarget ) {

			Map<String,String> prInfo = BNH0010Mapper.getPrInfo(data);

			if (prInfo !=null) {// CM_REQ_ID 로 체크해서 존재하면
				if ("N".equals(prInfo.get("EDIT_YN"))) { // 결재상태가 E 이면 패스

				} else {
					BNH0010Mapper.delPrhd(data);
					BNH0010Mapper.delPrdt(data);
		            data.put("PR_NUM", prInfo.get("PR_NUM"));
		            BNH0010Mapper.makePrdt(data);
					BNH0010Mapper.makePrhd(data);
					BNH0010Mapper.completeTarget(data);
				}
			} else {
				String prNo = docNumService.getDocNumber(data.get("BUYER_CD"), "PR");
	            data.put("PR_NUM", prNo);
	            BNH0010Mapper.makePrdt(data);
				BNH0010Mapper.makePrhd(data);
				BNH0010Mapper.completeTarget(data);
			}


		}
		//if (1==1) throw new Exception("================");
		return msg.getMessage("0001");
	}


}
