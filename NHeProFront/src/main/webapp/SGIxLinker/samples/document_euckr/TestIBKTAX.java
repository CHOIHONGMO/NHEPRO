import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKTAX {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "F:/KICA_SGIxLinker/templates/";
		String docCode = "IBKTAX";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 세금계산서(IBKTAX) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKTAX";			/*[필수]	 문서코드*/
		String head_mesg_name = "세금계산서";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "세금계산서";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 사업자 정보*/
		String CMPN_ID   = "111111111"; /*[필수] 구매자 사업자번호 */
		String CORP_NUMB = "111111119"; /*[선택] 구매사 법인 번호  */
		String FIRM_NAME = "구매 회사"; /*[선택] 구매사 회사 이름  */
		String TAX_CONT  = "2"; /*[필수] 세금계산서 갯수   */
		String TAX_TYPE  = "X"; /*[필수] 세금계산서 형식   */
		String BANK_CODE = "IB"; /*[선택] 은행코드          */

		/* 세금계산서 정보*/
		String SELL_CORP = "111111119"; /*[선택] 판매자법인번호(market place)            */
		String SELL_CNID = "111111118"; /*[선택] 판매자사업자번호(market place)          */
		String CTRT_FLAG = "1"; /*[선택] 계약주체구분( 판매자 '1' )              */
		String TRAD_NUMB = "12345"; /*[선택] 매매계약번호                            */
		String SALE_DATE = "20070501"; /*[선택] 구매매출일(마지막구매일)(YYYYMMDD)      */
		String TRAN_DATE = "20070601"; /*[필수] 세금계산서 정보 전송일(YYYYMMDD)        */
		String DEAL_DATE = "20070508"; /*[선택] 거래처리일자(정보전송일 + 1일)YYYMMDD   */
		String EXEC_DATE = "20070509"; /*[선택] 일괄실행일(거래처리일자와 같음:YYYYMMDD)*/
		String PURC_AMNT = "1000"; /*[선택] 대금결재금액=세금계산서 총금액          */
		String PURC_DATE = "20070709"; /*[선택] 대금결제일(YYYYMMDD):대출만기일         */
		String TAXS_NUMB = "452332"; /*[필수] 세금계산서번호                          */
		String ITEM_NAME = "테스트상품"; /*[필수] 상품명(여러가지 상품일땐 대표 상품명)   */
		String SUPY_AMNT = "100"; /*[필수] 세금계산서 공급가액                     */
		String TAXS_AMNT = "50"; /*[필수] 세금계산서 공급세액                     */
		String ACNT_AMNT = "1200"; /*[필수] 세금계산서 총금액(대출요청금액)         */
		String ACNT_DATE = "20070501"; /*[필수] 세금계산서 작성일자(YYYYMMDD)           */
		String SGIC_BOND = "23123"; /*[필수] 증권번호                                */
		String PURC_NO   = "543443"; /*[선택] 매매정보번호                            */
		String YSNO_CODE = "O"; /*[필수] 세금계산서 유효구분코드(O:정상, C:취소) */
		String CANS_REAS = "없음"; /*[선택] 세금계산서 취소 사유                    */

		

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 세금계산서(IBKLOA) */								
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
				&& dataToXml.setData("CMPN_ID", CMPN_ID  )/*[필수] 구매자 사업자번호 */  
				//&& dataToXml.setData("CORP_NUMB", CORP_NUMB)/*[선택] 구매사 법인 번호  */
				&& dataToXml.setData("FIRM_NAME", FIRM_NAME)/*[선택] 구매사 회사 이름  */
				//&& dataToXml.setData("TAX_CONT", TAX_CONT )/*[필수] 세금계산서 갯수   */ 
				//&& dataToXml.setData("TAX_TYPE", TAX_TYPE )/*[필수] 세금계산서 형식   */ 
				&& dataToXml.setData("BANK_CODE", BANK_CODE)/*[선택] 은행코드          */
				/* End of 사업자 정보 */				
				){
				}else{
					System.out.println(dataToXml.getErrorMsg());
				}

				/* Begin of 세금계산서정보 */	
				String data = null;
				for(int i = 0 ; i < 1 ; i++){
					dataToXml.initLoopDataWithChild("TAX_account_max", data);
					/*if(!dataToXml.setLoopDataWithChild("SELL_CORP", SELL_CORP)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("SELL_CNID", SELL_CNID)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					/*if(!dataToXml.setLoopDataWithChild("CTRT_FLAG", CTRT_FLAG)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("TRAD_NUMB", TRAD_NUMB)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("SALE_DATE", SALE_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("TRAN_DATE", TRAN_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("DEAL_DATE", DEAL_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("EXEC_DATE", EXEC_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("PURC_AMNT", PURC_AMNT)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("PURC_DATE", PURC_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("TAXS_NUMB", TAXS_NUMB)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("ITEM_NAME", ITEM_NAME)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("SUPY_AMNT", SUPY_AMNT)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("TAXS_AMNT", TAXS_AMNT)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("ACNT_AMNT", ACNT_AMNT)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("ACNT_DATE", ACNT_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("SGIC_BOND", SGIC_BOND)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					/*if(!dataToXml.setLoopDataWithChild("PURC_NO", PURC_NO    )){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
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
				/* End of 세금계산서정보 */
			
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "F:/KICA_SGIxLinker/samples/document/sampleIBKTAX.xml", xmlDoc);			
		}catch(Exception _e){
			System.out.println(_e.toString());
		}
		
		return xmlDoc;
	}


	public static void parseXML(String templatePath, String docCode, String xmlDoc)
	{
		/* 세금계산서(IBKTAX) */							
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 세금계산서(IBKTAX) */								
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
			String CMPN_ID   = xmlToData.getData("CMPN_ID");  
			//String CORP_NUMB = xmlToData.getData("CORP_NUMB");
			String FIRM_NAME = xmlToData.getData("FIRM_NAME");
			//String TAX_CONT  = xmlToData.getData("TAX_CONT"); 
			//String TAX_TYPE  = xmlToData.getData("TAX_TYPE"); 
			String BANK_CODE = xmlToData.getData("BANK_CODE");


			/* 세금계산서정보*/
			int loopsize = xmlToData.getLoopSize("TAX_account_max");
				String[] SELL_CORP = new String[loopsize];
				String[] SELL_CNID = new String[loopsize];
				String[] CTRT_FLAG = new String[loopsize];
				String[] TRAD_NUMB = new String[loopsize];
				String[] SALE_DATE = new String[loopsize];
				String[] TRAN_DATE = new String[loopsize];
				String[] DEAL_DATE = new String[loopsize];
				String[] EXEC_DATE = new String[loopsize];
				String[] PURC_AMNT = new String[loopsize];
				String[] PURC_DATE = new String[loopsize];
				String[] TAXS_NUMB = new String[loopsize];
				String[] ITEM_NAME = new String[loopsize];
				String[] SUPY_AMNT = new String[loopsize];
				String[] TAXS_AMNT = new String[loopsize];
				String[] ACNT_AMNT = new String[loopsize];
				String[] ACNT_DATE = new String[loopsize];
				String[] SGIC_BOND = new String[loopsize];
				String[] PURC_NO   = new String[loopsize];
				String[] YSNO_CODE = new String[loopsize];
				String[] CANS_REAS = new String[loopsize];
			for(int i = 0 ; i < loopsize ; i++){
				xmlToData.initLoopDataWithChild("TAX_account_max", i);
				//SELL_CORP[i] = xmlToData.getLoopDataWithChild("SELL_CORP");
				SELL_CNID[i] = xmlToData.getLoopDataWithChild("SELL_CNID");
				//CTRT_FLAG[i] = xmlToData.getLoopDataWithChild("CTRT_FLAG");
				//TRAD_NUMB[i] = xmlToData.getLoopDataWithChild("TRAD_NUMB");
				SALE_DATE[i] = xmlToData.getLoopDataWithChild("SALE_DATE");
				TRAN_DATE[i] = xmlToData.getLoopDataWithChild("TRAN_DATE");
				DEAL_DATE[i] = xmlToData.getLoopDataWithChild("DEAL_DATE");
				EXEC_DATE[i] = xmlToData.getLoopDataWithChild("EXEC_DATE");
				PURC_AMNT[i] = xmlToData.getLoopDataWithChild("PURC_AMNT");
				PURC_DATE[i] = xmlToData.getLoopDataWithChild("PURC_DATE");
				TAXS_NUMB[i] = xmlToData.getLoopDataWithChild("TAXS_NUMB");
				ITEM_NAME[i] = xmlToData.getLoopDataWithChild("ITEM_NAME");
				SUPY_AMNT[i] = xmlToData.getLoopDataWithChild("SUPY_AMNT");
				TAXS_AMNT[i] = xmlToData.getLoopDataWithChild("TAXS_AMNT");
				ACNT_AMNT[i] = xmlToData.getLoopDataWithChild("ACNT_AMNT");
				ACNT_DATE[i] = xmlToData.getLoopDataWithChild("ACNT_DATE");
				SGIC_BOND[i] = xmlToData.getLoopDataWithChild("SGIC_BOND");
				//PURC_NO  [i] = xmlToData.getLoopDataWithChild("PURC_NO");
				YSNO_CODE[i] = xmlToData.getLoopDataWithChild("YSNO_CODE");
				CANS_REAS[i] = xmlToData.getLoopDataWithChild("CANS_REAS");
				xmlToData.closeLoopDataWithChild("TAX_account_max");
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

			System.out.println("CMPN_ID  =" + CMPN_ID  );
			//System.out.println("CORP_NUMB=" + CORP_NUMB);
			System.out.println("FIRM_NAME=" + FIRM_NAME);
			//System.out.println("TAX_CONT =" + TAX_CONT );
			//System.out.println("TAX_TYPE =" + TAX_TYPE );
			System.out.println("BANK_CODE=" + BANK_CODE);

			for(int i = 0 ; i < TRAN_DATE.length ; i++){
				//System.out.println("SELL_CORP[" + i + "]" + SELL_CORP[i]);
				System.out.println("SELL_CNID[" + i + "]" + SELL_CNID[i]);
				//System.out.println("CTRT_FLAG[" + i + "]" + CTRT_FLAG[i]);
				//System.out.println("TRAD_NUMB[" + i + "]" + TRAD_NUMB[i]);
				System.out.println("SALE_DATE[" + i + "]" + SALE_DATE[i]);
				System.out.println("TRAN_DATE[" + i + "]" + TRAN_DATE[i]);
				System.out.println("DEAL_DATE[" + i + "]" + DEAL_DATE[i]);
				System.out.println("EXEC_DATE[" + i + "]" + EXEC_DATE[i]);
				System.out.println("PURC_AMNT[" + i + "]" + PURC_AMNT[i]);
				System.out.println("PURC_DATE[" + i + "]" + PURC_DATE[i]);
				System.out.println("TAXS_NUMB[" + i + "]" + TAXS_NUMB[i]);
				System.out.println("ITEM_NAME[" + i + "]" + ITEM_NAME[i]);
				System.out.println("SUPY_AMNT[" + i + "]" + SUPY_AMNT[i]);
				System.out.println("TAXS_AMNT[" + i + "]" + TAXS_AMNT[i]);
				System.out.println("ACNT_AMNT[" + i + "]" + ACNT_AMNT[i]);
				System.out.println("ACNT_DATE[" + i + "]" + ACNT_DATE[i]);
				System.out.println("SGIC_BOND[" + i + "]" + SGIC_BOND[i]);
				//System.out.println("PURC_NO  [" + i + "]" + PURC_NO[i]);
				System.out.println("YSNO_CODE[" + i + "]" + YSNO_CODE[i]);
				System.out.println("CANS_REAS[" + i + "]" + CANS_REAS[i]);
			}

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
