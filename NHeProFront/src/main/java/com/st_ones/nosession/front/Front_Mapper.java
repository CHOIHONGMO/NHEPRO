package com.st_ones.nosession.front;

import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface Front_Mapper {

    Map<String, String> doIrsNumCheck(Map<String, String> param);

    Map<String, String> vendorIdSearch(Map<String, String> param);

    Map<String, String> doPwInfo(Map<String, String> param);

    void doUpdateCVUR(Map<String, String> param);

    void doUpdateUSER(Map<String, String> param);

    Map<String, String> operIdSearch(Map<String, String> param);

    Map<String, String> custIdSearch(Map<String, String> param);

}
