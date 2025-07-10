-- 한 줄 짜리 주석
/*
    여러줄
    주석
*/

-- 현재 모든 계정들에 대해서 조회하는 명령문
SELECT * FROM DBA_USERS; -- 이건 관리자 계정으로 들어왔기 때문에 보인다.
-- 명령문 하나 실행(위쪽의 재생 버튼 클릭 | CTRL + ENTER)

-- 일반 사용자 계정을 생성하는 구문(오로지 관리자 계정에서만 할 수 있음)
-- [표현법] : CREATE USER 계정명 IDENTIFIED BY 비밀번호;

CREATE USER kh IDENTIFIED BY kh; -- 계정명은 대소문자 안 가림

-- 계정 추가해보기 => 오류?
-- 위에서 생성한 일반 사용자 계정에게 최소한의 권한(데이터 관리, 접속)을 부여해야 함.
-- [표현법] GRANT 권한1, 권한2, ... TO 계정명;

GRANT CONNECT, RESOURCE TO kh; -- Grant를 성공

