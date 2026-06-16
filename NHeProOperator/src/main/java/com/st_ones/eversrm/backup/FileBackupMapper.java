package com.st_ones.eversrm.backup;

import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * ******************************************************************************
 * 상기 프로그램에 대한 저작권을 포함한 지적재산권은 ㈜에스티원즈에 있으며,
 * ㈜에스티원즈가 명시적으로 허용하지 않은 사용, 복사, 변경, 제3자에의 공개, 배포는 엄격히 금지되며,
 * ㈜에스티원즈의 지적재산권 침해에 해당됩니다.
 * (Copyright ⓒ 2026 ST-ONES CORP., ALL RIGHTS RESERVED | Confidential)
 * ******************************************************************************
 * </pre>
 * @File Name : FileBackupMapper.java
 * @version 1.0
 */
@Repository
public interface FileBackupMapper {

    List<Map<String, Object>> selectOldFilesForDeletion(Map<String, Object> param);

    void insertStocatcn(Map<String, Object> param);

    void updateStocatcnStatus(Map<String, Object> param);

    void updateStocatchAppInfo(Map<String, Object> param);

    void clearStocatchAppInfo(Map<String, Object> param);

    List<Map<String, Object>> selectApprovedFilesForBackup(Map<String, Object> param);

    void updateStocatchDelFlag(Map<String, Object> param);

    List<Map<String, Object>> selectStocatcnList(Map<String, Object> param);

}
