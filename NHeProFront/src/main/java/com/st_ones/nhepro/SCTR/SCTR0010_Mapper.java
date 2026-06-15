package com.st_ones.nhepro.SCTR;

import java.util.List;
import java.util.Map;

public interface SCTR0010_Mapper {

    List<Map<String, Object>> sctr0010_doSearchContractProgressStatus(Map<String, Object> param);

    void sctr0010_doGurSave(Map<String, Object> grid);

    List<Map<String, String>> getContractAllContents(Map<String, String> formData);

    List<Map<String, String>> getContractMainContents(Map<String, String> formData);
    
    // 2021.02.09 : 협력사에서 전자서명 여부 가져오기
    String getVendorSignData(Map<String, String> formData);
    
    // 2021.02.09 : 협력사의 기존 전자서명값 삭제하기
    void doDeleteVendorSignData(Map<String, String> formData);
    
    int doUpdateContractStatusECCT(Map<String, String> formData);

    int doInsertSignedData(Map<String, String> formData);

    int doMergeRejectHistoryECRJ(Map<String, String> formData);

    Map<String, String> sctr0012_doSearchPrint(Map<String, String> param);

    List<Map<String, String>> sctr0012_doSearchOtherPrint(Map<String, String> param);

    Map<String, String> sctr0011_getContractInformation(Map<String, String> formData);

    List<Map<String, Object>> sctr0011_doSearchECPC_HD(Map<String, String> formData);

    int sctr0011_doSearchGuarInfo(Map<String, String> paramDataMap);

    void sctr0011_doSaveECPC_HD(Map<String, Object> grid);

    void sctr0011_doSaveECPC_HD_GUAR(Map<String, Object> grid);

    List<Map<String, Object>> sctr0011_doSearchECPC(Map<String, String> formData);

    List<Map<String, Object>> sctr0011_doSearchECMT(Map<String, String> formData);

    void doUpdateECPC_HD(Map<String, Object> ecpc_hd);

    void doUpdateECPC_HD_DI(Map<String, Object> ecpc_hd);


    Map<String, String> getGuarDataEcct(Map<String, Object> formData);
    
    Map<String, String> getGuarCancelDataEcct(Map<String, Object> formData);
    
    Map<String, String> getGuarSWDataEcct(Map<String, Object> formData);
    
    Map<String, String> getGuarSWDataStatus(Map<String, String> formData);

    List<Map<String, Object>> sctr0011_doSearchECCM(Map<String, String> formData);

    Map<String, String> sctr0010_doPdfValid(Map<String, String> param);

    Map<String, String> getGuarDataBdhd(Map<String, Object> formData);
    
    Map<String, String> getGuarCancelDataBdhd(Map<String, Object> formData);
    
    
    List<Map<String, String>> sctr0010_getSgGuarInformation(Map<String, Object> param);
    
    void setGuarSendComplete(Map<String, Object> formData);
    void setGuarSendCompleteIvap(Map<String, Object> formData);
    void setGuarSendCompleteBdhd(Map<String, Object> formData);
    void setGuarReSendComplete(Map<String, Object> formData);
    void setGuarCancelSendComplete(Map<String, Object> formData);
    
    void setGuarDelete(Map<String, Object> param);

    void upsGuarEcct(Map<String, Object> formData);

    void upsGuarRecevieEcpc(Map<String, String> formData);
    
    void upsGuarCancelRecevieBdhd(Map<String, Object> formData);
    
    void upsGuarCancelRecevieEcpc(Map<String, Object> formData);
    
    void upsGuarCancelConfirmRecevieEcpc(Map<String, Object> formData);
    
    void upsGuarRecevieIvap(Map<String, String> formData);

    void upsGuarRecevieBdhd(Map<String, String> formData);
    
    void insGuarRecevieGrtswgua(Map<String, String> formData);
    
    Map<String, String> getGuarInfoCheck(Map<String, String> formData);
    
    Map<String, String> getGuarNumInfoCheck(Map<String, String> formData);
    
    Map<String, String> sctr0010_getguarInformation(Map<String, String> formData);
    
    void sctr0011_doUpdateVendorFile(Map<String, String> param);
    
    void doSaveBatchLog(Map<String, Object> gridData);
    
    void sctr0010_doGuarSave(Map<String, Object> grid);
    
    int doInsertDFSignedData(Map<String, String> formData);    
}
