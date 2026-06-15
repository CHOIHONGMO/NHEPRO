package com.st_ones.common.cache.data;

import java.util.ArrayList;
import java.util.HashMap;
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
 * @File Name : GridModel.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class GridModel {

	public Map<String, Object> getRowEdit() {
		return rowEdit;
	}

	public void setRowEdit(Map<String, Object> rowEdit) {
		this.rowEdit = rowEdit;
	}

	public Map<String, Object> getCellEdit() {
		return cellEdit;
	}

	public void setCellEdit(Map<String, Object> cellEdit) {
		this.cellEdit = cellEdit;
	}

	private int page;
    private int total;
    private int records;
    private List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
    private Map<String, Object> rowStyle = new HashMap<String, Object>();
    private Map<String, Object> cellStyle = new HashMap<String, Object>();
    private Map<String, Object> colStyle =  new HashMap<String, Object>();
    private Map<String, Object> rowEdit =  new HashMap<String, Object>();
    private Map<String, Object> cellEdit =  new HashMap<String, Object>();

	public void setColStyle( Map<String, Object> colStyle ) {		
		this.colStyle = colStyle;
	}
	
	public void setRowStyle(Map<String, Object> rowStyle) {
		this.rowStyle = rowStyle;
	}

	public void setCellStyle( Map<String, Object> cellStyle ) {
		this.cellStyle = cellStyle;
	}
	
    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getRecords() {
        return records;
    }

    public void setRecords(int records) {
        this.records = records;
    }

    public List<Map<String, Object>> getRows() {
        return rows;
    }

    public void setRows(List<Map<String, Object>> rows) {
        this.rows.addAll(rows);
    }
    public Map<String, Object> getRowStyle() {
		return rowStyle;
	}

	public Map<String, Object> getCellStyle() {
		return cellStyle;
	}

	public Map<String, Object> getColStyle() {
		return colStyle;
	}
}
