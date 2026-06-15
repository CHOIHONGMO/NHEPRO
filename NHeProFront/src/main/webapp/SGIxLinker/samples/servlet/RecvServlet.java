

import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;

import kica.sgic.util.DataToXml;
import kica.sgic.util.SGIxLinker;

public class RecvServlet extends HttpServlet
{
	private String configpath = "";
	
	public void init(ServletConfig config) throws ServletException 
	{
		super.init(config);
		this.configpath = config.getInitParameter("KICA.SGIxLinker.CONF");
	}
		
	public synchronized void service(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException 
	{

		SGIxLinker xLinker =  new SGIxLinker(this.configpath, this.getServletName(), false);
	
		try
		{    		
			boolean isOK = xLinker.doRecvProcess(req, res);
					
			if(!isOK) {
				super.getServletContext().log("isOK is false");
				throw new Exception("정보인증 정보수신 API 오류입니다 : [" + xLinker.getErrorCode() + "] : " + xLinker.getErrorMsg());
			}

			String recvDocCode = xLinker.getRecvDocCode();
			String recvXmlDoc =  xLinker.getRecvXmlData();

			String responseXml="";
			
			/*
			 * 일반적인 Ack성 Response를 보낼때의 샘플 코드임
			 */
			if( (recvDocCode!=null)&&(!recvDocCode.equals(""))&&
					(recvXmlDoc!=null)&&(!recvXmlDoc.equals("")))
			{
				responseXml = xLinker.responseAck("SA", "업체정보 수신업무가 정상적으로 수행되었습니다.", "1234567890");
			}else{
				responseXml = xLinker.responseAck("SR", "실행중 오류가 발생하였습니다.(원인:***)", "1234567890");				
			}

			/*
			 * Ack성 Response가 아닌 경우의 샘플 코드임
			 * 응답서의 DOC_CODE는 직접 넣어주세요.
			 */
			/*
			DataToXml dataToXml = new DataToXml(xLinker.getTemplatePath(), "DOC_CDOE");
			if( (recvDocCode!=null)&&(!recvDocCode.equals(""))&&
					(recvXmlDoc!=null)&&(!recvXmlDoc.equals("")))
			{
				dataToXml.setData("abdbd", "182797349");
				dataToXml.setData("sdgfsf", "가나다라");
				dataToXml.setData("ksdj", "absvdbd");
			}else{
				dataToXml.setData("abdbd", "182797349");
				dataToXml.setData("sdgfsf", "error");
				dataToXml.setData("ksdj", "cause");
			}
			responseXml = dataToXml.getxmlData();
			*/
			
		    /*if(xLinker.sendResponse(res, responseXml))
		    	System.out.println(this.getServletName() + " service finished SUCCESSFULLY!!!");
		    else
		    	System.out.println(this.getServletName() + " service FAILED!!!!");
				*/
			
			ServletOutputStream output = null;
			try {
				output = res.getOutputStream();
				output.write(responseXml.getBytes()) ;
				output.flush() ; 
				if (output != null) output.close();
			} catch (IOException e) {
				System.out.println(this.getServletName() + " service FAILED!!!!");
				e.printStackTrace();
				throw new Exception("응답서 전송중 오류가 발생하였습니다.:"+e.toString());
			}
		    System.out.println(this.getServletName() + " service finished SUCCESSFULLY!!!");

		}catch(Exception e)	{
			e.printStackTrace();
	    }finally {
	    	
		} 	
    }

    public void destroy() {
        super.destroy() ;
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res)
                                              throws ServletException, IOException {
        service(req, res) ;
    }

    public void doPost(HttpServletRequest req, HttpServletResponse res)
                                               throws ServletException, IOException {
        service(req, res) ;
    }
}
