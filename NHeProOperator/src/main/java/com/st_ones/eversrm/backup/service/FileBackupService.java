package com.st_ones.eversrm.backup.service;

import com.st_ones.common.docNum.service.DocNumService;
import com.st_ones.common.util.clazz.EverDate;
import com.st_ones.common.util.clazz.EverString;
import com.st_ones.everf.serverside.config.PropertiesManager;
import com.st_ones.everf.serverside.service.BaseService;
import com.st_ones.eversrm.backup.FileBackupMapper;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
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
 * @File Name : FileBackupService.java
 * @version 1.0
 */
@Service(value = "fileBackupService")
public class FileBackupService extends BaseService {

    @Autowired
    private FileBackupMapper fileBackupMapper;

    @Autowired
    private DocNumService docNumService;

    /**
     * 5년 경과 및 결재 가능한 파일 조회
     */
    public List<Map<String, Object>> selectOldFilesForDeletion(Map<String, Object> param) throws Exception {
        return fileBackupMapper.selectOldFilesForDeletion(param);
    }

    /**
     * 결재 정보 및 삭제 진행 현황 목록 조회
     */
    public List<Map<String, Object>> selectStocatcnList(Map<String, Object> param) throws Exception {
        return fileBackupMapper.selectStocatcnList(param);
    }

    /**
     * 삭제 대상 결재 상신 (P 상태로 등록 및 STOCATCH 연결)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public String requestDeletionApproval(Map<String, Object> param, List<Map<String, Object>> gridData) throws Exception {
        String gateCd = (String) param.get("GATE_CD");
        if (EverString.isEmpty(gateCd)) {
            gateCd = "100";
        }

        // 1. 결재 문서 번호 채번
        String appDocNum = docNumService.getDocNumber(gateCd, "APPDOC");
        int appDocCnt = 1; // 신규 상신 차수 1

        Map<String, Object> masterParam = new HashMap<String, Object>();
        masterParam.put("ses", param.get("ses"));
        masterParam.put("APP_DOC_NUM", appDocNum);
        masterParam.put("APP_DOC_CNT", appDocCnt);

        // 2. STOCATCN 마스터 등록
        fileBackupMapper.insertStocatcn(masterParam);

        // 3. STOCATCH 각 파일 행에 결재 문서 정보 업데이트
        for (Map<String, Object> file : gridData) {
            Map<String, Object> fileParam = new HashMap<String, Object>();
            fileParam.put("ses", param.get("ses"));
            fileParam.put("APP_DOC_NUM", appDocNum);
            fileParam.put("APP_DOC_CNT", appDocCnt);
            fileParam.put("UUID", file.get("UUID"));
            fileParam.put("UUID_SQ", file.get("UUID_SQ"));

            fileBackupMapper.updateStocatchAppInfo(fileParam);
        }

        return appDocNum;
    }

    /**
     * 삭제 결재 승인 처리 (배치 작업을 위한 'E' 승인완료 처리)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void approveDeletion(Map<String, Object> param) throws Exception {
        param.put("SIGN_STATUS", "E");
        fileBackupMapper.updateStocatcnStatus(param);
    }

    /**
     * 삭제 결재 반려 처리 (STOCATCH 연결 해제 및 마스터 'R' 처리)
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void rejectDeletion(Map<String, Object> param) throws Exception {
        // 1. 결재 마스터 반려 상태로 변경
        param.put("SIGN_STATUS", "R");
        fileBackupMapper.updateStocatcnStatus(param);

        // 2. STOCATCH 테이블의 결재 연결 정보 초기화
        fileBackupMapper.clearStocatchAppInfo(param);
    }

    /**
     * 결재 승인 건에 대한 배치 작업 전 복구(회수) 처리
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public void restoreDeletionRequest(Map<String, Object> param) throws Exception {
        // 1. 결재 마스터 취소 상태로 변경
        param.put("SIGN_STATUS", "C");
        fileBackupMapper.updateStocatcnStatus(param);

        // 2. STOCATCH 테이블의 결재 연결 정보 초기화
        fileBackupMapper.clearStocatchAppInfo(param);
    }

    /**
     * [배치 작업 1] 매월 1회 실행 - 결재 완료된 파일을 백업 경로로 이동 후 삭제(DEL_FLAG='1') 처리
     */
    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
    public Map<String, Object> runMonthlyBackupBatch(Map<String, Object> param) throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        int processedCount = 0;
        int failCount = 0;

        String gateCd = (String) param.get("GATE_CD");
        if (EverString.isEmpty(gateCd)) {
            gateCd = "100";
        }

        // 1. 백업 대상 파일 조회 (STOCATCN.SIGN_STATUS = 'E' 이고 STOCATCH.DEL_FLAG = '0')
        Map<String, Object> selectParam = new HashMap<String, Object>();
        selectParam.put("GATE_CD", gateCd);
        List<Map<String, Object>> backupFiles = fileBackupMapper.selectApprovedFilesForBackup(selectParam);

        // 2. 백업 디렉터리 경로 설정
        String baseUploadPath = PropertiesManager.getString("everf.fileUpload.path");
        if (EverString.isEmpty(baseUploadPath)) {
            baseUploadPath = "C:/temp/upload/";
        }
        if (!baseUploadPath.endsWith("/") && !baseUploadPath.endsWith("\\")) {
            baseUploadPath += File.separator;
        }

        // 월별 백업 하위 폴더 생성 (예: backup/202606/)
        String yyyymm = EverDate.getYear() + EverDate.getMonth();
        String backupDirPath = baseUploadPath + "backup" + File.separator + yyyymm;
        File backupDir = new File(backupDirPath);
        if (!backupDir.exists()) {
            backupDir.mkdirs();
        }

        // 3. 물리 파일 이동 및 테이블 DEL_FLAG 업데이트
        for (Map<String, Object> fileInfo : backupFiles) {
            String filePath = (String) fileInfo.get("FILE_PATH");
            String fileNm = (String) fileInfo.get("FILE_NM");
            String ext = (String) fileInfo.get("FILE_EXTENSION");

            if (EverString.isEmpty(filePath) || EverString.isEmpty(fileNm)) {
                failCount++;
                continue;
            }

            // 원본 파일 경로 객체 생성
            File srcFile = new File(filePath + File.separator + fileNm + (EverString.isEmpty(ext) ? "" : "." + ext));
            if (srcFile.exists() && srcFile.isFile()) {
                File destFile = new File(backupDirPath + File.separator + fileNm + (EverString.isEmpty(ext) ? "" : "." + ext));
                try {
                    // Unix/Linux 간 다른 파일 시스템 이동을 대비하여 Copy & Delete 방식으로 안전하게 구현
                    FileUtils.copyFile(srcFile, destFile);
                    if (srcFile.delete()) {
                        getLog().info("파일 백업 이동 완료: {} -> {}", srcFile.getAbsolutePath(), destFile.getAbsolutePath());
                    } else {
                        getLog().warn("원본 파일 삭제 실패: {}", srcFile.getAbsolutePath());
                    }

                    // 4. STOCATCH 테이블 삭제 Flag('1') 처리
                    Map<String, Object> updateParam = new HashMap<String, Object>();
                    updateParam.put("GATE_CD", fileInfo.get("GATE_CD"));
                    updateParam.put("UUID", fileInfo.get("UUID"));
                    updateParam.put("UUID_SQ", fileInfo.get("UUID_SQ"));
                    fileBackupMapper.updateStocatchDelFlag(updateParam);

                    processedCount++;
                } catch (IOException e) {
                    getLog().error("파일 백업 이동 실패: " + srcFile.getAbsolutePath(), e);
                    failCount++;
                }
            } else {
                getLog().warn("물리 파일이 존재하지 않아 DB 상태만 업데이트합니다: {}", srcFile.getAbsolutePath());
                // 파일 유실 시에도 DEL_FLAG=1 업데이트하여 화면조회 차단
                Map<String, Object> updateParam = new HashMap<String, Object>();
                updateParam.put("GATE_CD", fileInfo.get("GATE_CD"));
                updateParam.put("UUID", fileInfo.get("UUID"));
                updateParam.put("UUID_SQ", fileInfo.get("UUID_SQ"));
                fileBackupMapper.updateStocatchDelFlag(updateParam);
                processedCount++;
            }
        }

        result.put("processedCount", processedCount);
        result.put("failCount", failCount);
        return result;
    }

    /**
     * [배치 작업 2] 매월/매주 실행 - 백업 경로에서 3개월(90일) 경과한 파일 영구 삭제
     */
    public Map<String, Object> runBackupPurgeBatch() throws Exception {
        Map<String, Object> result = new HashMap<String, Object>();
        int deletedCount = 0;
        int failCount = 0;

        String baseUploadPath = PropertiesManager.getString("everf.fileUpload.path");
        if (EverString.isEmpty(baseUploadPath)) {
            baseUploadPath = "C:/temp/upload/";
        }
        if (!baseUploadPath.endsWith("/") && !baseUploadPath.endsWith("\\")) {
            baseUploadPath += File.separator;
        }

        String backupRootPath = baseUploadPath + "backup";
        File backupRootDir = new File(backupRootPath);

        if (backupRootDir.exists() && backupRootDir.isDirectory()) {
            File[] yyyymmDirs = backupRootDir.listFiles();
            if (yyyymmDirs != null) {
                long limitTime = System.currentTimeMillis() - (90L * 24 * 60 * 60 * 1000); // 90일 기준 밀리초

                for (File dir : yyyymmDirs) {
                    if (dir.isDirectory()) {
                        // 1. 디렉터리 내 개별 파일들 검사 후 영구 삭제
                        File[] files = dir.listFiles();
                        if (files != null) {
                            for (File f : files) {
                                if (f.isFile() && f.lastModified() < limitTime) {
                                    if (f.delete()) {
                                        getLog().info("3개월 보존기간 만료 파일 영구 삭제 완료: {}", f.getAbsolutePath());
                                        deletedCount++;
                                    } else {
                                        failCount++;
                                    }
                                }
                            }
                        }

                        // 2. 디렉터리가 비어있고 최종 수정 일자가 3개월 전인 경우 디렉터리 자체 삭제
                        File[] remainingFiles = dir.listFiles();
                        if (remainingFiles == null || remainingFiles.length == 0) {
                            if (dir.lastModified() < limitTime) {
                                if (dir.delete()) {
                                    getLog().info("빈 백업 디렉터리 삭제 완료: {}", dir.getAbsolutePath());
                                }
                            }
                        }
                    }
                }
            }
        }

        result.put("deletedCount", deletedCount);
        result.put("failCount", failCount);
        return result;
    }
}
