# **EverUX Framework**
EverUX Framework는 2013년 7월을 시작으로 현재까지 개발되어 왔습니다.
전용 커스텀태그(e)를 지원하여 모든 JSP에 대해 동일한 디자인으로 개발될 수 있으며, 화면에 구성된 입력컴포넌트들을, 제공된 자바스크립트 API를 통해 편하게 제어할 수 있습니다. 

**컴파일 환경**
- JDK 6.0

**구조**
- Server
  - /src/main/webapp/WEB-INF/lib/everuxf-1.1.jar
  - /src/main/resources/everuxf.properties

- Client
  - /src/main/webapp/js/everuxf/everuxf.min.js
  - /src/main/webapp/css/everuxf/neo/everuxf.min.css
  - 라이선스 파일(licenseKey.js)
  - 이미지
  - 각종 스크립트 라이브러리 

**흐름(Flow)**
- 화면
    1.  **/view.so 로 화면을 호출
    2.  Custom Tag 컴파일/ 로드
    3.  Tag Class 에서 HTML 렌더링, FrontEnd 스크립트 생성
    4.  HTML 로드, Component 객체 생성
- 통신
    1. EVF.Store 객체 생성 및 URL 설정
    2. load() 함수를 통해 ajax 비동기 통신
    3. Controller -> Service -> DB Transaction 후 callback 함수 호출
    4. callBack 함수에서 결과 처리

##### FrontEnd Component

- Custom Tag로 구현
- Tag 속성에 ID, Name, Event 등을 설정
- 종류
    - Container Component
        - Abstract Container를 상속하여 API 활용
        - 입력 컴포넌트들을 담는 역할
        - 종류

            1.  UI
                - html 태그로 변환
                - 필수 스크립트 라이브러리, CSS 등의 링크

            2.  Window
                - body 태그로 변환
                - 화면의 이름, 프레임웍용 내부 데이터 설정

            3. SearchPanel
                - table 태그로 변환
                - 입력 컴포넌트를 표로 표현하기 위한 컨테이너
                - 자식 컴포넌트
                    1. Row
                        - tr 태그
                    2. Label
                        - td 태그
                        - 컴포넌트 이름, 필수여부를 표시할 때 사용
                    3. Field
                        - td 태그
                        - 입력 컴포넌트, 버튼, 텍스트 등을 표현할 때 사용
            4. GridPanel
                - div 태그로 변환
                - RealGrid를 담는 컨테이너
            5. TabPanel
                - div 태그로 변환
                - 탭 구현 시 사용하는 컨테이너
            6. Panel
                - div 태그로 변환
                - 화면 분할 등의 특수한 경우 사용
            7. ButtonBar
                - div 태그로 변환
                - 버튼을 담는 컨테이너
            8. CheckGroup
                - div 태그로 변환
                - 체크박스를 담는 컨테이너
            9. RadioGroup
                - div 태그로 변환
                - 라디오버튼을 담는 컨테이너
            10. TreePanel
                - div 태그로 변환
                - 현재는 중메뉴 트리를 출력하기 위해 구현됨
                - 자식 컴포넌트
                    1. Tab
                        - div 태그
                        - 각각의 탭을 구현하기 위한 컨테이너

    - Input Component
        - AbstractComponent를 상속하여 API 활용
        - 사용자의 데이터 입력 또는 출력 역할
        - 종류
            1. InputText
            2. InputDate
            3. InputPassword
            4. InputNumber
            5. InputHidden
            6. Search
            7. Select
            8. TextArea
            9. RichTextEditor
            10. FileManager
                - 파일매니저는 STOCATCH 테이블과 연동되어 UUID, UUID_SEQ 라는 키 값으로 관리
                - 
                - 
            11. Check
            12. Radio

    - Helper Component
        - Container, Input Component를 제외한 Component
        - AbstractComponent를 상속
        - 화면에 텍스트를 표현하기 위한 공통 컴포넌트
        - 종류
            1.  Button
            2.  Title
            3.  Text


### **Event**

**커스텀태그 속성을 통한 정적 이벤트 설정**

- Container Component
	1.  SearchPanel
       - onEnter

- InputComponent

    1. 컴포넌트 공통 이벤트
       - onChange
       - onClick
       - onKeyDown
       - onKeyUp
       - onKeyPress
       - onFocus
       - onDblClick

    2. InputDate
	   - onSelectDate

    3. Search
       - onIconClick

    4. InputText, Search
       - onClear


**스크립트를 통한 동적 이벤트 생성**

GridPanel
- addRowEvent
- delRowEvent
- cellClickEvent
- cellChangeEvent
- excelExportEvent
	- 엑셀 다운로드
- excelImportEvent
	- 엑셀 업로드

API

- Client
    - URL: http://devsiis.sinc.co.kr/docs/frontend/
    - EVF.C(“${ComponentID}”) 로 객체를 가져와서 사용할 수 있다.

- Server

    - URL: http://devsiis.sinc.co.kr/docs/backend/
    - EverHttpRequest
        1. Client에서 요청된 값이 담긴 객체로 입력 컴포넌트, 그리드 데이터 등을 가져올 수 있다.

    - EverHttpResponse
    	1. Client로 보낼 결과를 설정할 수 있다.
[