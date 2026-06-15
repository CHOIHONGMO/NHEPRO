import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestPERCOM {

	public static void main(String[] args) {
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "PERCOM";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 이행완료통보서(이행입찰)(PERCOM) */								
		/* HEADER */								
		String	head_mesg_send  ="A111111111900";	/*	[필수]	 전문송신기관	*/
		String	head_mesg_recv  ="z120811300200";	/*	[필수]	 전문수신기관	*/
		String	head_func_code  ="53";				/*	[필수]	 문서기능	*/
		String	head_mesg_type  ="PERCOM";			/*	[필수]	 문서코드	*/
		String	head_mesg_name  ="이행완료통보서";		/*	[필수]	 문서명	*/
		String	head_mesg_vers  ="1.0";				/*	[선택]	 전자문서버전	*/
		String	head_docu_numb  ="0043338 2";		/*	[필수]	 문서번호	*/
		String	head_mang_numb  ="13.20060227151000.12345.0043338' '2";	/*	[필수]	 문서관리번호	*/
		String	head_refr_numb  ="0043338 2";		/*	[필수]	 참조번호	*/
		String	head_titl_name  ="이행완료통보서";		/*	[필수]	 문서개요	*/
		String  head_orga_code  ="ABC";             /*  [필수]   연계코드   */
		/* 보험계약정보  */                                                                                                                                                                                                                    
		String docu_numb_text="122999";				/* [필수]	 증권번호			*/	        
		String docu_kind_code="1";					/* [필수]	 보험종목구분		*/		        
		String docu_issu_date="20060522";			/* [필수]	 완료정보 통보일자		*/		
		String docu_oper_code="1";					/* [선택]	조회등록 업무구분		*/		
		String docu_appl_code="1";					/* [선택]	신규배서구분	        */ 			
		/*  주요계약정보 */   
		String cont_numb_text="122992";				/* [필수]	   계약번호		        */
		String cont_name_text="Test contrat name";  /* [필수]	  계약건명		        */
		String cont_curc_code="WON";				/* [필수]	  대여(계약)금액/통화코드	*/
		String cont_main_amnt="10000";				/* [필수]	  대여(계약)금액/계약금액	*/
		/* 계약자정보 */
		String appl_orga_name="한국채권자주식회사";  /* [필수]	  기관명			*/                
		String appl_orps_divs="1";					 /* [필수]	  구분			*/	        
		String appl_orga_numb="1111111";			/* [선택] 법인등록번호		*/	        
		String appl_orps_iden="111111";				/* [필수]	  사업자/주민번호		*/		
		String appl_ownr_numb="1111111";			/* [선택] 대표자 주민등록번호	*/		
		String appl_ownr_name="김부자";				/* [필수]	   성명(대표자명)		*/		
		String appl_addn_name="";					/* [선택] 계약업체 부가상호		*/	
		String appl_orga_post="";					/* [선택] 회사 우편번호		*/		
		String appl_orga_addr="";					/* [선택] 회사 주소			*/	
		String appl_chrg_name="홍길동";				/* [필수]	   담당자명			*/        
		String appl_dept_name="테스트과";			/* [필수]	  소속부서			*/        
		String appl_offc_phon="02233200";			/* [필수]	  전화번호			*/        
		String appl_cell_phon="0111111111";			/* [필수]	  핸드폰번호		*/	        
		String appl_send_mail="test@test.co.kr";	/* [필수]	  담당자 EMAIL		*/	        
		String appl_home_post="200192";				/* [선택] 자택 우편번호		*/	        
		String appl_home_addr="서울시 중구 중림동 421-23 극동빌딩 9층";					/* [선택] 자택 주소			*/        
		String appl_home_phon="02-0000-0000";					/* [선택] 자택 전화번호		*/	        
		String appl_user_iden="A123456789012";					/* [필수]	  수신처ID			*/        
		String appl_user_type="AAA";					/* [필수]	  수신처TYPE                */			
		/* 고객개인정보 */
		String cust_fnsh_date="20060304";	/* [필수]	  주계약 종료일자		*/        
		String cust_curc_code="WON";	/* [필수]	  상환금액/통화코드	        */
		String cust_fnsh_amnt="10000";  /* [필수]	  상환금액/상환금액	        */
		String cust_bank_code="";  /* [선택] 환급요청 은행코드		*/
		String cust_bank_name="";  /* [선택] 환급요청 은행명		*/	
		String cust_bank_acnt="";  /* [선택] 환급요청 계좌번호         */   			
		/* 채권자정보 */
		String cred_orga_name="동양계약자주식회사";  /* [필수]	  기관명			*/                
		String cred_orps_divs="1";  /* [필수]	  구분			*/                
		String cred_orga_numb="1234123412345";  /* [선택] 법인등록번호		*/	        
		String cred_orps_iden="111111111";  /* [필수]	  사업자/주민번호		*/	        
		String cred_ownr_numb="";  /* [선택] 대표자 주민등록번호	*/		
		String cred_ownr_name="홍길동";  /* [필수]	  성명(대표자명)		*/	        
		String cred_bond_hold="";  /* [선택] 채권자명			*/        
		String cred_addn_name="";  /* [선택] 채권기관 부가상호		*/	
		String cred_orga_post="";  /* [선택] 회사 우편번호		*/	        
		String cred_orga_addr="";  /* [선택] 회사 주소			*/        
		String cred_chrg_name="박계약";  /* [필수]	  담당자명			*/        
		String cred_dept_name="테스트과";  /* [필수]	  소속부서			*/        
		String cred_phon_numb="02-0000-0000";  /* [필수]	  전화번호			*/        
		String cred_cell_phon="010-0000-0000";  /* [필수]	  핸드폰번호		*/	        
		String cred_send_mail="kang.bora@suyo.co.kr";  /* [필수]	  담당자 EMAIL		*/	        
		String cred_user_iden="D123456789012";  /* [필수]	  수신처ID			*/        
		String cred_user_type="DDD";  /* [필수]	  수신처TYPE	        */  			
		/* 수요자정보  */
		String mang_orga_name="";  /* [선택] 기관명			*/	                
		String mang_orps_divs="";  /* [선택] 구분			*/	                
		String mang_orga_numb="";  /* [선택] 법인등록번호		*/		        
		String mang_orps_iden="";  /* [선택] 사업자/주민번호		*/		        
		String mang_ownr_numb="";  /* [선택] 대표자 주민등록번호	*/			
		String mang_ownr_name="";  /* [선택] 성명(대표자명)		*/		        
		String mang_addn_name="";  /* [선택] 수요(대행)업체 부가상호	*/			
		String mang_orga_post="";  /* [선택] 회사 우편번호		*/		        
		String mang_orga_addr="";  /* [선택] 회사 주소			*/	        
		String mang_bond_hold="";  /* [선택] 채권자명			*/	        
		String mang_chrg_name="";  /* [선택] 담당자명			*/	        
		String mang_dept_name="";  /* [선택] 소속부서			*/	        
		String mang_phon_numb="";  /* [선택] 전화번호			*/	        
		String mang_cell_phon="";  /* [선택] 핸드폰번호		*/		        
		String mang_send_mail="";  /* [선택] 담당자 EMAIL		*/		        
		String mang_user_iden="";  /* [선택] 수신처ID			*/	        
		String mang_user_type="";  /* [선택] 수신처TYPE	        */                             
		
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
				/* Begin of 보험계약정보  */              
				&&  dataToXml.setData("docu_numb_text", docu_numb_text) 
				&&  dataToXml.setData("docu_kind_code", docu_kind_code) 
				&&  dataToXml.setData("docu_issu_date", docu_issu_date) 
				&&  dataToXml.setData("docu_oper_code", docu_oper_code) 
				&&  dataToXml.setData("docu_appl_code", docu_appl_code) 
				/* End of 보험계약정보  */ 		
				/*  Begin of 주요계약정보 */
				&&  dataToXml.setData("cont_numb_text", cont_numb_text)
				&&  dataToXml.setData("cont_name_text", cont_name_text)
				&&  dataToXml.setData("cont_curc_code", cont_curc_code)
				&&  dataToXml.setData("cont_main_amnt", cont_main_amnt)
				/*  End of 주요계약정보 */ 
				/* Begin of 계약자정보 */
				&&  dataToXml.setData("appl_orga_name", appl_orga_name)
				&&  dataToXml.setData("appl_orps_divs", appl_orps_divs)
				&&  dataToXml.setData("appl_orga_numb", appl_orga_numb)
				&&  dataToXml.setData("appl_orps_iden", appl_orps_iden)
				&&  dataToXml.setData("appl_ownr_numb", appl_ownr_numb)
				&&  dataToXml.setData("appl_ownr_name", appl_ownr_name)
				//&&  dataToXml.setData("appl_addn_name", appl_addn_name)
				//&&  dataToXml.setData("appl_orga_post", appl_orga_post)
				//&&  dataToXml.setData("appl_orga_addr", appl_orga_addr)
				//&&  dataToXml.setData("appl_chrg_name", appl_chrg_name)
				//&&  dataToXml.setData("appl_dept_name", appl_dept_name)
				&&  dataToXml.setData("appl_offc_phon", appl_offc_phon)
				&&  dataToXml.setData("appl_cell_phon", appl_cell_phon)
				&&  dataToXml.setData("appl_send_mail", appl_send_mail)
				//&&  dataToXml.setData("appl_home_post", appl_home_post)
				//&&  dataToXml.setData("appl_home_addr", appl_home_addr)
				//&&  dataToXml.setData("appl_home_phon", appl_home_phon)
				&&  dataToXml.setData("appl_user_iden", appl_user_iden)
				&&  dataToXml.setData("appl_user_type", appl_user_type)
				/* End of 계약자정보 */		
				/* Begin of 고객개인정보 */
				&&  dataToXml.setData("cust_fnsh_date", cust_fnsh_date)
				//&&  dataToXml.setData("cust_curc_code", cust_curc_code)
				//&&  dataToXml.setData("cust_fnsh_amnt", cust_fnsh_amnt)
				//&&  dataToXml.setData("cust_bank_code", cust_bank_code)
				//&&  dataToXml.setData("cust_bank_name", cust_bank_name)
				//&&  dataToXml.setData("cust_bank_acnt", cust_bank_acnt)
				/* End of 고객개인정보 */  			
				/* Begin of 채권자정보 */
				&&  dataToXml.setData("cred_orga_name", cred_orga_name)
				&&  dataToXml.setData("cred_orps_divs", cred_orps_divs)
				&&  dataToXml.setData("cred_orga_numb", cred_orga_numb)
				&&  dataToXml.setData("cred_orps_iden", cred_orps_iden)
				//&&  dataToXml.setData("cred_ownr_numb", cred_ownr_numb)
				&&  dataToXml.setData("cred_ownr_name", cred_ownr_name)
				//&&  dataToXml.setData("cred_bond_hold", cred_bond_hold)
				//&&  dataToXml.setData("cred_addn_name", cred_addn_name)
				//&&  dataToXml.setData("cred_orga_post", cred_orga_post)
				//&&  dataToXml.setData("cred_orga_addr", cred_orga_addr)
				&&  dataToXml.setData("cred_chrg_name", cred_chrg_name)
				&&  dataToXml.setData("cred_dept_name", cred_dept_name)
				&&  dataToXml.setData("cred_phon_numb", cred_phon_numb)
				&&  dataToXml.setData("cred_cell_phon", cred_cell_phon)
				&&  dataToXml.setData("cred_send_mail", cred_send_mail)
				&&  dataToXml.setData("cred_user_iden", cred_user_iden)
				&&  dataToXml.setData("cred_user_type", cred_user_type)
				/* End of 채권자정보 */	 	
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/samplePERCOM.xml", xmlDoc);
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
			  /* Begin of 보험계약정보  */     
			String docu_numb_text = xmlToData.getData("docu_numb_text");
			String docu_kind_code = xmlToData.getData("docu_kind_code");
			String docu_issu_date = xmlToData.getData("docu_issu_date");
			String docu_oper_code = xmlToData.getData("docu_oper_code");
			String docu_appl_code = xmlToData.getData("docu_appl_code");
			  /* End of 보험계약정보  */ 		
			  /*  Begin of 주요계약정보 */      
			String cont_numb_text = xmlToData.getData("cont_numb_text");
			String cont_name_text = xmlToData.getData("cont_name_text");
			String cont_curc_code = xmlToData.getData("cont_curc_code");
			String cont_main_amnt = xmlToData.getData("cont_main_amnt");
			  /*  End of 주요계약정보 */        
			  /* Begin of 계약자정보 */         
			String appl_orga_name = xmlToData.getData("appl_orga_name");
			String appl_orps_divs = xmlToData.getData("appl_orps_divs");
			String appl_orga_numb = xmlToData.getData("appl_orga_numb");
			String appl_orps_iden = xmlToData.getData("appl_orps_iden");
			String appl_ownr_numb = xmlToData.getData("appl_ownr_numb");
			String appl_ownr_name = xmlToData.getData("appl_ownr_name");
			String appl_addn_name = xmlToData.getData("appl_addn_name");
			String appl_orga_post = xmlToData.getData("appl_orga_post");
			String appl_orga_addr = xmlToData.getData("appl_orga_addr");
			//String appl_chrg_name = xmlToData.getData("appl_chrg_name");
			//String appl_dept_name = xmlToData.getData("appl_dept_name");
			String appl_offc_phon = xmlToData.getData("appl_offc_phon");
			String appl_cell_phon = xmlToData.getData("appl_cell_phon");
			String appl_send_mail = xmlToData.getData("appl_send_mail");
			//String appl_home_post = xmlToData.getData("appl_home_post");
			//String appl_home_addr = xmlToData.getData("appl_home_addr");
			//String appl_home_phon = xmlToData.getData("appl_home_phon");
			String appl_user_iden = xmlToData.getData("appl_user_iden");
			String appl_user_type = xmlToData.getData("appl_user_type");
			  /* End of 계약자정보 */		
			  /* Begin of 고객개인정보 */       
			String cust_fnsh_date = xmlToData.getData("cust_fnsh_date");
			//String cust_curc_code = xmlToData.getData("cust_curc_code");
			//String cust_fnsh_amnt = xmlToData.getData("cust_fnsh_amnt");
			String cust_bank_code = xmlToData.getData("cust_bank_code");
			String cust_bank_name = xmlToData.getData("cust_bank_name");
			String cust_bank_acnt = xmlToData.getData("cust_bank_acnt");
			  /* End of 고객개인정보 */  			
			  /* Begin of 채권자정보 */         
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
			/* End of 채권자정보 */	

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
			System.out.println("docu_numb_text=" + docu_numb_text);
			System.out.println("docu_kind_code=" + docu_kind_code);
			System.out.println("docu_issu_date=" + docu_issu_date);
			System.out.println("docu_oper_code=" + docu_oper_code);
			System.out.println("docu_appl_code=" + docu_appl_code);
			System.out.println("cont_numb_text=" + cont_numb_text);
			System.out.println("cont_name_text=" + cont_name_text);
			System.out.println("cont_curc_code=" + cont_curc_code);
			System.out.println("cont_main_amnt=" + cont_main_amnt);
			System.out.println("appl_orga_name=" + appl_orga_name);
			System.out.println("appl_orps_divs=" + appl_orps_divs);
			System.out.println("appl_orga_numb=" + appl_orga_numb);
			System.out.println("appl_orps_iden=" + appl_orps_iden);
			System.out.println("appl_ownr_numb=" + appl_ownr_numb);
			System.out.println("appl_ownr_name=" + appl_ownr_name);
			System.out.println("appl_addn_name=" + appl_addn_name);
			System.out.println("appl_orga_post=" + appl_orga_post);
			System.out.println("appl_orga_addr=" + appl_orga_addr);
			//System.out.println("appl_chrg_name=" + appl_chrg_name);
			//System.out.println("appl_dept_name=" + appl_dept_name);
			System.out.println("appl_offc_phon=" + appl_offc_phon);
			System.out.println("appl_cell_phon=" + appl_cell_phon);
			System.out.println("appl_send_mail=" + appl_send_mail);
			//System.out.println("appl_home_post=" + appl_home_post);
			//System.out.println("appl_home_addr=" + appl_home_addr);
			//System.out.println("appl_home_phon=" + appl_home_phon);
			System.out.println("appl_user_iden=" + appl_user_iden);
			System.out.println("appl_user_type=" + appl_user_type);
			System.out.println("cust_fnsh_date=" + cust_fnsh_date);
			//System.out.println("cust_curc_code=" + cust_curc_code);
			//System.out.println("cust_fnsh_amnt=" + cust_fnsh_amnt);
			System.out.println("cust_bank_code=" + cust_bank_code);
			System.out.println("cust_bank_name=" + cust_bank_name);
			System.out.println("cust_bank_acnt=" + cust_bank_acnt);
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
		}catch(Exception _e){
			System.out.println(_e.toString());
		}		
	}
}
