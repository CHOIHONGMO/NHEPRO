package com.st_ones.common.generator.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.st_ones.common.cache.data.ScrnCache;
import com.st_ones.common.generator.domain.GridMeta;
import com.st_ones.common.generator.service.GridGenService;
import com.st_ones.common.interceptor.service.ScreenInterceptorService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.common.util.excel.down.ExcelExportHandler;
import com.st_ones.common.util.excel.upload.ExcelImportHandler;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.info.BaseInfo;
import com.st_ones.everf.serverside.info.UserInfoManager;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

/**
 * <pre>
 ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2013 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 ******************************************************************************
 * </pre>
 * @File Name : GeneratorController.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
@Controller
@Scope("prototype")
@RequestMapping(value = "/grid/generator")
public class GeneratorController {

	private Logger logger = LoggerFactory.getLogger(GeneratorController.class);

	@Autowired private GridGenService gridGenService;

	@Autowired private ScreenInterceptorService screenInterceptorService;

	@RequestMapping(value = "/ExcelDown.so")
	public void excelDown(HttpServletRequest req, HttpServletResponse res) throws IOException {

		String fileType = EverString.nullToEmptyString(req.getParameter("fileType"));
		String fileName = EverString.nullToEmptyString(req.getParameter("fileName"));
		String rowsStr = EverString.nullToEmptyString(req.getParameter("rows"));
		String urlStr = EverString.nullToEmptyString(req.getParameter("url"));
		String excelOptions = EverString.nullToEmptyString(req.getParameter("excelOptions"));
		String groupColDef = EverString.nullToEmptyString(req.getParameter("groupColDef"));
		String frozenColIndex = EverString.nullToEmptyString(req.getParameter("frozenColIndex"));

		res.setContentType( fileType );
		fileName = fileName + "." + fileType;
		res.setContentType("application/octet-stream;");
		res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");

		Map columnDefMap = new ObjectMapper().readValue(req.getParameter("columnDef"), Map.class);

		if(columnDefMap != null) {
			try {
				new ExcelExportHandler(rowsStr, columnDefMap, fileType, urlStr, excelOptions, groupColDef, frozenColIndex).write(res.getOutputStream());
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				res.getOutputStream().close();
			}
		}
	}

	/**
	 * 리얼그리드용 엑셀업로드
	 * @param req
	 * @param res
	 * @throws IOException
	 */
	@RequestMapping(value = "/uploadExcel.so", method = RequestMethod.POST)
	public void uploadExcel(HttpServletRequest req, HttpServletResponse res) throws IOException {

		res.setCharacterEncoding("UTF-8");
		res.setContentType("text/html; charset=UTF-8");

		List<FileItem> fileItems;

		PrintWriter writer = res.getWriter();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ServletFileUpload fileUpload = new ServletFileUpload(new DiskFileItemFactory());

		try {

			fileItems = fileUpload.parseRequest(req);

		} catch (FileUploadException fue) {

			resultMap.put("errorMessage", fue.getMessage());
			writer.println(new ObjectMapper().writeValueAsString(resultMap));
			logger.error(fue.getMessage(), fue);
			return;
		}

		FileItem excelFile = null;
		for(FileItem fileItem : fileItems) {

			if(fileItem.getFieldName().equals("file-0")) {
				excelFile = fileItem;
			}
		}

		String gridData = null;
		try {

			if(excelFile != null) {
				gridData = new ExcelImportHandler(excelFile.getName()).read2(excelFile.getInputStream());
			}

		} catch(Exception e) {

			resultMap.put("errorMessage", e.getMessage());
			writer.println(new ObjectMapper().writeValueAsString(resultMap));
			logger.error(e.getMessage(), e);
			return;
		}

		resultMap.put("gridData", gridData);
		writer.println(new ObjectMapper().writeValueAsString(resultMap));

	}

	@RequestMapping(value = "/ExcelUpload.so", method = RequestMethod.POST)
	public void excelUpload(HttpServletRequest req, HttpServletResponse res) throws IOException {

		res.setCharacterEncoding("UTF-8");
		res.setContentType("text/html; charset=UTF-8");

		List<FileItem> fileItems;
		String colInfo = "";
		PrintWriter writer = res.getWriter();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		ServletFileUpload fileUpload = new ServletFileUpload(new DiskFileItemFactory());

		try {
			fileItems = fileUpload.parseRequest(req);
		} catch (FileUploadException e) {
			resultMap.put("errorMessage", e.getMessage());
			writer.println(new ObjectMapper().writeValueAsString(resultMap));
			logger.error(e.getMessage(), e);
			return;
		}

		FileItem excelFile = null;
		for (FileItem fileItem : fileItems){
			if(fileItem.getFieldName().equals("fileInput")) {
				excelFile = fileItem;
			}
			if(fileItem.getFieldName().equals("colInfo")) {
				colInfo = fileItem.getString("UTF-8");
			}
		}

		assert excelFile != null;
		List<Map<String, String>> gridData;

		try{
			gridData = new ExcelImportHandler(excelFile.getName(), colInfo).read(excelFile.getInputStream());
		} catch (Exception e){
			resultMap.put("errorMessage", e.getMessage());
			writer.println(new ObjectMapper().writeValueAsString(resultMap));
			logger.error(e.getMessage(), e);
			return;
		}

		resultMap.put("gridData", gridData);
		LoggerFactory.getLogger(getClass()).debug(" ========================== excelData ========================== : " + new ObjectMapper().writeValueAsString(gridData));
		writer.println(new ObjectMapper().writeValueAsString(resultMap));
	}

	@RequestMapping(value = "/gridGen.so")
	public void gridGen (EverHttpRequest req, EverHttpResponse resp) throws Exception {

		String gridId = req.getParameter("gridID");
		String screenId = req.getParameter("screenID");
		boolean detailView = Boolean.parseBoolean(req.getParameter("detailView"));

		BaseInfo baseInfo = UserInfoManager.getUserInfo();
		String numberFormat = baseInfo.getNumberFormat();
		String dateFormat = baseInfo.getDateFormat();
		String langCode = StringUtils.defaultIfEmpty(baseInfo.getLangCd(), PropertiesManager.getString("eversrm.langCd.default"));

		// 화면별 마스킹 정보를 가져온다.
		Map<String, Object> maskInfo = screenInterceptorService.getMaskInfo(screenId, EverDate.getDate());

		gridGenService.init(screenId, gridId, langCode, dateFormat, numberFormat, maskInfo);
		gridGenService.getEssential();

		List<GridMeta> columnInfos = gridGenService.getColumnInfos();

		// 버튼 이미지 정보 가져오기
        List<Map<String, Object>> btnImageInfo = gridGenService.getBtnImageInfos(screenId);

		List<Object> list = new ArrayList<Object>();
		Map<Object, Object> rtnData = new LinkedHashMap<Object, Object>();

		for (GridMeta data : columnInfos) {

			String colType = data.getColumnType();
			Map<Object, Object> defData = new LinkedHashMap<Object, Object>();
			Map<Object, Object> tempData = new LinkedHashMap<Object, Object>();

			tempData.put("columnId", data.getColumnId());
			tempData.put("columnType", colType);
			tempData.put("commonId", data.getCommonId());
			tempData.put("text", data.getText());
			tempData.put("width", data.getWidth());
			tempData.put("maxLength", data.getMaxLength());
			tempData.put("editable", detailView ? "false" : data.getEditable());
			tempData.put("align", data.getAlign());
			tempData.put("frozen", data.isFrozeFlag());
			tempData.put("textWrap", data.getTextWrap());
			tempData.put("decimalYn", data.isDecimalYn());
			tempData.put("btnImage", btnImageInfo);
			// 사용자 마스킹 허용여부를 셋팅한다.
			if (maskInfo != null && "E".equals(maskInfo.get("MASK_APPROVAL")) && "S".equals(maskInfo.get("SCREEN_CRUD"))) {
				tempData.put("maskType", "");
			} else {
				tempData.put("maskType", data.getMaskType());
			}

			if ("E".equals(data.getEssential())) {
				tempData.put("required", "true");
				tempData.put("defStyle", "E");
			} else {
				if ("D".equals(data.getEssential())) {
					tempData.put("defStyle", "D");
				} else if ("O".equals(data.getEssential())) {
					tempData.put("defStyle", "O");
				} else ;

				tempData.put("required", "false");
			}

			if ("imagetext".equals(data.getColumnType())) {
				if (data.getImageName() == null) {
					defData.put("src", "");
				} else {
					defData.put("src", data.getImageName());
				}

				defData.put("text", "");
				tempData.put("defData", defData);
			} else if ("combo".equals(data.getColumnType())) {
				List<Map<String, String>> comboData = data.getCombos();

				if (comboData != null) {
					for (Map<String, String> tmp : comboData) {
						tmp.put(tmp.get("value"), tmp.get("text"));
					}
					tempData.put("defData", comboData);
				}
			} else if ("date".equals(data.getColumnType())) {
				tempData.put("defData", "yyyy/MM/dd");
			} else if ("number".equals(data.getColumnType())) {
				tempData.put("defData", data.getDataFormat());
			}

			list.add(tempData);
		}

		rtnData.put("gridColData", list);
		rtnData.put("detailView", detailView);

		resp.setContentType("application/json");
		resp.getWriter().write(new ObjectMapper().writeValueAsString(rtnData));
	}
}