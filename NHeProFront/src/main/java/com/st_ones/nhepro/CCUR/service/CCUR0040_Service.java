package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.exception.NoResultException;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0040_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;


@Service(value = "CCUR0040_Service")
public class CCUR0040_Service extends BaseService {

	@Autowired
	CCUR0040_Mapper ccur0040_mapper;

	@Autowired
	private MessageService msg;

	@Autowired
	private DocNumService docNumService;

	public List<Map<String, Object>> ccur0040_doSearchEvalItemMgt(Map<String, String> param) throws Exception {
		return ccur0040_mapper.ccur0040_doSearchEvalItemMgt(param);
	}

	public List<Map<String, Object>> ccur0040_doSearchEvalItemMgtDetail(Map<String, String> param) throws Exception {
		return ccur0040_mapper.ccur0040_doSearchEvalItemMgtDetail(param);
	}

	public List<Map<String, Object>> ccur0040_doSearchEvalItemMgtDetail2(Map<String, String> param) throws Exception {
		return ccur0040_mapper.ccur0040_doSearchEvalItemMgtDetail2(param);
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String[] ccur0040_doSaveEvalItemMgt(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		String[] arr = new String[2];

		if (EverString.isEmpty(formData.get("EV_ITEM_NUM").toString())) {

			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			String docNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "EVI");
			formData.put("EV_ITEM_NUM", docNo);

			ccur0040_mapper.ccur0040_doInsertEvalItemMgtMaster(formData);

			if (gridDatas.size() > 0) {
				for (Map<String, Object> gridData : gridDatas) {
					gridData.put("EV_ITEM_NUM", docNo);
					ccur0040_mapper.ccur0040_doInsertEvalItemMgtDetail(gridData);
				}
			}
		} else {

			ccur0040_mapper.ccur0040_doUpdateEvalItemMgtMaster(formData);

			for (Map<String, Object> gridData : gridDatas) {
				gridData.put("EV_ITEM_NUM", formData.get("EV_ITEM_NUM").toString());
				if ("I".equals(gridData.get("INSERT_FLAG".toString()))) {
					ccur0040_mapper.ccur0040_doInsertEvalItemMgtDetail(gridData);
				}
				else if ("U".equals(gridData.get("INSERT_FLAG".toString()))) {
					ccur0040_mapper.ccur0040_doUpdateEvalItemMgtDetail(gridData);
				}
			}
		}

		if (!formData.get("SCALE_TYPE_CD_RT").equals("M") && ccur0040_mapper.ccur0040_doCheckEvalItemMgtDetail(formData) == 0)
			throw new NoResultException(msg.getMessageByScreenId("CCUR0040", "EXIST_DETAIL"));

		arr[0] = formData.get("EV_ITEM_NUM").toString();
		arr[1] = msg.getMessage("0001");
		return arr;
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String ccur0040_doDeleteEvalItemMgt(Map<String, String> formData, List<Map<String, Object>> gridDatas) throws Exception {

		for (Map<String, Object> gridData : gridDatas) {
			gridData.put("EV_ITEM_NUM", formData.get("EV_ITEM_NUM").toString());
			ccur0040_mapper.ccur0040_doDeleteEvalItemMgtDetail(gridData);
		}
		return msg.getMessage("0017");
	}

	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String ccur0040_doDeleteEvalItemMgt(List<Map<String, Object>> gridData) throws Exception {
		/*
		int chk = evalItemMgtMapper.doCheckInTemplateItemWeight(params);

		if (chk == 0) {
			evalItemMgtMapper.doDeleteEvalItemMgtAllDetail(params);
			evalItemMgtMapper.doDeleteEvalItemMgtMaster(grid);
		}
		*/

		for(Map<String, Object> grid : gridData) {
			ccur0040_mapper.ccur0040_doDeleteEvalItemMgtAllDetail(grid);
			ccur0040_mapper.ccur0040_doDeleteEvalItemMgtMaster(grid);
		}

		return msg.getMessage("0017");
	}

}