package com.st_ones.common.util.web;

import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.EverDateMapper;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.service.EverDateService;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : EverDateController.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@RequestMapping(value = "/common/util/web/everDateController")
public class EverDateController extends BaseController {

	@Autowired private EverDateService everDateService;

	@Autowired private MessageService messageService;

	@Autowired private EverDateMapper everDateMapper;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "/diffWithServerDate")
	public void diffWithServerDate(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		
		String requestDate = req.getParameter("requestDate");
		boolean isGrid = Boolean.valueOf(req.getParameter("isGrid"));

		Date currentTimeWithUserGmt = getCurrentTimeWithUserGmt();
		int compareResult = everDateService.diffWithServerDate(requestDate, currentTimeWithUserGmt, isGrid);
		resp.setParameter("diff", String.valueOf(compareResult));
		resp.setResponseMessage(getCompareMessage(compareResult));
	}

	@RequestMapping(value = "/getServerDateTime")
	public void getServerDateTime(EverHttpRequest req, EverHttpResponse resp) throws Exception {
		resp.setParameter("SERVER_DATE_YEAR", EverDate.getYear());
		resp.setParameter("SERVER_DATE_MONTH", EverDate.getMonth());
		resp.setParameter("SERVER_DATE_DAY", EverDate.getDay());
		resp.setParameter("SERVER_DATE_TIME", EverDate.getTime());
		resp.setResponseMessage("");
	}

	@RequestMapping(value = "/diffWithServerTime")
	public void diffWithServerTime(@RequestParam("requestDate")String requestDate,
				@RequestParam("hour")Integer hour,
				@RequestParam("minutes")Integer minutes,
				@RequestParam("sec")Integer sec,
				EverHttpRequest req, EverHttpResponse resp) throws Exception {

		int compareResult = -1;

		if(req != null) {

			boolean isGrid = Boolean.valueOf(req.getParameter("isGrid"));
			Date currentTimeWithUserGmt = getCurrentTimeWithUserGmt();

			if (requestDate != null && hour != null && minutes != null && sec != null) {
				compareResult = everDateService.diffWithServerDate(requestDate, currentTimeWithUserGmt, isGrid);
				if (compareResult == 0) {
					String timeString = String.format("%02d%02d%02d", hour, minutes, sec);
					compareResult = everDateService.diffWithServerTime(timeString, currentTimeWithUserGmt);
				}
			}
		}
		resp.setParameter("diff", String.valueOf(compareResult));
		resp.setResponseMessage(getCompareMessage(compareResult));
	}
	
	private String getCompareMessage(int compareResult) throws Exception {
		if (compareResult > 0) {
			return messageService.getMessageForService(everDateService, "LATER");
		} else if (compareResult < 0) {
			return messageService.getMessageForService(everDateService, "EARLIER");
		}
		return messageService.getMessageForService(everDateService, "SAME");
	}
	
	private Date getDateWithGap(Date date, int gap){
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.HOUR, gap);
		return calendar.getTime();
	}
	
	private int getSystemTimeGap() {
		BaseInfo userInfo = UserInfoManager.getUserInfo();
		int systemGmt = Integer.valueOf(userInfo.getSystemGmt().replace("GMT+", "").replace(":", ""));
		int userGmt = Integer.valueOf(userInfo.getUserGmt().replace("GMT+", "").replace(":", ""));
		return  userGmt - systemGmt;
	}
	
	private Date getCurrentTimeWithUserGmt() {
		Date currentServerTime = everDateMapper.getCurrentServerTime();
		Date currentTimeWithUserGmt = getDateWithGap(currentServerTime, getSystemTimeGap());
		logger.info(String.format("currentServerTime: %s, currentTimeWithUserGmt: %s", currentServerTime, currentTimeWithUserGmt));
		return currentTimeWithUserGmt;
	}
}
