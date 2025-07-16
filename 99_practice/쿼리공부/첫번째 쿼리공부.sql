----------------------------------퀴즈 1-----------------------------------------

-- 보너스를 안 받지만 부서 배치는 된 사원조회
SELECT *
FROM EMPLOYEE
WHERE BONUS = NULL AND DEPT_CODE != NULL;
-- NULL 값에 대해 정상적으로 비교 처리 되지않음!

-- 문제점 : NULL 값 비교할 때는 단순한 일반 비교 연산자를 통해 비굫라 수 없음!
-- 해결 방법 : IS NULL / IS NOT NULL 연산자를 이용해서 비교해야함!

-- 조치한 SQL문
SELECT *
FROM EMPLOYEE
WHERE BONUS IS NULL AND DEPT_CODE IS NOT NULL;

----------------------------------퀴즈 2-----------------------------------------
-- 검색하고자 하는 내용
-- JOB_CODE가 J7이거나 J6이면서 SALARY 값이 200만원 이상이고
-- BONUS가 있고 여자이며 이메일 주소_ 앞에 3글자만 있는 사원 조회
-- EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS를 조회하려고 한다.
-- 정상적으로 조회가 잘 된다면 실행결과는 2행 이어야 함

-- 위 내용을 실행시키고자 작성한 SQL문은 아래와 같다.

SELECT  EMP_NAME, EMAIL,EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE JOB_CODE ='J7' OR JOB_CODE ='J6' AND SALARY > 2000000
AND EMAIL LIKE '___$' AND BONUS IS NULL;

-- WHERE JOB_CODE IN('J7','J6') AND SALARY >=2000000 라고 생각.

-- 문제점
-- 1. OR 연산자와 AND 연산자가 나열되어 있을 경우 AND 연산자 연산이 먼저 수행됨!
--    문제에서 요구한 내용대로 될려면 OR 연산이 먼저 수행되어야함!
-- 2. 급여값에 대한 비교가 잘못되어 있음. >이 아닌 >= 으로 비교해야됨.
-- 3. BONUS가 있는 조건인데 IS NULL이 아닌 IS NOT NULL로 비교해야됨.
-- 4. 여자에 대한 조건이 누락되어 있음
-- 5. 이메일에 대한 비교시 네번째 자리에 있는 _를 데이터값으로 취급하기 위해서는 나만의 새 와일드카드를 제시해야 되고,
--    또한 ESCAPE 옵션으로 등록해야 함!

SELECT  EMP_NAME, EMAIL,EMP_NO, JOB_CODE, DEPT_CODE, SALARY, BONUS
FROM EMPLOYEE
WHERE (JOB_CODE ='J7' OR JOB_CODE ='J6') AND SALARY >= 2000000
AND EMAIL LIKE '___$_%' ESCAPE '$' AND BONUS IS NOT NULL
AND SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

----------------------------------퀴즈 3-----------------------------------------
-- [계정생성구문] CREATE USER 계정명 IDENTIFIED BY 비밀번호;

-- 계정명 : SCOTT, 비밀번호 : TIGER
-- 이때 일반사용자 계정인 KH 계정에 접속해서
-- CREATE USER SCOTT; 실행했더니 문제발생!

-- 문제점1. 사용자 계정 생성은 무조건 관리자 계정에서만 가능!
-- 문제점2. SQL문이 잘못됐음 비번까지 입력해야함!

-- 조치내용1. 관리자 계정에 접속한다.
-- 조치내용2. CREATE USER SCOTT IDENTIFIED BY TIGER;

-- 위의 SQL문을 실행 후 접속을 만들어서 접속을 하려고 했더니 실패!
-- 뿐만 아니라 해당 계정에 테이블 생성 같은 것도 되지 않음! 왜그럴까?

-- 문제점1. 사용자 계정 생성 후 최소한의 권한 부여가 안됐다.
-- 조치내용1. GRANT CONNECT, RESOURCE TO SCOTT;


----------------------------------퀴즈 4----------------------------------------
