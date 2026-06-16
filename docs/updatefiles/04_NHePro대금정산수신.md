# NH-ERP -> ePro 대금지급정보 연동 (04번 요구사항) 구현 명세서

본 문서는 NH-ERP에서 전자구매시스템(ePro)으로 대금정산 완료 정보를 전송받아 처리하기 위해 개발된 내역을 설명합니다. 기존 보증보험증권용 파일인 `SwGureController.java`를 수정하지 않고, **신규 컨트롤러인 `NhErpPayController.java`**를 생성하여 별도의 REST API 경로를 구성했습니다.

---

## 1. 개요
- **요구사항명:** NH-ERP -> ePro 연동
- **내용:** 계약 후 발생하는 NH-ERP의 대금정산 완료 정보를 ePro 시스템으로 수수하여 내부 대금정산 테이블(`STOCECPC`)에 저장 및 업데이트합니다.
- **REST API 엔드포인트:** `/nheproif/recvErpPay`
- **세션 여부:** 세션 없음 (nosession 패키지에 위치하여 세션 검사를 수행하지 않음)

---

## 2. 관련 파일 및 상세 변경 사항

### 2.1 [NEW] [NhErpPayController.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nosession/interfacez/web/NhErpPayController.java)
- ERP로부터 REST API 호출을 받기 위해 생성된 새로운 컨트롤러 클래스입니다.
- **주요 기능:**
  - `SEND_DATA` 파라미터로 전송된 JSON 문자열을 수신하여 `Map` 형태로 파싱합니다.
  - `ContSendErpService.recvErpPay_doSave(send_data_map)` 메소드를 호출하여 DB 트랜잭션을 처리합니다.
  - 처리 결과에 따라 성공 시 `{ "RESULT_YN": "Y", "RESULT_MSG": "SUCCESS" }`, 실패 시 `{ "RESULT_YN": "N", "RESULT_MSG": "FAIL: 에러메시지" }`를 반환합니다.

### 2.2 [MODIFY] [ContSendErpService.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nosession/interfacez/service/ContSendErpService.java)
- 수신된 JSON 데이터 리스트를 활용하여 `STOCECPC` 테이블에 데이터 인서트/업데이트 로직을 수행합니다.
- **동작 방식:**
  - `MSTDATA` 또는 `DET` 키에서 데이터 리스트를 추출합니다.
  - 리스트 내의 각 정산 정보 레코드에 대하여 필수 파라미터(`GATE_CD`, `BUYER_CD`, `CONT_NUM`, `CONT_CNT`, `PAY_CNT`, `PY_BUYER_CD`, `PY_DEPT_CD`)를 체크합니다.
  - 누락될 가능성이 있는 `PR_BUYER_CD`, `PR_DEPT_CD`, `VENDOR_CD` 정보는 계약 발주처 할당 테이블인 `STOCECCM`을 조회하여 보완합니다.
  - `STOCECPC` 테이블에 기존 데이터 존재 여부를 체크한 후, 존재할 경우 `update`, 존재하지 않을 경우 `insert`를 수행합니다.

### 2.3 [MODIFY] [ContSendErp_Mapper.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nosession/interfacez/ContSendErp_Mapper.java)
- DB 연동을 위해 다음 4개의 인터페이스 메소드를 정의했습니다.
  - `getEccmInfo`: 계약 고객사 정보 조회
  - `checkEcpcExists`: 기존 지급 정보 존재 여부 체크
  - `insertEcpc`: 대금 지급(정산) 정보 신규 등록
  - `updateEcpc`: 기존 대금 지급(정산) 정보 금액/비고 갱신

### 2.4 [MODIFY] [ContSendErp_Mapper.xml](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/resources/mappers/com/st_ones/nosession/interfacez/ContSendErp_Mapper.xml)
- 추가된 Mapper 인터페이스 메소드에 대응하는 MyBatis SQL 쿼리문을 추가하였습니다.
  - 중복 체크 후 해당 정산 레코드가 이미 존재할 때 업데이트를 타며, 미존재 시 `insert` 쿼리가 실행됩니다.
  - 등록자 및 수정자 ID는 외부 인터페이스 계정인 `"SYSTEM"`으로 처리됩니다.

---

## 3. 테스트 및 검증 방안
1. **Mock Request 테스트:**
   - 아래와 같은 JSON 페이로드 구조를 가진 `SEND_DATA` 값을 REST 클라이언트(POSTMAN 등)를 통해 `/nheproif/recvErpPay` 엔드포인트로 POST 전송합니다.
   
```json
{
  "MSTDATA": [
    {
      "GATE_CD": "100",
      "BUYER_CD": "C00007",
      "CONT_NUM": "CT26000001",
      "CONT_CNT": "1",
      "PAY_CNT": "1",
      "PY_BUYER_CD": "C00007",
      "PY_DEPT_CD": "DEPT01",
      "PAY_AMT": 50000000,
      "RMK": "NH-ERP 대금 정산 1차 지급 완료"
    }
  ]
}
```

2. **결과 확인:**
   - 호출 결과 응답으로 `{"RESULT_YN":"Y","RESULT_MSG":"SUCCESS"}`가 오는지 확인합니다.
   - 데이터베이스 `STOCECPC` 테이블에서 `CONT_NUM = 'CT26000001'` 이고 `PAY_CNT = 1` 인 데이터의 지급액과 사용 상태(`DEL_FLAG = '0'`)가 정상적으로 갱신되었는지 확인합니다.
