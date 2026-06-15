import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestPREINF {

	public static void main(String[] args) {
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "PREINF";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)
			parseXML(templatePath, docCode, xmlDoc);
	}
	
	public static String composeXML(String templatePath, String docCode)
	{
		/* 선금정보통보서(PREINF) */								
		/* HEADER */								
		String	head_mesg_send  ="A111111111900";	/*	[필수]	 전문송신기관	*/
		String	head_mesg_recv  ="z120811300200";	/*	[필수]	 전문수신기관	*/
		String	head_func_code  ="53";				/*	[필수]	 문서기능	*/
		String	head_mesg_type  ="PREINF";			/*	[필수]	 문서코드	*/
		String	head_mesg_name  ="선금정보통보서";	/*	[필수]	 문서명	*/
		String	head_mesg_vers  ="1.0";				/*	[선택]	 전자문서버전	*/
		String	head_docu_numb  ="0043338 2";		/*	[필수]	 문서번호	*/
		String	head_mang_numb  ="13.20060227151000.12345.0043338' '2";	/*	[필수]	 문서관리번호	*/
		String	head_refr_numb  ="0043338 2";		/*	[필수]	 참조번호	*/
		String	head_titl_name  ="선금정보통보서";	/*	[필수]	 문서개요	*/
		String  head_orga_code  ="ABC";             /*  [필수]   연계코드   */
		/* 보험계약정보 */								
		String	bond_kind_code  ="004";				/*	[필수]	 보험종목구분(002:계약,003:하자,004:선금,006:지급)	*/
		String	bond_begn_date  ="20060101";		/*	[선택]	 보험개시일자	*/
		String	bond_fnsh_date  ="20061231";		/*	[필수]	 보험종료일자	*/
		String	bond_curc_code  ="WON";				/*	[필수]	 보험가입금액/통화코드(WON, USD …)	*/
		String	bond_penl_amnt  ="10000000";		/*	[필수]	 보험가입금액/보험가입금액	*/
		String	bond_oper_code  =null;				/*	[선택]	 조회등록 업무구분(SELECT,INSERT)	*/
		String	bond_appl_code  ="10";				/*	[필수]	 신규배서 업무구분(10:신규,20:연장,60:증액,62:연장증액,70:감액,90:기타) */
		/* 주요계약정보 */								
		String	cont_numb_text  ="A2000800-61-3";	/*	[필수]	 계약번호	*/
		String	cont_name_text  ="Test Contract Name";	/*	[필수]	 계약건명	*/
		String	cont_proc_type  ="1";				/*	[필수]	 계약구분	*/
		String	cont_type_iden  ="1";				/*	[필수]	 계약방식(1:공동, 2:단독, 3:분담) */
		String	cont_asgn_rate  =null;				/*	[선택]	 지분율	*/
		String	cont_news_divs  ="1";				/*	[필수]	 신규/갱신 계약구분(1:신규계약, 2:갱신계약) */
		String	cont_plan_date  ="20070101";		/*	[선택]	 준공예정일	*/
		String	cont_main_date  ="20060101";		/*	[선택]	 계약체결일자	*/
		String	cont_curc_code  ="WON";				/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  ="18996938";		/*	[필수]	 계약금액(원화)/계약금액	*/
		String	forn_curc_code  =null;				/*	[선택]	 계약금액(외화)/통화코드(USD …)	*/
		String	forn_main_amnt  =null;				/*	[선택]	 계약금액(외화)/계약금액	*/
		String	hist_bond_numb  =null;				/*	[선택]	 배서대상 증권번호	*/
		/* 선금정보 */								
		String	prep_paym_type  ="1";				/*	[필수]	 지급구분(1:직불(수요자), 2;대지급(채권자)) */
		String	prep_begn_date  ="20060101";		/*	[필수]	 계약시작일자	*/
		String	prep_fnsh_date  ="20061231";		/*	[필수]	 계약종료일자	*/
		String	prep_term_text  ="365";				/*	[선택]	 계약기간	*/
		String	prep_paym_date  ="20060201";		/*	[필수]	 선금지급(예정)일자	*/
		String	prep_curc_code  ="WON";				/*	[필수]	 선금지급(예정)금액(원화)/통화코드(WON)	*/
		String	prep_paym_amnt  ="32000";			/*	[필수]	 선금지급(예정)금액(원화)/선금지급금액	*/
		String	fpre_curc_code  =null;				/*	[선택]	 선금지급(예정)금액(외화)/통화코드(USD …)	*/
		String	fpre_paym_amnt  =null;				/*	[선택]	 선금지급(예정)금액(외화)/선금지급금액	*/
		String	prep_pric_rate  =null;				/*	[선택]	 선금율	*/
		/* 채권자 정보 */								
		String	cred_orga_name  ="한국채권자주식회사";	/*	[필수]	 기관명	*/
		String	cred_orps_divs  ="O";				/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	cred_orga_numb  ="333333333333";	/*	[필수]	 법인등록번호	*/
		String	cred_orps_iden  ="2228122222";		/*	[필수]	 사업자/주민번호	*/
		String	cred_ownr_numb  ="6501011234567";	/*	[필수]	 대표자 주민등록번호	*/
		String	cred_ownr_name  ="김채권";			/*	[필수]	 성명(대표자명)	*/
		String	cred_bond_hold  ="김부자";			/*	[필수]	 채권자명	*/
		String	cred_addn_name  ="한국채권";		/*	[선택]	 채권기관 부가상호	*/
		String	cred_orga_post  ="120345";			/*	[필수]	 회사 우편번호	*/
		String	cred_orga_addr  ="서울시 중구 중림동 421-23 극동빌딩 9층";	/*	[필수]	 회사 주소	*/
		String	cred_chrg_name  ="김하늘";			/*	[필수]	 담당자명	*/
		String	cred_dept_name  ="공개입찰팀";		/*	[필수]	 소속부서	*/
		String	cred_phon_numb  ="02-0000-0000";	/*	[필수]	 전화번호	*/
		String	cred_cell_phon  ="010-0000-0000";	/*	[필수]	 핸드폰번호	*/
		String	cred_send_mail  ="kim.haneul@chaekwon.co.kr";	/*	[필수]	 담당자 EMAIL	*/
		String	cred_user_iden  ="A123456789012";	/*	[필수]	 수신처ID	*/
		String	cred_user_type  ="AAA";				/*	[필수]	 수신처TYPE	*/
		/* 계약자 정보 */							
		String	appl_orga_name  ="동양계약자주식회사";	/*	[필수]	 기관명	*/
		String	appl_orps_divs  ="O";				/*	[필수]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	appl_orga_numb  ="444444444444";	/*	[선택]	 법인등록번호	*/
		String	appl_orps_iden  ="3338133333";		/*	[필수]	 사업자/주민번호	*/
		String	appl_ownr_numb  ="7001011234567";	/*	[필수]	 대표자 주민등록번호	*/
		String	appl_ownr_name  ="박계약";			/*	[필수]	 성명(대표자명)	*/
		String	appl_addn_name  ="동양계약";		/*	[선택]	 계약업체 부가상호	*/
		String	appl_orga_post  ="441222";			/*	[선택]	 회사 우편번호	*/
		String	appl_orga_addr  ="서울시 종로구 213 대한빌딩 4층";	/*	[선택]	 회사 주소	*/
		String	appl_chrg_name  ="박강물";			/*	[필수]	 담당자명	*/
		String	appl_dept_name  ="정보전략실";		/*	[필수]	 소속부서	*/
		String	appl_offc_phon  ="02-0000-0000";	/*	[필수]	 전화번호	*/
		String	appl_cell_phon  ="010-0000-0000";	/*	[필수]	 핸드폰번호	*/
		String	appl_send_mail  ="park.ganmul@dongyang.co.kr";	/*	[필수]	 담당자 EMAIL	*/
		String	appl_home_post  ="120134";			/*	[선택]	 자택 우편번호	*/
		String	appl_home_addr  ="서울시 도봉구 방학동 313 아무개아파트 102-345호";	/*	[선택]	 자택 주소	*/
		String	appl_home_phon  ="0277778888";		/*	[선택]	 자택 전화번호	*/
		String	appl_user_iden  ="B123456789012";	/*	[필수]	 수신처ID	*/
		String	appl_user_type  ="BBB";				/*	[필수]	 수신처TYPE	*/
		/* 수요자 정보 */								
		String	mang_orga_name  ="세계수요자주식회사";	/*	[선택]	 기관명	*/
		String	mang_orps_divs  ="O";				/*	[선택]	 구분(O:사업자번호 P:주민등록번호)	*/
		String	mang_orga_numb  ="666666666666";	/*	[선택]	 법인등록번호	*/
		String	mang_orps_iden  ="5558155555";		/*	[선택]	 사업자/주민번호	*/
		String	mang_ownr_numb  ="6001011234567";	/*	[선택]	 대표자 주민등록번호	*/
		String	mang_ownr_name  ="강수요";			/*	[선택]	 성명(대표자명)	*/
		String	mang_addn_name  ="세계수요";		/*	[선택]	 수요(대행)업체 부가상호	*/
		String	mang_orga_post  ="230123";			/*	[선택]	 회사 우편번호	*/
		String	mang_orga_addr  ="서울시 서초구 서초동 234 한림빌딩 9층";	/*	[선택]	 회사 주소	*/
		String	mang_bond_hold  ="한국채권자주식회사";	/*	[선택]	 채권자명	*/
		String	mang_chrg_name  ="강보라";			/*	[선택]	 담당자명	*/
		String	mang_dept_name  ="수요조사2팀";		/*	[선택]	 소속부서	*/
		String	mang_phon_numb  ="02-0000-0000";	/*	[선택]	 전화번호	*/
		String	mang_cell_phon  ="010-0000-0000";	/*	[선택]	 핸드폰번호	*/
		String	mang_send_mail  ="kang.bora@suyo.co.kr";	/*	[선택]	 담당자 EMAIL	*/
		String	mang_user_iden  ="D123456789012";	/*	[선택]	 수신처ID	*/
		String	mang_user_type  ="DDD";				/*	[선택]	 수신처TYPE	*/
		
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}

		/* 계약정보통보서(CONINF) */								
		/* HEADER */								
		String xmlDoc = null;							

		try{
		
			if(		
				/* Begin of Header */
					dataToXml.setData("head_mesg_send", head_mesg_send)
				&&	dataToXml.setData("head_mesg_recv", head_mesg_recv) 
				&&	dataToXml.setData("head_func_code", head_func_code) 
				&&	dataToXml.setData("head_mesg_type", head_mesg_type) 
				&&	dataToXml.setData("head_mesg_name", head_mesg_name) 
				&&	dataToXml.setData("head_mesg_vers", head_mesg_vers) 
				&&	dataToXml.setData("head_docu_numb", head_docu_numb) 
				&&	dataToXml.setData("head_mang_numb", head_mang_numb) 
				&&	dataToXml.setData("head_refr_numb", head_refr_numb) 
				&&	dataToXml.setData("head_titl_name", head_titl_name) 
				&&  dataToXml.setData("head_orga_code", head_orga_code) 
				/* End of Header */

				/* Begin of 보험계약정보 */						
				&&  dataToXml.setData("bond_kind_code", bond_kind_code) 	
				&&  dataToXml.setData("bond_begn_date", bond_begn_date)
				&&  dataToXml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  dataToXml.setData("bond_curc_code", bond_curc_code)
				&&  dataToXml.setData("bond_penl_amnt", bond_penl_amnt)
				//&&  dataToXml.setData("bond_oper_code", bond_oper_code)
				&&  dataToXml.setData("bond_appl_code", bond_appl_code)
				/* End of 보험계약정보 */

				/* Begin of 주요계약정보 */						
				&&  dataToXml.setData("cont_numb_text", cont_numb_text) 
				&&  dataToXml.setData("cont_name_text", cont_name_text) 
				&&  dataToXml.setData("cont_proc_type", cont_proc_type)
				&&  dataToXml.setData("cont_type_iden", cont_type_iden)
				//&&  dataToXml.setData("cont_asgn_rate", cont_asgn_rate)
				&&  dataToXml.setData("cont_news_divs", cont_news_divs)
				&&  dataToXml.setData("cont_plan_date", cont_plan_date)
				&&  dataToXml.setData("cont_main_date", cont_main_date)
				&&  dataToXml.setData("cont_curc_code", cont_curc_code)
				&&  dataToXml.setData("cont_main_amnt", cont_main_amnt)
				//&&  dataToXml.setData("forn_main_amnt", forn_main_amnt)
				//&&  dataToXml.setData("hist_bond_numb", hist_bond_numb)
				/* End of 주요계약정보 */

				/* Begin of 선금정보 */					
				&&  dataToXml.setData("prep_paym_type", prep_paym_type)
				&&  dataToXml.setData("prep_begn_date", prep_begn_date)
				&&  dataToXml.setData("prep_fnsh_date", prep_fnsh_date)
				&&  dataToXml.setData("prep_term_text", prep_term_text)
				&&  dataToXml.setData("prep_paym_date", prep_paym_date)
				&&  dataToXml.setData("prep_curc_code", prep_curc_code)
				&&  dataToXml.setData("prep_paym_amnt", prep_paym_amnt)
				//&&  dataToXml.setData("fpre_curc_code", fpre_curc_code)
				//&&  dataToXml.setData("fpre_paym_amnt", fpre_paym_amnt)
				//&&  dataToXml.setData("prep_pric_rate", prep_pric_rate)
				/* End of 선금정보 */

				/* Begin of 채권자 정보 */	
				&&  dataToXml.setData("cred_orga_name", cred_orga_name)
				&&  dataToXml.setData("cred_orps_divs", cred_orps_divs)
				&&  dataToXml.setData("cred_orga_numb", cred_orga_numb)
				&&  dataToXml.setData("cred_orps_iden", cred_orps_iden)
				&&  dataToXml.setData("cred_ownr_numb", cred_ownr_numb)
				&&  dataToXml.setData("cred_ownr_name", cred_ownr_name)
				&&  dataToXml.setData("cred_bond_hold", cred_bond_hold)
				&&  dataToXml.setData("cred_addn_name", cred_addn_name)
				&&  dataToXml.setData("cred_orga_post", cred_orga_post)
				&&  dataToXml.setData("cred_orga_addr", cred_orga_addr)
				&&  dataToXml.setData("cred_chrg_name", cred_chrg_name)
				&&  dataToXml.setData("cred_dept_name", cred_dept_name)
				&&  dataToXml.setData("cred_phon_numb", cred_phon_numb)
				&&  dataToXml.setData("cred_cell_phon", cred_cell_phon)
				&&  dataToXml.setData("cred_send_mail", cred_send_mail)
				&&  dataToXml.setData("cred_user_iden", cred_user_iden)
				&&  dataToXml.setData("cred_user_type", cred_user_type)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */		
				&&  dataToXml.setData("appl_orga_name", appl_orga_name)
				&&  dataToXml.setData("appl_orps_divs", appl_orps_divs)
				&&  dataToXml.setData("appl_orga_numb", appl_orga_numb)
				&&  dataToXml.setData("appl_orps_iden", appl_orps_iden)
				&&  dataToXml.setData("appl_ownr_numb", appl_ownr_numb)
				&&  dataToXml.setData("appl_ownr_name", appl_ownr_name)
				&&  dataToXml.setData("appl_addn_name", appl_addn_name)
				&&  dataToXml.setData("appl_orga_post", appl_orga_post)
				&&  dataToXml.setData("appl_orga_addr", appl_orga_addr)
				&&  dataToXml.setData("appl_chrg_name", appl_chrg_name)
				&&  dataToXml.setData("appl_dept_name", appl_dept_name)
				&&  dataToXml.setData("appl_offc_phon", appl_offc_phon)
				&&  dataToXml.setData("appl_cell_phon", appl_cell_phon)
				&&  dataToXml.setData("appl_send_mail", appl_send_mail)
				&&  dataToXml.setData("appl_home_post", appl_home_post)
				&&  dataToXml.setData("appl_home_addr", appl_home_addr)
				&&  dataToXml.setData("appl_home_phon", appl_home_phon)
				&&  dataToXml.setData("appl_user_iden", appl_user_iden)
				&&  dataToXml.setData("appl_user_type", appl_user_type)
				/* End of 계약자 정보 */

				/* Begin of 수요자 정보 */			
				&&  dataToXml.setData("mang_orga_name", mang_orga_name)
				&&  dataToXml.setData("mang_orps_divs", mang_orps_divs)
				&&  dataToXml.setData("mang_orga_numb", mang_orga_numb)
				&&  dataToXml.setData("mang_orps_iden", mang_orps_iden)
				&&  dataToXml.setData("mang_ownr_numb", mang_ownr_numb)
				&&  dataToXml.setData("mang_ownr_name", mang_ownr_name)
				&&  dataToXml.setData("mang_addn_name", mang_addn_name)
				&&  dataToXml.setData("mang_orga_post", mang_orga_post)
				&&  dataToXml.setData("mang_orga_addr", mang_orga_addr)
				&&  dataToXml.setData("mang_bond_hold", mang_bond_hold)
				&&  dataToXml.setData("mang_chrg_name", mang_chrg_name)
				&&  dataToXml.setData("mang_dept_name", mang_dept_name)
				&&  dataToXml.setData("mang_phon_numb", mang_phon_numb)
				&&  dataToXml.setData("mang_cell_phon", mang_cell_phon)
				&&  dataToXml.setData("mang_send_mail", mang_send_mail)
				&&  dataToXml.setData("mang_user_iden", mang_user_iden)
				&&  dataToXml.setData("mang_user_type", mang_user_type)
				/* End of 수요자 정보 */
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/samplePREINF.xml", xmlDoc);
			}else{
				System.out.println(dataToXml.getErrorMsg());
			}
		}catch(Exception _e){
			System.out.println(_e.toString());
		}
		
		return xmlDoc;	
	}
	
	public static void parseXML(String templatePath, String docCode, String xmlDoc)
	{	

		try{	
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			 /* Begin of Header */
			 String head_mesg_send = xmlToData.getData("head_mesg_send");
			 String head_mesg_recv = xmlToData.getData("head_mesg_recv");
			 String head_func_code = xmlToData.getData("head_func_code");
			 String head_mesg_type = xmlToData.getData("head_mesg_type");
			 String head_mesg_name = xmlToData.getData("head_mesg_name");
			 String head_mesg_vers = xmlToData.getData("head_mesg_vers");
			 String head_docu_numb = xmlToData.getData("head_docu_numb");
			 String head_mang_numb = xmlToData.getData("head_mang_numb");
			 String head_refr_numb = xmlToData.getData("head_refr_numb");
			 String head_titl_name = xmlToData.getData("head_titl_name");
			 String head_orga_code = xmlToData.getData("head_orga_code");
			 /* End of Header */
			   
			 /* Begin of 보험계약정보 */						
			 String bond_kind_code = xmlToData.getData("bond_kind_code");                  	
			 String bond_begn_date = xmlToData.getData("bond_begn_date");                  
			 String bond_fnsh_date = xmlToData.getData("bond_fnsh_date");                  
			 String bond_curc_code = xmlToData.getData("bond_curc_code");                  
			 String bond_penl_amnt = xmlToData.getData("bond_penl_amnt");                  
			 String bond_oper_code = xmlToData.getData("bond_oper_code");
			 String bond_appl_code = xmlToData.getData("bond_appl_code");
			 /* End of 보험계약정보 */
			   
			 /* Begin of 주요계약정보 */						
			 String cont_numb_text = xmlToData.getData("cont_numb_text"); 
			 String cont_name_text = xmlToData.getData("cont_name_text"); 
			 String cont_proc_type = xmlToData.getData("cont_proc_type");
			 String cont_type_iden = xmlToData.getData("cont_type_iden");
			 String cont_asgn_rate = xmlToData.getData("cont_asgn_rate");
			 String cont_news_divs = xmlToData.getData("cont_news_divs");
			 String cont_plan_date = xmlToData.getData("cont_plan_date");
			 String cont_main_date = xmlToData.getData("cont_main_date");
			 String cont_curc_code = xmlToData.getData("cont_curc_code");
			 String cont_main_amnt = xmlToData.getData("cont_main_amnt");
			 String forn_main_amnt = xmlToData.getData("forn_main_amnt");
			 String hist_bond_numb = xmlToData.getData("hist_bond_numb");
			 /* End of 주요계약정보 */
			  
			 /* Begin of 선금정보 */					
			 String prep_paym_type = xmlToData.getData("prep_paym_type");
			 String prep_begn_date = xmlToData.getData("prep_begn_date");
			 String prep_fnsh_date = xmlToData.getData("prep_fnsh_date");
			 String prep_term_text = xmlToData.getData("prep_term_text");
			 String prep_paym_date = xmlToData.getData("prep_paym_date");
			 String prep_curc_code = xmlToData.getData("prep_curc_code");
			 String prep_paym_amnt = xmlToData.getData("prep_paym_amnt");
			 String fpre_curc_code = xmlToData.getData("fpre_curc_code");
			 String fpre_paym_amnt = xmlToData.getData("fpre_paym_amnt");
			 String prep_pric_rate = xmlToData.getData("prep_pric_rate");
			 /* End of 선금정보 */
			  
			 /* Begin of 채권자 정보 */	
			 String cred_orga_name = xmlToData.getData("cred_orga_name");
			 String cred_orps_divs = xmlToData.getData("cred_orps_divs");
			 String cred_orga_numb = xmlToData.getData("cred_orga_numb");
			 String cred_orps_iden = xmlToData.getData("cred_orps_iden");
			 String cred_ownr_numb = xmlToData.getData("cred_ownr_numb");
			 String cred_ownr_name = xmlToData.getData("cred_ownr_name");
			 String cred_bond_hold = xmlToData.getData("cred_bond_hold");
			 String cred_addn_name = xmlToData.getData("cred_addn_name");
			 String cred_orga_post = xmlToData.getData("cred_orga_post");
			 String cred_orga_addr = xmlToData.getData("cred_orga_addr");
			 String cred_chrg_name = xmlToData.getData("cred_chrg_name");
			 String cred_dept_name = xmlToData.getData("cred_dept_name");
			 String cred_phon_numb = xmlToData.getData("cred_phon_numb");
			 String cred_cell_phon = xmlToData.getData("cred_cell_phon");
			 String cred_send_mail = xmlToData.getData("cred_send_mail");
			 String cred_user_iden = xmlToData.getData("cred_user_iden");
			 String cred_user_type = xmlToData.getData("cred_user_type");
			 /* End of 채권자 정보 */
			  
			 /* Begin of 계약자 정보 */		
			 String appl_orga_name = xmlToData.getData("appl_orga_name");
			 String appl_orps_divs = xmlToData.getData("appl_orps_divs");
			 String appl_orga_numb = xmlToData.getData("appl_orga_numb");
			 String appl_orps_iden = xmlToData.getData("appl_orps_iden");
			 String appl_ownr_numb = xmlToData.getData("appl_ownr_numb");
			 String appl_ownr_name = xmlToData.getData("appl_ownr_name");
			 String appl_addn_name = xmlToData.getData("appl_addn_name");
			 String appl_orga_post = xmlToData.getData("appl_orga_post");
			 String appl_orga_addr = xmlToData.getData("appl_orga_addr");
			 String appl_chrg_name = xmlToData.getData("appl_chrg_name");
			 String appl_dept_name = xmlToData.getData("appl_dept_name");
			 String appl_offc_phon = xmlToData.getData("appl_offc_phon");
			 String appl_cell_phon = xmlToData.getData("appl_cell_phon");
			 String appl_send_mail = xmlToData.getData("appl_send_mail");
			 String appl_home_post = xmlToData.getData("appl_home_post");
			 String appl_home_addr = xmlToData.getData("appl_home_addr");
			 String appl_home_phon = xmlToData.getData("appl_home_phon");
			 String appl_user_iden = xmlToData.getData("appl_user_iden");
			 String appl_user_type = xmlToData.getData("appl_user_type");
			 /* End of 계약자 정보 */
			   
			 /* Begin of 수요자 정보 */			
			 String mang_orga_name = xmlToData.getData("mang_orga_name");
			 String mang_orps_divs = xmlToData.getData("mang_orps_divs");
			 String mang_orga_numb = xmlToData.getData("mang_orga_numb");
			 String mang_orps_iden = xmlToData.getData("mang_orps_iden");
			 String mang_ownr_numb = xmlToData.getData("mang_ownr_numb");
			 String mang_ownr_name = xmlToData.getData("mang_ownr_name");
			 String mang_addn_name = xmlToData.getData("mang_addn_name");
			 String mang_orga_post = xmlToData.getData("mang_orga_post");
			 String mang_orga_addr = xmlToData.getData("mang_orga_addr");
			 String mang_bond_hold = xmlToData.getData("mang_bond_hold");
			 String mang_chrg_name = xmlToData.getData("mang_chrg_name");
			 String mang_dept_name = xmlToData.getData("mang_dept_name");
			 String mang_phon_numb = xmlToData.getData("mang_phon_numb");
			 String mang_cell_phon = xmlToData.getData("mang_cell_phon");
			 String mang_send_mail = xmlToData.getData("mang_send_mail");
			 String mang_user_iden = xmlToData.getData("mang_user_iden");
			 String mang_user_type = xmlToData.getData("mang_user_type");
			 /* End of 수요자 정보 */

			System.out.println("head_mesg_send=" + head_mesg_send);
			System.out.println("head_mesg_recv=" + head_mesg_recv);
			System.out.println("head_func_code=" + head_func_code);
			System.out.println("head_mesg_type=" + head_mesg_type);
			System.out.println("head_mesg_name=" + head_mesg_name);
			System.out.println("head_mesg_vers=" + head_mesg_vers);
			System.out.println("head_docu_numb=" + head_docu_numb);
			System.out.println("head_mang_numb=" + head_mang_numb);
			System.out.println("head_refr_numb=" + head_refr_numb);
			System.out.println("head_titl_name=" + head_titl_name);
			System.out.println("head_orga_code=" + head_orga_code);				
			System.out.println("bond_kind_code=" + bond_kind_code);                  	
			System.out.println("bond_begn_date=" + bond_begn_date);                  
			System.out.println("bond_fnsh_date=" + bond_fnsh_date);                  
			System.out.println("bond_curc_code=" + bond_curc_code);                  
			System.out.println("bond_penl_amnt=" + bond_penl_amnt);                  
			System.out.println("bond_oper_code=" + bond_oper_code);
			System.out.println("bond_appl_code=" + bond_appl_code);				
			System.out.println("cont_numb_text=" + cont_numb_text); 
			System.out.println("cont_name_text=" + cont_name_text); 
			System.out.println("cont_proc_type=" + cont_proc_type);
			System.out.println("cont_type_iden=" + cont_type_iden);
			System.out.println("cont_asgn_rate=" + cont_asgn_rate);
			System.out.println("cont_news_divs=" + cont_news_divs);
			System.out.println("cont_plan_date=" + cont_plan_date);
			System.out.println("cont_main_date=" + cont_main_date);
			System.out.println("cont_curc_code=" + cont_curc_code);
			System.out.println("cont_main_amnt=" + cont_main_amnt);
			System.out.println("forn_main_amnt=" + forn_main_amnt);
			System.out.println("hist_bond_numb=" + hist_bond_numb);			
			System.out.println("prep_paym_type=" + prep_paym_type);
			System.out.println("prep_begn_date=" + prep_begn_date);
			System.out.println("prep_fnsh_date=" + prep_fnsh_date);
			System.out.println("prep_term_text=" + prep_term_text);
			System.out.println("prep_paym_date=" + prep_paym_date);
			System.out.println("prep_curc_code=" + prep_curc_code);
			System.out.println("prep_paym_amnt=" + prep_paym_amnt);
			System.out.println("fpre_curc_code=" + fpre_curc_code);
			System.out.println("fpre_paym_amnt=" + fpre_paym_amnt);
			System.out.println("prep_pric_rate=" + prep_pric_rate);
			System.out.println("cred_orga_name=" + cred_orga_name);
			System.out.println("cred_orps_divs=" + cred_orps_divs);
			System.out.println("cred_orga_numb=" + cred_orga_numb);
			System.out.println("cred_orps_iden=" + cred_orps_iden);
			System.out.println("cred_ownr_numb=" + cred_ownr_numb);
			System.out.println("cred_ownr_name=" + cred_ownr_name);
			System.out.println("cred_bond_hold=" + cred_bond_hold);
			System.out.println("cred_addn_name=" + cred_addn_name);
			System.out.println("cred_orga_post=" + cred_orga_post);
			System.out.println("cred_orga_addr=" + cred_orga_addr);
			System.out.println("cred_chrg_name=" + cred_chrg_name);
			System.out.println("cred_dept_name=" + cred_dept_name);
			System.out.println("cred_phon_numb=" + cred_phon_numb);
			System.out.println("cred_cell_phon=" + cred_cell_phon);
			System.out.println("cred_send_mail=" + cred_send_mail);
			System.out.println("cred_user_iden=" + cred_user_iden);
			System.out.println("cred_user_type=" + cred_user_type);	
			System.out.println("appl_orga_name=" + appl_orga_name);
			System.out.println("appl_orps_divs=" + appl_orps_divs);
			System.out.println("appl_orga_numb=" + appl_orga_numb);
			System.out.println("appl_orps_iden=" + appl_orps_iden);
			System.out.println("appl_ownr_numb=" + appl_ownr_numb);
			System.out.println("appl_ownr_name=" + appl_ownr_name);
			System.out.println("appl_addn_name=" + appl_addn_name);
			System.out.println("appl_orga_post=" + appl_orga_post);
			System.out.println("appl_orga_addr=" + appl_orga_addr);
			System.out.println("appl_chrg_name=" + appl_chrg_name);
			System.out.println("appl_dept_name=" + appl_dept_name);
			System.out.println("appl_offc_phon=" + appl_offc_phon);
			System.out.println("appl_cell_phon=" + appl_cell_phon);
			System.out.println("appl_send_mail=" + appl_send_mail);
			System.out.println("appl_home_post=" + appl_home_post);
			System.out.println("appl_home_addr=" + appl_home_addr);
			System.out.println("appl_home_phon=" + appl_home_phon);
			System.out.println("appl_user_iden=" + appl_user_iden);
			System.out.println("appl_user_type=" + appl_user_type);			
			System.out.println("mang_orga_name=" + mang_orga_name);
			System.out.println("mang_orps_divs=" + mang_orps_divs);
			System.out.println("mang_orga_numb=" + mang_orga_numb);
			System.out.println("mang_orps_iden=" + mang_orps_iden);
			System.out.println("mang_ownr_numb=" + mang_ownr_numb);
			System.out.println("mang_ownr_name=" + mang_ownr_name);
			System.out.println("mang_addn_name=" + mang_addn_name);
			System.out.println("mang_orga_post=" + mang_orga_post);
			System.out.println("mang_orga_addr=" + mang_orga_addr);
			System.out.println("mang_bond_hold=" + mang_bond_hold);
			System.out.println("mang_chrg_name=" + mang_chrg_name);
			System.out.println("mang_dept_name=" + mang_dept_name);
			System.out.println("mang_phon_numb=" + mang_phon_numb);
			System.out.println("mang_cell_phon=" + mang_cell_phon);
			System.out.println("mang_send_mail=" + mang_send_mail);
			System.out.println("mang_user_iden=" + mang_user_iden);
			System.out.println("mang_user_type=" + mang_user_type);
		}catch(Exception _e){
			System.out.println(_e.toString());
		}		
	}
}
