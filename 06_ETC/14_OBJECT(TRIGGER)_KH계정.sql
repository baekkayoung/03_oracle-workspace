/*
    < 트리거 TRIGGER >
    내가 지정한 테이블에 INSERT, UPDATE, DELETE 등 DML 문에 의해 변경 사항이 생겼을 때 (테이블에 이벤트가 발생했을 때)
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
    EX) 
    회원 탈퇴시 기존의 회원테이블에 DELETE 후 곧바로 탈퇴된 회원들만 따로 보관하는 테이블에 자동으로 INSERT 처리해야된다!
    신고 횟수가 일정 수를 넘겼을 때 묵시적으로 해당 회원을 블랙리스트로 처리되게끔
    입출고에 대한 데이터가 기록 (INSERT) 될 때마다 해당 상품에 대한 재고 수량을 매번 수정(UPDATE)해야 될 때
    
    * 트리거 종류
    - SQL문의 실행시기에 따른 분류
    > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
    > AFTER TRIGGER : 내가 지정한 테이블에 이벤트가 발생한 후에 실행
    
    
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
    > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
    > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때마다 매번 트리거 실행
                            (FOR EACH ROW 옵션 기술) :
                            > : OLD - BEFORE UPDATE(수정전 자료), BEFORE DELETE(삭제전 자료)
                            > : NEW - AFTER INSERT(추가된 자료), AFTER UPDATE(수정후 자료)
    
    * 트리거 생성 구문
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE|AFTER   INSERT|UPDATE |DELETE   ON 테이블명
    [FOR EACH ROW]
    자동으로 실행할 내용; (프로시져)
     ㄴ [DECLARE 
        변수 선언]
        BEGIN
        실행 내용 (해당 위에 지정된 이벤트 발생시 묵시적으로(자동으로) 실행할 구문)
        [EXCEPTION
        예외처리구문]
        END;
        /
*/
SET SERVEROUTPUT ON; 

-- EMPLOYEE 테이블에 새로운 행이 INSERT될 때마다 자동으로 메시지 출력하는 트리거 만들어보기
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN  
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다!');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, SAL_LEVEL, HIRE_DATE)
VALUES(500,'이순신','111111-1111111','D7','J7','S2',SYSDATE);

--------------------------------------------------------------------------------

-- 상품 입고 및 출고 관련 예시
-- >> 테스트를 위한 테이블 및 시퀀스 생성

-- 1. 상품에 대한 데이터 보관할 테이블 (TB_PRODUCT)
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY,         -- 상품번호
    PNAME VARCHAR2(30) NOT NULL,     -- 상품명
    BRAND VARCHAR2(30) NOT NULL,     -- 브랜드
    PRICE NUMBER,                    -- 가격
    STOCK NUMBER DEFAULT 0           -- 재고수량
);

-- 상품번호 중복 안되게끔 매번 새로운 번호를 발생시켜주는 시퀀스 (SEQ_PCODE)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플 데이터 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시25', '삼성' , 1400000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰16', '애플' , 1600000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '대륙폰', '샤오미' , 600000, 20);


SELECT * FROM TB_PRODUCT;

COMMIT;


-- 2. 상품 입출고 상세 이력 테이블 (TB_PRODETAIL)
-- 어떤 상품이 어떤 날짜에 몇 개 입고 또는 출고가 되었는지에 대한 데이터를 기록하는 테이블

CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY,           --이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT, --상품번호
    PDATE DATE NOT NULL,                --상품입출고일
    AMOUNT NUMBER NOT NULL,             --입출고수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고','출고')) -- 상태
);

-- 이력번호로 매번 새로운 번호를 발생시켜서 들어갈 수 있게 도와주는 시퀀스 (SEQ_DCODE)
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

-- 200번 상품이 오늘 날짜로 10개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 200, SYSDATE, 10, '입고');
-- 200번 상품의 재고수량을 0 증가 (아직 0개)
UPDATE TB_PRODUCT
SET STOCK = STOCK + 10
WHERE PCODE = 200;

COMMIT; -- 해당 트렌젝션 커밋

-- 210번 상품이 오늘 날짜로 5개 출고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 210, SYSDATE, 5, '출고');
-- 210번 상품의 재고 수량을 5 감소
UPDATE TB_PRODUCT
SET STOCK = STOCK - 5
WHERE PCODE = 210;

COMMIT;

-- 205번 상품이 오늘 날짜로 20개 입고
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 205, SYSDATE, 20, '입고');
-- 205번 상품의 재고수량 20개 증가
UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 200; -- 200번에 오기입

ROLLBACK;

INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 205, SYSDATE, 20, '입고'); -- 4번으로 됨 3이미써버려서

UPDATE TB_PRODUCT
SET STOCK = STOCK + 20
WHERE PCODE = 205;

COMMIT;

-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생시
-- TB_PRODUCT 테이블에 매번 자동으로 재고수량이 UPDATE 되게끔 트리거 정의

/*
    - 상품이 입고된 경우 => 해당 상품을 찾아서 재고수량 컬럼 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK + 현재 입고된 수량(INSERT된 자료의 AMOUNT값)
    WHERE PCODE = 입고된 상품번호 (INSERT된 자료의 PCODE값);
    
    - 상품이 출고된 경우 => 해당 상품 찾아서 재고수량 감소 UPDATE
    UPDATE TB_PRODUCT
    SET STOCK = STOCK - 현재 출고된 수량(INSERT된 자료의 AMOUNT 값)
    WHERE PCODE = 출고된 상품 번호 (INSERT가 된 자료의 PCODE값);
*/

-- NEW: 방금 인설트된거 가리킴 
CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL -- 디테일에 인설트 된 후 실행
FOR EACH ROW -- 매번 실행
BEGIN 
    -- 상품이 입고된 경우 = 재고수량 증가
    IF (:NEW.STATUS = '입고')
        THEN 
            UPDATE TB_PRODUCT
            SET STOCK = STOCK + :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
    
    -- 상품이 출고된 경우 = 재고수량 감소
    IF (:NEW.STATUS = '출고')
        THEN
            UPDATE TB_PRODUCT
            SET STOCK = STOCK - :NEW.AMOUNT
            WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 210번 상품이 오늘 날짜로 7개 출고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL , 210, SYSDATE , 7 , '출고'); --> 이제 자동으로 바뀜!

-- 200번 상품이 오늘 날짜로 100개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 200 , SYSDATE, 100 ,'입고'); --> 잘됨!









/*
1. 성적테이블(학번, 이름, 국, 영, 수), 학점테이블(학번, 총점수, 평균, 등수) 만들기
성적테이블 : TB_SCORE
학점테이블 : TB_GRADE
*/
-- 1-1) 성적테이블 (학번, 이름, 국, 영, 수)
CREATE TABLE TB_SCORE(
    STUDENT_NUM VARCHAR(30), -- PRIMARY KEY
    NAME VARCHAR2(30),
    KOREAN NUMBER,
    ENGLISH NUMBER,
    MATH NUMBER
);

-- 1-2) 학점테이블 (학번, 총점수, 평균, 등수)
CREATE TABLE TB_GRADE(
    STUDENT_NUM VARCHAR2(30),  -- PRIMARY KEY
    SUM NUMBER,
    AVG NUMBER,
    GRD NUMBER
);
 
/*
CREATE SEQUENCE SEQ_STUDENT_NUM
START WITH 200
INCREMENT BY 5
NOCACHE;

DROP SEQUENCE SEQ_STUDENT_NUM;
*/

--2. 성적테이블에 INSERT 발생하면 자동으로 학점테이블에 INSERT해주는 트리거 생성 !!!!!!!!!!!!!!!
CREATE OR REPLACE TRIGGER TRG_INSERT_02
AFTER INSERT ON TB_SCORE -- 티비스코어에 인서트가 되면 하겠다/
FOR EACH ROW
BEGIN
    INSERT INTO TB_GRADE(STUDENT_NUM, SUM, AVG)
    VALUES(:NEW.STUDENT_NUM,
           :NEW.KOREAN + :NEW.ENGLISH + :NEW.MATH,
           (:NEW.KOREAN + :NEW.ENGLISH + :NEW.MATH)/ 3);
END;
/

-- 찐 트리거 만들기
CREATE OR REPLACE TRIGGER TRG_TEST
AFTER INSERT OR UPDATE ON TB_SCORE
BEGIN 
    PROC_UPDATE_RANK;
END;
/

-- 샘플데이터
INSERT INTO TB_SCORE
VALUES(1, '차은우',60, 70, 80);

INSERT INTO TB_SCORE
VALUES(2, '주지훈',70, 70, 80);

INSERT INTO TB_SCORE
VALUES(3, '장원영',80, 70, 80);

UPDATE TB_SCORE
SET KOREAN =70
WHERE NAME ='차은우';

DELETE FROM TB_SCORE -- 그레이드 지우는 거 아님
WHERE NAME = '장원영'; --5번에서 정한 것 

 /*
DECLARE
    SUM NUMBER;
    AVG NUMBER;
BEGIN
    SUM := NVL(:NEW.KOREAN, 0 )+ NVL(:NEW.ENGLISH, 0 )+ NVL(:NEW.MATH, 0 );
    AVG := SUM / 3;
    
    INSERT INTO TB_GRADE (STUDENT_NUM, SUM, AVG)
    VALUES (:NEW.STUDENT_NUM, SUM, AVG);
    */

--3. 성적테이블이 UPDATE되면 해당 국어, 영어, 수학 점수의 값이 오라클 콘솔에 출력되는 트리거 생성 !!!!!!!!!!!!

CREATE OR REPLACE TRIGGER TRG_SCORE_UPDATE_LOG
AFTER UPDATE ON TB_SCORE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('국어: ' || :NEW.KOREAN || ', 영어: ' || :NEW.ENGLISH || ', 수학: ' || :NEW.MATH);
END;
/

--4. 성적테이블에 INSERT/ UPDATE 되면 등수를 매겨서 저장해주는 프로시저 생성(어려움주의) !!!!!!!!!!!!!!!

CREATE OR REPLACE PROCEDURE PROC_UPDATE_RANK IS
BEGIN
    UPDATE TB_GRADE G
    SET GRD = (SELECT RN
                FROM (SELECT STUDENT_NUM, RANK() OVER(ORDER BY SUM DESC) AS RN -- 나 조회할건데 학번이랑 토탈점수가지고 조회
                      FROM TB_GRADE) SUB -- 스튜던트넘버랑 RN 가지고 있음
                      WHERE G.STUDENT_NUM = SUB.STUDENT_NUM); 
                      -- G 1번 이랑 SUB GRD 랑 같은 거. 3등 2번이랑 같은거? 2등

END;
/


--5. 점수 테이블에 학생 데이터가 삭제되면 학점 테이블에도 학생 데이터 삭제 + 나머지 사람 등수 매기는 트리거 생성

CREATE OR REPLACE TRIGGER TRG_SCORE_DELETE
AFTER DELETE ON TB_SCORE
FOR EACH ROW
BEGIN
    -- 학점 테이블에서 학생 삭제
    DELETE FROM TB_GRADE 
    WHERE STUDENT_NUM = :OLD.STUDENT_NUM;
    -- 이미 삭제된 데이터AFTER DELETE니까 OLD! 

    -- 등수 다시 계산
    PROC_UPDATE_RANK;
END;
/



