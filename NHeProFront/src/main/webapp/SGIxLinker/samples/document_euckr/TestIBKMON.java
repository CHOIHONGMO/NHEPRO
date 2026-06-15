import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;

public class TestIBKMON {
	
	public static void main(String[] args) throws Exception
	{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "IBKMON";
		
		String xmlDoc = composeXML(templatePath, docCode);
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)		
			parseXML(templatePath, docCode, xmlDoc);
	}

	public static String composeXML(String templatePath, String docCode)
	{
		/* 대출정보(IBKMON) */								
		/* HEADER */										
		String head_mesg_send = "A111111111900";	/*[필수]	 전문송신기관*/
		String head_mesg_recv = "z120811300200";	/*[필수]	 전문수신기관*/
		String head_func_code = "53";				/*[필수]	 문서기능*/
		String head_mesg_type = "IBKMON";			/*[필수]	 문서코드*/
		String head_mesg_name = "대출정보";			/*[필수]	 문서명*/
		String head_mesg_vers = "1.0";				/*[선택]	 문서버전*/
		String head_mang_numb = "13.20060227151000.12345.0043338' '2";		/*[필수]	 문서관리번호*/
		String head_titl_name = "대출정보";			/*[필수]	 문서개요*/
		String head_orga_code = "ABC";				/*[필수]	 연계회사구분코드 엔투비:NTB, 로지텍:SLT, 한솔제지:HAN*/
		String head_serl_numb = "0043338 2";		/*[선택]	 일련번호*/
		String head_erro_code = "SA";				/*[선택]	 에러코드(ER:에러발생, SA:정상수용)*/
		String head_resp_text = "정상";				/*[선택]	 응답메세지*/
		String head_bank_text = "은행사용란";		/*[선택]	 은행사용란*/

		/* 대출정보*/
		String TRAD_NUMB = "22223"; /*[선택] 매매계약번호                                                */
		String SELL_CORP = "2222222229"; /*[필수] 판매자법인번호(market place)                                */
		String SELL_CNID = "2222222221"; /*[필수] 판매자사업자번호(market place)                              */
		String CMPN_ID   = "2222222223"; /*[필수] 구매자 사업자번호                                           */
		String CORP_NUMB = "2222222224"; /*[선택] 구매사 법인 번호                                            */
		String FIRM_NAME = "구매 회사"; /*[선택] 구매사 회사 이름                                            */
		String TAXS_NUMB = "343345"; /*[필수] 세금계산서번호                                              */
		String BANK_CODE = "B"; /*[필수] 은행코드                                                    */
		String BANK_ACNT = "34"; /*[필수] 계좌번호(건별대출실행계좌)                               */
		String REPY_DATE = "20070503"; /*[필수] 송금일자(YYYYMMDD)                                          */
		String REPY_TIME = "141214"; /*[필수] 송금시각(HH24MISS)                                          */
		String REPY_PRIC = "1000"; /*[필수] 송금액                                                      */
		String SEND_PRIC = "2000";
		String LOAN_INST = "2.33"; /*[선택] 대출이자율(소수점 5자리까지 허용)                           */
		String FNSH_DATE = "20090503"; /*[선택] 대출만기일자                                                */
		String LOAN_FLAG = "T"; /*[선택] 대출종류(T, R) : 세금계산서에 있는 세금계산서 형식 분류 코드*/
		String LOAN_CODE = "Y"; /*[선택] 대출실행여부(Y:실행, N:미실행)                              */
		String UNLN_REAS = "미실행"; /*[선택] 대출미실행사유(미실행시에만 값있음)                         */
		String SGIC_BOND = "5432"; /*[필수] 증권번호                                                    */
		String INST_CODE = "F";    /*[선택] 이자 선취/후취 구분('F':선취, 'S':후취)                     */
		String PURC_NO   = "3234"; /*[선택] 매매정보번호(은행고유의 채번번호)                           */
		String YSNO_CODE = "O"; /*[필수] 대출실행 구분코드(O:정상, C:취소)                           */
		String CANS_REAS = "없음"; /*[선택] 대출실행 취소 사유                                          */

		

				
		// 매핑 정보 파일, XML 탬플릿 정보 파일
		DataToXml dataToXml = new DataToXml(templatePath, docCode);

		if(dataToXml.getErrorCode() != 0)
		{
			System.out.println(dataToXml.getErrorMsg());
			return null;
		}
		
		/* 대출정보(IBKMON) */							
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
				){
				}else{
					System.out.println(dataToXml.getErrorMsg());
				}

				/* Begin of 대출정보 */	
				String data = null;
				for(int i = 0 ; i < 3 ; i++){
					dataToXml.initLoopDataWithChild("MON_bank_max", data);
					/*if(!dataToXml.setLoopDataWithChild("TRAD_NUMB", TRAD_NUMB)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("SELL_CORP", SELL_CORP)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("SELL_CNID", SELL_CNID)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("CMPN_ID", CMPN_ID  )){  
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					/*if(!dataToXml.setLoopDataWithChild("CORP_NUMB", CORP_NUMB)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("FIRM_NAME", FIRM_NAME)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
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
					if(!dataToXml.setLoopDataWithChild("SEND_PRIC", SEND_PRIC)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("LOAN_INST", LOAN_INST)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("FNSH_DATE", FNSH_DATE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					/*if(!dataToXml.setLoopDataWithChild("LOAN_FLAG", LOAN_FLAG)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("LOAN_CODE", LOAN_CODE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("UNLN_REAS", UNLN_REAS)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}*/
					if(!dataToXml.setLoopDataWithChild("SGIC_BOND", SGIC_BOND)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}
					if(!dataToXml.setLoopDataWithChild("INST_CODE", INST_CODE)){
						System.out.println(dataToXml.getErrorMsg());
						break;
					}					
					/*if(!dataToXml.setLoopDataWithChild("PURC_NO", PURC_NO  )){  
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
				/* End of 대출정보 */
			
				xmlDoc = dataToXml.getxmlData();	

				FileWriteUtil.genFileCreate( "D:/KICA_SGIxLinker/samples/document/sampleIBKMON.xml", xmlDoc);			
		}catch(Exception _e){
			System.out.println(_e.toString());
		}
		
		return xmlDoc;
	}


	public static void parseXML(String templatePath, String docCode, String xmlDoc)
	{
		/* 대출정보(IBKMON) */							
		try{		
			XmlToData xmlToData = new XmlToData(templatePath, docCode, xmlDoc);

			if(xmlToData.getErrorCode() != 0)
			{
				System.out.println(xmlToData.getErrorMsg());
				return;
			}			
			
			/* 대출정보(IBKMON) */							
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

			/* 대출정보*/
			int loopsize = xmlToData.getLoopSize("MON_bank_max");
				//String[] TRAD_NUMB = new String[loopsize];
				//String[] SELL_CORP = new String[loopsize];
				String[] SELL_CNID = new String[loopsize];
				String[] CMPN_ID   = new String[loopsize]; 
				//String[] CORP_NUMB = new String[loopsize];
				String[] FIRM_NAME = new String[loopsize];
				String[] TAXS_NUMB = new String[loopsize];
				String[] BANK_CODE = new String[loopsize];
				String[] BANK_ACNT = new String[loopsize];
				String[] REPY_DATE = new String[loopsize];
				String[] REPY_TIME = new String[loopsize];
				String[] REPY_PRIC = new String[loopsize];
				String[] SEND_PRIC = new String[loopsize];
				String[] LOAN_INST = new String[loopsize];
				String[] FNSH_DATE = new String[loopsize];
				//String[] LOAN_FLAG = new String[loopsize];
				//String[] LOAN_CODE = new String[loopsize];
				//String[] UNLN_REAS = new String[loopsize];
				String[] SGIC_BOND = new String[loopsize];
				String[] INST_CODE = new String[loopsize];
				//String[] PURC_NO   = new String[loopsize];
				String[] YSNO_CODE = new String[loopsize];
				String[] CANS_REAS = new String[loopsize];
			for(int i = 0 ; i < loopsize ; i++){
				xmlToData.initLoopDataWithChild("MON_bank_max", i);
				//TRAD_NUMB[i] = xmlToData.getLoopDataWithChild("TRAD_NUMB");
				//SELL_CORP[i] = xmlToData.getLoopDataWithChild("SELL_CORP");
				SELL_CNID[i] = xmlToData.getLoopDataWithChild("SELL_CNID");
				CMPN_ID  [i] = xmlToData.getLoopDataWithChild("CMPN_ID"); 
				//CORP_NUMB[i] = xmlToData.getLoopDataWithChild("CORP_NUMB");
				FIRM_NAME[i] = xmlToData.getLoopDataWithChild("FIRM_NAME");
				TAXS_NUMB[i] = xmlToData.getLoopDataWithChild("TAXS_NUMB");
				BANK_CODE[i] = xmlToData.getLoopDataWithChild("BANK_CODE");
				BANK_ACNT[i] = xmlToData.getLoopDataWithChild("BANK_ACNT");
				REPY_DATE[i] = xmlToData.getLoopDataWithChild("REPY_DATE");
				REPY_TIME[i] = xmlToData.getLoopDataWithChild("REPY_TIME");
				REPY_PRIC[i] = xmlToData.getLoopDataWithChild("REPY_PRIC");
				SEND_PRIC[i] = xmlToData.getLoopDataWithChild("SEND_PRIC");
				LOAN_INST[i] = xmlToData.getLoopDataWithChild("LOAN_INST");
				FNSH_DATE[i] = xmlToData.getLoopDataWithChild("FNSH_DATE");
				//LOAN_FLAG[i] = xmlToData.getLoopDataWithChild("LOAN_FLAG");
				//LOAN_CODE[i] = xmlToData.getLoopDataWithChild("LOAN_CODE");
				//UNLN_REAS[i] = xmlToData.getLoopDataWithChild("UNLN_REAS");
				SGIC_BOND[i] = xmlToData.getLoopDataWithChild("SGIC_BOND");
				INST_CODE[i] = xmlToData.getLoopDataWithChild("INST_CODE");				
				//PURC_NO  [i] = xmlToData.getLoopDataWithChild("PURC_NO");
				YSNO_CODE[i] = xmlToData.getLoopDataWithChild("YSNO_CODE");
				CANS_REAS[i] = xmlToData.getLoopDataWithChild("CANS_REAS");
				xmlToData.closeLoopDataWithChild("MON_bank_max");
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

			for(int i = 0 ; i < SELL_CNID.length ; i++){
				//System.out.println("TRAD_NUMB[" + i + "]" + TRAD_NUMB[i]);
				//System.out.println("SELL_CORP[" + i + "]" + SELL_CORP[i]);
				System.out.println("SELL_CNID[" + i + "]" + SELL_CNID[i]);
				System.out.println("CMPN_ID  [" + i + "]" + CMPN_ID[i]); 
				//System.out.println("CORP_NUMB[" + i + "]" + CORP_NUMB[i]);
				System.out.println("FIRM_NAME[" + i + "]" + FIRM_NAME[i]);
				System.out.println("TAXS_NUMB[" + i + "]" + TAXS_NUMB[i]);
				System.out.println("BANK_CODE[" + i + "]" + BANK_CODE[i]);
				System.out.println("BANK_ACNT[" + i + "]" + BANK_ACNT[i]);
				System.out.println("REPY_DATE[" + i + "]" + REPY_DATE[i]);
				System.out.println("REPY_TIME[" + i + "]" + REPY_TIME[i]);
				System.out.println("REPY_PRIC[" + i + "]" + REPY_PRIC[i]);
				System.out.println("SEND_PRIC[" + i + "]" + SEND_PRIC[i]);
				System.out.println("LOAN_INST[" + i + "]" + LOAN_INST[i]);
				System.out.println("FNSH_DATE[" + i + "]" + FNSH_DATE[i]);
				//System.out.println("LOAN_FLAG[" + i + "]" + LOAN_FLAG[i]);
				//System.out.println("LOAN_CODE[" + i + "]" + LOAN_CODE[i]);
				//System.out.println("UNLN_REAS[" + i + "]" + UNLN_REAS[i]);
				System.out.println("SGIC_BOND[" + i + "]" + SGIC_BOND[i]);
				System.out.println("INST_CODE[" + i + "]" + INST_CODE[i]);
				//System.out.println("PURC_NO  [" + i + "]" + PURC_NO[i]);
				System.out.println("YSNO_CODE[" + i + "]" + YSNO_CODE[i]);
				System.out.println("CANS_REAS[" + i + "]" + CANS_REAS[i]);
			}

		}catch(Exception _e){
			System.out.println(_e.toString());
		}
	}	
}
