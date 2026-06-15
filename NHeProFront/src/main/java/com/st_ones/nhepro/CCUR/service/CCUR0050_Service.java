package com.st_ones.nhepro.CCUR.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.login.domain.UserInfo;
import com.st_ones.common.message.service.MessageService;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.nhepro.CCUR.CCUR0050_Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service(value = "CCUR0050_Service")
public class CCUR0050_Service extends BaseService {

	@Autowired CCUR0050_Mapper ccur0050_mapper;
	
	@Autowired private DocNumService docNumService;
	
	@Autowired
	private MessageService msg;

	public List<Map<String, Object>> ccur0050_doSearchLeftGrid(Map<String, String> param) throws Exception {
		return ccur0050_mapper.ccur0050_doSearchLeftGrid(param);
	}
	
	public List<Map<String, Object>> ccur0050_doSearchRightGrid(Map<String, String> param) throws Exception {
		return ccur0050_mapper.ccur0050_doSearchRightGrid(param);
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String ccur0050_doDelete(List<Map<String, Object>> gridData) throws Exception {
		for(Map<String,Object> grid : gridData) {
			ccur0050_mapper.ccur0050_doDeleteAllSTOCEVTD(grid);
			ccur0050_mapper.ccur0050_doDeleteSTOCEVTM(grid);
		}

		return msg.getMessage("0017");
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String[] ccur0050_doCopy(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();

		// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
		String newEvTplNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "EVT");
		param.put("EV_TPL_NUM", newEvTplNo);
		ccur0050_mapper.ccur0050_doInsertSTOCEVTM(param);
		
		for(Map<String, Object> data : gridDatas){
			data.put("EV_TPL_NUM", newEvTplNo);
			ccur0050_mapper.ccur0050_doInsertSTOCEVTD(data);
		}

		String [] args = new String[2];
		args[0] = newEvTplNo;
		args[1] = msg.getMessage("0001");
		return args;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public String[] ccur0050_doSave(Map<String, String> param, List<Map<String, Object>> gridDatas) throws Exception {

		UserInfo userInfo = UserInfoManager.getUserInfo();
		String [] args = new String[2];
		int existEVTM = ccur0050_mapper.ccur0050_checkExistEVTM(param);
		
		String evTplNo = param.get("EV_TPL_NUM").toString();
		if(existEVTM != 0){
			ccur0050_mapper.ccur0050_doUpdateSTOCEVTM(param);
			for(Map<String, Object> data : gridDatas){
				data.put("EV_TPL_NUM", evTplNo);


				if (data.get("STATUS")== null) {
					data.put("STATUS", "");
				}
				
				if(data.get("STATUS").toString().equals("D")){
					ccur0050_mapper.ccur0050_doDeleteSTOCEVTD(data);
				}else{
					int existEVTD = ccur0050_mapper.ccur0050_checkExistEVTD(data);
					if(existEVTD != 0){
						ccur0050_mapper.ccur0050_doUpdateSTOCEVTD(data);
					}else{
						ccur0050_mapper.ccur0050_doInsertSTOCEVTD(data);
					}
				}				
			}
		} else {

			// 채번로직 변경. Parameter [화면에서 전달 받은 COMPANY_CD (없는 경우, ses.manageCd 또는 ses.companyCd), DOC_TYPE ]
			evTplNo = docNumService.getDocNumber(userInfo.getCompanyCd(), "EVT");
			param.put("EV_TPL_NUM", evTplNo);

			ccur0050_mapper.ccur0050_doInsertSTOCEVTM(param);
			for(Map<String, Object> data : gridDatas){

				if (data.get("STATUS")== null) {
					data.put("STATUS", "");
				}
				
				if(!data.get("STATUS").toString().equals("D")){
					data.put("EV_TPL_NUM", evTplNo);
					ccur0050_mapper.ccur0050_doInsertSTOCEVTD(data);
				}
			}
		}
		args[0] = evTplNo;
		args[1] = msg.getMessage("0001");
		return args;
	}
	
	// SRM_101
	public List<Map<String, Object>> ccur0051_doSearchAppendItem(Map<String, String> param) throws Exception {
		return ccur0050_mapper.ccur0051_doSearchAppendItem(param);
	}
}
