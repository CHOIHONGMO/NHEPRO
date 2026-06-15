import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKLOA {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKLOA";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 약정정보(IBKLOA) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKLOA";			/*[필수]	 문서코드*/
		String head_mesg_name = "약정정보";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "약정정보";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 대출한도(약정체결)승인*/
		String TRAD_NUMB = "1234";/*[선택]  매매계약번호                                         */
		String SELL_CORP = "1111111119";/*[필수]  판매자법인번호(market place)                         */
		String SELL_CNID = "1111111111";/*[필수]  판매자사업자번호(market place)                       */
		String CMPN_ID   = "1111111118";/*[필수]  구매사 사업자번호                                    */
		String CORP_NUMB = "1111111117";/*[선택]  구매사 법인 번호                                     */
		String FIRM_NAME = "테스트 회사";/*[선택]  구매사 회사 이름                                     */
		String LENN_PRIC = "10000";/*[필수]  여신금액                                             */
		String LENN_BEGN = "20070501";/*[필수]  여신시작일(YYYYMMDD)                                 */
		String LENN_FNSH = "20080502";/*[필수]  여신종료일(YYYYMMDD)                                 */
		String LENN_INST = "2.223";/*[선택]  대출이자율(소수점 5자리 까지 허용)                   */
		String BANK_CODE = "B";/*[필수]  은행코드                                             */
		String BANK_NAME = "IBK";/*[선택]  은행명                                               */
		String CDLN_ACNT = "34623";/*[선택]  여신승인번호                                         */
		String CTRC_NAME = "테스트";/*[선택]  약정체결 담당자 이름                                 */
		String CTRC_PHON = "0211111111111111";/*[선택]  약정체결 담당자 전화번호                             */
		String CTRC_BRNC = "테스트지점";/*[선택]  약정체결 지점명                                      */
		String SGIC_BOND = "32456";/*[필수]  증권번호                                             */
		String HIST_ACNT = "23324";/*[선택]  이전 여신번호(여신연장 때문에 추가)                  */
		String HIST_BEGN = "20060501";/*[선택]  이전 여신시작일(YYYYMMDD)                            */
		String HIST_FNSH = "20070502";/*[선택]  이전 여신종료일(YYYYMMDD)                            */
		String YSNO_CODE = "O";/*[필수]  여신승인여부(O:승인, C:취소, T:해지, U:변경, R:연장) */
		String CANS_REAS = "없음";/*[선택]  여신 취소 또는 해지 사유                             */

		

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 증권정보(IBKLOA) */								
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

				/* Begin of 대출한도(약정체결)승인 */
				//&& dataToXml.setData("TRAD_NUMB", TRAD_NUMB)
				//&& dataToXml.setData("SELL_CORP", SELL_CORP)
				&& dataToXml.setData("SELL_CNID", SELL_CNID)
				&& dataToXml.setData("CMPN_ID", CMPN_ID  )
				//&& dataToXml.setData("CORP_NUMB", CORP_NUMB)
				&& dataToXml.setData("FIRM_NAME", FIRM_NAME)
				&& dataToXml.setData("LENN_PRIC", LENN_PRIC)
				&& dataToXml.setData("LENN_BEGN", LENN_BEGN)
				&& dataToXml.setData("LENN_FNSH", LENN_FNSH)
				&& dataToXml.setData("LENN_INST", LENN_INST)
				&& dataToXml.setData("BANK_CODE", BANK_CODE)
				&& dataToXml.setData("BANK_NAME", BANK_NAME)
				&& dataToXml.setData("CDLN_ACNT", CDLN_ACNT)
				&& dataToXml.setData("CTRC_NAME", CTRC_NAME)
				&& dataToXml.setData("CTRC_PHON", CTRC_PHON)
				&& dataToXml.setData("CTRC_BRNC", CTRC_BRNC)
				&& dataToXml.setData("SGIC_BOND", SGIC_BOND)
				&& dataToXml.setData("HIST_ACNT", HIST_ACNT)
				&& dataToXml.setData("HIST_BEGN", HIST_BEGN)
				&& dataToXml.setData("HIST_FNSH", HIST_FNSH)
				&& dataToXml.setData("YSNO_CODE", YSNO_CODE)
				&& dataToXml.setData("CANS_REAS", CANS_REAS)
				/* End of 대출한도(약정체결)승인 */
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKLOA.xml", xmlDoc);
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
		/* 약정정보(IBKLOA) */							
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 약정정보(IBKLOA) */							
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

			/* 대출한도(약정체결)승인 */
			//String TRAD_NUMB = xmlToData.getData("TRAD_NUMB");
			//String SELL_CORP = xmlToData.getData("SELL_CORP");
			String SELL_CNID = xmlToData.getData("SELL_CNID");
			String CMPN_ID   = xmlToData.getData("CMPN_ID");
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");
			String LENN_PRIC = xmlToData.getData("LENN_PRIC");
			String LENN_BEGN = xmlToData.getData("LENN_BEGN");
			String LENN_FNSH = xmlToData.getData("LENN_FNSH");
			String LENN_INST = xmlToData.getData("LENN_INST");
			String BANK_CODE = xmlToData.getData("BANK_CODE");
			String BANK_NAME = xmlToData.getData("BANK_NAME");
			String CDLN_ACNT = xmlToData.getData("CDLN_ACNT");
			String CTRC_NAME = xmlToData.getData("CTRC_NAME");
			String CTRC_PHON = xmlToData.getData("CTRC_PHON");
			String CTRC_BRNC = xmlToData.getData("CTRC_BRNC");
			String SGIC_BOND = xmlToData.getData("SGIC_BOND");
			String HIST_ACNT = xmlToData.getData("HIST_ACNT");
			String HIST_BEGN = xmlToData.getData("HIST_BEGN");
			String HIST_FNSH = xmlToData.getData("HIST_FNSH");
			String YSNO_CODE = xmlToData.getData("YSNO_CODE");
			String CANS_REAS = xmlToData.getData("CANS_REAS");

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

			//System.out.println("TRAD_NUMB=" + TRAD_NUMB);
			//System.out.println("SELL_CORP=" + SELL_CORP);
			System.out.println("SELL_CNID=" + SELL_CNID);
			System.out.println("CMPN_ID  =" + CMPN_ID  );
			//System.out.println("CORP_NUMB=" + CORP_NUMB);
			System.out.println("FIRM_NAME=" + FIRM_NAME);
			System.out.println("LENN_PRIC=" + LENN_PRIC);
			System.out.println("LENN_BEGN=" + LENN_BEGN);
			System.out.println("LENN_FNSH=" + LENN_FNSH);
			System.out.println("LENN_INST=" + LENN_INST);
			System.out.println("BANK_CODE=" + BANK_CODE);
			System.out.println("BANK_NAME=" + BANK_NAME);
			System.out.println("CDLN_ACNT=" + CDLN_ACNT);
			System.out.println("CTRC_NAME=" + CTRC_NAME);
			System.out.println("CTRC_PHON=" + CTRC_PHON);
			System.out.println("CTRC_BRNC=" + CTRC_BRNC);
			System.out.println("SGIC_BOND=" + SGIC_BOND);
			System.out.println("HIST_ACNT=" + HIST_ACNT);
			System.out.println("HIST_BEGN=" + HIST_BEGN);
			System.out.println("HIST_FNSH=" + HIST_FNSH);
			System.out.println("YSNO_CODE=" + YSNO_CODE);
			System.out.println("CANS_REAS=" + CANS_REAS);

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
