<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 페이지</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
 <!-- CSS 임포트 -->
 <link rel="stylesheet" href="resources/css/newbie.css">
 
 <style>
 /*글꼴 임포트 https://fonts.google.com/specimen/Lobster#standard-styles*/
 	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
 	/*위는 h태그에 사용할 글꼴, 아래는 한글 텍스트에 사용할 글꼴*/
 	@import url('https://fonts.googleapis.com/css2?family=Single+Day&display=swap');
 </style>
</head>
<body>
<h2><a href="home">del Luna</a></h2>
<form method="post" action="signUp" id="newJoin">
	<p>이름(실명)<br>
	<input type="text" name="realName"><br></p>
	<p>로그인 아이디<br>
	<input type="text" name="newId"><br></p>
	<p>비밀번호<br>
	<input type="password" name="pw1"><br></p>
	<p>비밀번호 확인<br>
	<input type="password" name="pw2"><br><br></p>
	<p><input type="submit" value="회원가입"></p>
</form>
</body>
<script src="https://code.jquery.com/jquery-3.5.0.js"></script>
<script>
$(document)
.on('submit','#newJoin',function(){
	if($('input[name=realName]').val()==''){
		alert('이름을 입력하세요');
		return false;
	}
	if($('input[name=newId]').val()==''){
		alert('ID를 입력하세요');
		return false;
	}
	if($('input[name=pw1]').val()==''){
		alert('비밀번호를 입력하세요');
		return false;
	}
	if($('input[name=pw2]').val()==''){
		alert('비밀번호가 일치하지 않습니다');
		return false;
	}
	alert('회원가입이 완료되었습니다');
	return true;
})
</script>
</html>