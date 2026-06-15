import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestRBONGU {

	public static void main(String[] args) {
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "RBONGU";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)
			parseXML(templatePath, docCode, xmlDoc);
	}
	
	public static String composeXML(String templatePath, String docCode)
	{
		/* 최종응답서(RBONGU) */								
		/* HEADER */								
		String	head_mesg_send  ="A111111111900";	/*	[필수]	 전문송신기관	*/
		String	head_mesg_recv  ="z120811300200";	/*	[필수]	 전문수신기관	*/
		String	head_func_code  ="53";				/*	[필수]	 문서기능	*/
		String	head_mesg_type  ="RBONGU";			/*	[필수]	 문서코드	*/
		String	head_mesg_name  ="최종응답서";		/*	[필수]	 문서명	*/
		String	head_mesg_vers  ="1.0";				/*	[선택]	 전자문서버전	*/
		String	head_docu_numb  ="0043338 2";		/*	[필수]	 문서번호	*/
		String	head_mang_numb  ="13.20060227151000.12345.0043338' '2";	/*	[필수]	 문서관리번호	*/
		String	head_refr_numb  ="0043338 2";		/*	[필수]	 참조번호	*/
		String	head_titl_name  ="최종응답서";		/*	[필수]	 문서개요	*/
		String  head_orga_code  ="ABC";             /*  [필수]   연계코드   */

		/* 문서정보 */                                                                                                                                                                                                                                           
		String  docu_numb_text  ="18996938";			/* [필수]	증권번호	*/	        
		String  docu_kind_code  ="D";					/* [필수]	보험종목구분		*/	
		String  docu_issu_date  ="20060304";			/* [선택]	작성일자		*/	
		String  docu_user_type  ="N";					/* [필수]	발신처TYPE	    */            
		/* 주요계약정보  */                                                                                                                                                                                                                                      
		String  cont_numb_text  ="A2000800-61-3";		/* [필수]	계약번호		*/	
		String  cont_main_name  ="Test Contract Name";	/* [필수]	계약건명			*/
		String  cont_curc_code  ="WON";					/* [선택]	계약금액/통화코드	     */   
		String  cont_main_amnt  ="10000";				/* [선택]	계약금액/계약금액      */         
		/* 계약자정보    */                                                                                                                                                                                                                                      
		String  appl_orga_name  ="한국채권자주식회사";	/* [필수]	기관명	*/		        
		String  appl_orps_divs  ="0";					/* [필수]	구분		*/	        
		String  appl_orps_iden  ="2228122222";			/* [필수]	사업자/주민번호	*/		
		String  appl_ownr_name  ="김채권";				/* [필수]	성명(대표자명)*/	                
		/* 채권자정보     */                                                                                                                                                                                                                                     
		String  cred_bond_hold  ="김부자";				/* [필수]	채권자명*/
		/* 응답정보   */                                                                                                                                                                                                                                         
		String  resp_type_code  ="SA";												/* [필수]	응답코드	*/
		String  resp_type_name  ="응답서";											/* [필수]	응답코드명	*/
		String  resp_mesg_text  ="업체정보 수신업무가 정상적으로 수행되었습니다.";  /* [필수]	응답내용  */      
		
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
				
				/* Begin of 문서정보 */ 
				&&  dataToXml.setData("docu_numb_text", docu_numb_text)
				&&  dataToXml.setData("docu_kind_code", docu_kind_code)
				&&  dataToXml.setData("docu_issu_date", docu_issu_date)
				&&  dataToXml.setData("docu_user_type", docu_user_type)
				/* End of 문서정보 */        

				/* Begin of 주요계약정보  */   
				&&  dataToXml.setData("cont_numb_text", cont_numb_text)
				&&  dataToXml.setData("cont_main_name", cont_main_name)
				&&  dataToXml.setData("cont_curc_code", cont_curc_code)
				&&  dataToXml.setData("cont_main_amnt", cont_main_amnt)
				/* End of 주요계약정보  */ 
					
				/* Begin of 계약자정보    */    
				&&  dataToXml.setData("appl_orga_name", appl_orga_name)
				&&  dataToXml.setData("appl_orps_divs", appl_orps_divs)
				&&  dataToXml.setData("appl_orps_iden", appl_orps_iden)
				&&  dataToXml.setData("appl_ownr_name", appl_ownr_name)
				/* End of 계약자정보  */   
					
				/* Begin of채권자정보     */    
				&&  dataToXml.setData("cred_bond_hold", cred_bond_hold)
				/* End of채권자정보     */ 

				/* Begin of 응답정보   */    
				&&  dataToXml.setData("resp_type_code", resp_type_code)
				&&  dataToXml.setData("resp_type_name", resp_type_name)
				&&  dataToXml.setData("resp_mesg_text", resp_mesg_text)
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleRBONGU.xml", xmlDoc);
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
			  /* Begin of 문서정보 */      
			String docu_numb_text = xmlToData.getData("docu_numb_text");
			String docu_kind_code = xmlToData.getData("docu_kind_code");
			String docu_issu_date = xmlToData.getData("docu_issu_date");
			String docu_user_type = xmlToData.getData("docu_user_type");
			  /* End of 문서정보 */                                                
			  /* Begin of 주요계약정보  */    
			String cont_numb_text = xmlToData.getData("cont_numb_text");
			String cont_main_name = xmlToData.getData("cont_main_name");
			String cont_curc_code = xmlToData.getData("cont_curc_code");
			String cont_main_amnt = xmlToData.getData("cont_main_amnt");
			  /* End of 주요계약정보  */        
			  /* Begin of 계약자정보    */      
			String appl_orga_name = xmlToData.getData("appl_orga_name");
			String appl_orps_divs = xmlToData.getData("appl_orps_divs");
			String appl_orps_iden = xmlToData.getData("appl_orps_iden");
			String appl_ownr_name = xmlToData.getData("appl_ownr_name");
			  /* End of 계약자정보  */          
			  /* Begin of채권자정보     */      
			String cred_bond_hold = xmlToData.getData("cred_bond_hold");
			  /* End of채권자정보     */        
			  /* Begin of 응답정보   */         
			String resp_type_code = xmlToData.getData("resp_type_code");
			String resp_type_name = xmlToData.getData("resp_type_name");
			String resp_mesg_text = xmlToData.getData("resp_mesg_text");

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
			System.out.println("docu_user_type=" + docu_user_type);
			System.out.println("cont_numb_text=" + cont_numb_text);
			System.out.println("cont_main_name=" + cont_main_name);
			System.out.println("cont_curc_code=" + cont_curc_code);
			System.out.println("cont_main_amnt=" + cont_main_amnt);
			System.out.println("appl_orga_name=" + appl_orga_name);
			System.out.println("appl_orps_divs=" + appl_orps_divs);
			System.out.println("appl_orps_iden=" + appl_orps_iden);
			System.out.println("appl_ownr_name=" + appl_ownr_name);
			System.out.println("cred_bond_hold=" + cred_bond_hold);
			System.out.println("resp_type_code=" + resp_type_code);
			System.out.println("resp_type_name=" + resp_type_name);
			System.out.println("resp_mesg_text=" + resp_mesg_text);
		}catch(Exception _e){
			System.out.println(_e.toString());
		}		
	}
}
