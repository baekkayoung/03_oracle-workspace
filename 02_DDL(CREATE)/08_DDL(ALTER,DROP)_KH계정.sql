/*
    DDL (DATA DEFINITION LABGUAGE) : 데이터 정의 언어
    
    객체들을 생성(CREATE), 변경(ALTER), 삭제(DROP)하는 구문
    
    <ALTER>
    객체를 변경하는 구문
    
    [표현식]
    ALTER TABLE 테이블명 변경할내용;
    
    * 변경할내용
    1) 컬럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제  --> 수정은 불가, 수정하려면 삭제하고 다시 새로 만들기
    3) 컬럼명 / 테이블명 / 제약조건명 변경 


*/

-- 1) 컬럼 추가 / 수정 / 삭제
-- 1_1) 컬럼 추가 (ADD) : ADD 컬럼명 자료형 [DEFAULT] [제약조건]
-- DEPT_COPY에 CNAME 컬럼 추가

ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);

SELECT * FROM DEPT_COPY;

-- LNAME 컬럼 추가(기본값을 지정한채로)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';

-- 1_2) 컬럼 수정 (MODIFY)
--> 자료형 수정         : MODIFY 컬럼명 바꾸고자하는 자료형

--> DEFAULT 값 수정     : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3); -- 2
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; -- 얘는 오류남
--01439. 00000 -  "column to be modified must be empty to change datatype"
--존재하는 데이터가 없어야만 이렇게 바꿀 수 있음. 

ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR(10); -- 얘는 오류남
-- 01441. 00000 -  "cannot decrease column length because some value is too big"
-- 이미 담겨있는 데이터의 크기보다 작은 데이터 크기를 설정하면 안됨 / 10 바이트 보다 큼

-- DEPT_COPY 테이블에!
-- DEPT_TITLE 컬럼을 VARCHAR2(50)로
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(50);
-- LOCATION_ID 컬럼을 VARCHAR2(4)로
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHAR2(4);
-- LNAME 컬럼의 기본값을 '미국'으로 변경
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국'; 
-- 후에 디폴트 값을 바꾼다고 해서 기존의 것은 바뀌는 것은 아님

SELECT * FROM DEPT_COPY;

-- 다중 변경 가능
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(50)
    MODIFY LOCATION_ID VARCHAR2(4)
    MODIFY LNAME DEFAULT '미국';

-- 1_3) 컬럼삭제(DROP COLUMN): DROP COLUMN 삭제하고자 하는 컬럼명
-- 복사본 테이블 생성
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

SELECT * FROM DEPT_COPY2;

-- DEPT_COPY2 로부터 DEPT_ID 컬럼 지우기 
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;

-- 컬럼 삭제하는 건 다중 ALTER 불가!
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID; -- 마지막 혼자 남은 얘는 안됨
-- 12983. 00000 -  "cannot drop all columns in a table"
-- 테이블 내에 모든 컬럼을 삭제할 수 없음! => 최소 1개의 컬럼은 존재해야 함

--------------------------------------------------------------------------------

-- 2) 제약조건 추가 / 삭제
/*
    2_1) 제약조건 추가
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블[(컬럼명)] - 컬럼명 작성 안 하면 PK랑 같이 
    UNIQUE      : ADD UNIQUE(컬럼명)
    CHECK       : ADD CHECK(컬럼에 대한 조건)
    NOT NULL    : MODIFY 컬럼명 NOT NULL | NULL => NULL 허용안하겠다 / 하겠다
    
    제약조건명을 지정하고자 한다면 [CONSTRAINT 제약조건명] 제약조건
*/

-- DEPT_ID에 PK 제약조건 추가
-- DEPT_TITLE에 UNIQUE 제약조건 추가
-- LNAME에 NN 제약조건 추가
ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_YQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;
    
-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명
-- NOT NULL은 삭제 말고 MODIFY로 쓰면 됨

ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

-- 다중
ALTER TABLE DEPT_COPY
    DROP CONSTRAINT DCOPY_YQ
    MODIFY LNAME NULL;
    -- 02443. 00000 -  "Cannot drop constraint  - nonexistent constraint"
    
--------------------------------------------------------------------------------

-- 3) 컬럼명 / 제약조건명 / 테이블명 변경 (RENAME)
-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명;

-- DEPT_TITLE => DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) 제약조건명 변경 : RENAME CONSTRAINT 제약조건명 TO 바꿀제약조건명
-- SYS_C007184 (확인해서 가지고 오기!!) -> DCOPY_LID_NN 로 변경
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007184 TO DCOPY_LID_NN;

-- 3_3) 테이블명 변경 : RENAME [기존 테이블명] TO 바꿀 테이블명
-- DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

--------------------------------------------------------------------------------
-- 테이블 삭제
DROP TABLE DEPT_TEST;
-- 단, 어딘가에서 참조되고 있는 부모테이블은 함부로 삭제가 안 됨!
-- 만약에 삭제하고자 한다면?
-- 방법1. 자식테이블 먼저 삭제 후 부모테이블 삭제하는 방법
-- 방법2. 그냥 부모테이블만 삭제하는데, 제약조건까지 같이 삭제하는 방법
-- DROP TABLE 테이블명 CASCADE CONSTRAINT; =>  테이블을 삭제하면서, 이 테이블을 참조하는 자식 테이블의 외래 키 제약조건을 같이 삭제한다

















