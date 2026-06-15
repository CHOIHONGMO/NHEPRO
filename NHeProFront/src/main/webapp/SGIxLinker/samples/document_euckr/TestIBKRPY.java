import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKRPY {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKRPY";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 상환정보(IBKTAX) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKRPY";			/*[필수]	 문서코드*/
		String head_mesg_name = "상환정보";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "상환정보";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 사업자 정보*/
		String SELL_CORP = "1111111117"; /*[필수] 판매자법인번호(market place)   */
		String SELL_CNID = "1111111116"; /*[필수] 판매자사업자번호(market place) */
		String CMPN_ID   = "1111111114"; /*[필수] 구매자 사업자번호              */
		String CORP_NUMB = "1111111119"; /*[선택] 구매사 법인 번호               */
		String FIRM_NAME = "구매회사"; /*[선택] 구매사 회사 이름               */

		/* 상환정보*/
		String TRAD_NUMB = "23133442"; /*[선택] 매매계약번호                                                */
		String TAXS_NUMB = "3244332"; /*[필수] 세금계산서번호                                              */
		String BANK_CODE = "B"; /*[필수] 은행코드                                                    */
		String BANK_ACNT = "32523"; /*[필수] 건별계좌번호                                                */
		String REPY_DATE = "20090501"; /*[필수] 상환일자(YYYYMMDD)                                          */
		String REPY_TIME = "170123"; /*[선택] 상환시각(HH24MISS)                                          */
		String REPY_PRIC = "0"; /*[필수] 상환금액(원금), default : 0                                 */
		String REPY_INTR = "0"; /*[선택] 상환금액(이자), default : 0                                 */
		String RMAN_RRIC = "0"; /*[선택] 상환 후 남은 대출금액, default : 0                          */
		String RECS_NAME = "홍길동"; /*[선택] 입금자이름                                                  */
		String SGIC_BOND = "32234"; /*[필수] 증권번호                                                    */
		String REPY_FLAG = "T"; /*[선택] 상환종류(T, R) : 세금계산서에 있는 세금계산서 형식 분류 코드*/
		String REPY_CODE = "M"; /*[선택] 상환 종목 코드(F:만기상환, M:중도상환)                      */
		String BACK_INTR = "1000"; /*[선택] 중도 상환시 대출이 선취였던 경우 되돌려 주는 이자금액       */
		String BACK_ACNT = "324343"; /*[선택] 이자를 되돌려 주는 경우 되돌려 준 이자를 입금한 계좌번호    */
		String YSNO_CODE = "O"; /*[필수] 상환 유효 코드(O:정상, C:취소)                              */
		String CANS_REAS = "없음"; /*[선택] 상환 정보 취소 사유                                         */		

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 상환정보(IBKTAX) */							
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

				/* Begin of 사업자 정보 */	
				//&& dataToXml.setData("SELL_CORP", SELL_CORP)/*[필수] 판매자법인번호(market place)   */
				&& dataToXml.setData("SELL_CNID", SELL_CNID)/*[필수] 판매자사업자번호(market place) */
				&& dataToXml.setData("CMPN_ID", CMPN_ID  )/*[필수] 구매자 사업자번호              */
				//&& dataToXml.setData("CORP_NUMB", CORP_NUMB)/*[선택] 구매사 법인 번호               */
				&& dataToXml.setData("FIRM_NAME", FIRM_NAME)/*[선택] 구매사 회사 이름               */
				/* End of 사업자 정보 */				
				){
				}else{
					System.out.println(dataToXml.getErrorMsg());
				}

				/* Begin of 상환정보 */	
				String data = null;
				for(int i = 0 ; i < 2 ; i++){
					dataToXml.initLoopDataWithChild("RPY_pepay_max", data);					
					/*if(!dataToXml.setLoopDataWithChild("TRAD_NUMB", TRAD_NUMB)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("TAXS_NUMB", TAXS_NUMB)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("BANK_CODE", BANK_CODE)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("BANK_ACNT", BANK_ACNT)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("REPY_DATE", REPY_DATE)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("REPY_TIME", REPY_TIME)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("REPY_PRIC", REPY_PRIC)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("REPY_INTR", REPY_INTR)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("RMAN_RRIC", RMAN_RRIC)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("RECS_NAME", RECS_NAME)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("SGIC_BOND", SGIC_BOND)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					/*if(!dataToXml.setLoopDataWithChild("REPY_FLAG", REPY_FLAG)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("REPY_CODE", REPY_CODE)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("BACK_INTR", BACK_INTR)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("BACK_ACNT", BACK_ACNT)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("YSNO_CODE", YSNO_CODE)){ 
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("CANS_REAS", CANS_REAS)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}					
					data = dataToXml.closeLoopDataWithChild();
				}
				/* End of 상환정보 */
			
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKRPY.xml", xmlDoc);			
		}catch(Exception _e){
			System.out.println(_e.toString());
		}
		
		return xmlDoc;
	}


	public static void parseXML(String templatePath, String docCode, String xmlDoc)
	{
		/* 상환정보(IBKTAX) */							
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 상환정보(IBKTAX) */								
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

			/* 사업자 정보 */
			//String SELL_CORP = xmlToData.getData("SELL_CORP");/*[필수] 판매자법인번호(market place)   */
			String SELL_CNID = xmlToData.getData("SELL_CNID");/*[필수] 판매자사업자번호(market place) */
			String CMPN_ID   = xmlToData.getData("CMPN_ID");/*[필수] 구매자 사업자번호              */
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");/*[선택] 구매사 법인 번호               */
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");/*[선택] 구매사 회사 이름               */
			


			/* 세금계산서 정보*/
			int loopsize = xmlToData.getLoopSize("RPY_pepay_max");
				//String[] TRAD_NUMB = new String[loopsize];
				String[] TAXS_NUMB = new String[loopsize];
				String[] BANK_CODE = new String[loopsize];
				String[] BANK_ACNT = new String[loopsize];
				String[] REPY_DATE = new String[loopsize];
				String[] REPY_TIME = new String[loopsize];
				String[] REPY_PRIC = new String[loopsize];
				String[] REPY_INTR = new String[loopsize];
				String[] RMAN_RRIC = new String[loopsize];
				String[] RECS_NAME = new String[loopsize];
				String[] SGIC_BOND = new String[loopsize];
				//String[] REPY_FLAG = new String[loopsize];
				String[] REPY_CODE = new String[loopsize];
				String[] BACK_INTR = new String[loopsize];
				String[] BACK_ACNT = new String[loopsize];
				String[] YSNO_CODE = new String[loopsize];
				String[] CANS_REAS = new String[loopsize];
			for(int i = 0 ; i < loopsize ; i++){
				xmlToData.initLoopDataWithChild("RPY_pepay_max", i);
				//TRAD_NUMB[i] = xmlToData.getLoopDataWithChild("TRAD_NUMB");
				TAXS_NUMB[i] = xmlToData.getLoopDataWithChild("TAXS_NUMB");
				BANK_CODE[i] = xmlToData.getLoopDataWithChild("BANK_CODE");
				BANK_ACNT[i] = xmlToData.getLoopDataWithChild("BANK_ACNT");
				REPY_DATE[i] = xmlToData.getLoopDataWithChild("REPY_DATE");
				REPY_TIME[i] = xmlToData.getLoopDataWithChild("REPY_TIME");
				REPY_PRIC[i] = xmlToData.getLoopDataWithChild("REPY_PRIC");
				REPY_INTR[i] = xmlToData.getLoopDataWithChild("REPY_INTR");
				RMAN_RRIC[i] = xmlToData.getLoopDataWithChild("RMAN_RRIC");
				RECS_NAME[i] = xmlToData.getLoopDataWithChild("RECS_NAME");
				SGIC_BOND[i] = xmlToData.getLoopDataWithChild("SGIC_BOND");
				//REPY_FLAG[i] = xmlToData.getLoopDataWithChild("REPY_FLAG");
				REPY_CODE[i] = xmlToData.getLoopDataWithChild("REPY_CODE");
				BACK_INTR[i] = xmlToData.getLoopDataWithChild("BACK_INTR");
				BACK_ACNT[i] = xmlToData.getLoopDataWithChild("BACK_ACNT");
				YSNO_CODE[i] = xmlToData.getLoopDataWithChild("YSNO_CODE");
				CANS_REAS[i] = xmlToData.getLoopDataWithChild("CANS_REAS");
				xmlToData.closeLoopDataWithChild("RPY_pepay_max");
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

			//System.out.println("SELL_CORP=" + SELL_CORP);
			System.out.println("SELL_CNID=" + SELL_CNID);
			System.out.println("CMPN_ID  =" + CMPN_ID  );
			//System.out.println("CORP_NUMB=" + CORP_NUMB);
			System.out.println("FIRM_NAME=" + FIRM_NAME); 

			for(int i = 0 ; i < TAXS_NUMB.length ; i++){
				//System.out.println("TRAD_NUMB[" + i + "]" +  TRAD_NUMB[i]);
				System.out.println("TAXS_NUMB[" + i + "]" +  TAXS_NUMB[i]);
				System.out.println("BANK_CODE[" + i + "]" +  BANK_CODE[i]);
				System.out.println("BANK_ACNT[" + i + "]" +  BANK_ACNT[i]);
				System.out.println("REPY_DATE[" + i + "]" +  REPY_DATE[i]);
				System.out.println("REPY_TIME[" + i + "]" +  REPY_TIME[i]);
				System.out.println("REPY_PRIC[" + i + "]" +  REPY_PRIC[i]);
				System.out.println("REPY_INTR[" + i + "]" +  REPY_INTR[i]);
				System.out.println("RMAN_RRIC[" + i + "]" +  RMAN_RRIC[i]);
				System.out.println("RECS_NAME[" + i + "]" +  RECS_NAME[i]);
				System.out.println("SGIC_BOND[" + i + "]" +  SGIC_BOND[i]);
				//System.out.println("REPY_FLAG[" + i + "]" +  REPY_FLAG[i]);
				System.out.println("REPY_CODE[" + i + "]" +  REPY_CODE[i]);
				System.out.println("BACK_INTR[" + i + "]" +  BACK_INTR[i]);
				System.out.println("BACK_ACNT[" + i + "]" +  BACK_ACNT[i]);
				System.out.println("YSNO_CODE[" + i + "]" +  YSNO_CODE[i]);
				System.out.println("CANS_REAS[" + i + "]" +  CANS_REAS[i]);
			}

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
