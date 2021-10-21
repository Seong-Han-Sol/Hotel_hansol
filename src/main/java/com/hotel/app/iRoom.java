package com.hotel.app;

import java.util.ArrayList;

public interface iRoom {
	//객실 리스트
	ArrayList<Roominfo> showRoomList();
	//객실 타입리스트
	ArrayList<RoomType> showRoomType();
	//객실 추가
	void addRoom(String roomname, int roomtype, int howmnay, int howmuch);
	void updateRoom(int roomcode, String roomname, int roomtype, int howmany, int howmuch);
	void deleteRoom(int roomcode);
}
