package com.hotel.app;

import java.util.ArrayList;

public interface iBooking {
	//예약된 객실을 제외한 객실리스트 불러오기 
	ArrayList<Roominfo> canBookingRoom(String checkin, String checkout);
	//예약된 객실
	ArrayList<BookInfo> bookingCheck(String checkin, String checkout);
	//예약추가
	void addBooking(int roomcode, int howmany, String checkin, String checkout, int total, String bname, String mobile);
	//예약수정
	void updateBooking(int bookcode, int roomcode, int howmany, String checkin, String checkout, int total, String bname, String mobile);
	//예약삭제
	void deleteBooking(int bookcode);
}
