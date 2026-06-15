<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="e" uri="http://www.st-ones.com/eversrm" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>계약서 출력</title>
    <link href="/css/print.css" media="print"/>
    <link href="/js/ckeditor/contents.css?t=E8PB" media="print"/>
    <script type="text/javascript">
    	
        function init() {
        	// BECM_050, SECM_010은 detailView는 false
        	// 리스마스터에서 가상로그인으로 호출시 detailView는 true
        	if( ${not param.detailView eq 'true'} ){
                window.print();
        	}
        }

		function doPdf() {
			var pdf = new jsPDF('p', 'mm', 'a4');
			var canvas = pdf.canvas;
			var pageWidth = 210; //캔버스 너비 mm
			var pageHeight = 295; //캔버스 높이 mm
			canvas.width = pageWidth;

			var ele = document.querySelector("#cont_content");
			var width = ele.offsetWidth; // 셀렉트한 요소의 px 너비
			var height = ele.offsetHeight; // 셀렉트한 요소의 px 높이
			var imgHeight = pageWidth * height/width; // 이미지 높이값 px to mm 변환

			if(!ele){
				console.warn(selector + ' is not exist.');
				return false
			}

			html2canvas(ele, {
				onrendered: function(canvas) {
					// jsPDF 객체 생성 생성자에는 가로, 세로 설정, 페이지 크기 등등 설정할 수 있다. 자세한건 문서 참고.
					// 현재 파라미터는 기본값이다 굳이 쓰지 않아도 되는데 저것이 기본값이라고 보여준다.

					var position = 0;
					var imgData = canvas.toDataURL('image/png');
					pdf.addImage(imgData, 'png', 0, position, pageWidth, imgHeight, undefined, 'slow');
					//Paging 처리
					var heightLeft = imgHeight; //페이징 처리를 위해 남은 페이지 높이 세팅.
					heightLeft -= pageHeight;
					while (heightLeft >= 0) {
						position = heightLeft - imgHeight;
						pdf.addPage();
						pdf.addImage(imgData, 'png', 0, position, pageWidth, imgHeight);
						heightLeft -= pageHeight;

					}
					pdf = addWaterMark(pdf);
					pdf.save('sample.pdf');
				}
			});
		}

		function doPdf2() {
			var ele = document.querySelector("#cont_content");

			html2canvas(ele, {
				onrendered: function(canvas) {
					var imgData = canvas.toDataURL('image/png');

					var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
					var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
					var imgHeight = canvas.height * imgWidth / canvas.width;
					var heightLeft = imgHeight;

					var doc = new jsPDF('p', 'mm', 'a4');
					var position = 0;

					// 첫 페이지 출력
					doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
					heightLeft -= pageHeight;

					// 한 페이지 이상일 경우 루프 돌면서 출력
					while (heightLeft >= 20) {
						position = heightLeft - imgHeight;
						doc.addPage();
						doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
						heightLeft -= pageHeight;
					}

					// 파일 저장
					doc.save('sample_A4.pdf');
				}
			});
		}

		function doPdf3() {
			var store = new EVF.Store();
			store.setParameter("cont_content", $('#cont_content').html());
			store.load('/eversrm/eContract/eContractMgt/BECM_060/doPdf.so', function () {

			});
		}

		function doPdf4() {
        	/*
        	var url = "http://localhost/ConvertService.ashx";
			var data = {
				"async": false,
				"filetype": "docx",
				"key": EVF.getUUID(true).substr(1, 13),
				"outputtype": "pdf",
				"title": "Example Document Title.docx",
				"url": "https://example.com/url-to-example-document.docx",
				"endConvert": true,
				"fileUrl": "https://localhost/ResourceService.ashx?filename=output.doc",
				"percent": 100
			};

			$('#form')[0].submit();

			$.ajax({
				"url": 'http://localhost/ConvertService.ashx',
				"dataType": 'jsonp',
				"data" : {
					"async": false,
					"filetype": "docx",
					"key": EVF.getUUID(true).substr(1, 13),
					"outputtype": "pdf",
					"title": "Example Document Title.docx",
					"url": "https://example.com/url-to-example-document.docx",
					"endConvert": true,
					"fileUrl": "https://localhost/ResourceService.ashx?filename=output.doc",
					"percent": 100
				},
				success: function(data) {
					console.log(data);
				}
			});
			*/

			var config = {
				"document": {
					"fileType": "docx",
					"key": EVF.getUUID(true).substr(1, 13),
					"url": "http://localhost:8082/cccc.html"
				},
				"documentType": "text",
				"editorConfig": {
					"callbackUrl": "http://localhost/url-to-callback.ashx"
				}
			};

			var docEditor = new DocsAPI.DocEditor("placeholder", config);
		}

		function addWaterMark(doc) {
			var totalPages = doc.internal.getNumberOfPages();

			for (i = 1; i <= totalPages; i++) {
				doc.setPage(i);
				//doc.addImage(imgData, 'PNG', 40, 40, 75, 75);
				doc.setTextColor(150);
				doc.text(50, doc.internal.pageSize.height - 30, 'Watermark');
			}

			return doc;
		}
	</script>
</head>

<body onload="init();">
	
	<div id="cont_content">
		<div>
			${fn:replace(fn:replace(fn:replace(formContents,'&lt;','<'), '&gt;', '>'),'&quot;','\"') }
		</div>
		<c:forEach items="${additionalFormContents}" var="datum" varStatus="status">
			<div style="page-break-after: always; page-break-inside: avoid;"/>
			<div>
				${fn:replace(fn:replace(fn:replace(datum.CONTRACT_TEXT, '&lt;', '<'), '&gt;', '>'),'&quot;', '\"')}
			</div>
		</c:forEach>
	</div>
</body>
</html>
