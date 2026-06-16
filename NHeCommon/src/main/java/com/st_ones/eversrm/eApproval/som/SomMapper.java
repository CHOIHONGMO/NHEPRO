package com.st_ones.eversrm.eApproval.som;

import java.util.Map;
import org.springframework.stereotype.Repository;

@Repository("somMapper")
public interface SomMapper {

    String getUserDeptName(Map<String, String> param);

    void insertSomInterfaceLog(Map<String, Object> param);

    void updateSomInterfaceLog(Map<String, Object> param);

    Map<String, String> selectSTOCSCTM(Map<String, String> param);

    void updateSTOCSCTM(Map<String, Object> param);

    void updateSTOCSCTP(Map<String, Object> param);

    java.util.List<Map<String, Object>> selectPrData(Map<String, String> param);

    java.util.List<Map<String, Object>> selectPoData(Map<String, String> param);
}
