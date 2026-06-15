import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKGUA {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKGUA";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 증권정보(IBKGUA) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKGUA";			/*[필수]	 문서코드*/
		String head_mesg_name = "증권정보";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "증권정보";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 구매업체(회원사) 정보 */
		String TRAD_NUMB = "11114";					/*[선택]	 매매계약번호*/
		String SELL_CORP = "1111111119";			/*[필수]	 판매자법인번호(market place)*/
		String SELL_CNID = "1111111111";			/*[필수]	 판매자사업자번호(market place)*/
		String CMPN_ID   = "1111111118";			/*[필수]	 구매자 사업자 번호 */
		String CORP_NUMB = "1111111117";			/*[선택]	 구매사 법인 번호*/
		String FIRM_NAME = "테스트 증권";			/*[선택]	 구매사 회사 이름*/
		String YSNO_CODE = "0";						/*[필수]	 증권정보 구분코드*/
		String CANS_REAS = "없음";					/*[선택]	 증권정보 취소 사유*/

		/* 증권정보 */
		String SGIC_BOND = "1234";					/*[필수]	 증권번호*/
		String GURT_PRIC = "10000";					/*[필수]	 보험가입금액*/
		String INSU_BEGN = "20070501";				/*[필수]	 보험기간 시작일자(YYYYMMDD)*/
		String INSU_FNSH = "20080501";				/*[필수]	 보험기간 종료일자(YYYYMMDD)*/
		String OLSG_BOND = "1111";					/*[선택]	 구 증권 번호*/
		String OLSG_BEGN = "20060501";				/*[선택]	 구 증권 시작일자(기간 연장때문에 추가)*/
		String OLSG_FNSH = "20070501";				/*[선택]	 구 증권 종료일자(기간 연장때문에 추가)*/

		/* 주계약정보 */
		String LENN_PRIC = "1000";					/*[선택]	 대출금액*/
		String LENN_BEGN = "20070502";				/*[선택]	 대출실행일*/
		String LENN_FNSH = "20080502";				/*[선택]	 대출종료일*/
		String LENN_INST = "30";					/*[선택]	 대출이자율*/
		String GURT_RATE = "60";					/*[선택]	 대출보증비율(%)*/
		String GURT_INSU = "1114";					/*[선택]	 피보험자 법인번호*/
		String SPCL_COND = "없음";					/*[선택]	 특기사항*/

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 증권정보(IBKGUA) */								
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

				/* Begin of 구매업체(회원사) 정보 */
				//&&	dataToXml.setData("TRAD_NUMB", TRAD_NUMB)
				//&&	dataToXml.setData("SELL_CORP", SELL_CORP)
				&&	dataToXml.setData("SELL_CNID", SELL_CNID)
				&&	dataToXml.setData("CMPN_ID", CMPN_ID)
				//&&	dataToXml.setData("CORP_NUMB", CORP_NUMB)
				&&	dataToXml.setData("FIRM_NAME", FIRM_NAME)
				&&	dataToXml.setData("YSNO_CODE", YSNO_CODE)
				&&	dataToXml.setData("CANS_REAS", CANS_REAS)
				/* End of 구매업체(회원사) 정보 */

				/* Begin of 증권정보 */
				&&	dataToXml.setData("SGIC_BOND", SGIC_BOND)
				&&	dataToXml.setData("GURT_PRIC", GURT_PRIC)
				&&	dataToXml.setData("INSU_BEGN", INSU_BEGN)
				&&	dataToXml.setData("INSU_FNSH", INSU_FNSH)
				&&	dataToXml.setData("OLSG_BOND", OLSG_BOND)
				&&	dataToXml.setData("OLSG_BEGN", OLSG_BEGN)
				&&	dataToXml.setData("OLSG_FNSH", OLSG_FNSH)
				/* End of 증권정보 */

				/* Begin of 주계약정보 */
				&&	dataToXml.setData("LENN_PRIC", LENN_PRIC)
				&&	dataToXml.setData("LENN_BEGN", LENN_BEGN)
				&&	dataToXml.setData("LENN_FNSH", LENN_FNSH)
				&&	dataToXml.setData("LENN_INST", LENN_INST)
				&&	dataToXml.setData("GURT_RATE", GURT_RATE)
				&&	dataToXml.setData("GURT_INSU", GURT_INSU)
				&&	dataToXml.setData("SPCL_COND", SPCL_COND)
				/* End of 주계약정보 */
				)
			{
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKGUA.xml", xmlDoc);
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
		/* 증권정보(IBKGUA) */								
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 증권정보(IBKGUA) */								
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

			/* 구매업체(회원사) 정보 */
			//String TRAD_NUMB = xmlToData.getData("TRAD_NUMB");			/*[선택]	 매매계약번호*/
			//String SELL_CORP = xmlToData.getData("SELL_CORP");			/*[필수]	 판매자법인번호(market place)*/
			String SELL_CNID = xmlToData.getData("SELL_CNID");			/*[필수]	 판매자사업자번호(market place)*/
			String CMPN_ID   = xmlToData.getData("CMPN_ID");			/*[필수]	 구매자 사업자 번호 */
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");			/*[선택]	 구매사 법인 번호*/
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");			/*[선택]	 구매사 회사 이름*/
			String YSNO_CODE = xmlToData.getData("YSNO_CODE");			/*[필수]	 증권정보 구분코드*/
			String CANS_REAS = xmlToData.getData("CANS_REAS");			/*[선택]	 증권정보 취소 사유*/

			/* 증권정보 */
			String SGIC_BOND = xmlToData.getData("SGIC_BOND");			/*[필수]	 증권번호*/
			String GURT_PRIC = xmlToData.getData("GURT_PRIC");			/*[필수]	 보험가입금액*/
			String INSU_BEGN = xmlToData.getData("INSU_BEGN");			/*[필수]	 보험기간 시작일자(YYYYMMDD)*/
			String INSU_FNSH = xmlToData.getData("INSU_FNSH");			/*[필수]	 보험기간 종료일자(YYYYMMDD)*/
			String OLSG_BOND = xmlToData.getData("OLSG_BOND");			/*[선택]	 구 증권 번호*/
			String OLSG_BEGN = xmlToData.getData("OLSG_BEGN");			/*[선택]	 구 증권 시작일자(기간 연장때문에 추가)*/
			String OLSG_FNSH = xmlToData.getData("OLSG_FNSH");			/*[선택]	 구 증권 종료일자(기간 연장때문에 추가)*/

			/* 주계약정보 */
			String LENN_PRIC = xmlToData.getData("LENN_PRIC");			/*[선택]	 대출금액*/
			String LENN_BEGN = xmlToData.getData("LENN_BEGN");			/*[선택]	 대출실행일*/
			String LENN_FNSH = xmlToData.getData("LENN_FNSH");			/*[선택]	 대출종료일*/
			String LENN_INST = xmlToData.getData("LENN_INST");			/*[선택]	 대출이자율*/
			String GURT_RATE = xmlToData.getData("GURT_RATE");			/*[선택]	 대출보증비율(%)*/
			String GURT_INSU = xmlToData.getData("GURT_INSU");			/*[선택]	 피보험자 법인번호*/
			String SPCL_COND = xmlToData.getData("SPCL_COND");			/*[선택]	 특기사항*/

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

			//System.out.println("TRAD_NUMB     =" + TRAD_NUMB     );
			//System.out.println("SELL_CORP     =" + SELL_CORP     );
			System.out.println("SELL_CNID     =" + SELL_CNID     );
			System.out.println("CMPN_ID       =" + CMPN_ID       );
			//System.out.println("CORP_NUMB     =" + CORP_NUMB     );
			System.out.println("FIRM_NAME     =" + FIRM_NAME     );
			System.out.println("YSNO_CODE     =" + YSNO_CODE     );
			System.out.println("CANS_REAS     =" + CANS_REAS     );
			System.out.println("SGIC_BOND     =" + SGIC_BOND     );
			System.out.println("GURT_PRIC     =" + GURT_PRIC     );
			System.out.println("INSU_BEGN     =" + INSU_BEGN     );
			System.out.println("INSU_FNSH     =" + INSU_FNSH     );
			System.out.println("OLSG_BOND     =" + OLSG_BOND     );
			System.out.println("OLSG_BEGN     =" + OLSG_BEGN     );
			System.out.println("OLSG_FNSH     =" + OLSG_FNSH     );
			System.out.println("LENN_PRIC     =" + LENN_PRIC     );
			System.out.println("LENN_BEGN     =" + LENN_BEGN     );
			System.out.println("LENN_FNSH     =" + LENN_FNSH     );
			System.out.println("LENN_INST     =" + LENN_INST     );
			System.out.println("GURT_RATE     =" + GURT_RATE     );
			System.out.println("GURT_INSU     =" + GURT_INSU     );
			System.out.println("SPCL_COND     =" + SPCL_COND     );

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
