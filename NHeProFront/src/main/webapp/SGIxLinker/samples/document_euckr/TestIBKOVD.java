import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKOVD {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKOVD";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 연체정보(IBKOVD) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKOVD";			/*[필수]	 문서코드*/
		String head_mesg_name = "연체정보";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "연체정보";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 기본정보*/
		String TRAD_NUMB = "1111111119"; /*[선택] 매매계약번호                   */
		String SELL_CORP = "1111111118"; /*[선택] 판매자법인번호(market place)   */
		String SELL_CNID = "1111111117"; /*[선택] 판매자사업자번호(market place) */
		String CMPN_ID   = "1111111116"; /*[필수] 구매자 사업자번호              */
		String CORP_NUMB = "1111111115"; /*[선택] 구매사 법인 번호               */
		String FIRM_NAME = "테스트회사"; /*[선택] 구매사 회사 이름               */

		/* 연체상세정보*/
		String TAXS_NUMB = "12334532";	/*[필수] 세금계산서번호                             */
		String BANK_CODE = "B";			/*[필수] 은행코드                                   */
		String OVER_DATE = "20070501";	/*[선택] 연체최초발생일자(YYYYMMDD)                 */
		String OVER_PRID = "30";		/*[선택] 연체일수                                   */
		String OVER_PRIC = "0";			/*[필수] 연체금액(원금) default :0                  */
		String OVER_INST = "0";			/*[필수] 연체금액(이자) default :0                  */
		String SGIC_BOND = "43342";		/*[필수] 증권번호                                   */
		String YSNO_CODE = "O";			/*[필수] 연체 정보 구분 코드(O;정상, C:취소, T:해제)*/
		String CANS_REAS = "없음";		/*[선택] 연체 정보 취소 사유                        */	

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 연체정보(IBKOVD) */						
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
				//&& dataToXml.setData("TRAD_NUMB", TRAD_NUMB)/*[선택] 매매계약번호                   */
				//&& dataToXml.setData("SELL_CORP", SELL_CORP)/*[선택] 판매자법인번호(market place)   */
				&& dataToXml.setData("SELL_CNID", SELL_CNID)/*[선택] 판매자사업자번호(market place) */
				&& dataToXml.setData("CMPN_ID", CMPN_ID  )/*[필수] 구매자 사업자번호              */
				//&& dataToXml.setData("CORP_NUMB", CORP_NUMB)/*[선택] 구매사 법인 번호               */
				&& dataToXml.setData("FIRM_NAME", FIRM_NAME)/*[선택] 구매사 회사 이름               */
				/* End of 기본정보 */				
				){
				}else{
					System.out.println(dataToXml.getErrorMsg());
				}

				/* Begin of 상환정보 */	
				String data = null;
				for(int i = 0 ; i < 2 ; i++){
					dataToXml.initLoopDataWithChild("OVD_due_max", data);
					if(!dataToXml.setLoopDataWithChild("TAXS_NUMB", TAXS_NUMB)){ /*[필수] 세금계산서번호                             */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("BANK_CODE", BANK_CODE)){ 	/*[필수] 은행코드                                   */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("OVER_DATE", OVER_DATE)){ /*[선택] 연체최초발생일자(YYYYMMDD)                 */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("OVER_PRID", OVER_PRID)){ /*[선택] 연체일수                                   */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("OVER_PRIC", OVER_PRIC)){ 	/*[필수] 연체금액(원금) default :0                  */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("OVER_INST", OVER_INST)){ 	/*[필수] 연체금액(이자) default :0                  */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("SGIC_BOND", SGIC_BOND)){ /*[필수] 증권번호                                   */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("YSNO_CODE", YSNO_CODE)){ 	/*[필수] 연체 정보 구분 코드(O;정상, C:취소, T:해제)*/
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("CANS_REAS", CANS_REAS)){ /*[선택] 연체 정보 취소 사유                        */
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					data = dataToXml.closeLoopDataWithChild();
				}
				/* End of 상환정보 */
			
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKOVD.xml", xmlDoc);			
		}catch(Exception _e){
			System.out.println(_e.toString());
		}
		
		return xmlDoc;
	}


	public static void parseXML(String templatePath, String docCode, String xmlDoc)
	{
		/* 연체정보(IBKOVD) */					
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 연체정보(IBKOVD) */						
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
			//String TRAD_NUMB = xmlToData.getData("TRAD_NUMB");/*[선택] 매매계약번호                   */
			//String SELL_CORP = xmlToData.getData("SELL_CORP");/*[선택] 판매자법인번호(market place)   */
			String SELL_CNID = xmlToData.getData("SELL_CNID");/*[선택] 판매자사업자번호(market place) */
			String CMPN_ID   = xmlToData.getData("CMPN_ID");/*[필수] 구매자 사업자번호              */
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");/*[선택] 구매사 법인 번호               */
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");/*[선택] 구매사 회사 이름               */

			/* 연체상세정보*/
			int loopsize = xmlToData.getLoopSize("OVD_due_max");
				String[] TAXS_NUMB = new String[loopsize];/*[필수] 세금계산서번호                             */
				String[] BANK_CODE = new String[loopsize];/*[필수] 은행코드                                   */
				String[] OVER_DATE = new String[loopsize];/*[선택] 연체최초발생일자(YYYYMMDD)                 */
				String[] OVER_PRID = new String[loopsize];/*[선택] 연체일수                                   */
				String[] OVER_PRIC = new String[loopsize];/*[필수] 연체금액(원금) default :0                  */
				String[] OVER_INST = new String[loopsize];/*[필수] 연체금액(이자) default :0                  */
				String[] SGIC_BOND = new String[loopsize];/*[필수] 증권번호                                   */
				String[] YSNO_CODE = new String[loopsize];/*[필수] 연체 정보 구분 코드(O;정상, C:취소, T:해제)*/
				String[] CANS_REAS = new String[loopsize];/*[선택] 연체 정보 취소 사유                        */	
			for(int i = 0 ; i < loopsize ; i++){
				xmlToData.initLoopDataWithChild("OVD_due_max", i);
				TAXS_NUMB[i] = xmlToData.getLoopDataWithChild("TAXS_NUMB");/*[필수] 세금계산서번호                             */
				BANK_CODE[i] = xmlToData.getLoopDataWithChild("BANK_CODE");/*[필수] 은행코드                                   */
				OVER_DATE[i] = xmlToData.getLoopDataWithChild("OVER_DATE");/*[선택] 연체최초발생일자(YYYYMMDD)                 */
				OVER_PRID[i] = xmlToData.getLoopDataWithChild("OVER_PRID");/*[선택] 연체일수                                   */
				OVER_PRIC[i] = xmlToData.getLoopDataWithChild("OVER_PRIC");/*[필수] 연체금액(원금) default :0                  */
				OVER_INST[i] = xmlToData.getLoopDataWithChild("OVER_INST");/*[필수] 연체금액(이자) default :0                  */
				SGIC_BOND[i] = xmlToData.getLoopDataWithChild("SGIC_BOND");/*[필수] 증권번호                                   */
				YSNO_CODE[i] = xmlToData.getLoopDataWithChild("YSNO_CODE");/*[필수] 연체 정보 구분 코드(O;정상, C:취소, T:해제)*/
				CANS_REAS[i] = xmlToData.getLoopDataWithChild("CANS_REAS");/*[선택] 연체 정보 취소 사유                        */
				xmlToData.closeLoopDataWithChild("OVD_due_max");
			}
			

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

			for(int i = 0 ; i < TAXS_NUMB.length ; i++){
				System.out.println("TAXS_NUMB[" + i + "]" + TAXS_NUMB[i]);
				System.out.println("BANK_CODE[" + i + "]" + BANK_CODE[i]);
				System.out.println("OVER_DATE[" + i + "]" + OVER_DATE[i]);
				System.out.println("OVER_PRID[" + i + "]" + OVER_PRID[i]);
				System.out.println("OVER_PRIC[" + i + "]" + OVER_PRIC[i]);
				System.out.println("OVER_INST[" + i + "]" + OVER_INST[i]);
				System.out.println("SGIC_BOND[" + i + "]" + SGIC_BOND[i]);
				System.out.println("YSNO_CODE[" + i + "]" + YSNO_CODE[i]);
				System.out.println("CANS_REAS[" + i + "]" + CANS_REAS[i]);
			}

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
