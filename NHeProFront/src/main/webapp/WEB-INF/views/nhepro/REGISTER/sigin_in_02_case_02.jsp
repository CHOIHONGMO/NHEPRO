<!doctype html>
<html lang="ko">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="Referrer" content="origin">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="apple-mobile-web-app-title" content="FIRSTePro" />
  <meta name="robots" content="index,nofollow"/>
  <meta name="description" content="FIRSTePro"/>
  <meta name="keywords" content="FIRSTePro"/>
  <meta name="format-detection" content="telephone=no"/>
  <title>FIRSTePro 빠르고 투명한 전자구매/계약 서비스</title>
  <link rel="stylesheet" href="../css/fonts/NanumGothic.css">
  <link rel="stylesheet" href="../css/bootstrap.min.css">
  <script src="../js/bundle.js"></script>
</head>

<body>
<div class="wrap">
  <header>
  <div class="box">
    <div class="nav_top">
      <ul class="clearfix">
        <li><a href="#">HOME</a></li>
        <li><a href="#">FAQ</a></li>
        <li><a href="#">회원가입</a></li>
      </ul>
    </div>
    <!--  수정사항    -->
    <!--  2020-03-12    -->
    <!--  a태그 링크 수정    -->
    <div>
      <nav class="navbar navbar-expand">
        <h1><a class="navbar-brand" href="index.html"><img src="../img/common/logo_firstepro.png" alt="FIRSTePro"></a>
        </h1>
        <div class="collapse navbar-collapse">
          <ul class="navbar-nav mr-auto">
            <li class="nav-item active">
              <a class="nav-link" href="#">서비스안내</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">고객지원센터</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">회사소개</a>
            </li>
          </ul>
        </div>
      </nav>
    </div>
  </div>
</header>

  <section class="personal sign_in">
    <h2 class="sr-only">회원가입</h2>
    <div class="title">
      <p>회원가입</p>
    </div>
    <div class="box">
      <div class="content">
        <div class="clearfix pb-3">
          <ul class="step">
            <li class="active">STEP 1. 약관동의</li>
            <li class="current">STEP 2. 정보입력</li>
            <li>STEP 3. 가입완료</li>
          </ul>
        </div>
        <div class="p-content">
          <p class="p-title">회원사 정보</p>
          <form>
            <div class="row">
              <p class="title"><i class="fas fa-dot-circle"></i>기본정보</p>
            </div>
            <div class="row ">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>회사명(국문)<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>회사명(영문)</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>사업자등록번호<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="" disabled>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>사업자구분<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>법인등록번호</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="-없이 입력해 주세요.">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>기업규모<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>대표자명<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>설립일자<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a class="btn btn-outline-light btn-calendar add-on"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>농협구분<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>법인구분(농협일경우)</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="row double">
              <div class="col-12">
                <div class="row">
                  <div class="col-title">
                    <span>주소<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <div class="row">
                      <div class="input-group" style="width: 366px">
                        <input class="form-control" type="search" placeholder="" aria-label="Search">
                        <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                      </div>
                    </div>
                    <div class="row">
                      <input type="text" class="form-control d-inline mr-2" title="example" placeholder="" style="width: 554px">
                      <input type="text" class="form-control d-inline" title="example" placeholder="" style="width: 380px">
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>업태<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>종목<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>대표전화번호<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="tel" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>대표팩스번호</span>
                  </div>
                  <div class="col-desc">
                    <input type="tel" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>대표 e-mail<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="email" class="form-control" title="example" placeholder="Email 형식에 맞게 입력해 주세요.">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>홈페이지</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
            </div>
            <div class="row double">
              <div class="col-12">
                <div class="row">
                  <div class="col-title">
                    <span>회사소개</span>
                  </div>
                  <div class="col-desc">
                    <textarea title="text" style="width:100%; height: 100%; resize: none"></textarea>
                  </div>
                </div>
              </div>
            </div>
            <div class="row double">
              <div class="col-12">
                <div class="row">
                  <div class="col-title">
                    <span>특이사항</span>
                  </div>
                  <div class="col-desc">
                    <textarea title="text" style="width:100%; height: 100%; resize: none"></textarea>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row border-0">
              <p class="title"><i class="fas fa-dot-circle"></i>특허 및 취급면허</p>
            </div>
            <div class="p-table">
              <table class="table">
                <colgroup>
                  <col width="5%" />
                  <col width="18%" />
                  <col width="18%" />
                  <col width="18%" />
                  <col width="17%" />
                  <col width="17%" />
                  <col width="5" />
                </colgroup>
                <thead class="thead-light">
                <tr>
                  <th scope="col">선택</th>
                  <th scope="col">구분</th>
                  <th scope="col">특허/면허 번호</th>
                  <th scope="col">특허/면허 명</th>
                  <th scope="col">발급처</th>
                  <th scope="col">유효기간</th>
                  <th scope="col">첨부파일</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                  <td>
                    <div class="custom-control custom-checkbox custom-checkbox-sm">
                      <input type="checkbox" class="custom-control-input" title="text">
                      <label class="custom-control-label font-weight-bold"></label>
                    </div>
                  </td>
                  <td>
                    <select class="custom-select" title="Text">
                      <option selected="">특허/면허</option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="custom-control custom-checkbox custom-checkbox-sm">
                      <input type="checkbox" class="custom-control-input" title="text">
                      <label class="custom-control-label font-weight-bold"></label>
                    </div>
                  </td>
                  <td>
                    <select class="custom-select" title="Text">
                      <option selected="">특허/면허</option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td>
                    <div class="custom-control custom-checkbox custom-checkbox-sm">
                      <input type="checkbox" class="custom-control-input" title="text">
                      <label class="custom-control-label font-weight-bold"></label>
                    </div>
                  </td>
                  <td>
                    <select class="custom-select" title="Text">
                      <option selected="">특허/면허</option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <input type="text" class="form-control" title="example" placeholder="">
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                </tbody>
              </table>
              <div class="btn-area">
                <a href="#" class="btn btn-outline-secondary">행추가</a>
                <a href="#" class="btn btn-outline-secondary">행삭제</a>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row">
              <p class="title"><i class="fas fa-dot-circle"></i>재무정보<span class="font-weight-normal"> (직전년도 정보 입력가능, 신규 업체인 경우 입력 미입력 가능)</span><span class="right">단위(원)</span></p>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>기준년도</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>자료근거</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>총자산</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="(자동계산)" readonly>
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>총자본</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>총부채</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>부채비율</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="(자동계산)" readonly>
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>유동자산</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>유동부채</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>유동비율</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="(자동계산)" readonly>
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>총매출액</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>당기순이익</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>첨부파일</span>
                  </div>
                  <div class="col-desc">
                    <div class="input-group">
                      <input class="form-control" type="search" placeholder="" aria-label="Search">
                      <button class="btn btn-outline-light btn-search"><i class="far fa-search"></i></button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row">
              <p class="title"><i class="fas fa-dot-circle"></i>관리정보</p>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>계산서발행구분<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title line-2">
                    <span>계산서<br/>발행사이트</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>발행타입<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>신용평가사</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>신용등급</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>첨부파일</span>
                  </div>
                  <div class="col-desc">
                    <div class="input-group">
                      <input class="form-control" type="search" placeholder="" aria-label="Search">
                      <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row">
              <p class="title"><i class="fas fa-dot-circle"></i>결제정보</p>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>전산담당자<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>연락처<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>e-Mail<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>은행 및 지점명</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>계좌번호</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>예금주</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row row-3">
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>지급조건</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>지급형태</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-4">
                <div class="row">
                  <div class="col-title">
                    <span>계산서발행조건</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row border-0">
              <p class="title"><i class="fas fa-dot-circle"></i>첨부파일</p>
            </div>
            <div class="p-table">
              <table class="table">
                <colgroup>
                  <col width="32%">
                  <col width="15%">
                  <col width="18%">
                  <col width="18%">
                  <col width="8%">
                  <col width="8%">
                </colgroup>
                <thead class="thead-light">
                <tr>
                  <th scope="col">서류명</th>
                  <th scope="col">유효기간</th>
                  <th scope="col">유효시작일</th>
                  <th scope="col">유효종료일</th>
                  <th scope="col">필수여부</th>
                  <th scope="col">첨부파일</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                  <td class="text-left">
                    사업자등록증 사본(원본대조필)
                  </td>
                  <td>
                    1년
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td class="text-left">
                    법인등기부등본
                  </td>
                  <td>
                    3개월
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td class="text-left">
                    법인인감증명
                  </td>
                  <td>
                    3개월
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search" type="submit"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td class="text-left">
                    통장사본(원본대조필)
                  </td>
                  <td>
                    1년
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search" type="submit"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td class="text-left">
                    회사소개서
                  </td>
                  <td>
                    1년
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search" type="submit"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                <tr>
                  <td class="text-left">
                    기업신용평가표
                  </td>
                  <td>
                    1년
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="2020.03.00" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    <div class="input-group date" data-provide="datepicker" data-date-today-highlight="true" data-date-language="kr" data-date-format="yyyy-mm-dd" autoclose="true">
                      <input type="text" id="datePicker" class="form-control" value="" title="datepicker" data-autohide="true">
                      <a href="#" class="btn btn-outline-light btn-calendar add-on" type="submit"><i class="far fa-calendar-alt"></i></a>
                    </div>
                  </td>
                  <td>
                    여
                  </td>
                  <td>
                    <a href="#" class="btn btn-outline-light btn-search" type="submit"><i class="far fa-search"></i></a>
                  </td>
                </tr>
                </tbody>
              </table>
            </div>
          </form>
        </div>
        <div class="p-content">
          <form>
            <div class="row">
              <p class="title"><i class="fas fa-dot-circle"></i>관리자 정보</p>
            </div>
            <div class="row ">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>사용자 ID<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control d-inline-block" title="example" placeholder="" style="width: 279px">
                    <a href="#" class="btn btn-outline-secondary d-inline-block">중복체크</a>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>사용자명<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>비밀번호<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="" disabled="">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>비밀번호확인<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>전화번호<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="tel" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>e-Mail<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="email" class="form-control" title="example" placeholder="Email 형식에 맞게 입력해 주세요.">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>팩스번호</span>
                  </div>
                  <div class="col-desc">
                    <input type="tel" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>휴대전화<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <input type="email" class="form-control" title="example" placeholder="EX) 000-000-0000">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>메일수신여부<i class="far fa-check"></i></span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>SMS 수신여부</span>
                  </div>
                  <div class="col-desc">
                    <select class="custom-select" title="Text">
                      <option selected=""></option>
                      <option value="1">Text</option>
                      <option value="2">Text</option>
                      <option value="3">Text</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>직위(직급)</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="row">
                  <div class="col-title">
                    <span>직책</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-12">
                <div class="row">
                  <div class="col-title">
                    <span>담당업무</span>
                  </div>
                  <div class="col-desc">
                    <input type="text" class="form-control" title="example" placeholder="">
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>
        <div class="p-content">
          <div class="btn-area">
            <button class="btn btn-xl btn-primary mr-3">가입등록</button>
            <button class="btn btn-xl btn-primary">가입취소</button>
          </div>
        </div>
      </div>
    </div>
  </section>
  <footer>
  <div class="box">
    <div class="row no-gutters">
      <div class="offset-3 col-9">
        <ul class="c-intro clearfix">
          <li><a href="#">회사소개</a></li>
          <li><a href="#">서비스이용약관</a></li>
          <li><a class="font-weight-bold" href="#">개인정보처리방침</a></li>
        </ul>
      </div>
    </div>
  </div>
  <div class="bg">
    <div class="box">
      <div class="row no-gutters">
        <div class="col-3">
          <div class="img">
            <img src="../img/common/logo_footer.png" alt="농협정보시스템">
          </div>
        </div>
        <div class="col-9">
          <ul class="c-info">
            <li>
              <span class="bar">상호 : (주)농협정보시스템</span>
              <span class="bar">대표이사 : 이구환</span>
              <span>사업자등록번호 : 120-87-01755</span>
            </li>
            <li>
              <span class="bar font-weight-bold">대표전화 : <a href="tel:031-738-8157">031-738-8157</a></span>
              <span class="bar">팩스 : <a href="tel:031-738-8199">031-738-8199</a></span>
              <span class="font-weight-bold">대표이메일 : <a href="mailto:mhebill@nonghyup.com/">mhebill@nonghyup.com</a></span>
            </li>
            <li>
              <span>주소 : 서울특별시 서초구 매헌로 24 농협양재전산센터</span>
            </li>
            <li>
              <span>COPYRIGHTⓒ 2018 NH INFORMATION SYSTEM CO.,LTD ALL RIGHTS RESERVED.</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</footer>

</div>
</body>
</html>
