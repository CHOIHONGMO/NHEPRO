import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKGAT {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKGAT";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 보증가능액조회 및 결과(IBKGAT) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKGAT";			/*[필수]	 문서코드*/
		String head_mesg_name = "보증가능액조회 및 결과";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "보증가능액조회 및 결과";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 기본정보 */
		String CMPN_ID   = "1111111119"; /*[필수] 사업자번호                              */
		String CORP_NUMB = "1111111118"; /*[선택] 법인 번호                               */
		String FIRM_NAME = "테스트"; /*[선택] 회사 상호                               */
		String BANK_CODE = "B"; /*[필수] 은행코드                                */
		String BRAN_NAME = "경기지점"; /*[선택] 은행지점명                              */
		String CLRK_NAME = "홍길동"; /*[선택] 은행지점 담당자 이름                    */
		String BRAN_PHON = "0311111234"; /*[] 은행지점 담당자 전화번호                */
		String BOND_CODE = "S"; /*[필수] 보증가능액조회코드('S':조회, 'R':결과)  */
		String BOND_RSLT = "Y"; /*[선택] 보증가능여부('Y':보증가능, 'N':보증불가)*/
		String BOND_AMNT = "1000"; /*[선택] 보증가능한도금액                        */
		String ACPT_NUMB = "2345"; /*[선택] 보증가능액 조회 전문 접수 번호          */
		String JUDG_OPIN = "심사 의견 내용 또는 특이 사항";     /*[선택] 심사 의견 내용 또는 특이 사항 기타등등  */
				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 보증가능액조회 및 결과(IBKGAT) */							
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
				&&	dataToXml.setData("head_mang_numb", head_mang_numb)
				&&	dataToXml.setData("head_titl_name", head_titl_name)
				&&	dataToXml.setData("head_orga_code", head_orga_code)
				&&	dataToXml.setData("head_serl_numb", head_serl_numb)
				&&	dataToXml.setData("head_erro_code", head_erro_code)
				&&	dataToXml.setData("head_resp_text", head_resp_text)
				&&	dataToXml.setData("head_bank_text", head_bank_text)
				/* End of Header */

				/* Begin of 기본정보 */
				&& dataToXml.setData("CMPN_ID", CMPN_ID  )
				//&& dataToXml.setData("CORP_NUMB", CORP_NUMB)
				&& dataToXml.setData("FIRM_NAME", FIRM_NAME)
				&& dataToXml.setData("BANK_CODE", BANK_CODE)
				&& dataToXml.setData("BRAN_NAME", BRAN_NAME)
				&& dataToXml.setData("CLRK_NAME", CLRK_NAME)
				&& dataToXml.setData("BRAN_PHON", BRAN_PHON)
				&& dataToXml.setData("BOND_CODE", BOND_CODE)
				&& dataToXml.setData("BOND_RSLT", BOND_RSLT)
				&& dataToXml.setData("BOND_AMNT", BOND_AMNT)
				&& dataToXml.setData("ACPT_NUMB", ACPT_NUMB)
				&& dataToXml.setData("JUDG_OPIN", JUDG_OPIN)
				/* End of 기본정보 */
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKGAT.xml", xmlDoc);
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
		/* 보증가능액조회 및 결과(IBKGAT) */							
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 보증가능액조회 및 결과(IBKGAT) */							
			/* HEADER */										
			String head_mesg_send = xmlToData.getData("head_mesg_send");	/*[필수]	 전문송신기관*/
			String head_mesg_recv = xmlToData.getData("head_mesg_recv");	/*[필수]	 전문수신기관*/
			String head_func_code = xmlToData.getData("head_func_code");	/*[필수]	 문서기능*/
			String head_mesg_type = xmlToData.getData("head_mesg_type");	/*[필수]	 문서코드*/
			String head_mesg_name = xmlToData.getData("head_mesg_name");	/*[필수]	 문서명*/
			String head_mesg_vers = xmlToData.getData("head_mesg_vers");	/*[선택]	 문서버전*/
			String head_mang_numb = xmlToData.getData("head_mang_numb");	/*[필수]	 문서관리번호*/
			String head_titl_name = xmlToData.getData("head_titl_name");	/*[필수]	 문서개요*/
			String head_orga_code = xmlToData.getData("head_orga_code");	/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
			String head_serl_numb = xmlToData.getData("head_serl_numb");	/*[선택]	 일련번호*/
			String head_erro_code = xmlToData.getData("head_erro_code");	/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
			String head_resp_text = xmlToData.getData("head_resp_text");	/*[선택]	 응답메세지*/
			String head_bank_text = xmlToData.getData("head_bank_text");	/*[선택]	 은행사용란*/

			/* 기본정보 */
			String CMPN_ID   = xmlToData.getData("CMPN_ID");
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");
			String BANK_CODE = xmlToData.getData("BANK_CODE");
			String BRAN_NAME = xmlToData.getData("BRAN_NAME");
			String CLRK_NAME = xmlToData.getData("CLRK_NAME");
			String BRAN_PHON = xmlToData.getData("BRAN_PHON");
			String BOND_CODE = xmlToData.getData("BOND_CODE");
			String BOND_RSLT = xmlToData.getData("BOND_RSLT");
			String BOND_AMNT = xmlToData.getData("BOND_AMNT");
			String ACPT_NUMB = xmlToData.getData("ACPT_NUMB");
			String JUDG_OPIN = xmlToData.getData("JUDG_OPIN");

			System.out.println("head_mesg_send=" + head_mesg_send);
			System.out.println("head_mesg_recv=" + head_mesg_recv);
			System.out.println("head_func_code=" + head_func_code);
			System.out.println("head_mesg_type=" + head_mesg_type);
			System.out.println("head_mesg_name=" + head_mesg_name);
			System.out.println("head_mesg_vers=" + head_mesg_vers);
			System.out.println("head_mang_numb=" + head_mang_numb);
			System.out.println("head_titl_name=" + head_titl_name);
			System.out.println("head_orga_code=" + head_orga_code);
			System.out.println("head_serl_numb=" + head_serl_numb);
			System.out.println("head_erro_code=" + head_erro_code);
			System.out.println("head_resp_text=" + head_resp_text);
			System.out.println("head_bank_text=" + head_bank_text);

			System.out.println("CMPN_ID   =" + CMPN_ID  );
			//System.out.println("CORP_NUMB =" + CORP_NUMB);
			System.out.println("FIRM_NAME =" + FIRM_NAME);
			System.out.println("BANK_CODE =" + BANK_CODE);
			System.out.println("BRAN_NAME =" + BRAN_NAME);
			System.out.println("CLRK_NAME =" + CLRK_NAME);
			System.out.println("BRAN_PHON =" + BRAN_PHON);
			System.out.println("BOND_CODE =" + BOND_CODE);
			System.out.println("BOND_RSLT =" + BOND_RSLT);
			System.out.println("BOND_AMNT =" + BOND_AMNT);
			System.out.println("ACPT_NUMB =" + ACPT_NUMB);
			System.out.println("JUDG_OPIN =" + JUDG_OPIN);

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
