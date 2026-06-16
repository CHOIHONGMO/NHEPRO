<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<e:ui locale="${ses.countryCd}" lang="${ses.langCd}" dateFmt="${ses.dateFormat}">
    <style>
        .ai-dashboard {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            font-family: 'Inter', 'Noto Sans KR', sans-serif;
        }
        .ai-price-card {
            flex: 2;
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.92), rgba(15, 23, 42, 0.95));
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 20px;
            color: #f8fafc;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            backdrop-filter: blur(8px);
        }
        .ai-side-card {
            flex: 1;
            background: linear-gradient(135deg, rgba(17, 24, 39, 0.95), rgba(31, 41, 55, 0.95));
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 20px;
            color: #f8fafc;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.25);
            backdrop-filter: blur(8px);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .card-header-title {
            font-size: 14px;
            font-weight: 600;
            color: #38bdf8;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        .price-box {
            flex: 1;
            padding: 10px 15px;
            background: rgba(255, 255, 255, 0.03);
            border-radius: 8px;
            border-left: 4px solid #64748b;
        }
        .price-box.lowest {
            border-left-color: #f43f5e;
            margin-right: 15px;
        }
        .price-box.average {
            border-left-color: #0ea5e9;
        }
        .price-label {
            font-size: 12px;
            color: #94a3b8;
            margin-bottom: 4px;
        }
        .price-value {
            font-size: 24px;
            font-weight: 800;
            color: #ffffff;
        }
        .price-unit {
            font-size: 13px;
            font-weight: normal;
            color: #94a3b8;
            margin-left: 4px;
        }
        .ai-report-box {
            background: rgba(255, 255, 255, 0.02);
            border: 1px dashed rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 13px;
            line-height: 1.6;
            color: #cbd5e1;
            max-height: 120px;
            overflow-y: auto;
        }
        .circle-progress-wrapper {
            position: relative;
            width: 110px;
            height: 110px;
            margin: 10px 0;
        }
        .circle-bg {
            fill: none;
            stroke: rgba(255, 255, 255, 0.05);
            stroke-width: 8;
        }
        .circle-progress {
            fill: none;
            stroke: #10b981;
            stroke-width: 8;
            stroke-linecap: round;
            transform: rotate(-90deg);
            transform-origin: 50% 50%;
            transition: stroke-dasharray 0.8s ease;
        }
        .circle-percentage {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 22px;
            font-weight: 800;
            color: #10b981;
        }
        .ai-model-badge {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid rgba(16, 185, 129, 0.3);
            color: #34d399;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            margin-top: 15px;
        }
        .loading-overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(4px);
            z-index: 100;
            justify-content: center;
            align-items: center;
            color: #38bdf8;
            font-size: 16px;
            font-weight: 600;
            border-radius: 12px;
        }
    </style>
    <script>
        var grid;
        var baseUrl = "/nhepro/LLM/LLM0010/";

        function init() {
            grid = EVF.C("grid");
            
            // 팝업 기동 시 즉시 해당 품목의 과거 AI 분석 이력 검색
            doSearch();
        }

        function doSearch() {
            var store = new EVF.Store();
            store.setGrid([grid]);
            store.load(baseUrl + "llm0010_doSearch.so", function () {
                grid.setProperty('shrinkToFit', true);
            });
        }

        function doInquire() {
            var store = new EVF.Store();
            if(!store.validate()) return;

            // 로딩 오버레이 활성화
            $("#loadingOverlay").css("display", "flex");

            store.load(baseUrl + "llm0010_doInquire.so", function () {
                $("#loadingOverlay").css("display", "none");
                
                var success = this.getParameter("isSuccess");
                
                // 데이터 받아오기
                var minPrice = this.getParameter("MIN_PRICE");
                var avgPrice = this.getParameter("AVG_PRICE");
                var confidence = this.getParameter("CONFIDENCE");
                var aiModel = this.getParameter("AI_MODEL");
                var analysisResult = this.getParameter("ANALYSIS_RESULT");

                // 실시간 UI 업데이트
                if (minPrice != null && minPrice !== "") {
                    $("#txtMinPrice").text(parseFloat(minPrice).toLocaleString("ko-KR"));
                }
                if (avgPrice != null && avgPrice !== "") {
                    $("#txtAvgPrice").text(parseFloat(avgPrice).toLocaleString("ko-KR"));
                }
                if (confidence != null && confidence !== "") {
                    $("#txtConfidence").text(parseFloat(confidence).toFixed(1) + "%");
                    
                    var strokeDasharray = 289;
                    var offset = strokeDasharray - (parseFloat(confidence) / 100) * strokeDasharray;
                    $("#circleProgress").css("stroke-dasharray", strokeDasharray);
                    $("#circleProgress").css("stroke-dashoffset", offset);
                }
                if (aiModel != null && aiModel !== "") {
                    $("#txtAiModel").text(aiModel);
                }
                if (analysisResult != null && analysisResult !== "") {
                    $("#txtAnalysisResult").text(analysisResult);
                }

                EVF.alert("AI 분석이 성공적으로 실행되었습니다.", function() {
                    doSearch();
                });
            });
        }

        function doClose() {
            EVF.closeWindow();
        }
    </script>
    <e:window id="LLM0010" onReady="init" initData="${initData}" title="${fullScreenName}">
        <e:buttonBar align="right" width="100%">
            <e:button id="doInquire" name="doInquire" label="AI 분석 실행" onClick="doInquire" />
            <e:button id="doClose" name="doClose" label="닫기" onClick="doClose" />
        </e:buttonBar>

        <e:searchPanel id="form" title="대상 품목 정보" labelWidth="${labelWidth}" width="100%" columnCount="3" useTitleBar="false">
            <e:row>
                <%-- 품목코드 --%>
                <e:label for="ITEM_CD" title="${form_ITEM_CD_N}" />
                <e:field>
                    <e:inputText id="ITEM_CD" name="ITEM_CD" value="${form.ITEM_CD}" width="100%" readOnly="true" />
                </e:field>
                <%-- 품명 --%>
                <e:label for="ITEM_DESC" title="${form_ITEM_DESC_N}" />
                <e:field>
                    <e:inputText id="ITEM_DESC" name="ITEM_DESC" value="${form.ITEM_DESC}" width="100%" required="true" />
                </e:field>
                <%-- 규격 --%>
                <e:label for="ITEM_SPEC" title="${form_ITEM_SPEC_N}" />
                <e:field>
                    <e:inputText id="ITEM_SPEC" name="ITEM_SPEC" value="${form.ITEM_SPEC}" width="100%" />
                </e:field>
            </e:row>
        </e:searchPanel>

        <!-- AI 추천 대시보드 UI 영역 -->
        <div style="position: relative; margin-top: 15px;">
            <!-- 로딩 화면 -->
            <div id="loadingOverlay" class="loadingOverlay">
                <div style="text-align: center;">
                    <img src="/images/loading.gif" style="display: block; margin: 0 auto 10px; width: 40px; height: 40px;" />
                    <span>농협 내부 LLM 분석엔진 연동 중...</span>
                </div>
            </div>

            <div class="ai-dashboard">
                <!-- 가격 분석 카드 -->
                <div class="ai-price-card">
                    <div class="card-header-title">
                        <span style="color: #38bdf8;">📊</span> AI 가격 예측 분석
                    </div>
                    <div class="price-row">
                        <div class="price-box lowest">
                            <div class="price-label">추천 최저가</div>
                            <div class="price-value"><span id="txtMinPrice">0</span><span class="price-unit">KRW</span></div>
                        </div>
                        <div class="price-box average">
                            <div class="price-label">추천 평균가</div>
                            <div class="price-value"><span id="txtAvgPrice">0</span><span class="price-unit">KRW</span></div>
                        </div>
                    </div>
                    <div class="card-header-title" style="margin-top: 20px; margin-bottom: 8px;">
                        <span>📝</span> AI 종합 상세 분석 소견
                    </div>
                    <div id="txtAnalysisResult" class="ai-report-box">
                        [AI 분석 실행] 버튼을 클릭하면 농협 정보 내부 LLM 서비스로부터 가격 정보를 도출하여 상세 분석 소견을 작성합니다.
                    </div>
                </div>

                <!-- 신뢰도/모델 카드 -->
                <div class="ai-side-card">
                    <div class="card-header-title" style="margin-bottom: 5px;">
                        🎯 신뢰 등급
                    </div>
                    <div class="circle-progress-wrapper">
                        <svg width="110" height="110">
                            <circle class="circle-bg" cx="55" cy="55" r="46" />
                            <circle id="circleProgress" class="circle-progress" cx="55" cy="55" r="46" style="stroke-dasharray: 289; stroke-dashoffset: 289;" />
                        </svg>
                        <div id="txtConfidence" class="circle-percentage">0.0%</div>
                    </div>
                    <div id="txtAiModel" class="ai-model-badge">NH-LLM-v2.0</div>
                </div>
            </div>
        </div>

        <!-- 과거 조회 이력 그리드 -->
        <e:gridPanel id="grid" name="grid" height="230px" gridType="${_gridType}" readOnly="true" />
    </e:window>
</e:ui>
