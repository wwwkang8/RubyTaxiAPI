# 택시 배차 시스템

## 개선사항
  1) Mysql, Ruby on Rails 사용
  2) 택시기사 배차 수락 여부를 택시기사 번호와 배차 상태로 판별
  3) JWT 토큰 방식의 로그인
  4) 택시기사가 승객 운송완료 후 배차상태 변경 후, 다음 배차예약 수락할 수 있도록 변경
  
 
 ## 기능설명 및 파라메터
 
 ## 회원 가입 
 URL
 - POST /users 

	
| Level 1  |Level 2 |Required | Description |
| ------------- | ------------- | ------------- | ------------- |
| user | email  | O  | 사용자가 입력하는 이메일. 중복 허용불가 |
| | pwd  | O  | 사용자가 입력하는 비밀번호. |
| | usertype | O | 사용자의 타입. 승객(passenger), 기사(driver) |

### 요청 예제
POST /users

### Header
- Content-Type: application/json

### Body
- {
   "user":{
      "email":"driver30@gmail.com",
      "pwd":"123",
      "usertype":"driver"
   }
}

### Response
| Level 1  | Description |
| ------------- | ------------- |
| message | 회원 가입의 성공 실패여부에 관한 메시지 반환 |

### Exceptions
| Code  |Field |Type | Message | Description |
| ------------- | ------------- | ------------- |------------- | ------------- |
| invalid_params | user.email  | required  | has already been taken | 기존에 이메일이 사용되고 있을 경우 중복 허용불가. |
| | user.usertype  | required  | Please choose either passenger or driver in usertype| 사용자의 유저 타입이 오입력되었을 경우 |
| | user.password | required | Password is empty | 비밀번호가 입력되지 않아 파라메터로 전송되지 않았을 때 |
| | user.password | required | Please write password at least 6 characters | 비밀번호가 6자리 미만으 입력되었을 때 |




 ## 로그인(JWT) <br/>

### URL
 - POST /loginToken 
	
| Level 1  |Level 2 |Required | Description |
| ------------- | ------------- | ------------- | ------------- |
| session | email  | O  | 로그인시 입력하는 이메일 주소 |
| | pwd  | O  | 로그인시 입력하는 비밀번호 |
| | usertype | O | 사용자의 타입. 승객(passenger), 기사(driver) |

### 요청 예제
POST /loginToken

### Header
- Content-Type: application/json

### Body
{
   "session":{
      "email":"driver11@gmail.com",
      "pwd":"123"
   }
}

### Response
| Level 1  | ㅣLevel 2 | Level 3  | Description  |
| ------------- | ------------- |------------- | ------------- |
| data | . | . | User의 이메일 정보와 토큰을 포함하는 데이터 |
| . | user | . | User의 이메일을 가지고 있는 데이터 |
| . | . | email | User의 이메일 데이터 |
| . | token | . | user_id와 2주의 토근 유효를 가지는 토큰 값 |

### 응답예제
{
   "data":{
      "user":{
         "email":"driver12@gmail.com"
      },
      "token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyMCwiZXhwIjoxNTQ3NTY1MTc0fQ.4LPLVD9m6J6ncNeWPIUVwKPM1b1WanCrgDrANVjya4I"
   }
}


### Exceptions
| Code  |Field |Type | Message | Description |
| ------------- | ------------- | ------------- |------------- | ------------- |
| invalid_params | user.email  | required  | No user found. Please check email/password | 이메일이 잘못 입력되었을 때. |
| | user.password | required | No user found. Please check email/password | 비밀번호가 잘못 입력되었을 때 |


## 배차 목록조회

### URL
- GET /bookings/:id

| Level 1  |Level 2 |Required | Description |
| ------------- | ------------- | ------------- | ------------- |
| user | email  | O  | 사용자가 입력하는 이메일. 중복 허용불가 |
| | pwd  | O  | 사용자가 입력하는 비밀번호. |
| | usertype | O | 사용자의 타입. 승객(passenger), 기사(driver) |


      
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
   
   
  
  
