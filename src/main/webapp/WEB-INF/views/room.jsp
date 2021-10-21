<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실관리</title>
    <!-- CSS 임포트 -->
    <link rel="stylesheet" href="resources/css/room.css">
<style>	
 	/*글꼴 임포트 https://fonts.google.com/specimen/Lobster#standard-styles*/
 	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
 	/*위는 h태그에 사용할 글꼴, 아래는 a,h3태그에 사용할 글꼴*/
 	@import url('https://fonts.googleapis.com/css2?family=Single+Day&display=swap');
</style>
</head>
<body>
	<div class="all">
    <div class="menu">
        <!-- 상단 메뉴 -->
        <a href="room">객실관리</a>
       	<a href="booking">예약관리</a>
      	<a href="logout">로그아웃</a>    
       <h1>객실관리</h1>
    </div>
        <!-- 첫번째 영역 -->
        <div class="div_first">
           <p><b>객실 목록</b></p>
            <select size="10" id="listRoom">
<%--           	<c:forEach items="${list}" var="room">
					<option value="${room.roomcode}">${room.roomname},${room.typename},${room.howmany}명,${room.howmuch}원</option>
				</c:forEach> --%>
            </select>
        </div>
    <!-- 두번째 영역 -->
    <div class="div_second">
    <input type="hidden" id="rCode"> <!-- 객실 코드 -->
       <p>객실이름 : &nbsp;<input type="text" id="rName" style="width: 170px;"></p>
           <p class="p1">객실분류 : </p>
           <select size="10" id="rSize">
            <c:forEach items="${type}" var="type">
           		<option value="${type.typecode}">${type.name}</option>
           </c:forEach>
           </select> 
           <br>
          <p style="margin-left: -50px"> 숙박가능인원 : <input type="number" style="width: 60px;" id="rPerson">명</p>
           <br>
           <p style="margin-left: -25px">1박 요금 : <input type="text" style="width: 120px;" id="rPrice">원</p>
           <br>
           <input type="button" value="등록" id="btnAdd" style="background-color: blue; color: white;">
           <input type="button" value="삭제" id="btnDel" style="background-color: red; color: white;">
           <input type="button" value="초기화" id="btnEmpty">
    </div>
    </div>
</body>
<script src="https://code.jquery.com/jquery-3.5.0.js"></script>
<script>
$(document)
.ready(function(){
	$.post("http://localhost:8080/app/showRoomList",{},function(result){
		console.log(result);
		$.each(result, function(ndx,value){
			str='<option value="'+value['roomcode']+'">'+value['roomname']+','+value['typename']+','+value['howmany']+','+value['howmuch']+'</option>';
			$('#listRoom').append(str);
		})
	},'json');
})
.on('click','#listRoom option',function(){
	let str=$(this).text(); //text(); = <옵션>텍스트</옵션>  태그안의 텍스트 값을 가져옴
	let ar=str.split(',');
	//alert(ar[1]);
	$('#rName').val(ar[0]);
	$('#rSize option:contains("'+ar[1]+'")').prop('selected',true);
	$('#rPerson').val(ar[2]);
	$('#rPrice').val(ar[3]);
	let code=$(this).val();
	$('#rCode').val(code);
	return false;
})
.on('click','#btnAdd',function(){
	let roomname=String($('#rName').val());
	let roomtype=String($('#rSize').val());
	let howmany=String($('#rPerson').val());
	let howmuch=String($('#rPrice').val());
	//validation 유효성검사
	if(roomname==''||roomtype==''||howmany==''||howmuch==''){
		alert('누락된 값이 있습니다 확인해주세요');
		return false;
	}
	let roomcode=String($('#rCode').val());
	if(roomcode==''){//insert
		$.post('http://localhost:8080/app/addRoom',{roomname:roomname,roomtype:roomtype,howmany:howmany,howmuch:howmuch},function(result){
			if(result=='ok'){
				location.reload();
			}
		},'text');
	} else { //update
		console.log('roomcode['+roomcode+']');
		$.post('http://localhost:8080/app/updateRoom',{roomcode:roomcode,roomname:roomname,roomtype:roomtype,howmany:howmany,howmuch:howmuch},function(result){
			if(result=='ok'){
				location.reload();
			}
		},'text');
	}
})
.on('click','#btnDel',function(){ //삭제
	$.post('http://localhost:8080/app/deleteRoom',{roomcode:$('#rCode').val()},function(result){
		console.log(result);
		if(result=='ok'){
			$('#btnEmpty').trigger('click');
			$('#listRoom option:selected').remove();
		}
	},'text');
	return false;
})
.on('click','#btnEmpty',function(){
	$('#rCode,#rName,#rSize,#rPerson,#rPrice').val('');
	return false;
})
</script>
</html>