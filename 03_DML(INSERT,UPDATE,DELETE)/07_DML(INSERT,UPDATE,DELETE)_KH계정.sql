/*
    DQL (QUERY 데이터 질의 언어) : SELECT
    
    DML (MANUPULATION 데이터 조작 언어) : [SELECT], INSERT, UPDATE, DELETE
    DDL (DEFINITION 데이터 정의 언어) : CREATE, ALTER, DROP
    DCL (CONTROL 데이터 제어 언어) : GRANT, REVOKE, [COMMIT, ROLLBACK]
    
    TCL (TRANSACTION 트랜젝션 제어 언어) : COMMIT, ROLLBACK
    
    < DML : DATA MANIPULATION LANGUAGE>
    데이터 조작 언어
    
    테이블에 값을 삽입하거나(INSERT), 수정하거나(UPDATE), 삭제하는 구문(DELETE)
*/

/*
    1. INSERT
       : 테이블에 새로운 행을 추가하는 구문
       
       [표현식]
       1) INSERT INTO 테이블명 VALUES(값, 값2, ...);
          -> 테이블의 모든 컬럼에 대한 값을 제시해서 한 행을 INSERT를 하고자 할 때 사용
             컬럼 순번을 지켜서 VALUES에 값을 나열해야 됨
            
            부족하게 값을 제시했을 경우 => "not enough values" 오류!
            값을 더 많이 제시했을 경우  => "too many values" 오류!
*/

INSERT INTO EMPLOYEE
VALUES(900,'차은우','900101-1234567','cha_00@kh.or.kr','01011112222',
        'D1','J7','S3', 4000000,0.2 ,200 , SYSDATE, NULL, DEFAULT);
SELECT * FROM EMPLOYEE;

/*
    2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES (값1, 값2, 값3);
       -> 테이블에 내가 선택한 컬럼에 대한 값만 INSERT할 때 사용
       그래도 한 행 단위로 추가되기 때문에
       선택이 안 된 컬럼은 기본적으로 NULL이 들어감
       = NOT NULL 제약조건이 걸려있는 컬럼은 반드시 선택해서 직접 값을 제시해야됨!
       단, DEFALUT 값이 있는 경우는 NULL이 아닌 DEFAULT 값이 들어간다!
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL, HIRE_DATE)
VALUES (901,'박보검', '880101-1111111','J1','S2',SYSDATE);

SELECT * FROM EMPLOYEE;

INSERT 
  INTO EMPLOYEE
       (
         EMP_ID
       , EMP_NAME
       , EMP_NO
       , JOB_CODE
       , SAL_LEVEL
       , HIRE_DATE
       )
VALUES ( 901
        , '박보검'
        , '880101-1111111'
        , 'J1'
        , 'S2'
        ,SYSDATE
        );
        
--------------------------------------------------------------------------------
/*
    3) INSERT INTO 테이블명 (서브쿼리)
      VALUES로 값을 직접 명시하는 거 대신에, 서브쿼리로 조회된 결과값을 통째로 INSERT 가능!
*/

-- 새로운 테이블 셋팅
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR(20)
);

SELECT * FROM EMP_01;

-- 전체 사원들의 사번, 이름, 부서명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID); 
-- 등가 조인이라 그냥 JOIN 하면 NULL이면 조회 안 됨 => LEFT JOIN

INSERT INTO EMP_01(
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID));

SELECT * FROM EMP_01;

--------------------------------------------------------------------------------

/*
    2. INSERT ALL
    
*/

-- 테스트할 테이블
-- 구조만 배끼기 : WHERE에 성립 안되는 식 제시

CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1 = 0;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0; 
    
SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회

SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE= 'D1';

/*
    [표현식]
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼명, 컬럼명, ...)
    INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
    INTO 테이블명3 VALUES(컬럼명, 컬럼명, ...)
    서브쿼리;
*/

INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID 
    FROM EMPLOYEE
    WHERE DEPT_CODE= 'D1'; -- 왜 8개

-- 조건을 사용해서도 각 테이블에 INSERT 가능!

--> 2000년도 이전 입사자들에 대한 정보 담을 테이블
-- 테이블 구조만 배껴서 먼저 만들기
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1= 0;

--> 2000년도 이후 입사자들에 대한 정보 담을 테이블

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE
    WHERE 1= 0;
    
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

/*
    [표현식]
    INSERT ALL
    WHEN 조건1 THEN
        INTO 테이블1 VALUES(컬럼명, 컬럼명,...)
    WHEN 조건2 THEN
        INTO 테이블2 VALUES(컬럼명, 컬럼명,...)
    서브쿼리;
*/

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN 
    INTO EMP_OLD VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;
    
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

--------------------------------------------------------------------------------
/*
    3. UPDATE  
       테이블에 기록되어있는 기존의 데이터를 수정하는 구문
       
       [표현식]
       UPDATE 테이블명
         SET 컬럼명 = 바꿀값, 
             컬럼명 = 바꿀값,
             .
             . 
             => 여러개의 컬럼 값 동시에 변경 가능
       [ WHERE 조건 ] => 생략이 가능하나, 전체 테이블에 있는 모든 행의 데이터가 변경됨
                        꼭 작성하는 습관을 들이자!
*/

-- 복사본 테이블 만들어서 작업해보자
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- D9 부서의 부서명을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
   SET DEPT_TITLE = '전략기획팀' -- 총무부였음
   WHERE DEPT_ID = 'D9';

ROLLBACK;

-- 우선 복사본 떠서 진행
CREATE TABLE EMP_SALADY 
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE;
    
SELECT * FROM EMP_SALADY;

-- 노옹철 사원의 급여를 100만원으로 변경! -- 데이터 백업

UPDATE EMP_SALADY
    SET SALARY = 1000000 -- 3700000
    WHERE EMP_ID = 202; -- PK로 값 주는 게 좋음 동명이인 있을 가능성
    
-- 선동일 사원의 급여를 700만원으로 변경하고, 보너스도 0.2로 변경

SELECT EMP_NAME, SALARY, BONUS
FROM EMP_SALADY
WHERE EMP_NAME = '선동일'; -- 선동일 8000000 0.3

UPDATE EMP_SALADY
    SET SALARY = 7000000, -- 8000000
        BONUS = 0.2 -- 0.3
    WHERE EMP_ID =200;


-- 전체사원의 급여를 기존의 급여 10프로 인상한 금액 (기존 급여 * 1.1)
UPDATE EMP_SALADY
    SET SALARY = SALARY * 1.1;

-- ** UPDATE시 서브쿼리를 사용 가능

/*
    UPDATE 테이블명
       SET 컬럼명 = (서브쿼리)
     WHERE 조건;
*/

-- 방명수 사원의 급여와 보너스 값을 유재식 사원의 급여와 보너스 값으로 변경

SELECT * FROM EMP_SALADY
WHERE EMP_NAME ='방명수';-- 214	방명수	D1	1518000	


-- 단일행 서브쿼리
UPDATE EMP_SALADY
   SET SALARY = (SELECT SALARY FROM EMP_SALADY WHERE EMP_NAME ='유재식') -- 3740000 단일행 서브쿼리 => 비교연산자 사용 가능
   , BONUS = (SELECT BONUS FROM EMP_SALADY WHERE EMP_NAME ='유재식')
WHERE EMP_ID = 214;

-- 다중열 서브쿼리
UPDATE EMP_SALADY
   SET (SALARY, BONUS) = (SELECT SALARY,BONUS FROM EMP_SALADY WHERE EMP_NAME ='유재식') -- 다중열 서브쿼리, 2행 뜸
WHERE EMP_ID = 214;

-- ASIA 지역에서 근무하는 사원들의 보너스값을 0.3으로 변경
-- ASIA 지역에서 근무하는 사원들 조회
SELECT EMP_ID -- *에서 변경 
FROM EMP_SALADY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALADY
  SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID 
                    FROM EMP_SALADY
                    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                    WHERE LOCAL_NAME LIKE 'ASIA%'); -- 다중행
                    
SELECT * FROM EMP_SALADY;


--------------------------------------------------------------------------------
-- UPDATE시에도 해당 컬럼에 대한 제약조건에 위배되면 안됨!
-- 사번이 200번인 사원의 이름을 NULL로 변경!

UPDATE EMPLOYEE
  SET EMP_NAME = NULL
WHERE EMP_ID = 200; -- ORA-01407: cannot update ("KH"."EMPLOYEE"."EMP_NAME") to NULL
-- NOT NULL 제약조건 위배!

-- 노옹철 사원의 직급코드를 J9으로 변경!
SELECT * FROM JOB;

UPDATE EMPLOYEE
  SET JOB_CODE = 'J9'
WHERE EMP_ID = 203; 
--FK 제약조건 위배!

UPDATE EMPLOYEE
  SET JOB_CODE = 'J4'
WHERE EMP_ID = 203; 


--------------------------------------------------------------------------------
COMMIT;

/*
    4. DELETE
      테이블에 기록된 데이터를 삭제하는 구문 (한 행 단위로 삭제됨)
      
      [표현식]
      DELETE FROM 테이블명
      [WHERE 조건;] --> WHERE절 제시 안 하면 전체 행 다 삭제됨
*/



-- 차은우 사원의 데이터 지우기
DELETE FROM EMPLOYEE; -- 모든 데이터가 삭제됨...
SELECT * FROM EMPLOYEE;
ROLLBACK;  -- 마지막 커밋 시점으로 돌아감

DELETE FROM EMPLOYEE
WHERE EMP_ID = 900; 

DELETE FROM EMPLOYEE
WHERE EMP_ID = 901;  -- 박보검 삭제

COMMIT;

-- DEPT_ID D1부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';
-- ORA-02292: integrity constraint (KH.SYS_C007149) violated - child record found
-- 외래키 제약조건
-- D1의 값을 가져다 쓰는 자식 데이터가 있기 때문에 삭제 안 됨

-- DEPT_ID가 D3인 부서를 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3';

SELECT * FROM DEPARTMENT;

ROLLBACK;

-- * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문
--              DELETE 보다 수행속도가 빠름
--              별도의 조건 제시 불가, ROLLBACK 불가하다
-- [표현식] TRUNCATE TABLE 테이블명;
SELECT * FROM EMP_SALADY;

TRUNCATE TABLE EMP_SALADY;
ROLLBACK; -- 내부적으로 COMMIT이 됨. 되돌리기가 불가능.










--------------------------------------------------------------------------------




