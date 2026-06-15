package com.st_ones.nhepro.REGISTER;

import java.util.Collection;
import java.util.List;
import java.util.Map;


/**
 * The interface REG _ mapper.
 */
public interface REG_Mapper {

    int userIdCheck(Map<String, String> param);

    Map<String, String> userCompanyInfo(Map<String, String> param);

    List<Map<String, Object>> doSearchATTD(Map<String, String> param);

    List<Map<String, Object>> doFileInfo(Map<String, Object> paramData);

    void userInsertCVUR(Map<String, Object> param);

    void userInsertUSAP(Map<String, Object> param);

    void doFileUpdate(Map<String, Object> fileInfo);

    void doInsertVNGL(Map<String, Object> param);

    void doInsertCUST(Map<String, Object> param);

    void doInsertVNFI(Map<String, Object> param);

    void doInsertVNAP(Map<String, Object> param);

    void doInsertVNSL(Map<String, Object> slInfo);

    void doInsertVNCM(Map<String, Object> buyerInfo);

    void doInsertATTS(Map<String, Object> attsAttFile);

    Map<String, String> operIdSearch(Map<String, String> param);

    Map<String, String> custIdSearch(Map<String, String> param);

    Map<String, String> vendorIdSearch(Map<String, String> param);

    Map<String, String> doPwInfo(Map<String, String> param);

    void doUpdateCVUR(Map<String, String> param);

    void doUpdateUSER(Map<String, String> param);

    List<Map<String, Object>> getBrUserList(Map<String, Object> buyerInfo);

    List<Map<String, Object>> getBrVendorUserList(Map<String, Object> param);

    Map<String, String> doSearchVNGL(Map<String, String> param);

    List<Map<String, Object>> doSearchVNSL(Map<String, String> param);

    Map<String, String> doSearchVNFI(Map<String, String> param);

    List<Map<String, Object>> doSearchVNAP(Map<String, String> param);

    List<Map<String, Object>> doSearchVNCM(Map<String, String> param);

    Map<String, String> doSearchCVUR(Map<String, String> param);

    List<Map<String, Object>> doSearchATTS(Map<String, String> param);

    void doDeleteVNGL(Map<String, Object> param);

    void doDeleteVNCM(Map<String, Object> param);

    void doDeleteVNFI(Map<String, Object> param);

    void doDeleteVNAP(Map<String, Object> param);

    void doDeleteVNSL(Map<String, Object> param);

    void doDeleteATTS(Map<String, Object> param);

    void doDeleteUSAP(Map<String, Object> param);

    void doDeleteCVUR(Map<String, Object> param);
    
    Map<String, String> costSmsInfo(Map<String, Object> param);
}

