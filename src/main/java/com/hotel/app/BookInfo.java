package com.hotel.app;

public class BookInfo {
	private int bookcode;
	private int roomcode;
	private String roomname;
	private String typename;
	private int howmany;
	private int max_howmany;
	private String checkin;
	private String checkout;
	private int total;
	private String bname;
	private String mobile;
	
	public BookInfo() {}

	public BookInfo(int bookcode, int roomcode, String roomname, String typename, int howmany, int max_howmany,
			String checkin, String checkout, int total, String bname, String mobile) {
		this.bookcode = bookcode;
		this.roomcode = roomcode;
		this.roomname = roomname;
		this.typename = typename;
		this.howmany = howmany;
		this.max_howmany = max_howmany;
		this.checkin = checkin;
		this.checkout = checkout;
		this.total = total;
		this.bname = bname;
		this.mobile = mobile;
	}

	public int getBookcode() {
		return bookcode;
	}

	public void setBookcode(int bookcode) {
		this.bookcode = bookcode;
	}

	public int getRoomcode() {
		return roomcode;
	}

	public void setRoomcode(int roomcode) {
		this.roomcode = roomcode;
	}

	public String getRoomname() {
		return roomname;
	}

	public void setRoomname(String roomname) {
		this.roomname = roomname;
	}

	public String getTypename() {
		return typename;
	}

	public void setTypename(String typename) {
		this.typename = typename;
	}

	public int getHowmany() {
		return howmany;
	}

	public void setHowmany(int howmany) {
		this.howmany = howmany;
	}

	public int getMax_howmany() {
		return max_howmany;
	}

	public void setMax_howmany(int max_howmany) {
		this.max_howmany = max_howmany;
	}

	public String getCheckin() {
		return checkin;
	}

	public void setCheckin(String checkin) {
		this.checkin = checkin;
	}

	public String getCheckout() {
		return checkout;
	}

	public void setCheckout(String checkout) {
		this.checkout = checkout;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public String getBname() {
		return bname;
	}

	public void setBname(String bname) {
		this.bname = bname;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	
}
