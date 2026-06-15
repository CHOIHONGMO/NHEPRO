package com.st_ones.common.excel;

import net.sf.jxls.parser.Cell;
import net.sf.jxls.processor.RowProcessor;
import net.sf.jxls.transformer.Row;
import org.apache.poi.ss.usermodel.CellStyle;

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
 * @File Name : AutoFitRowProcessor.java
 * @date 2013. 07. 22.
 * @version 1.0
 * @see
 */
public class AutoFitRowProcessor implements RowProcessor {

    @Override
    public void processRow(Row row, Map namedCell) {

        List cells = row.getCells();

        for (int i = 0; i < cells.size(); i++) {
            Cell cell = (Cell) cells.get(i);
            if(!cell.isNull()) {
                CellStyle cellStyle = cell.getPoiCell().getCellStyle();
//                cellStyle.setWrapText(true);
                cell.getPoiCell().setCellStyle(cellStyle);
//                cell.getPoiCell().setCellValue("huhu!");
            }
        }
    }
}
