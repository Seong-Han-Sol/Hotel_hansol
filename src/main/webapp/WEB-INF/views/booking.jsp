<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- <%
	String loginid=(String)session.getAttribute("loginid");
	out.println(loginid);
	if(!loginid.equals("test")){
		response.sendRedirect("http://localhost:8080/app/");
	}
%> --%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약관리</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
 <!-- CSS 임포트 -->
    <link rel="stylesheet" href="resources/css/booking.css">
    <style>	
 	/*글꼴 임포트 https://fonts.google.com/specimen/Lobster#standard-styles*/
 	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
 	/*위는 h태그에 사용할 글꼴, 아래는 a,h3태그에 사용할 글꼴*/
 	@import url('https://fonts.googleapis.com/css2?family=Single+Day&display=swap');
</style>
</head>
<body>
<div class="menu">
	<!-- 상단 메뉴 --> 
	<h2><a href="room">객실관리</a>
	    <a href="booking">예약관리</a>
	    <a href="logout">로그아웃</a>
	    <h1>예약관리</h1>
	</h2>
</div>        
<div class="all"> <!--전체 영역 div-->
    <!--숙박기간 조회 / 예약가능 객실 묶은 div 시작-->
    <div class="first">
        <!--숙박기간 조회 div 시작-->
        <div class="inquiry"> 
            <p>&nbsp;&nbsp;숙박기간 <input type="date" id="start1"> ~ </label>
            <label><input type="date" id="end1"><br></p>
            <p>&nbsp;&nbsp;객실분류 <select id="room">
            <option value="-">전체</option>
            	<c:forEach items="${type}" var="type">
					<option value="${type.typecode}">${type.name}</option>
	    		</c:forEach>
            </select>
            <input type="button" value="조회" id="btnInquiry"></p>
        </div> 
        <!--숙박기간 조회 div 끝-->
        <!--예약 가능 객실-->
        	<h2>예약가능 객실 리스트</h2>
        	<select size="10" id="roomCheck">
        	</select>
    </div>
    <!--숙박기간 조회 / 예약가능 객실 묶은 div 끝--> 
    <!-- 객실 정보 나오는 두번째 영역 div 시작 -->
    <div class="second">
        <p>객실이름 : <input type="text" id="rName" style="margin-top: 10px;" streadOnly></p> <br>
		<p>객실종류 : <input type="text" id="rSize" readOnly></p><br>
		<p>예약인원 : <input type="number" id="bPerson" min=1>명</p> <br>
		<p>최대인원 : <input type="number" id="rPerson" min=1 readOnly>명</p><br>
    	<p> 예약기간 &nbsp;<input type="date" id="startDate" readOnly> ~ 
        <input type="date" id="endDate" readOnly></p><br>
		<input type="hidden" id="rPrice"> <!-- 1박비용 -->
      	<p>총 숙박비: <input type="text" id="totalPrice" min=1 readOnly>원</p><br>
        <p>예약자명 : <input type="text" id="bName" ></p> <br>
        <p>모바일(형식:010-aaaa-bbbb)<br>
        <input type="text" id="bPnum" style="margin-top: 5px;"><br></p>
        <input type="hidden" id="rCode"> <!-- 객실코드 -->
        <input type="hidden" id="bCode"> <!-- 예약 코드 -->
        <input type="button" value="예약" id="btnBook" style="background-color: blue;">
        <input type="button" value="취소" id="btnCancel" style="background-color: red;">
        <input type="button" value="Clear" id="btnEmpty" style="background-color: rgb(255, 102, 153); border: 2px solid rgb(204, 000, 051);">
    </div>
    <!-- 객실 정보 나오는 두번째 영역 div 끝 -->
    <!-- 예약된 객실 정보 나오는 세번째 영역 div 시작 -->
    <div class="third">
    <h2 style="margin-bottom: 3px">객실 예약 리스트</h2>
    <p style="margin-top: 2px">객실이름|객실종류|예약인원|최대인원|체크인|체크아웃|총금액|예약자명|모바일</p>
       <select size="20" id="bookingList">
       </select>
    </div>
    <!-- 예약된 객실 정보 나오는 세번째 영역 div 끝 -->
</div>
<!--전체 영역 div 끝-->
</body>
<script src="https://code.jquery.com/jquery-3.5.0.js"></script>
<script>
$(document)
.on('click','#btnInquiry',function(){ //조회버튼 누르면 밑에 예약가능 객실과 예약된 객실 목록이 뜨게함
	$.post("http://localhost:8080/app/canBookingRoom",{checkin:$('#start1').val(),checkout:$('#end1').val()},function(result){
		$('#roomCheck').empty();
		$.each(result,function(ndx,value){
			str='<option value="'+value['roomcode']+'">'+value['roomname']+','+value['typename']+','+value['howmany']+','+value['howmuch']+'</option>';
			$('#roomCheck').append(str);	
		});
	},'json');
	$.post("http://localhost:8080/app/bookingCheck",{checkin:$('#start1').val(),checkout:$('#end1').val()},function(result){
		console.log(result);
		$('#bookingList').empty();
		$.each(result, function(ndx,value){
			str='<option value="'+value['bookcode']+','+value['roomcode']+'">'+value['roomname']+','+value['roomtype']+','+value['howmany']+'/'+value['max_howmany']+','+value['checkin']+'~'
			+value['checkout']+','+value['total']+','+value['bname']+','+value['mobile']+'</option>';
			$('#bookingList').append(str);
		})
	},'json');
	return false;
})
.on('click','#roomCheck option',function(){ //객실 리스트 클릭하면 예약 입력란에 기본정보 표시
	var str=$(this).text();
	var rInfo=str.split(','); 
	$('#rName').val(rInfo[0]);
	$('#rSize').val(rInfo[1]);
	$('#rPerson').val(rInfo[2]);
	$('#rPrice').val(rInfo[3]);
	$('#startDate').val($('#start1').val());
	$('#endDate').val($('#end1').val());
	let code=$(this).val();
	$('#rCode').val(code);
	$('#startDate,#endDate').trigger('change');
	return false;
})
.on('click','#btnBook',function(){
	if($('#rName').val()==''){
		alert('객실이 선택되어야 합니다');
		return false;
	}
	if($('#bPerson').val()==''|| isNaN($('#bPerson').val())){
		alert('숙박인원이 입력되지 않았습니다');
		return false;
	}
	if($('#rPerson').val()==''|| isNaN($('#rPerson').val())){
		alert('총 숙박가능 인원이 입력되어야 합니다');
		return false;
	}
	if($('#startDate').val()==''|| $('#endDate').val()==''){
		alert('숙박기간을 지정해주세요');
		return false;
	}
	if($('#totalPrice').val()==''){
		alert('총 숙박비가 계산되지 않았습니다');
		return false;
	}
	if($('#bName').val()==''){
		alert('예약자 이름을 입력해주세요');
		return false;
	}
	if($('#bPnum').val()==''){
		alert('핸드폰 번호를 입력해주세요');
		return false;
	}
	//insert into DB
	let bookcode=String($('#bCode').val());
	if(bookcode==''){ //insert
		$.post('http://localhost:8080/app/addBooking', {roomcode:$('#rCode').val(),howmany:$('#rPerson').val(),
				checkin:$('#startDate').val(),checkout:$('#endDate').val(),
				total:$('#totalPrice').val(),bname:$('#bName').val(),
				mobile:$('#bPnum').val()}, function(result){
					if(result=='ok'){
						pstr='<option value="'+$('#rCode').val()+'">'+
						$('#rName').val()+','+$('#rSize').val()+','+
						$('#bPerson').val()+'/'+$('#rPerson').val()+','+
						$('#startDate').val()+'~'+$('#endDate').val()+','+$('#totalPrice').val()+','+
						$('#bName').val()+','+$('#bPnum').val()+'</option>';
						$('#bookingList').append(pstr);
						$('#btnEmpty').trigger('click');
						$('#roomCheck').empty();
					} else {
						alert('예약이 완료되지 않았습니다. (DB오류)');
					}
					console.log($('#rCode').val(),$('#rName').val());
				},'text');
	} else { //Update
			$.post('http://localhost:8080/app/updateBooking',{bookcode:$('#bCode').val(),roomcode:$('#rCode').val(),howmany:$('#rPerson').val(),
				checkin:$('#startDate').val(),checkout:$('#endDate').val(),
				total:$('#totalPrice').val(),bname:$('#bName').val(),
				mobile:$('#bPnum').val()},function(result){
					if(result=='ok'){
						$('#btnInquiry').trigger('click');
					}
				},'text');
	}
	return false;
})
.on('change','#startDate, #endDate', function(){
	//총 숙박비 계산
	let checkin=$('#startDate').val();
	let checkout=$('#endDate').val();
	if(checkin==''|| checkout==''){
		return false;
	}
	checkin=new Date(checkin);
	checkout=new Date(checkout);
	if(checkin > checkout){
		alert('체크인 날짜가 잘못되었습니다(체크아웃 날짜보다 뒤로 선택됨)');
		return false;
	}
	let ms=Math.abs(checkout-checkin);
	let days=Math.ceil(ms/(1000*60*60*24));
	let total=days*parseInt($('#rPrice').val());
	$('#totalPrice').val(total);
	return false;
})
.on('click','#btnEmpty',function(){ //초기화
	$('#rName,#rSize,#bPerson,#rPerson,#startDate,#endDate,#rPrice,#totalPrice,#bName,#bPnum,#rCode,#bCode').val('');
	return false;
})
.on('click','#btnCancel',function(){ //삭제
	$.post("http://localhost:8080/app/deleteBooking", {bookcode:$('#bCode').val()}, function(result){
		console.log(result);
		if(result=='ok'){
			$('#btnEmpty').trigger('click');
			$('#bookingList option:selected').remove();
		}
	},'text');
	return false;
})
.on('click','#bookingList option',function(){
	let str=$(this).text();
	let ar=str.split(",");
	//alert(ar)
	let arr=String(ar[2]).split("/");
	//alert(arr)
	let dtar =String(ar[3]).split("~");
	//alert(dtar[0]);
	//alert(ar[7]);
	$('#rName').val(ar[0]);
	$('#rSize').val(ar[1]);
	$('#bPerson').val(arr[0]);
	$('#rPerson').val(arr[1]);
	$('#startDate').val(dtar[0]);
	$('#endDate').val(dtar[1]);
	$('#totalPrice').val(ar[4]);
	$('#bName').val(ar[5]);
	$('#bPnum').val(ar[6]);
	let code=$(this).val();
	//alert(code)
	let cdar=String(code).split(",");
	//alert(cdar[1]);
	$('#bCode').val(cdar[0]);
	$('#rCode').val(cdar[1]);
	return false;
})
</script>
</html>