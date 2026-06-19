# SOM 시스템 결재 연동 구현 결과서

본 문서는 ePro 시스템의 결재상신 기능을 외부 SOM(그룹웨어) 시스템과 REST API를 통해 실시간 연동하도록 구현한 결과와 상세 설계 명세에 대해 기술합니다.

---

## 1. 연동 개요

ePro 내부의 결재 상신 프로세스가 발생하면, 결재 정보를 외부 SOM 시스템에 전송(HTTP REST API)하고, SOM 시스템에서 결재 단계가 진행될 때마다 그 결과를 비동기로 수신(Callback API)하여 ePro의 결재 상태 및 연관 비즈니스 데이터 상태를 최신화합니다.

```
+------------------+                   +--------------------+
|   ePro System    |   (상신 REST API)  |     SOM System     |
|                  | ----------------> |                    |
|                  |                   |  (결재 프로세스)   |
|                  |   (Callback API)  |                    |
|   (Callback)     | <---------------- |                    |
+------------------+                   +--------------------+
```

---

## 2. API Key 인증 및 통신 설정

연동 시 시스템 간의 보안 강화를 위해 **API Key 인증 방식**을 적용합니다. 

- **인증 헤더:** 모든 REST API 호출 및 Callback 요청 시 HTTP Header에 `X-API-KEY` 값을 포함해야 합니다.
- **설정 정보 (`eversrm.properties`):**

  ```properties
  # SOM 연동 활성화 여부 (true: 활성, false: 비활성)
  som.approval.integration.flag=true
  
  # SOM 결재상신 API URL
  som.approval.url=http://som-gateway-host/som/api/requestApproval
  
  # 연동 인증용 API Key
  som.approval.api.key=ever-som-secret-key-2026
  ```

---

## 3. API 연동 명세

### A. ePro -> SOM 결재상신 (REST API 송신)

- **Method:** `POST`
- **Endpoint:** `${som.approval.url}`
- **Headers:**
  - `Content-Type: application/json;charset=UTF-8`
  - `X-API-KEY: ${som.approval.api.key}`
- **Request Body (10종 데이터 명세):**

  ```json
  {
    "appDocNum": "AP202606160001", 
    "appDocCnt": "1",
    "docType": "PR",
    "buyerCd": "100",
    "subject": "2026년 6월 소모품 구매 의뢰 결재 건",
    "draftUserId": "11303733",
    "draftUserName": "김정아",
    "draftDeptName": "IT지원부",
    "draftDate": "20260616173000",
    "docHtml": "<html><body>결재 본문 내용 (HTML)</body></html>"
  }
  ```

  > `docHtml` 필드는 `SomService.makeApprovalHtml`을 통해 `docType`과 `appDocNum`을 기반으로 해당 업무 테이블을 조회하여 동적으로 생성됩니다.

- **Response Body:**

  ```json
  {
    "RESULT_YN": "Y",
    "RESULT_MSG": "SUCCESS",
    "SOM_APP_ID": "SOM-APP-998877"
  }
  ```

### B. SOM -> ePro 결재 진행결과 반영 (Callback API 수신)

- **Method:** `POST`
- **Endpoint:** `/nheproif/somCallback`
- **Headers:**
  - `Content-Type: application/json;charset=UTF-8`
  - `X-API-KEY: ${som.approval.api.key}`
- **Request Body:**

  ```json
  {
    "appDocNum": "AP202606160001",
    "appDocCnt": "1",
    "somAppId": "SOM-APP-998877",
    "signStatus": "E",
    "signUserId": "88776655",
    "signUserName": "홍길동",
    "signDate": "20260616180000",
    "signRmk": "승인 완료합니다."
  }
  ```

  > `signStatus` 정의:
  > - `P` (진행중 - 중간 결재)
  > - `E` (최종 승인 완료)
  > - `R` (반려)
  > - `C` (기안자 상신 취소)
- **Response Body:**

  ```json
  {
    "RESULT_YN": "Y",
    "RESULT_MSG": "SUCCESS"
  }
  ```

---

## 4. 구현 및 변경 내역 (Proposed Changes)

프로젝트 간 의존성 규칙(`NHeProFront` -> `NHeCommon`)을 준수하기 위해 REST Endpoint 파일만 `NHeProFront`에 두고, 비즈니스 및 DB 레이어 파일은 공통 프로젝트인 `NHeCommon`에 배치하였습니다.

### 1) NHeProFront 프로젝트 생성 파일

- **[SomController.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nosession/interfacez/web/SomController.java)**
  - 비동기 Callback API 엔드포인트 수신 및 `X-API-KEY` 유효성 검증 수행.
  - `NHeCommon` 프로젝트의 `SomService`를 주입받아 Callback 비즈니스 로직 호출.

### 2) NHeCommon 프로젝트 생성 파일

- **[SomService.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeCommon/src/main/java/com/st_ones/eversrm/eApproval/som/service/SomService.java)**
  - `docType`과 `appDocNum`을 사용하여 상세 비즈니스 데이터(구매의뢰 `PR`, 발주 `PO` 등)를 조회하여 HTML 본문을 동적으로 생성하는 `makeApprovalHtml` 메서드 구현.
  - 외부 API Key를 포함한 결재상신 REST 송신 처리 및 Callback 수신 데이터의 DB 상태 변경 연계.
- **[SomMapper.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeCommon/src/main/java/com/st_ones/eversrm/eApproval/som/SomMapper.java)**
  - 결재 상태 업데이트 및 PR/PO 품목 정보 조회를 위한 Mapper 인터페이스 정의.
- **[SomMapper.xml](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeCommon/src/main/resources/mappers/com/st_ones/eversrm/eApproval/som/SomMapper.xml)**
  - 구매의뢰(`STOCPRHD`/`STOCPRDT`), 발주(`STOCPOHD`/`STOCPODT`) 등 결재대상 상세 조회를 위한 SQL 구현 및 상태 동기화용 SQL 구현.

### 3) 기존 파일 수정

- **[BAPM_Service.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeCommon/src/main/java/com/st_ones/eversrm/eApproval/eApprovalModule/service/BAPM_Service.java)**
  - ePro 내부 결재상신 처리 `doApprovalProcess` 메서드에서 SOM 연동 활성화 여부를 판단하는 `if (PropertiesManager.getBoolean("som.approval.integration.flag", true))` 분기를 추가하여 `somService.sendSomApproval()` 메서드를 호출하도록 구현.
  - 기존 이메일/SMS 발송 코드의 삭제 없이 연동 호출을 추가 얹는 방식으로 안정성 확보.

---

## 5. 결재 완료/반려 비즈니스 연계

SOM에서 최종 결재 완료(`E`) 또는 반려(`R`), 상신취소(`C`) 정보가 Callback으로 수신되면, ePro 시스템의 `EndApprovalService`를 연동하여 후속 비즈니스 작업을 자동으로 트리거합니다.

- **승인완료 (`E`):** `endApprovalService.doAfterApprove` 호출 -> 대상 문서(PR, BID, PO 등)의 최종 승인 비즈니스 상태 갱신.
- **반려 (`R`):** `endApprovalService.doAfterReject` 호출 -> 대상 문서의 반려 상태 갱신 및 반려 메일 통보.
- **상신취소 (`C`):** `endApprovalService.doAfterCancel` 호출 -> 상신취소 상태로 복원 처리.

---

## 6. 별도 PDF 변환 소프트웨어를 통한 연동 구현 방안

본 연동에서는 ePro 서버 내의 자체 변환 대신 **별도의 전문 PDF 변환 소프트웨어/서버(예: Synap Document Converter, Hancom, 혹은 CLI 변환기 등)**를 활용하여 고해상도 결재 PDF 문서를 생성하고 연계합니다.

### A. PDF 변환 및 SOM 연동 프로세스

```
[ePro 기안 상신] 
       │
       ▼
1. 결재 상신용 HTML 템플릿 생성 (ePro 서버)
       │
       ▼
2. 외부 PDF 변환 API/CLI 호출 (HTML 또는 URL 전달) ────────▶ [PDF 변환 소프트웨어]
       │                                                         │
       ▼                                                         ▼
4. 변환된 PDF 파일을 스토리지(NAS/웹서버)에 저장 ◀───────── 3. PDF 문서 생성 완료
       │
       ▼
5. PDF 파일의 고유 웹 접근 URL 링크 추출 
   (예: http://epro.nh.com/files/pdf/AP202606160001.pdf)
       │
       ▼
6. SOM 상신 API 호출 (payload에 pdfLink 포함하여 전송) ──────▶ [SOM 모바일 결재 화면]
                                                                  (사용자가 터치하여 PDF 뷰어로 조회)
```

### B. 외부 변환 솔루션 연동 방식

별도 소프트웨어와의 인터페이스 방식에 따라 아래 두 가지 방식을 설계할 수 있습니다.

#### 방식 1: HTTP REST API 연동형 (가장 권장)

별도의 변환 엔진 서버가 데몬 형태로 구동 중인 경우, ePro 백엔드에서 변환 서버로 멀티파트 파일(HTML)을 업로드하고 PDF 결과를 비동기/동기로 반환받습니다.

```java
// 예시: HttpClient를 사용한 외부 PDF 변환 API 호출
public String convertHtmlToPdfViaApi(String htmlContent, String docNum) {
    String pdfConvertUrl = PropertiesManager.getString("pdf.converter.url"); // 변환기 서버 주소
    
    // HTTP Multipart POST 요청 구성
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.MULTIPART_FORM_DATA);
    
    MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
    body.add("file", getHtmlFileResource(htmlContent, docNum)); // HTML 데이터 전달
    body.add("outputName", docNum + ".pdf");
    
    HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);
    ResponseEntity<String> response = restTemplate.postForEntity(pdfConvertUrl, requestEntity, String.class);
    
    // 변환된 PDF의 다운로드 경로 또는 스토리지 파일 경로 반환
    return parsePdfPathFromResponse(response.getBody()); 
}
```

#### 방식 2: OS Command Line Utility (CLI) 실행형

서버 내부에 변환 실행 엔진(`exe` 또는 `sh`)이 로컬로 설치되어 있는 경우, Java Runtime을 통해 프로세스를 직접 실행하여 HTML을 PDF로 변환합니다.

```java
public void convertHtmlToPdfViaCli(String htmlFilePath, String outputPdfPath) {
    try {
        // CLI 프로그램 실행 명령어 구성
        String converterPath = PropertiesManager.getString("pdf.converter.cli.path");
        String[] cmd = {
            converterPath, 
            "-html", htmlFilePath, 
            "-o", outputPdfPath
        };
        
        Process process = Runtime.getRuntime().exec(cmd);
        int exitCode = process.waitFor();
        
        if (exitCode != 0) {
            throw new RuntimeException("PDF 변환 프로그램 실행 실패. Exit Code: " + exitCode);
        }
    } catch (Exception e) {
        logger.error("CLI를 이용한 PDF 변환 중 오류 발생: ", e);
    }
}
```

### C. SOM 결재상신 API 페이로드 변경 사항

SOM(모바일결재)에서 본문 링크를 제공하기 위해 기존 JSON Body 명세에 `docPdfUrl` 필드를 추가하여 연동을 수립합니다.

- **Request Body 변경 (예시):**

  ```json
  {
    "appDocNum": "AP202606160001",
    "appDocCnt": "1",
    "docType": "PR",
    "buyerCd": "100",
    "subject": "2026년 6월 소모품 구매 의뢰 결재 건",
    "draftUserId": "11303733",
    "draftUserName": "김정아",
    "draftDeptName": "IT지원부",
    "draftDate": "20260616173000",
    "docHtml": "<html><body>결재 본문 내용 (HTML)</body></html>",
    "docPdfUrl": "http://epro.nh.com/files/pdf/AP202606160001.pdf" 
  }
  ```

- `docPdfUrl` : 변환 소프트웨어 완료 후 업로드된 웹 접근 가능 PDF 주소. 모바일 SOM 시스템 결재 카드에서 이 링크를 활성화하여 터치 시 다운로드/바로보기 제공.
