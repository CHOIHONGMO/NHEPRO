package com.st_ones.eversrm.backup.web;

import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.everf.serverside.web.BaseController;
import com.st_ones.everf.serverside.web.wrapper.EverHttpRequest;
import com.st_ones.everf.serverside.web.wrapper.EverHttpResponse;
import com.st_ones.eversrm.backup.service.FileBackupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
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
 * @File Name : FileBackupController.java
 * @version 1.0
 */
@Controller
@RequestMapping(value = "/eversrm/backup")
public class FileBackupController extends BaseController {

    @Autowired
    private FileBackupService fileBackupService;

    /**
     * 화면명 : 삭제 대상 파일 관리 (5년 경과 대상 선정)
     * 경로 : eversrm/backup/fileDeleteList
     */
    @RequestMapping(value = "/fileDeleteList/view")
    public String fileDeleteList(EverHttpRequest req) throws Exception {
        return "/eversrm/backup/fileDeleteList";
    }

    /**
     * 화면명 : 파일 삭제 결재 및 백업 현황 조회
     * 경로 : eversrm/backup/fileDeleteStatus
     */
    @RequestMapping(value = "/fileDeleteStatus/view")
    public String fileDeleteStatus(EverHttpRequest req) throws Exception {
        req.setAttribute("regFromDate", EverDate.addDateMonth(EverDate.getDate(), -3));
        req.setAttribute("regToDate", EverDate.getDate());
        return "/eversrm/backup/fileDeleteStatus";
    }

    /**
     * 5년 경과 파일 목록 조회 API
     */
    @RequestMapping(value = "/fileBackup/selectOldFiles")
    public void selectOldFiles(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        Map<String, Object> param = new HashMap<String, Object>(formData);
        resp.setGridObject("grid", fileBackupService.selectOldFilesForDeletion(param));
    }

    /**
     * 삭제 대상 파일 결재 요청 API
     */
    @RequestMapping(value = "/fileBackup/requestApproval")
    public void requestApproval(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        Map<String, Object> param = new HashMap<String, Object>(formData);
        List<Map<String, Object>> gridData = req.getGridData("grid");

        String appDocNum = fileBackupService.requestDeletionApproval(param, gridData);

        resp.setResponseMessage("삭제 결재 문서가 정상 상신되었습니다. (결재번호: " + appDocNum + ")");
    }

    /**
     * 삭제 결재 승인 상태 회수/복구 API (배치 작업 실행 전 가능)
     */
    @RequestMapping(value = "/fileBackup/restoreFile")
    public void restoreFile(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        Map<String, Object> param = new HashMap<String, Object>(formData);
        List<Map<String, Object>> gridData = req.getGridData("grid");

        for (Map<String, Object> row : gridData) {
            row.put("ses", param.get("ses"));
            fileBackupService.restoreDeletionRequest(row);
        }

        resp.setResponseMessage("선택한 삭제 결재건의 파일 정보가 복구되었습니다.");
    }

    /**
     * 삭제 및 백업 현황 조회 API
     */
    @RequestMapping(value = "/fileBackup/selectStatus")
    public void selectStatus(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        Map<String, Object> param = new HashMap<String, Object>(formData);
        resp.setGridObject("grid", fileBackupService.selectStocatcnList(param));
    }

    /**
     * [수동 실행 수단] 결재 완료된 파일의 백업 및 삭제 Flag 처리 수동 배치 실행 API
     */
    @RequestMapping(value = "/fileBackup/runBackupBatch")
    public void runBackupBatch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, String> formData = req.getFormData();
        Map<String, Object> param = new HashMap<String, Object>(formData);
        Map<String, Object> result = fileBackupService.runMonthlyBackupBatch(param);
        resp.setResponseMessage("백업 배치 실행 완료. (성공: " + result.get("processedCount") + "건, 실패: " + result.get("failCount") + "건)");
    }

    /**
     * [수동 실행 수단] 백업 디렉터리 내 3개월 초과 파일 영구삭제 수동 배치 실행 API
     */
    @RequestMapping(value = "/fileBackup/runPurgeBatch")
    public void runPurgeBatch(EverHttpRequest req, EverHttpResponse resp) throws Exception {
        Map<String, Object> result = fileBackupService.runBackupPurgeBatch();
        resp.setResponseMessage("영구삭제 배치 실행 완료. (삭제됨: " + result.get("deletedCount") + "건, 실패: " + result.get("failCount") + "건)");
    }
}
