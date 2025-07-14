/*
    < JOIN >
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    조회 결과는 하나의 결과물(RESET SET)로 나옴
    
    관계형 데이터베이스는 최소한의 데이터로 각각의 테이블에 데이터를 담고 있음(중복을 최소화하기 위해 최대한 쪼개서 관리함)
    
    -- 어떤 사원이 어떤 부서에 속해있는지 궁금함
    
    => 관계형 데이터베이스에서 SQL문을 이용한 테이블간의 관계를 맺는 방법
        (무작정 다 조회를 해오는 게 아니라 각 테이블간 연결고리로써의 데이터를 매칭시켜서 조회해야함
        
        JOIN은 크게 "오라클 전용 구문"과 "ANSI 구문" (ANSI == 미국국립표준협회 => 아스키 코드표 만드는 단체)
                                [JOIN 용어 정리]
            오라클 전용 구문                  |                ANSI 구문
    --------------------------------------------------------------------------------
                등가조인                     | 내부조인(INNER JOIN)
                EQUAL JOIN                 | 자연조인 (NATRUAL JOIN)
    --------------------------------------------------------------------------------
                포괄 조인                    | 왼쪽 외부 조인 (LEFT OUTER JOIN)
                (LEFT OUTER                | 오른쪽 외부 조인(LIGHT OUTER JOIN)
                (RIGHT OUTER)              | 전체 외부 조인 (FULL OUTER JOIN)
     -------------------------------------------------------------------------------
                자체조인(SELF JOIN)          |             JOIN ON
            비등가조인(NON EQUAL JOIN)        |
    --------------------------------------------------------------------------------
    */

-- 전체 사원들의 사번, 사원명, 부서코드 , 부서명 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- 전체 사원들의 사번, 사원명, 직급코드, 직급명 조회하고자 할 때
SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME
FROM JOB;

/*
    1. 등가조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
    연결시키는 컬럼의 값이 일치하는 행동만 조인돼서 조회 (== 일치하는 값이 없는 행은 조회에서 제외)
*/

-->> 오라클 전용구문
-- FROM절에 조회하고자하는 테이블 나열 (,구분자로)
-- WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건을 제시함

-- 1)연결할 두 컬럼명이 다른 경우(EMPLOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- 사번, 사원명, 부서코드, 부서명을 같이 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 값이 없는 행은 조회에서 제외된 거 확인 가능
-- DEPT_CODE가 NULL인 사람 조회X, DEPT_ID가 DEPT

-- 2) 연결된 두 컬럼명이 같은 경우(EMPLOYEE : JOB_CODE, JOB: JOB_CODE)
-- 사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE; -->  ambigyosly : 애매하다, 모호하다  // column ambiguously defined

-- 1) 해결방법 : 테이블명 이용하는 방법
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 2) 해결방법 : 테이블에 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E , JOB J 
WHERE E.JOB_CODE = J.JOB_CODE;


-- >> ANSI 구문
-- FROM절에 기준이 되는 테이블 하나 기술한 후
-- JOIN절에 같이 조회하고자 하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건도 기술
-- JOIN USING, JOIN ON

-- 1) 연결할 두 컬러명이 다른 경우(EMLPOYEE : DEPT_CODE, DEPARTMENT : DEPT_ID)
-- 오로지 JOIN ON으로만 가능
-- 사번, 사원명, 부서코드, 부서명
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE= DEPT_ID);

-- 2)연결할 두 컬럼명이 같은 경우 (E : JOB_CODE, J:JOB CODE)
-- JOIN ON JOIN USING 구문도 사용 가능!
-- 사번, 사원명, 직급코드, 직급명

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB ON (JOB_CODE, JOB_NAME);-- 잘못된 코드

--1) 해결방법: 테이블명 또는 별칭을 이용해서 하는 방법
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, J.JOB_CODE
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 2) 해결방법 : JOIN USING 구문 사용하는 방법

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

----------------[참고 사항] -----------

-- 자연 조인(NATURAL JOIN) : 각 테이블마다 동일한 컬럼이 한 개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB;

-- 추가적인 조건 제시
-- 직급명이 대리인 사원의 이름, 직급명, 급여 조회
-->> 오라클 전용 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME ='대리';


-->> ANSI 구문
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME ='대리';

---------------------------------------실문--------------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번 이름, 보너스 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID)
WHERE D.DEPT_TITLE = '인사관리부';

-- 2. DEPARTMENT 과 LOCATION을 참고해서 전체부서의 부서 코드, 부서명, 지역코드, 지역명 조회
-->> 오라클 전용 구문
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION; -- LOCAL_CODE

SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

-->> ANSI 구문
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE);

-- 3. 보너스를 받는사람들의 사번, 사원명, 보너스, 부서명 조회
-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, BONUS , DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL; 

/*
SELECT EMP_ID, EMP_NAME, BONUS , DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE BONUS IS NOT NULL; */

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서 조회
-->> 오라클 전용 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE <>'총무부';

-->> ANSI 구문
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE <>'총무부';

-- 지금 현재 DEPT_CODE가 NULL인 것들은 나오지 않고 있음!
--------------------------------------------------------------------------------
/*
    2. 포괄조인 / 외부조인 (OUTER JOIN)
    두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜서 조회 가능
    단, 반드시 LEFT / RIGHR 지정해야됨 (기준이 되는 테이블 지정)
*/

-- 월급 주기
-- 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID); -- 23명인데 21명
-- 부서배치가 아직 안 된 사원 2명에 대한 정보가 조회X
-- 부서에 배정된 사원이 없는 부서 같은 경우도 조회X

-- 1) LEFT OUTER JOIN : 두 테이블 중 왼편에 기술된 테이블 기준으로 JOIN
-- >> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE -- EMPLOYEE에 있는 건 무조건 다 나오는 거임
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- 부서 배치를 받지 않았던 2명의 사원 정보도 조회됨

-- >>  오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); -- 기준으로 삼고자하는 테이블의 반대편 컬럼뒤에 (+) 붙이기

-- 2) LIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
-->> ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-->> 오라클 전용 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- 3) FULL [OUTER] JOIN : 두 테이블을 가진 모든 행을 조회할 수 있음 (단, 오라클 전용 구문으로는 안 됨)
-->>ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

--------------------------------------------------------------------------------

/*
    3. 자체 조인(SELF JOIN)
    같은 테이블을 다시 한 번 조인하는 경우
*/
SELECT * FROM EMPLOYEE;
-- 전체 사원의 사번, 사원명, 사원 부서코드,  => EMPLOYEE E
--     사원의 사번, 사수명, 사수 부서코드   => EMPLOYEE M

-->> 오라클 전용 구문
SELECT E.EMP_ID "사원의 사번", E.EMP_NAME "사원명" , E.DEPT_CODE "사원 부서 코드",
       M.EMP_ID "사수의 사번", M.EMP_NAME "사수명", M.DEPT_CODE " 사수 부서 코드"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-->> ANSI 구문
SELECT E.EMP_ID "사원의 사번", E.EMP_NAME "사원명", E.DEPT_CODE "사원 부서 코드",
       M.EMP_ID "사수의 사번", M.EMP_NAME "사수명", M.DEPT_CODE "사수 부서 코드"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON(E.MANGER_ID = M.EMP_ID); ----------------------------------

--------------------------------------------------------------------------------
/*
    <다중 JOIN>
    2개 이상의 테이블을 가지고 JOIN을 할 때 
*/

-- 사번, 사원명, 부서명, 직급명 조회
SELECT * FROM EMPLOYEE; --DEPT_CODE ,JOB_CODE
SELECT * FROM DEPARTMENT; -- DEPT_ID
SELECT * FROM JOB; -- JOB_CODE

-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D , JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (DEPT_CODE = DEPT_ID)
JOIN JOB J USING(JOB_CODE);

-- 사번, 사원명, 부서명, 지역명
SELECT * FROM EMPLOYEE;     -- DEPT_CODE
SELECT * FORM DEPARTMENT; --    DEPT_ID       LOCATION_ID
SELECT * FROM LOCATION; --                    LOCAL_CODE

-->> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE;

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
------------------------------실습 문제-------------------------------------------
--1. 사번, 사원명, 부서명, 지역명, 국가명 조회 (EMP,DEP,LOC,NARIONAL 조인)
-->> 오라클 전용 구문
SELECT * FROM DEPARTMENT; -- lOCATION_ID
SELECT* FROM LOCATION; -- LOCAL_CODE NATIONAL CODE
SELECT * FROM NATIONAL;--               NATIONAL_CODE

SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE;

-->> ANSI 구문
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, L.LOCAL_NAME, N.NATIONAL_NAME
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
    JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
    JOIN NATIONAL N USING(NATIONAL_CODE); --------------------------------------------


--2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 해당 급여 등급에서 받을 수 있는 최대 금액 조회 (SAL_GRADE)(모든 테이블 조회)
SELECT * FROM JOB; --JOB CODE
SELECT * FROM SAL_GRADE; -- SAL_LEVEL
SELECT * FROM EMPLOYEE; --      "

-->> 오라클 전용 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.MAX_SAL
FROM EMPLOYEE E, DEPARTMENT D, JOB J , LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND E.SAL_LEVEL = S.SAL_LEVEL;

-->> ANSI 구문
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME, L.LOCAL_NAME, N.NATIONAL_NAME, S.MAX_SAL
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J USING(JOB_CODE)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING(NATIONAL_CODE)
JOIN SAL_GRADE S USING(SAL_LEVEL);



