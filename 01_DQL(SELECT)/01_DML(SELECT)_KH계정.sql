/*
    < SELECT >
    데이터 조회할 때 사용되는 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물(즉, 조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자 하는 컬럼1, 컬럼2,...
    FROM 테이블명;
    
    * 반드시 존재하는 컬럼으로 써야한다! 없는 컬럼 쓰면 오류남!
    
*/

-- EMPLOYEE 테이블의 모든 컬럼(*) 조회
-- SELECT EMP_ID, EMP_NAME,...
SELECT *
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사번, 이름, 급여 조회

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- JOB 테이블의 모든 컬럼 조회
SELECT *
FROM JOB;

-----------------------실습문제---------------------------
--1. JOB 테이블의 직급명만 조회
SELECT JOB_NAME
FROM JOB;

--2. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT *
FROM DEPARTMENT;

--3. DEPARTMENT 테이블의 부서코드, 부서명만 조회
SELECT DEPT_TITLE, DEPT_ID
FROM DEPARTMENT;

--4. EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, HIRE_DATE, SALARY
FROM EMPLOYEE;

/*
    <컬럼값을 통한 산술 연산>
    SELECT절 컬럼명 작성 부분에 산술연산 기술 가능 (이때, 산술연산된 결과 조회)
    
*/

-- EMPLOYEE 테이블의 사원명, 사원의 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY*12
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 사원명, 급여, 보너스, 연봉, 보너스 포함된 연봉 조회((급여+급여*보너스))*12
SELECT EMP_NAME, SALARY, BONUS, SALARY *12, ((SALARY+SALARY*BONUS))*12
FROM EMPLOYEE;
--> 산술 연산 과정 중 NULL 값이 존재할 경우 산술연산을 한 결과값 마저도 NULL로 나오게 된다

-- EMPLOYEE에 사원명, 입사일
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE;

-- EMPLOYEE에 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- 데이트 형식끼리 연산 가능!!
-- *오늘 날짜: SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM EMPLOYEE;
-- DATE - DATE : 결과의 값은 일 단위가 맞음!
-- 단, 값이 지저분한 이유는 DATE 형식은 년/월/일/시/분/초 단위로 시간정보까지도 관리를 하기 때문에!

--------------------------------------------------------------------------------

/*
    <컬럼명에 별칭 지정하기>
    산술연산을 하게 되면 컬럼명 지저분함.. 이때 컬럼명으로 별칭을 부여해서 깔끔하게 보여줌
    
    [표현법 4가지]
    컬럼명 별칭 / 컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
    
    AS 붙이든 안 붙이든간에 부여하고자 하는 별칭에 띄어쓰기 혹은 특수문자가 포함될 경우 반드시 "별칭"으로 기술해야 됨
    
*/

SELECT EMP_NAME 사원명, SALARY AS 급여, SALARY *12 "연봉(원)", (SALARY+ SALARY*BONUS)*12 AS "총소득(보너스 포함)"
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 리터럴 >
    임의로 지정한 문자열 ('')
    
    SELECT절에 리터럴을 제시하면 마치 테이블에 존재하는 데이터처럼 조회 가능
*/

-- EMPLOYEE 테이블의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "단위" 
FROM EMPLOYEE; 

/*
    <연결 연산자 : || >
    여러 컬럼값들을 마치 하나의 컬럼인 것 처럼 연결, 컬럼값과 리터럴 값을 연결할 수 있음
    
    system.out.println("num의 값 : " + num); 의 + 역할
*/

-- 사번, 이름, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- 컬럼값과 리터럴을 연결
-- XXX의 월급은 XXX원 입니다. => 컬럼명 별칭 : 급여 정보

SELECT EMP_NAME || '의 월급은' || SALARY || '원 입니다.' AS "급여 정보"
FROM EMPLOYEE;

--------------------------------------------------------------------------------
/*
    < DISTINCT >
    컬럼에 중복된 값들을 한 번씩만 표시하고자 할 때 사용
    
*/
-- 현재 우리 회사에 어떤 직급의 사람들이 존재하는지 궁금함.
SELECT JOB_CODE
FROM EMPLOYEE; -- 현재 23명의 직급이 전부 다 조회됨

-- EMPLOYEE에 직급코드(중복제거) 조회
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE; -- 중복을 제거해서 7개의 직급이 조회됨

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; --null : 아직 부서배치가 안 된 사람

-- 유의사항 : DISTINCT는 SELECT절에 한 번만 기술 가능!!
/*  여러 번 안됨 : 구문 오류
SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE 
FROM EMPLOYEE;
*/

-- 쌍으로 엮어서는 가능
SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < WHERE 절 >
    조회하고자하는 테이블로부터 특정 조건에 만족하는 데이터만을 조회하고자 할 때 사용
    이때 WHERE절에는 조건식을 제시하게 됨
    조건식에서는 다양한 연산자들 사용 가능
    
    [표현법]
    SELECT 컬럼1, 컬럼2, ...
    FROM 테이블명
    WHERE 조건식;
    
    [비교 연산지]
    >, <, >=, <=        -> 대소비교
    =                      -> 동등비교
    !=, ^=, <>             -> 동등하지 않은지 비교    
*/

-- EMPLOYEE 에서 부서코드가 'D9'인 사원들만 조회 (이때, 모든 컬럼 조회)
SELECT * 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'; --반드시 홑따옴표

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드만 조회
SELECT EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 부서코드가 D1이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D1';
--WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- 재직중(ENT_YN = 'N')인 사원들의 사번, 이름, 입사일
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN = 'N';

--------------------------------실습문제------------------------------------------

--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉(보너스 미포함) 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12
FROM EMPLOYEE
WHERE SALARY >= 3000000;

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY*12 AS "연봉", DEPT_CODE -- 3번
FROM EMPLOYEE -- 1번
WHERE SALARY*12>=50000000; -2 

-- WHERE 연봉 >= 50000000; 2번 (invalid identifier)옵티마이저의 실행 계획에 따라..
-- WHERE 절에서는 SELECT절에서 작성한 별칭 사용 불가!
-- 쿼리 실행 순서
-- FROM 절 => WHERE절 => SELECT절

--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회
SELECT EMP_NO, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';

-- 부서코드가 'D9' 이면서 급여는 500만원 이상인 사원들의 사번, 사원명, 급여, 부서코드 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6' 이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- 급여가 350만원 이상~ 600만원 이하를 받는 사원들의 사원명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

--------------------------------------------------------------------------------
/*
    < BETWEEN A AND B >
    조건식에서 사용되는 구문
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용되는 연산자
    
    [표현법]
    비교대상컬럼 BETWEEN A(값1) AND B(값2)
    => 해당 컬럼값이 A이상이고 B이하인 경우
*/

SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 위 쿼리 범위 밖의 사람들 조회하고자 한다면?

SELECT EMP_NAME, EMP_ID, SALARY
FROM EMPLOYEE
--WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY /*NOT*/ BETWEEN 3500000 AND 6000000; -- 논리부정연산자
-- 컬럼명 앞 또는 BETWEEN 앞에 기입 가능!!

-- 입사일이 '90/01/01' ~ '01/01/01'
SELECT *
FROM EMPLOYEE
-- WHERE HIRE_DATE >='90/01/01' AND HIRE_DATE <= '01/01/01';
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

--------------------------------------------------------------------------------

/*
    < LIKE >
    비교하고자하는 컬럼값이 내가 제시한 특정 패턴에 만족될 경우 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'
    
    - 특정 패턴 제시시 '%', '_'를 와일드카드로 쓸 수 있음.
    >> '%' : 0글자 이상
    EX) 비교대상컬럼 LIKE '문자%' => 비교대상의 컬럼값이 문자로 "시작"되는 걸 조회
        비교대상컬럼 LIKE '%문자' => 비교대상의 컬럼값이 문자로 "끝"나는 걸 조회
        비교대상컬럼 LIKE '%문자%' => 비교대상의 컬럼값이 문자가 포함되는 걸 조회
    
    >> '_' : 1글자 이상
    EX) 비교대상컬럼 LIKE '_문자' => 비교 대상의 컬럼값에 문자앞에 무조건 한 글자가 올 경우 조회 은우X
        비교대상컬럼 LIKE '__문자' => 비교 대상의 컬럼값에 문자앞에 무조건 두 글자가 올 경우 조회 차은우 X
        비교대상컬럼 LIKE '_문자_' => 비교 대상의 컬럼값에 문자 앞과 뒤에 무조건 한 글자씩
*/

-- 사원들 중 성이 전씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 이름중에 하가 포함된 사원들의 사원명, 주민번호, 전화번호 조회
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 이름의 가운데 글자가 하 인 사람들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

-- 전화번호의 세번째 자리가 1인 사원들의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';


-- ** 특이 케이스
-- 이메일 중 _ 기준으로 앞글자가 3글자인 사원들의 사번, 여름, 이메일 조회
-- sim_bs@kh.co.kr, sun.di@kh.or.kr

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%'; -- 원했던 결과 도출 불가!
-- 와일드 카드로사용하고 있는 문자와 컬럼값에 담긴 문자가 동일하기 때문에 제대로 조회 안됨 (다 와일드카드_로 조회됨)
--> 어떤게 와일드카드고 어떤게 데이터값인지 구분을 지어줘야됨!
--> 데이터 값으로 취급하고자 하는 값 앞에 나만의 와일드카드 제시하고, EXCAPE OPTION으로 등록해야 됨

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE /**/EMAIL LIKE '___$_%' ESCAPE '$';

---------------------------------실습문제-----------------------------------------
--1. EMPLOYEE에서 이름이 "연" 으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

--2. EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE NOT PHONE LIKE '010%';

--3. ELPLOYEE에서 이름에 '하'가 포함되어있고, 급여가 240만원 이상인 사원들의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2400000;

--4. DEPARTMENT에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_ID = 'D5' OR DEPT_ID = 'D6' OR DEPT_ID ='D7';
--WHERE DEPT_TITLE LIKE '해외영업%'

--------------------------------------------------------------------------------

/*
    < IS NULL / IS NOT NULL >
    컬럼값에 NULL이 있을 경우 NULL 값 비교에 사용되는 연산자
*/

-- 보너스를 받지 않는 사원(BOUNUS 값이 NULL)들의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--WHERE BONUS = NULL; 정상적으로 조회 안됨
WHERE BONUS IS NULL; 

-- 보너스를 받는 사원(BONUS 값이 NULL이 아닌)들의 사번, 이름, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--WHERE BONUS != NULL;
WHERE BONUS IS NOT NULL;
-- NOT은 컬럼명 앞 또는 IS 뒤에서 사용 가능

-- 사수가 없는 사원(MANAGE_ID 값이 NULL)들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치를 아직 받지는 않았지만 보너스는 받는 사원들의 이름, 보넛, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

--------------------------------------------------------------------------------
/*
    <IN>
    비교대상 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는지
    
    [표현법]
    비교대상컬럼 IN('값1', '값2', ...)

*/
-- 부서코드가 D6 이거나 D8이거나 D6인 부서원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE = 'D6' OR DEPT_ CODE = 'DB OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6','D8','D5');

-- 그 외의 사원들
SELECT EMP_NAME, DEPTE_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6','D8','D5');

--------------------------------------------------------------------------------

/*
    < 연산자 우선순위>
    0.()
    1.산술연산자
    2.연결연산자
    3.비교연산자
    4.IS NULL / LIKE '특정패턴' / IN
    5. BETWEEN A AND B
    6. NOT(논리연산자)
    7. AND(논리연산자)
    8. OR(논리연산자)
    
*/

-- ** OR 보다 AND가 먼저 연산됨
-- 직급코드가 J7 이거나 J2인 사원들중 급여가 200 만원 이상인 사람들의 모든 컬럼교회
SELECT *
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR  JOB_CODE = 'J2') AND SALARY >= 2000000;

--------------------------------실습문제------------------------------

--1. 사수가 없고 부서배치도 받지 않은 사원들의 (사원명, 사수사번, 부서코드 조회)
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

--2. 연봉(보너스미포함)이 3000만원 이상이고 보너스를 받지 않는 사람들의 사번, 사원명, 급여, 보너스) 조회
SELECT EMP_NO, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
WHERE SALARY*12 >= 30000000 AND BONUS IS NULL;

--3. 입사일이 '95/01/01' 이상이고 부서배치를 받은 사람들의 (사번, 사원명, 입사일 , 부서코드} 조회)
SELECT EMP_NO, EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;

--4. 급여가 200만원 이상 500만원 이하이고 입사일이 '01/01/01' 이상이고 보너스를 받지 않는 사원들의 (사번, 사원명, 급여, 입사일, 보너스) 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 AND HIRE_DATE >= '01/01/01' AND BONUS IS NULL;

--5. 보너스 포함 연봉이 NULL이 아니고 이름이 '하'가 포함되어 있는 사원들의 (사번, 사원명, 급여, 보너스포함연봉) 조회(별칭부여)
SELECT EMP_ID AS "사번" , EMP_NAME AS "사원명", SALARY AS "급여",  (SALARY + SALARY * BONUS)*12 AS "보너스 포함 연봉"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL AND EMP_NAME LIKE '%하%';

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;

--------------------------------------------------------------------------------

/*
    < ORDER BY 절 > 
    가장 마지막 줄에 작성하고 뿐만 아니라 실행순서 또한 마지막에 실행(그래서 별칭 인식 가능)
    
    [표현법]
    SELECT 조회할 컬럼, 컬럼, 산술연산식 AS "별칭" ...
    FROM 조회하고자하는 테이블명
    WHRER 조건식
    OODER BY 정렬하고싶은컬럼|별칭|컬럼순번 [ASC|DESC] [NULLS FIRST|NULLS LAST]
    
    - ASC : 오름차순 정렬(생략시 기본값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRTST : 정렬하고자 하는 값에 NULL이 있을 경우 해당 데이터를 먼저 배치 (생략시 DESC일때의 기본값)
    - NULLS LAST : 정렬하고자 하는 값에 NULL이 있을 경우 해당 데이터를 맨 뒤 배치 (생략시 ASC일때의 기본값)
*/

SELECT *
FROM EMPLOYEE
--ORDER BY BONUS;
--ORDER BY BONUS ASC; 오름차순 정렬일때 기본적으로 NULLS LAST구나!
--ORDER BY BONUS ASC NULLS FIRST; 오름차순인데 NULL이 먼저
--ORDER BY BONUS DESC; -- 내림차순 정렬일 때는 기본적으로 NULLS FIRST 구나!
ORDER BY BONUS DESC, SALARY ASC; -- 정렬 기준 여러개 제시 가능(첫번째 기준의 컬럼값이 동일할 경우 두번쨰 기준 컬럼가지고 정렬)

-- 전체 사원의 사원명, 연봉 조회 (이때 연봉별 내림차순 정렬조회)
SELECT EMP_NAME, SALARY*12 AS "연봉"
FROM EMPLOYEE
--ORDER BY SALARY*12 DESC;
--ORDER BY 연봉 DESC; -- 실행순서에따라 별칭을 사용할 수 있다
ORDER BY 2 DESC; -- 컬럼의 순번 사용 가능 (컬럼 개수보다 큰 숫자 안됨)









