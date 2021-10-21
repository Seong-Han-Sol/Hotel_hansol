package com.hotel.app;

public interface iMember {
	//회원가입(newbie)
	void signUp(String loName, String loId, String loPass);
	
	//로그인 체크(login)
	int checkUser(String userId, String userPass);
}
