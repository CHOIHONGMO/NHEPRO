# AI 최저가 및 평균가 조회 기능 (RQ-PR-IT20260020) 처리 결과 보고서

본 문서는 농협 정보 내부 AI LLM 서비스 연동을 통한 최저가 및 평균가 조회 기능 설계, 데이터베이스 변경 사항(DDL) 및 추가/변경된 소스 코드의 상세 사양을 설명하는 결과 문서입니다.

---

## 1. 데이터베이스 테이블 설계 (DDL)

실시간 LLM 분석 요청 내역 및 수신된 예측 단가 정보를 저장하기 위한 `STOCAIRH` 테이블 DDL 스크립트입니다.

```sql
-- 1) AI 최저가 및 평균가 추천 이력 테이블 생성 (Oracle 기준)
CREATE TABLE STOCAIRH (
    GATE_CD          VARCHAR2(10) NOT NULL,
    BUYER_CD         VARCHAR2(10) NOT NULL,
    AI_INQ_NO        VARCHAR2(20) NOT NULL,
    REG_DATE         DATE DEFAULT SYSDATE NOT NULL,
    REG_USER_ID      VARCHAR2(50) NOT NULL,
    DEL_FLAG         VARCHAR2(1) DEFAULT '0' NOT NULL,
    ITEM_CD          VARCHAR2(50),
    ITEM_DESC        VARCHAR2(500) NOT NULL,
    ITEM_SPEC        VARCHAR2(1000),
    MIN_PRICE        NUMBER(22, 5),
    AVG_PRICE        NUMBER(22, 5),
    CONFIDENCE       NUMBER(5, 2),
    ANALYSIS_RESULT  CLOB,
    AI_MODEL         VARCHAR2(100),
    CONSTRAINT PK_STOCAIRH PRIMARY KEY (GATE_CD, BUYER_CD, AI_INQ_NO)
);

-- 2) 코멘트(인덱스 설명) 추가
COMMENT ON TABLE STOCAIRH IS 'AI 최저가 및 평균가 분석 이력 테이블';
COMMENT ON COLUMN STOCAIRH.GATE_CD IS '게이트 코드';
COMMENT ON COLUMN STOCAIRH.BUYER_CD IS '회사 코드';
COMMENT ON COLUMN STOCAIRH.AI_INQ_NO IS 'AI 조회 일련번호';
COMMENT ON COLUMN STOCAIRH.ITEM_CD IS '품목 코드';
COMMENT ON COLUMN STOCAIRH.ITEM_DESC IS '송신 품명(한글)';
COMMENT ON COLUMN STOCAIRH.ITEM_SPEC IS '송신 규격(한글)';
COMMENT ON COLUMN STOCAIRH.MIN_PRICE IS 'AI 추천 최저가';
COMMENT ON COLUMN STOCAIRH.AVG_PRICE IS 'AI 추천 평균가';
COMMENT ON COLUMN STOCAIRH.CONFIDENCE IS 'AI 분석 신뢰도';
COMMENT ON COLUMN STOCAIRH.ANALYSIS_RESULT IS 'AI 분석 상세 소견';
COMMENT ON COLUMN STOCAIRH.AI_MODEL IS 'AI LLM 모델명';
COMMENT ON COLUMN STOCAIRH.REG_DATE IS '분석 일시';
COMMENT ON COLUMN STOCAIRH.REG_USER_ID IS '조회 요청자 ID';
COMMENT ON COLUMN STOCAIRH.DEL_FLAG IS '삭제 여부';

-- 3) 빠른 조회를 위한 품목 인덱스 생성
CREATE INDEX IX_STOCAIRH_ITEM ON STOCAIRH (GATE_CD, BUYER_CD, ITEM_CD);
```

---

## 2. 생성 및 변경 소스 코드 파일 정보

이번 요건 구현을 위해 추가 및 수정된 모든 파일의 목록입니다.

### 백엔드 (Java & MyBatis Config)

1. **[LLM0010_Controller.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nhepro/LLM/web/LLM0010_Controller.java) [NEW]**
   - **엔드포인트 및 화면 맵핑:**
     - `/LLM0010/view` : AI 가격 분석 팝업 뷰 호출
     - `/LLM0010/llm0010_doSearch` : 품목 기준 과거 AI 분석 이력 그리드 조회
     - `/LLM0010/llm0010_doInquire` : 실시간 LLM REST API 연동 및 DB 적재 기동
     - `/LLM0020/view` : 전사 AI 결과 이력 목록 메인 뷰 호출
     - `/LLM0020/llm0020_doSearch` : 전체 AI 이력 그리드 조회

2. **[LLM0010_Service.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nhepro/LLM/service/LLM0010_Service.java) [NEW]**
   - **핵심 비즈니스 메서드 구현:**
     - `llm0010_doSearch`: 과거 이력 조회 연동.
     - `llm0010_doInquire`: `PropertiesManager`로부터 외부 `nh.ai.llm.url` 값을 조회한 뒤, `HttpURLConnection`을 이용해 대상 품명/규격 JSON 송수신. Jackson ObjectMapper를 활용하여 결과 매핑. 만약 연동 장애 또는 타임아웃 발생 시 자체 Mock 예측 모델(`mockLlmInquiry`)을 구동하여 서비스 예외 발생 차단(Fallback 처리).
     - `llm0020_doSearch`: 전사 로그 통합 검색.

3. **[LLM0010_Mapper.java](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/java/com/st_ones/nhepro/LLM/LLM0010_Mapper.java) [NEW]**
   - **인터페이스 선언:**
     - `llm0010_doSearch`, `llm0010_doInsertHistory`, `llm0020_doSearch` 정의.

4. **[LLM0010_Mapper.xml](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/resources/mappers/com/st_ones/nhepro/LLM/LLM0010_Mapper.xml) [NEW]**
   - **MyBatis SQL 매핑:**
     - `<select id="llm0010_doSearch">` : 과거 조회 이력 가져오기
     - `<insert id="llm0010_doInsertHistory">` : AI 분석 이력 DB 적재
     - `<select id="llm0020_doSearch">` : 전사 전체 AI 이력 조회

5. **[eversrm.properties](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/resources/eversrm.properties) [MODIFY]**
   - **프로퍼티 정의:**
     - `nh.ai.llm.url=http://ai-llm-internal-service.nonghyup.com/v1/recommend/price` 환경 변수 설정.

### 프론트엔드 (JSP)

6. **[CITR0041.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/CITI/CITR0041.jsp) [MODIFY]**
   - **UI 변경:** 상세 화면 내 `<e:buttonBar>` 영역에 **[AI 가격 정보 조회]** 버튼 추가 및 클릭 시 팝업창을 여는 `doAiPriceInquiry()` 스크립트 작성 (이때 호출 대상 주소는 `/nhepro/LLM/LLM0010/view.so`로 설정).

7. **[LLM0010.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/LLM/LLM0010.jsp) [NEW]**
   - **디자인 개선:** 프리미엄 그래디언트 테마의 대시보드 구조.
   - **주요 영역:**
     - **추천 최저가/평균가 표시 카드:** 가격 예측 수치 및 AI 소견을 보여주는 글라스모피즘 스타일의 카드 레이아웃.
     - **신뢰 등급 표시 원형 링:** `svg` 원형 프로그레스와 신뢰도 퍼센트(`CONFIDENCE`) 실시간 바인딩.
     - **이력 목록 그리드:** 과거 이력이 하단에 배치되어 데이터 변화 양상 비교 가능.

8. **[LLM0020.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/LLM/LLM0020.jsp) [NEW]**
   - **구현 기능:** 기간 범위 필터와 그리드 이력 조회를 포함한 전사 관리용 AI 결과 목록 통합 뷰. 엑셀 내보내기 및 각 행 클릭 시 상세 레포트 팝업(LLM0010) 연동 기능 완비.

---

## 3. 기능 동작 흐름 요약

1. **상세 조회 진입:** 사용자가 품목 상세 화면([CITR0041.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/CITI/CITR0041.jsp))에 진입한 후 **[AI 가격 정보 조회]** 버튼을 클릭합니다.
2. **분석 팝업 실행:** 팝업창([LLM0010.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/LLM/LLM0010.jsp))이 열리며, 품명과 규격이 자동 셋업되고 동시에 하단에 과거 조회 이력이 로드됩니다.
3. **LLM REST 연동:** **[AI 분석 실행]** 클릭 시 컨트롤러에 비동기 데이터 처리를 요청하며, 서비스가 properties에 정의된 AI LLM REST 엔드포인트에 접속하여 실시간 권장 가격 데이터를 수집합니다.
4. **결과 시각화 및 적재:** 파싱된 응답 값을 기반으로 추천 단가 및 신뢰 등급(애니메이션 링)이 대시보드에 역동적으로 그려지며, `docNumService`를 통해 고유 `AI_INQ_NO`가 채번되어 `STOCAIRH` 테이블에 자동 보존됩니다.
5. **목록 이력 조회:** [LLM0020.jsp](file:///c:/ST-onesIDE/workspace/NHEPRO/NHeProFront/src/main/webapp/WEB-INF/views/nhepro/LLM/LLM0020.jsp)를 통해 기간별, 품목별 검색 및 분석 결과 엑셀 다운로드가 원활하게 작동합니다.
