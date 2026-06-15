<%@ page contentType="text/html;" %>
<html>
<head>
<title>KICASGIxLinker Sending Sample</title>
</head>

<%@ include file="signgate_xlinker.jsp" %>

<%
		/////////////////////// xml문서 생성 start ////////////////////////

		/* 계약정보통보서(CONINF) */
		/* HEADER */
		String	head_mesg_send  ="A120870175500";	/*	[필수]	 전문송신기관	*/
		String	head_mesg_recv  ="z120811300200";	/*	[필수]	 전문수신기관	*/  //서울보증보험 쪽 아이디(z120811300200)로 수정
//		String	head_mesg_recv  ="A111111111900";	/*	[필수]	 전문수신기관	*/
		String	head_func_code  ="53";				/*	[필수]	 문서기능	*/
		String	head_mesg_type  ="CONINF";			/*	[필수]	 문서코드	*/
		String	head_mesg_name  = "계약정보통보서";	/*	[필수]	 문서명	*/
		String	head_mesg_vers  ="1.0";				/*	[선택]	 전자문서버전	*/
		String	head_docu_numb  ="0043338 2";		/*	[필수]	 문서번호	*/
		String	head_mang_numb  ="13.20060227151000.12345.0043338' '2";	/*	[필수]	 문서관리번호	*/
		String	head_refr_numb  ="0043338 2";		/*	[필수]	 참조번호	*/
		String	head_titl_name  ="계약정보통보서";	/*	[필수]	 문서개요	*/
		String  head_orga_code  ="TGC";             /*  [필수]   연계코드   */
		/* 보험계약정보 */
		String	bond_kind_code  ="002";				/*	[필수]	" 보험종목구분(002:계약,003:하자,004:선금,006:지급)"	*/
		String	bond_begn_date  ="20060101";		/*	[필수]	 보험개시일자	*/
		String	bond_fnsh_date  ="20061231";		/*	[필수]	 보험종료일자	*/
		String	bond_curc_code  ="WON";				/*	[필수]	" 보험가입금액/통화코드(WON, USD …)"	*/
		String	bond_penl_amnt  ="18996938";		/*	[필수]	 보험가입금액/보험가입금액	*/
		String	bond_oper_code  ="SELECT";			/*	[선택]	" 조회등록 업무구분(SELECT,INSERT)"	*/
		String	bond_appl_code  ="10";				/*	[필수]	" 신규배서 업무구분(10:신규,20:연장,60:증액,62:연장증액,70:감액,90:기타)"	*/
		/* 주요계약정보 */
		String	cont_numb_text  ="A2000800-61-3";	/*	[필수]	 계약번호	*/
		String	cont_name_text  ="Test Contract Name";	/*	[필수]	 계약건명	*/
		String	cont_proc_type  ="F00";				/*	[필수]	 계약구분	*/
		String	cont_type_iden  ="1";				/*	[필수]	" 계약방식(1:공동, 2:단독, 3:분담)"	*/
		String	cont_asgn_rate  =null;				/*	[선택]	 지분율	*/
		String	cont_news_divs  ="1";				/*	[필수]	" 신규/갱신 계약구분(1:신규계약, 2:갱신계약)"	*/
		String	cont_plan_date  ="20070101";		/*	[선택]	 준공예정일	*/
		String	cont_main_date  ="20060101";		/*	[선택]	 계약체결일자	*/
		String	cont_curc_code  ="WON";				/*	[필수]	 계약금액(원화)/통화코드(WON)	*/
		String	cont_main_amnt  ="18996938";		/*	[필수]	 계약금액(원화)/계약금액	*/
		String	forn_curc_code  =null;				/*	[선택]	 계약금액(외화)/통화코드(USD …)	*/
		String	forn_main_amnt  =null;				/*	[선택]	 계약금액(외화)/계약금액	*/
		String	hist_bond_numb  =null;				/*	[선택]	 배서대상 증권번호	*/
		/* 계약정보 */
		String	cont_begn_date  ="20060101";		/*	[필수]	 계약시작일자	*/
		String	cont_fnsh_date  ="20061231";		/*	[필수]	 계약종료일자	*/
		String	cont_term_text  ="365";				/*	[선택]	 계약기간	*/
		String	cont_pric_rate  ="12.5";			/*	[필수]	" 보증금율(단가계약일 경우 ""0""으로 입력)"	*/
		String	cont_unit_divs  ="1";				/*	[필수]	" 단가계약 여부(1:단가계약,2:일반계약)"	*/
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

		String xml_str = null;

		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml datatoxml = new DataToXml( this.templates_path, "CONINF");

		if(datatoxml.getErrorCode()!=0)
		{
			System.out.println(datatoxml.getErrorMsg());
			return;
		}

		/* 계약정보통보서(CONINF) */
		/* HEADER */

		try{

			if(
				/* Begin of Header */
					datatoxml.setData("head_mesg_send", head_mesg_send)
				&&	datatoxml.setData("head_mesg_recv", head_mesg_recv)
				&&	datatoxml.setData("head_func_code", head_func_code)
				&&	datatoxml.setData("head_mesg_type", head_mesg_type)
				&&	datatoxml.setData("head_mesg_name", head_mesg_name)
				&&	datatoxml.setData("head_mesg_vers", head_mesg_vers)
				&&	datatoxml.setData("head_docu_numb", head_docu_numb)
				&&	datatoxml.setData("head_mang_numb", head_mang_numb)
				&&	datatoxml.setData("head_refr_numb", head_refr_numb)
				&&	datatoxml.setData("head_titl_name", head_titl_name)
				&&  datatoxml.setData("head_orga_code", head_orga_code)
				/* End of Header */

				/* Begin of 보험계약정보 */
				&&  datatoxml.setData("bond_kind_code", bond_kind_code)
				&&  datatoxml.setData("bond_begn_date", bond_begn_date)
				&&  datatoxml.setData("bond_fnsh_date", bond_fnsh_date)
				&&  datatoxml.setData("bond_curc_code", bond_curc_code)
				&&  datatoxml.setData("bond_penl_amnt", bond_penl_amnt)
				&&  datatoxml.setData("bond_oper_code", bond_oper_code)
				&&  datatoxml.setData("bond_appl_code", bond_appl_code)
				/* End of 보험계약정보 */

				/* Begin of 주요계약정보 */
				&&  datatoxml.setData("cont_numb_text", cont_numb_text)
				&&  datatoxml.setData("cont_name_text", cont_name_text)
				&&  datatoxml.setData("cont_proc_type", cont_proc_type)
				&&  datatoxml.setData("cont_type_iden", cont_type_iden)
				//&&  datatoxml.setData("cont_asgn_rate", cont_asgn_rate)
				&&  datatoxml.setData("cont_news_divs", cont_news_divs)
				&&  datatoxml.setData("cont_plan_date", cont_plan_date)
				&&  datatoxml.setData("cont_main_date", cont_main_date)
				&&  datatoxml.setData("cont_curc_code", cont_curc_code)
				&&  datatoxml.setData("cont_main_amnt", cont_main_amnt)
				//&&  datatoxml.setData("forn_curc_code", forn_curc_code)
				//&&  datatoxml.setData("forn_main_amnt", forn_main_amnt)
				//&&  datatoxml.setData("hist_bond_numb", hist_bond_numb)
				/* End of 주요계약정보 */

				/* Begin of 계약정보 */
				&&  datatoxml.setData("cont_begn_date", cont_begn_date)
				&&  datatoxml.setData("cont_fnsh_date", cont_fnsh_date)
				&&  datatoxml.setData("cont_term_text", cont_term_text)
				&&  datatoxml.setData("cont_pric_rate", cont_pric_rate)
				&&  datatoxml.setData("cont_unit_divs", cont_unit_divs)
				/* End of 계약정보 */

				/* Begin of 채권자 정보 */
				&&  datatoxml.setData("cred_orga_name", cred_orga_name)
				&&  datatoxml.setData("cred_orps_divs", cred_orps_divs)
				&&  datatoxml.setData("cred_orga_numb", cred_orga_numb)
				&&  datatoxml.setData("cred_orps_iden", cred_orps_iden)
				&&  datatoxml.setData("cred_ownr_numb", cred_ownr_numb)
				&&  datatoxml.setData("cred_ownr_name", cred_ownr_name)
				&&  datatoxml.setData("cred_bond_hold", cred_bond_hold)
				&&  datatoxml.setData("cred_addn_name", cred_addn_name)
				&&  datatoxml.setData("cred_orga_post", cred_orga_post)
				&&  datatoxml.setData("cred_orga_addr", cred_orga_addr)
				&&  datatoxml.setData("cred_chrg_name", cred_chrg_name)
				&&  datatoxml.setData("cred_dept_name", cred_dept_name)
				&&  datatoxml.setData("cred_phon_numb", cred_phon_numb)
				&&  datatoxml.setData("cred_cell_phon", cred_cell_phon)
				&&  datatoxml.setData("cred_send_mail", cred_send_mail)
				&&  datatoxml.setData("cred_user_iden", cred_user_iden)
				&&  datatoxml.setData("cred_user_type", cred_user_type)
				/* End of 채권자 정보 */

				/* Begin of 계약자 정보 */
				&&  datatoxml.setData("appl_orga_name", appl_orga_name)
				&&  datatoxml.setData("appl_orps_divs", appl_orps_divs)
				&&  datatoxml.setData("appl_orga_numb", appl_orga_numb)
				&&  datatoxml.setData("appl_orps_iden", appl_orps_iden)
				&&  datatoxml.setData("appl_ownr_numb", appl_ownr_numb)
				&&  datatoxml.setData("appl_ownr_name", appl_ownr_name)
				&&  datatoxml.setData("appl_addn_name", appl_addn_name)
				&&  datatoxml.setData("appl_orga_post", appl_orga_post)
				&&  datatoxml.setData("appl_orga_addr", appl_orga_addr)
				&&  datatoxml.setData("appl_chrg_name", appl_chrg_name)
				&&  datatoxml.setData("appl_dept_name", appl_dept_name)
				&&  datatoxml.setData("appl_offc_phon", appl_offc_phon)
				&&  datatoxml.setData("appl_cell_phon", appl_cell_phon)
				&&  datatoxml.setData("appl_send_mail", appl_send_mail)
				&&  datatoxml.setData("appl_home_post", appl_home_post)
				&&  datatoxml.setData("appl_home_addr", appl_home_addr)
				&&  datatoxml.setData("appl_home_phon", appl_home_phon)
				&&  datatoxml.setData("appl_user_iden", appl_user_iden)
				&&  datatoxml.setData("appl_user_type", appl_user_type)
				/* End of 계약자 정보 */

				/* Begin of 수요자 정보 */
				&&  datatoxml.setData("mang_orga_name", mang_orga_name)
				&&  datatoxml.setData("mang_orps_divs", mang_orps_divs)
				&&  datatoxml.setData("mang_orga_numb", mang_orga_numb)
				&&  datatoxml.setData("mang_orps_iden", mang_orps_iden)
				&&  datatoxml.setData("mang_ownr_numb", mang_ownr_numb)
				&&  datatoxml.setData("mang_ownr_name", mang_ownr_name)
				&&  datatoxml.setData("mang_addn_name", mang_addn_name)
				&&  datatoxml.setData("mang_orga_post", mang_orga_post)
				&&  datatoxml.setData("mang_orga_addr", mang_orga_addr)
				&&  datatoxml.setData("mang_bond_hold", mang_bond_hold)
				&&  datatoxml.setData("mang_chrg_name", mang_chrg_name)
				&&  datatoxml.setData("mang_dept_name", mang_dept_name)
				&&  datatoxml.setData("mang_phon_numb", mang_phon_numb)
				&&  datatoxml.setData("mang_cell_phon", mang_cell_phon)
				&&  datatoxml.setData("mang_send_mail", mang_send_mail)
				&&  datatoxml.setData("mang_user_iden", mang_user_iden)
				&&  datatoxml.setData("mang_user_type", mang_user_type)
				/* End of 수요자 정보 */
			)
			{
				xml_str = datatoxml.getxmlData();
				System.out.println(xml_str);
			}else{
				System.out.println(datatoxml.getErrorMsg());
			}
		}catch(Exception _e){
			System.out.println(_e.toString());
		}

		/////////////////////// xml문서 생성 end ////////////////////////

		if(xml_str == null){
			System.out.println("xml문서 생성 실패");
			return;
		}

		////////////////////// xml 문서 송신 start ///////////////////////

		String reqXml = xml_str;
		System.out.println("생성xml문서:" + reqXml);

		HashMap attach = new HashMap();
		attach.put("test1.txt", "test1".getBytes());
		attach.put("test2.txt", "test2".getBytes());

		SGIxLinker xLinker =  new SGIxLinker(this.sendinfo_conf, "send_jsp", true);
    	boolean isOK = xLinker.doSendProcess(reqXml, null);
		//boolean isOK = xLinker.doSendProcess(reqXml, attach);
		if(!isOK)
		{
			System.out.println("SGIxLinker 에러메시지:" + xLinker.getErrorMsg());
			return;
		}

		String recvXml = xLinker.getRecvXmlData();
		System.out.println("수신받은 응답서:" + recvXml);
		//***************************************
		//***************************************
		// xml 응답서 문서 정보를 XmltoData로
		// 추출하여 상태값 DB에 저장
		// 매핑 정보 파일, XML 탬플릿 정보 파일

		XmlToData xmlToData = null;

		try{

			xmlToData = new XmlToData(xLinker.getTempPath() , "RESPONSE", recvXml);

			if(xmlToData.getErrorCode()!=0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}

		}catch(Exception e){
			System.out.println(e.toString());
			e.printStackTrace();

		}

		try{
			String res_cont_num = xmlToData.getData("res_cont_num");
			//String res_docu_num = xmlToData.getData("res_docu_num");
			String respTypeCode = xmlToData.getData("res_info_code");
			String respTypeName = xmlToData.getData("res_info_typename");
			String respMesgText = xmlToData.getData("res_info_result");

			System.out.println("계약번호 = "+res_cont_num);
			System.out.println("응답코드 = "+respTypeCode);
			System.out.println("응답코드명 = "+respTypeName);
			System.out.println("응답메시지 = "+respMesgText);

		    out.println("Response Contract Number = " + res_cont_num);
			out.println("<br>");
	        out.println("Response Code = " + respTypeCode);
	        out.println("<br>");
	        out.println("Response Name = "+respTypeName);
	        out.println("<br>");
	        out.println("Response Message = "+respMesgText);

		}catch(Exception _e){
			System.out.println(_e.toString());
		}

		////////////////////// xml 문서 송신 end ///////////////////////
%>

<body>
</body>
</html>