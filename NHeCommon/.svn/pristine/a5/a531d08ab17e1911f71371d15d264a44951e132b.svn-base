package com.st_ones.common.serverpush.reverseajax;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.directwebremoting.Browser;
import org.directwebremoting.ScriptSessions;
import org.directwebremoting.annotations.RemoteProxy;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Map;

//import com.st_ones.eversrm.solicit.rAuction.rAuctionMgt.SSOR_Mapper; 

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : ReverseAuction.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service
@RemoteProxy
public class ReverseAuction {

	public void clientCall() throws IOException {
//		setData(null, null);
	}

	@SuppressWarnings("rawtypes")
	public void pushData(Map auctionData) throws IOException {

		final String auctionDataString = new ObjectMapper().writeValueAsString(auctionData);
		Browser.withAllSessions(new Runnable() {
			public void run() {
				ScriptSessions.addFunctionCall("serverPushCallback", auctionDataString);
			}
		});
	}
}
