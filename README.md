# 택시 배차 시스템

## 개선사항
  1) Mysql, Ruby on Rails 사용
  2) 택시기사 배차 수락 여부를 택시기사 번호와 배차 상태로 판별
  3) JWT 토큰 방식의 로그인
  4) 택시기사가 승객 운송완료 후 배차상태 변경 후, 다음 배차예약 수락할 수 있도록 변경
  
 
 ## 기능설명 및 파라메터
 
 ### 회원 가입 
 URL
 - POST /users 
 
Parameter
- Level 1 | Required
	- email :
	- pwd
	- usertype
	
	
| Level 1  | Required | Description |
| ------------- | ------------- | ------------- |
| email  | O  | 사용자가 입력하는 이메일. 중복 허용불가 |
| pwd  | O  | 사용자가 입력하는 비밀번호. |
| usertype | O | 사용자의 타입. 승객(passenger), 기사(driver) |

요청 예제
Header


 2) 로그인 <br/>
     - 세션 기반 GET /login(.:format)    sessions#new <br/>
     {<br/>
      "email":"driver12@gmail.com",<br/>
      "pwd":"123"<br/>
     }<br/>
     
     - JWT 기반 POST /loginToken(.:format)   sessions#create_token <br/>
     {<br/>
      "email":"driver12@gmail.com",<br/>
      "pwd":"123"<br/>
     }<br/>
     토큰 생성 <br/>
     {<br/>
    "data": {<br/>
        "user": {<br/>
            "email": "driver12@gmail.com"<br/>
        },<br/>
        "token":            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMCwiZXhwIjoxNTQ3NTY1MTc0fQ.4LPLVD9m6J6ncNeWPIUVwKPM1b1WanCrgDrANVjya4I"<br/>
        }<br/>
      }<br/>
      <br/>
  3) 배차 신청 POST /bookings    bookings#create<br/>
    {<br/>
      "destination":"I want to go to Drama&Company",<br/>
      "user_id":7<br/>
    }<br/>
    <br/>
  4) 배차 수락 PATCH /bookings/:id     bookings#update<br/>
   예시) http://localhost:3000/bookings/21<br/>
   {<br/>
      "taxi":"11",<br/>
      "user_id":7<br/>
   }<br/>
   <br/>
   5) 배차 완료 후 상태 업데이트 POST /bookings/finishDriving     bookings#finish_driving<br/>
    예시) http://localhost:3000/bookings/finishDriving<br/>
    {<br/>
	    "id":21<br/>
    }<br/>
    <br/>
   6) 배차 목록보기 GET /bookings(.:format)     bookings#index<br/>
   
   
  
  
