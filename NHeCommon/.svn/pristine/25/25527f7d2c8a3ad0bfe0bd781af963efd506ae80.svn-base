package com.st_ones.common.util.excel.down;

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
 * @File Name : AbsExcelExportProcessor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public abstract class AbsExcelExportProcessor {

    protected String url;
    protected String groupColDef;
    protected String frozenColIndex;
    protected Map<String, Object> excelOptions;
    protected List<Map<String, Object>> data;
    protected List<String> colIndex;
    protected List<String> colNames;
    protected List<String> colTypes;
    protected List<String> colAlign;
    protected OutputStream outputStream;

    protected abstract void beforeWrite() throws IOException;

    protected abstract void writeHeaders() throws WriteException, IOException;

    protected abstract void writeRows() throws WriteException, ParseException, IOException;

    protected abstract void afterWrite() throws IOException, WriteException;

    public void write() throws IOException, WriteException, ParseException {
        beforeWrite();
        writeHeaders();
        writeRows();
        afterWrite();
    }

    public void setOutputStream(OutputStream outputStream) {
        this.outputStream = outputStream;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setColAlign(List<String> colAlign) {
        this.colAlign = colAlign;
    }

    public void setExcelOptions(Map<String, Object> excelOptions) {
        this.excelOptions = excelOptions;
    }

    public void setGroupColDef(String groupColDef) {
        this.groupColDef = groupColDef;
    }

    public void setFrozenColIndex(String frozenColIndex) {
        this.frozenColIndex = frozenColIndex;
    }

    public void setData(List<Map<String, Object>> data) {
        this.data = data;
    }

    public void setColIndex(List<String> colIndex) {
        this.colIndex = colIndex;
    }

    public void setColNames(List<String> colNames) {
        this.colNames = colNames;
    }

    public void setColTypes(List<String> colTypes) {
        this.colTypes = colTypes;
    }
}
