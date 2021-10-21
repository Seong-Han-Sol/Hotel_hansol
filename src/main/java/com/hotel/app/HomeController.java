package com.hotel.app;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	private HttpSession session;
	@Autowired
	private SqlSession sqlSession;
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	//로그인 페이지 이동
	@RequestMapping("/login") 
	public String goLogin() {
		return "login";
	}
	//회원가입 페이지 이동
	@RequestMapping("/newbie") 
	public String goNewbie() {
		return "newbie";
	}
	//다른 페이지에서 메인으로 이동
	@RequestMapping("/home") 
	public String goHome() {
		return "home";
	}
	//로그아웃 > 메인으로 이동
	@RequestMapping("/logout")
	public String doLogout() {
		return "home";
	}
	//로그인하면 예약관리로 이동(DB에 등록된 유저만)
	@RequestMapping(value = "/checkLogin", method = RequestMethod.POST)
	public String doLogin(HttpServletRequest hsr, Model model) {
		String userId=hsr.getParameter("uId");
		String userPw=hsr.getParameter("uPw");
		//DB에서 유저확인 : 기존유저면 booking 아니면 home
		iMember member=sqlSession.getMapper(iMember.class);
		int n=member.checkUser(userId, userPw);
		if(n>0) {
			HttpSession session=hsr.getSession();
			session.setAttribute("loginid", userId);
			return "booking";
		}else {
			return "home";
		}
	}
	
	//회원가입 Insert
	@RequestMapping(value ="/signUp", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	public String signUp(HttpServletRequest hsr) {
		String loName=hsr.getParameter("realName");
		String loId=hsr.getParameter("newId");
		String loPass=hsr.getParameter("pw1");
		iMember member=sqlSession.getMapper(iMember.class);
		member.signUp(loName, loId, loPass);
		return "home";
	}
	//예약관리 화면
	@RequestMapping("/booking")
	public String booking(HttpServletRequest hsr, Model model) {
		HttpSession session=hsr.getSession();
		String loginid=(String)session.getAttribute("loginid");
		iRoom room=sqlSession.getMapper(iRoom.class);
		ArrayList<RoomType> roomType=room.showRoomType();
		model.addAttribute("type", roomType);
		if(loginid.equals("")||loginid==null) {
			return "redirect:/";
		} else {
			return "booking";
		}
	}
	//객실관리 화면
	@RequestMapping("/room")
	public String room(HttpServletRequest hsr, Model model) {
		HttpSession session=hsr.getSession();
		if(session.getAttribute("loginid")==null) {
			return "redirect:/home";
		}
		//객실관리 객실분류에 객실타입을 보여주는 코드
		//interface 호출하고  결과를 room.jsp에 전달
		iRoom room = sqlSession.getMapper(iRoom.class);
		ArrayList<RoomType> roomType=room.showRoomType();
		model.addAttribute("type", roomType);
		return "room";
		
	}
	
	//객실관리 화면에 들어가면 객실목록에 객실리스트를 보여주는 코드
	@RequestMapping(value = "/showRoomList" , method = RequestMethod.POST, produces = "application/text; charset=utf8")
	@ResponseBody
	public String showRoomList(HttpServletRequest hsr) {
		iRoom room = sqlSession.getMapper(iRoom.class);
		ArrayList<Roominfo> roominfo = room.showRoomList();
		//찾아진 데이터로 JSONArray만들기
		JSONArray ja = new JSONArray();
		for(int i=0; i<roominfo.size();i++) {
			JSONObject jo =new JSONObject();
			jo.put("roomcode", roominfo.get(i).getRoomcode());
			jo.put("roomname", roominfo.get(i).getRoomname());
			jo.put("typename", roominfo.get(i).getTypename());
			jo.put("howmany", roominfo.get(i).getHowmany());
			jo.put("howmuch", roominfo.get(i).getHowmuch());
			ja.add(jo);
		}
		System.out.println(ja.toString());
		return ja.toString();
	}
	//객실 추가하기
	@RequestMapping(value = "/addRoom", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	@ResponseBody
	public String addRoom(HttpServletRequest hsr) {
		String rname=hsr.getParameter("roomname");
		int rtype=Integer.parseInt(hsr.getParameter("roomtype"));
		int howmany=Integer.parseInt(hsr.getParameter("howmany"));
		int howmuch=Integer.parseInt(hsr.getParameter("howmuch"));
		iRoom room = sqlSession.getMapper(iRoom.class);
		room.addRoom(rname, rtype, howmany, howmuch);
		return "ok";
	}
	
	//객실 수정하기 (roomcode가 있으면 수정  없으면 등록)
	@RequestMapping(value = "/updateRoom", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	@ResponseBody
	public String updateRoom(HttpServletRequest hsr) {
		iRoom room=sqlSession.getMapper(iRoom.class);
		int roomcode=Integer.parseInt(hsr.getParameter("roomcode"));
		String roomname=hsr.getParameter("roomname");
		int roomtype=Integer.parseInt(hsr.getParameter("roomtype"));
		System.out.println("roomcode["+roomcode+"]");
		System.out.println("roomcode["+roomname+"]");
		System.out.println("roomcode["+roomtype+"]");
		room.updateRoom(roomcode, roomname, roomtype, Integer.parseInt(hsr.getParameter("howmany")), Integer.parseInt(hsr.getParameter("howmuch")));
		return "ok";
	}
	//객실 삭제
	@RequestMapping(value = "/deleteRoom", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	@ResponseBody
	public String deleteRoom(HttpServletRequest hsr) {
		int roomcode = Integer.parseInt(hsr.getParameter("roomcode"));
		iRoom room = sqlSession.getMapper(iRoom.class);
		room.deleteRoom(roomcode);
		return "ok";
	}
	//booking.jsp 아래
	//조회버튼 클릭시 예약가능 객실 보여주는 것
	@RequestMapping(value = "/canBookingRoom", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	@ResponseBody
	public String canBooking(HttpServletRequest hsr) {
		iBooking room = sqlSession.getMapper(iBooking.class);
		String checkin = hsr.getParameter("checkin");
		String checkout =hsr.getParameter("checkout");
		ArrayList<Roominfo> canBooking = room.canBookingRoom(checkin, checkout);
		JSONArray ja = new JSONArray();
		for(int i=0; i<canBooking.size();i++) {
			JSONObject jo = new JSONObject();
			jo.put("roomcode", canBooking.get(i).getRoomcode());
			jo.put("roomname", canBooking.get(i).getRoomname());
			jo.put("typename", canBooking.get(i).getTypename());
			jo.put("howmany", canBooking.get(i).getHowmany());
			jo.put("howmuch", canBooking.get(i).getHowmuch());
			ja.add(jo);
		}
		System.out.println(ja.toString());
		return ja.toString();
	}
	//예약 체크
	@RequestMapping(value = "/bookingCheck", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	@ResponseBody
	public String getBooking(HttpServletRequest hsr) {
		iBooking book=sqlSession.getMapper(iBooking.class);
		String checkin = hsr.getParameter("checkin");
		String checkout = hsr.getParameter("checkout");
		ArrayList<BookInfo> bookinfo = book.bookingCheck(checkin, checkout);
		JSONArray ja =new JSONArray();
		for(int i=0; i<bookinfo.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("bookcode", bookinfo.get(i).getBookcode());
			jo.put("roomcode", bookinfo.get(i).getRoomcode());
			jo.put("roomname", bookinfo.get(i).getRoomname());
			jo.put("roomtype", bookinfo.get(i).getTypename());
			jo.put("howmany", bookinfo.get(i).getHowmany());
			jo.put("max_howmany", bookinfo.get(i).getMax_howmany());
			jo.put("checkin", bookinfo.get(i).getCheckin());
			jo.put("checkout", bookinfo.get(i).getCheckin());
			jo.put("total", bookinfo.get(i).getTotal());
			jo.put("bname", bookinfo.get(i).getBname());
			jo.put("mobile", bookinfo.get(i).getMobile());
			ja.add(jo);
		}
		System.out.println(ja.toString());
		return ja.toString();
	}
	//예약등록
	@RequestMapping(value = "/addBooking", method = RequestMethod.POST, produces ="application/text; charset=utf8")
	  @ResponseBody
	  public String addBooking(HttpServletRequest hsr) {
		  int roomcode=Integer.parseInt(hsr.getParameter("roomcode"));
		  int howmany=Integer.parseInt(hsr.getParameter("howmany"));
		  String checkin = hsr.getParameter("checkin");
		  String checkout = hsr.getParameter("checkout");
		  int total=Integer.parseInt(hsr.getParameter("total"));
		  String bname=hsr.getParameter("bname");
		  String mobile=hsr.getParameter("mobile");
		  iBooking book = sqlSession.getMapper(iBooking.class);
		  book.addBooking(roomcode, howmany, checkin, checkout, total, bname, mobile);
		  return "ok";
	  }
	//예약수정
	@RequestMapping(value = "/updateBooking", method = RequestMethod.POST , produces ="application/text; charset=utf8")
	  @ResponseBody
	  public String updateBooking(HttpServletRequest hsr) {
		  iBooking book =sqlSession.getMapper(iBooking.class);
		  int bookcode=Integer.parseInt(hsr.getParameter("bookcode"));
		  int roomcode=Integer.parseInt(hsr.getParameter("roomcode"));
		  int howmany=Integer.parseInt(hsr.getParameter("howmany"));
		  String checkin=hsr.getParameter("checkin");
		  String checkout=hsr.getParameter("checkout");
		  int total=Integer.parseInt(hsr.getParameter("total"));
		  String bname=hsr.getParameter("bname");
		  String mobile=hsr.getParameter("mobile");
		  book.updateBooking(bookcode, roomcode, howmany, checkin, checkout, total, bname, mobile);
		  return "ok";
	  }
	//예약삭제
	@RequestMapping(value = "/deleteBooking", method = RequestMethod.POST , produces ="application/text; charset=utf8")
	  @ResponseBody
	  public String deletBooking(HttpServletRequest hsr) {
		  int bookcode= Integer.parseInt(hsr.getParameter("bookcode"));
		  iBooking book = sqlSession.getMapper(iBooking.class);
		  book.deleteBooking(bookcode);
		  return "ok";
	  }
}
