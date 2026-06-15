
import kica.sgic.util.SGIxLinker;

public class SendTest {

	public static void main(String[] args){
		
		try{
			String templatePath = "D:/tomcat7/webapps/ROOT/linker/templates/";
			String docCode = "CONINF";
			
			String xmlDoc = TestCONINF.composeXML(templatePath, docCode);
			System.out.println("1. 생성된 전문");
			System.out.println("--------------------------------------------------------------------");
			System.out.println(xmlDoc);
			
			SGIxLinker xLinker = new SGIxLinker("D:/tomcat7/webapps/ROOT/linker/conf/sendinfo.properties", "LocalTest", false);
			boolean isOK = xLinker.doSendProcess(xmlDoc, null);		
			if(isOK){
				System.out.println("2. 수신된 전문");
				System.out.println("--------------------------------------------------------------------");
				System.out.println(xLinker.getRecvXmlData());
			}else{
				System.out.println("오류 발생");
				System.out.println("--------------------------------------------------------------------");
				System.out.println(xLinker.getErrorCode() + ":" + xLinker.getErrorMsg());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
}
