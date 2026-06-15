package com.st_ones.common.generator.service;

import com.st_ones.common.cache.data.ColumnInfoCache;
import com.st_ones.common.combo.service.CommonComboService;
import com.st_ones.common.generator.GridGenMapper;
import com.st_ones.common.generator.domain.GridMeta;
import com.st_ones.common.interceptor.service.ScreenInterceptorService;
import com.st_ones.common.popup.service.CommonPopupService;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.util.StringUtil;
import com.st_ones.everf.serverside.web.BaseController;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : GridGenService.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Service(value="gridGenService")
@Scope("prototype")
public class GridGenService extends BaseController {

	@Autowired private CommonPopupService commonPopupService;
	@Autowired private CommonComboService commonComboService;
	@Autowired private ColumnInfoCache columnInfoCache;
	@Autowired private GridGenMapper gridGenMapper;

	private String screenID;
	private String gridID;
	private String langCode;
	private String numberFormat;
	private String dateFormat;
	private List<GridMeta> columnInfos = new ArrayList<GridMeta>();
	private Map<String, Object> maskInfo;

	public void init(String _screenID, String _gridID, String _langCode, String dateFormat, String numberFormat, Map<String, Object> maskInfo) throws Exception {

		this.screenID = _screenID;
		this.gridID = _gridID;
		this.langCode = _langCode;
		this.numberFormat = numberFormat;
		this.dateFormat = dateFormat;
		this.maskInfo = maskInfo;

		setGridMetas();
	}

	@Autowired
	CacheManager cacheManager;

	private void setGridMetas() throws Exception {

		if(screenID.equals("commonPopup")) {
			columnInfos = commonPopupService.getGridHeader(gridID);
		} else {
//			Cache gridCache = cacheManager.getCache("gridCache");
//			net.sf.ehcache.Cache nativeCache = (net.sf.ehcache.Cache)gridCache.getNativeCache();
//			List keys = nativeCache.getKeys();
//			Iterator iterator = keys.iterator();
//			while(iterator.hasNext()) {
//				Element element = nativeCache.get(iterator.next());
//			}
//			nativeCache.removeAll();

			columnInfos = columnInfoCache.getData(screenID, gridID, langCode);
		}

		for (GridMeta columnInfo : columnInfos) {
			if ("combo".equals(columnInfo.getColumnType())) {

//				if(Integer.parseInt(columnInfo.getWidth()) > 0) {
//					columnInfo.setWidth(String.valueOf(Integer.parseInt(columnInfo.getWidth()) + 17));
//				}

				if (EverString.isNotEmpty(columnInfo.getCommonId())) {

					List<Map<String,String>> list = commonComboService.getCodeCombo(columnInfo.getCommonId());
					if (list.size()==0) {
						list = new ArrayList<Map<String,String>>();
						Map<String,String> map = new LinkedHashMap<String,String>();
						map.put("value", "mm");
						map.put("text", "공통코드 잘못넣으셨네.");
						list.add(map);
						columnInfo.setCombos(list);
					} else {
						// 그리드 콤보 Text 마스킹 적용
						String maskType = columnInfo.getMaskType();
						if (StringUtils.isNotEmpty(maskType)) {

							// 마스킹 해제 승인이 나오면 마스킹을 하지 않는다.
							if(maskInfo != null && "E".equals(maskInfo.get("MASK_APPROVAL"))) {
								maskType = null;
							}

							// 마스킹 적용 : 이름, 전체, 이메일만 적용(N, A, E)
							for(Map<String, String> selectInfo : list) {
								selectInfo.put("text", EverString.setEncryptedString(selectInfo.get("text"), maskType));
							}
						}

						columnInfo.setCombos(list);
					}

				} else {
					List<Map<String,String>> list = new ArrayList<Map<String,String>>();
					Map<String,String> map = new LinkedHashMap<String,String>();
					map.put("value", "mm");
					map.put("text", "콤보공통코드 안넣었네.");
					list.add(map);
					columnInfo.setCombos(list);
				}
			}
		}
	}

	public String getEssential() {
		String essential = "";

		for (GridMeta columnInfo : columnInfos) {
			if (EverString.defaultIfEmpty(columnInfo.getEssential(), "").equals("E")) {
				essential = essential + "," + columnInfo.getColumnId();
			}

			String dataType = columnInfo.getDataType();
			String dataFormat = getDataFormat(dataType);
			columnInfo.setDataFormat(dataFormat);
		}

		essential = essential.replaceFirst(",", "");
		return essential;
	}

	private String getDataFormat(String dataType) {
		if(dataType == null){return "";}
/*		String naturalNumberFormat = numberFormat.substring(0, 7);
		String tenthsFormat = numberFormat.substring(0, 9);
		String hundredthsFormat = numberFormat.substring(0, 10);
		String thousandthsFormat = hundredthsFormat + '0';

		if (dataType.equals("MAX")) { return "2"; } // Max Length
		if (dataType.equals("NUM")) { return "0"; } // Number
		if (dataType.equals("SEQ")) { return "0"; }// Seq
		if (dataType.equals("CNT")) { return "0"; } // Count
		if (dataType.equals("AMT")) { return hundredthsFormat; } // Amount
		if (dataType.equals("PER")) { return hundredthsFormat; } // Percent
		if (dataType.equals("QTY")) { return hundredthsFormat; } // Qty
		if (dataType.equals("RAT")) { return hundredthsFormat; } // Rate
		if (dataType.equals("SCO")) { return hundredthsFormat; } // Score
		if (dataType.equals("PRI")) { return thousandthsFormat; } // Price
		if (dataType.equals("DATE")) { return dateFormat; } // Date
		return "";
*/
		if( dataType.equals("NUM")
				|| dataType.equals("SEQ")
				|| dataType.equals("CNT") ) {
			return "0";
		} else if (dataType.equals("MAX")
				|| dataType.equals("AMT")) {
			return "0";
		} else if (dataType.equals("DEC1")) {
			return "1";
		} else if (dataType.equals("DEC2")) {
			return "2";
		} else if (dataType.equals("DEC3")) {
			return "3";
		} else if (dataType.equals("DEC4")) {
			return "4";
		} else if (dataType.equals("DEC5")) {
			return "5";
		} else if (dataType.equals("PER")) {
			return "2";
		} else if (dataType.equals("QTY")) {
			return "3";
		} else if (dataType.equals("RAT")) {
			return "2";
		} else if (dataType.equals("SCO")) {
			return "1";
		} else if (dataType.equals("PRI")) {
			return "3";
		} else { return "";	}
	}
	public List<GridMeta> getColumnInfos() {
		return columnInfos;
	}

    public List<Map<String, Object>> getBtnImageInfos(String screenId) {
	    return gridGenMapper.getBtnImageInfos(screenId);
    }
}
