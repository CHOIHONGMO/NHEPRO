import kica.sgic.util.DataToXml;
import kica.sgic.util.XmlToData;
import signgate.sgic.xmlmanager.util.FileWriteUtil;
import signgate.sgic.xml.util.XmlUtil;

public class TestBONCAL {

	public static void main(String[] args) throws Exception{
		String templatePath = "d:/KICA_SGIxLinker/templates/";
		String docCode = "BONCAL";
		
		//String xmlDoc = composeXML(templatePath, docCode);
		
		String xmlDoc = XmlUtil.readStringFileName("D:/KICA_SGIxLinker/samples/document/testBONCAL.xml");
		System.out.println( xmlDoc );

		System.out.println( "----------------------------------------------------------------------------" );

		if(xmlDoc!=null)
			parseXML(templatePath, docCode, xmlDoc);
	}
	public static String composeXML(String templatePath, String docCode)
	{	
		return "로직 아직 추가해야 함";			
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
			/*String mess_send_idnt = xmlToData.getData("mess_send_idnt");
			String mess_recv_idnt = xmlToData.getData("mess_recv_idnt");
			String mess_func_code = xmlToData.getData("mess_func_code");
			String mess_type_idnt = xmlToData.getData("mess_type_idnt");
			String mess_name_desc = xmlToData.getData("mess_name_desc");
			String mess_vers_text = xmlToData.getData("mess_vers_text");
			String docu_numb_text = xmlToData.getData("docu_numb_text");
			String docu_mang_text = xmlToData.getData("docu_mang_text");
			String docu_refn_numb = xmlToData.getData("docu_refn_numb");
			String docu_titl_text = xmlToData.getData("docu_titl_text");
			String send_orgn_name = xmlToData.getData("send_orgn_name");
			String send_orgn_idnt = xmlToData.getData("send_orgn_idnt");
			String recv_orgn_name = xmlToData.getData("recv_orgn_name");
			String recv_orgn_idnt = xmlToData.getData("recv_orgn_idnt");*/
			String cont_numb_text = xmlToData.getData("cont_numb_text");
			String appl_bran_code = xmlToData.getData("appl_bran_code");
			String appl_kind_code = xmlToData.getData("appl_kind_code");
			String appl_serl_code = xmlToData.getData("appl_serl_code");
			String bond_penl_code = xmlToData.getData("bond_penl_code");
			String bond_penl_amnt = xmlToData.getData("bond_penl_amnt");
			String bond_penl_text = xmlToData.getData("bond_penl_text");
			String appl_ends_code = xmlToData.getData("appl_ends_code");

			/*System.out.println("mess_send_idnt: " + mess_send_idnt);
			System.out.println("mess_recv_idnt: " + mess_recv_idnt);
			System.out.println("mess_func_code: " + mess_func_code);
			System.out.println("mess_type_idnt: " + mess_type_idnt);
			System.out.println("mess_name_desc: " + mess_name_desc);
			System.out.println("mess_vers_text: " + mess_vers_text);
			System.out.println("docu_numb_text: " + docu_numb_text);
			System.out.println("docu_mang_text: " + docu_mang_text);
			System.out.println("docu_refn_numb: " + docu_refn_numb);
			System.out.println("docu_titl_text: " + docu_titl_text);
			System.out.println("send_orgn_name: " + send_orgn_name);
			System.out.println("send_orgn_idnt: " + send_orgn_idnt);
			System.out.println("recv_orgn_name: " + recv_orgn_name);
			System.out.println("recv_orgn_idnt: " + recv_orgn_idnt);*/
			System.out.println("cont_numb_text: " + cont_numb_text);
			System.out.println("appl_bran_code: " + appl_bran_code);
			System.out.println("appl_kind_code: " + appl_kind_code);
			System.out.println("appl_serl_code: " + appl_serl_code);
			System.out.println("bond_penl_code: " + bond_penl_code);
			System.out.println("bond_penl_amnt: " + bond_penl_amnt);
			System.out.println("bond_penl_text: " + bond_penl_text);
			System.out.println("appl_ends_code: " + appl_ends_code);
		}catch(Exception _e){
			System.out.println(_e.toString());
		}		
	}
}
