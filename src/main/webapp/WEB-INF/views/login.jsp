<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 페이지</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
 <!-- CSS 임포트 -->
 <link rel="stylesheet" href="resources/css/login.css">
 <style>
 /*글꼴 임포트 https://fonts.google.com/specimen/Lobster#standard-styles*/
 	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
 	/*위는 h태그에 사용할 글꼴, 아래는 한글 텍스트에 사용할 글꼴*/
 	@import url('https://fonts.googleapis.com/css2?family=Single+Day&display=swap');
 </style>

</head>
<body>
<h2><a href="home">del Luna</a></h2>
<form method="post" action="/app/checkLogin" id="loginUser">
	<p>로그인 아이디 : <input type="text" name="uId" style="height: 35px; font-size: 30px"><br></p>
	<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;비밀번호 : <input type="password" name="uPw" style="height: 35px; font-size: 30px"><br></p>
	<input type="submit" value="로그인">
</form>
</body>
<script src="https://code.jquery.com/jquery-3.5.0.js"></script>
<script>
$(document)
.on('submit', '#loginUser', function(){
	var pstr=$.trim($('input[name=uId]').val());
	$('input[name=uId]').val(pstr);
	pstr=$.trim($('input[name=uPw]').val());
	$('input[name=uPw]').val(pstr);
	if($('input[name=uId]').val()==''){
		alert('로그인 아이디를 입력하세요');
		return false;
	}
	if($('input[name=uPw]').val()==''){
		alert('비밀번호를 입력하세요');
		return false;
	}
})
</script>
</html>