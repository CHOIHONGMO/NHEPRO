package com.st_ones.common.util.excel.down;

import com.st_ones.common.util.excel.common.common;
import jxl.write.WriteException;

import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
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
 * @File Name : ExcelExportHandler.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class ExcelExportHandler {

	private AbsExcelExportProcessor excelExportProc;

	public ExcelExportHandler(String rows, Map<String, List<String>> columnDef, String fileType, String url, String excelOptions, String groupColDef, String frozenColIndex) throws IOException {

		excelExportProc = common.getExcelExportProcInst(fileType);
		if(excelExportProc != null) {
			excelExportProc.setData((common.getListMap(rows) == null ? null : common.getListMap(rows)));
			excelExportProc.setColIndex((columnDef.get("colIndex") == null ? null : columnDef.get("colIndex")));
			excelExportProc.setColNames((columnDef.get("colNames") == null ? null : columnDef.get("colNames")));
			excelExportProc.setColTypes((columnDef.get("colTypes") == null ? null : columnDef.get("colTypes")));
			excelExportProc.setColAlign((columnDef.get("colAlign") == null ? null : columnDef.get("colAlign")));
			excelExportProc.setExcelOptions((common.getObjMap(excelOptions) == null ? null : common.getObjMap(excelOptions)));
			excelExportProc.setUrl((url == null ? "" : url));
			excelExportProc.setGroupColDef((groupColDef == null ? "" : groupColDef));
			excelExportProc.setFrozenColIndex((frozenColIndex == null ? "" : frozenColIndex));
		}
	}

	public void write(OutputStream outputStream) throws IOException, WriteException, ParseException {
		excelExportProc.setOutputStream(outputStream);
		if(excelExportProc != null) {
			excelExportProc.write();
		}
	}
}
