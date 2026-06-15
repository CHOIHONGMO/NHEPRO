<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="/js/everf/everuxf.min.js"></script>

<script type="text/javascript">
	function errorContentsMoveToCenter() {
		var pageHeight = $(document).height();
		var pageWidth = $(document).width();
		var alignHeight = $('#align').height();
		var alignWidth = $('#align').width();
		var centerHeight = pageHeight / 2 - alignHeight / 2 + 'px';
		var centerWidth = pageWidth / 2 - alignWidth / 2 + 'px';
		$('#align').css('top', centerHeight);
		$('#align').css('left', centerWidth);
		var errorContentsHeight = $('#errorContents').height();
		$('#errorContents').css('padding-top', (alignHeight - errorContentsHeight) / 2 + 'px');
	}

	$(window).load(errorContentsMoveToCenter);
	$(window).resize(errorContentsMoveToCenter);
</script>
<style type="text/css">
body {
	background-color: #fff;
	background-position: center;
	text-align: center;
}

#align {
	position: fixed;
	width: 800px;
	height: 600px;
	background-image: url('/images/everuxf/error/bg_error.jpg');
	background-repeat: no-repeat;
}

#errorContents {
	text-align: center;
	vertical-align: middle;
	text-align: center;
}

#errorTitle {
	margin: 0px;
	font-size: 22px;
	font-weight: bold;
	background-image: url('/images/everuxf/error/icon_error.png');
	background-repeat: no-repeat;
	height: 32px;
	text-align: left;
	padding-left: 50px;
	padding-top: 0px;
	margin-left: 20px;
}

#errorMessage {
	font-size: 16px;
	margin: 0px;
}
</style>
</head>
<body>
	<div id="align">
		<div id="errorContents">
			<BR><BR><BR><BR><BR><BR><BR>
			<p id="errorTitle">접근 권한이 없습니다. 관리자에게 문의하시기 바랍니다.</p>
		</div>
	</div>
</body>
</html>