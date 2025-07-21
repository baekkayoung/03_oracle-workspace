/*
    *서브쿼리(SUBQUERY)
    - 하나의 SQL문 안에 포함된 또다른 SELECT문
    - 메인 SQL문을 위해 보조 역할을 하는 쿼리문
    
*/

-- 간단 서브쿼리 예시1
-- 노옹철 사원과 같은 부서에 속한 사원들을 조회하고 싶음!

-- 1) 먼저 노옹철 사원의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9인걸 알아냄

-- 2) 부서코드가 D9인 사원들 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> 위의 2단계를 하나의 쿼리문으로!
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '노옹철');
                    
-- 간단 서브쿼리 예시2
-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사람들의 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE; -- 9047663원
                    
-- 2) 급여가 3047663원 이상인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>=6047663;

-- 위의 2단계를 하나의 쿼리문으로!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>=(SELECT AVG(SALARY)
                FROM EMPLOYEE);

--------------------------------------------------------------------------------


/*
    *서브쿼리의 구분
    서브쿼리를 수행한 결과값이 몇 행 몇 열 이냐에 따라서 분류됨
    
    - 단일행 서브쿼리 : 서브쿼리의 조회 결과값의 개수가 오로지 1개일 때 (한 행 한 열)
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행일 때(여러행 한열) => 동명이인 노옹철 2명일 대
    - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때(한 행 여러열)
    - 다중행 다중열 서브쿼리 : 서브쿼리 조회 결과값이 여러행 여러컬럼일 때(여러행 여러열)
    
    >> 서브쿼리 종류가 뭐냐에 따라서 서브쿼리 앞에 붙는 연산자가 달라짐!
*/
/*
    1. 단일행 서브쿼리 (SINGLE ROW SUNQUERY)
    서브쿼리의 조회 결과값의 개수가 오로지 1개일때 (한 행 한 열)
    일반 비교 연산자 사용 가능
    = != ^= <> > < >= .......
*/

--1) 전 직원의 평균급여보다 급여를 더 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);
                
--2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
--3) 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
-- >> 오라클 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND SALARY > (SELECT SALARY
             FROM EMPLOYEE
             WHERE EMP_NAME = '노옹철');

-- >> ANCI 전용 구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON ( DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');
                
-- 4) 부서별 급여합이 가장 큰 부서의 부서코드, 급여 합 조회
-- 4-1) 먼저 부서별 급여합 중에서도 가장 큰 값 하나만 조회

SELECT MAX(SUM(SALARY)) --DEPT_CODE 삭제 : not a single-group group function
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000

-- 4-2) 부서별 급여합이 17700000원인 부서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE -- 부서 모아서
HAVING SUM(SALARY) = 17700000; -- 급여가 17700000원인 부서 구함

-- 위의 두 단계를 하나의 쿼리문으로!
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE 
HAVING SUM(SALARY) =(SELECT MAX(SUM(SALARY))
                     FROM EMPLOYEE
                     GROUP BY DEPT_CODE);
                     
-- 전지연 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명
-- 단, 전지연은 제외

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '전지연';

SELECT DEPT_CODE = 'D9', DEPT_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_NAME
FROM EMPLOYEE
GROUP BY DEPT CODE
WHERE DEPT_CODE ^= 'D9';

-->> 오라클 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_CODE = (SELECT DEPT_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME ='전지연')
AND EMP_NAME != '전지연';

-->> ANSI 구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE =DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '전지연')
AND EMP_NAME <> '전지연';

--------------------------------------------------------------------------------
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
    서브쿼리를 수행한 결과값이 여러 행 일때 (컬럼은 한 개 !)
    
    - IN 서브쿼리 : 여러개의 결과값 중에서 한 개라도 일치하는 값이 있다면
    
    - > ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클 경우
    - < ANY 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
    
    비교대상 > ANY(값1, 값2, 값3)
    비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
    
    --> ALL 서브쿼리 : 여러개의 "모든" 결과값들 보다 클 경우
    --< ALL 서크쿼리 : 여러개의 "모든" 결과값들 보다 작을 경우
    
    비교대상 >ALL(값1, 값2, 값3)
    비교대상 > 값1 AND 비교대상> 값2 AND 비교대상 >값3
    
*/

--1) 유재식 또는 윤은해 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
--1_1) 유재식 또는 윤은해 사원이 어떤 직급인지 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN('유재식','윤은해'); -- J3, J7

-- 1_2) J3, J7인 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN('J3','J7');

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN('유재식','윤은해')); -- IN 말고 = 사용 불가 여러행으로 조회됐기 때문에

-- 사원 => 대리 => 과장 => 차장 => 부장 ...
-- 2) 대리 직급임에도 불구하고 과장직급 급여들 최소급여보다 더 많이 받는 직원 조회 (사원, 이름, 직급, 급여)
 
 --2_1) 먼저 과장 직급인 사원들의 급여 조회
 SELECT SALARY
 FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
 AND JOB_NAME ='과장'; -- 22000000 2500000 37600000
 
 --2_2) 직급이 대리이면서 급여값이 위의 목록들 값중에 하나라도 큰 사람
 SELECT EMP_ID , EMP_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME ='대리'
 AND SALARY > ANY (2200000, 2500000, 3760000);
 
 
 SELECT EMP_ID , EMP_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME ='대리'
 AND SALARY > ANY (SELECT SALARY
                 FROM EMPLOYEE E, JOB J
                 WHERE E.JOB_CODE = J.JOB_CODE -- 값 3개
                 AND JOB_NAME ='과장');

--단일행 서브쿼리로 가능!
 SELECT EMP_ID , EMP_NAME, SALARY
 FROM EMPLOYEE
 JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME ='대리'
 AND SALARY > (SELECT MIN(SALARY)
                 FROM EMPLOYEE E, JOB J
                 WHERE E.JOB_CODE = J.JOB_CODE -- 값 1개
                 AND JOB_NAME ='과장');
                 
-- 3) 과장 직급임에도 불구하고 차장직인 사원들의 모든 금여보다도 더 많이 받는 사원들의 사변, 지원명, 직급명, 급여
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME ='과장'
AND SALARY > (SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME ='차장'); --> single-row subquery returns more than one row


SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME ='과장'
AND SALARY > ALL (SELECT SALARY
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME ='차장');
                
/*
    3. 다중열 서브쿼리 
       결과값은 한 행이지만 나열된 컬럼수가 여러개일 경우
*/

--1) 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회(사원명, 부서코드, 직급코드, 입사일)
-->> 단일행 서브쿼리로도 가능함!
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '하이유')
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '하이유');
                
-->> 다중열 서브쿼리로!

SELECT EMP_NAME, DEPT_CODE,JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME ='하이유');
                               
-- 박나라 사원과 같은 직급코드, 같은 사수를 가지고 있는 사람들의 사번, 사원명, 직급코드 , 사수사번 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME ='박나라');
                                
                                
--------------------------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과값이 여러행 여러열일 경우
*/
-- 1) 각 직급별 최소급여를 받는 사원 조회(사번, 사원명, 직급코드, 급여)
-->> 각 직급별 최소 급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 1-2)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000 -- 잡코드가 J2이면서 370만원인 사람
OR JOB_CODE ='J7' AND SALARY = 1380000; -- 잡코드가 J7이면서 138만원인 사람

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE); 
                            
-- 2) 각 부서별 최고급여를 받는 사번, 사원명, 부서코드, 급여
SELECT DEPT_CODE, MAX(SALARY) -- D9
FROM EMPLOYEE
GROUP BY DEPT_CODE; --  서브쿼리

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY) -- D9
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE);

/*
    5. 인라인 뷰 (INLINE-VIEW)
    
    서브쿼리를 수행한 결과를 마치 테이블처럼 사용!
*/
-- 사원들의 사번, 이름, 보너스포함연봉(별칭부여: 연봉), 부서코드 조회 => 보너스포함 연봉이 절대 NULL이 나오지 않도록!
-- 단, BONUS 연봉이 3000만원 이상인 사원들만 조회

SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0))*12 AS "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY * NVL(BONUS, 0))*12 >=30000000; -- WHERE 절에 별칭 바로 사용 못 함

SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0))*12 AS "연봉", DEPT_CODE
FROM EMPLOYEE;
-- 이걸 마치 존재하는 테이블인거마냥 사용할 수 있음! 그게 바로 인라인뷰!

SELECT EMP_ID, EMP_NAME --, MANAGER_ID: 인라인 뷰에 없는 컬럼 제시하면 오류남!
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0))*12 AS "연봉", DEPT_CODE
      FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

-->> 인라인뷰를 주로 사용하는 예 => TOP-N 분석(상위 몇 개만 보여주고 싶을 때 => BEST 상품, BEST 게시글...)

--> 전 직원 중 급여가 가장 높은 상위 5명만 조회
-- *ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1번부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY --2 (이때 ROWNUM으로 순서가 이미 부여됨. 정렬도 하기전에 이미 순서 부여)
FROM EMPLOYEE --1
WHERE ROWNUM <=5
ORDER BY SALARY DESC; --3
-- 정상적인 결과가 조회되지 않는다는 문제

-- ORDER BY절이 다 수행된 결과를 가지고 그때서야 ROWNUM을 부여 후 5명 추려야함!
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME,SALARY,DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <=5;

-- ROWNUM이랑 전체컬럼 조회하고 싶음... => 별칭 부여하는 방식으로!
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME,SALARY,DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <=5;


-- 가장 최근에 입사한 사원 5명 조회(사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;

SELECT ROWNUM,EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT EMP_NAME, SALARY, HIRE_DATE
        FROM EMPLOYEE
        ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <=5;

SELECT ROWNUM, EMP_NAME, SALARY, HIRE_DATE
FROM(SELECT *
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <=5;

-- 각 부서별 평균 급여가 높은 3개의 부서를 조회(부서코드, 평균급여)
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 2 DESC;

SELECT ROWNUM, DEPT_CODE, FLOOR(평균급여)
FROM (SELECT DEPT_CODE, AVG(SALARY) AS "평균급여"
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
        ORDER BY 2 DESC)
WHERE ROWNUM <=3;

--------------------------------------------------------------------------------
/*
    *순위 매기는 함수 (WINDOW FUNCTION)
    - RANK() OVER(정렬기준) : 동일한 순위 이후 등수를 동일한 인원수 만큼 건너 뛰고 순위 계산
                        EX) 공동 1위 2명이면 그 다음 순위는 3위
                        
     
    - DENSE_RANK() OVER(정렬기준) : 동일한 순위가 있다고 해도 그 다음 등수를 무조건 1씩 증가시킴
                        EX) 공동 1위가 2명이더라도 그 다음 순위를 2위
     
     >> 두 함수는 무조건 SELECT에서만 사용 가능하다
*/

-- 급여가 높은 순대로 순위를 매겨서 조회
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "순위" 
FROM EMPLOYEE;
-- 공동 19위 2명 그 뒤의 순위는 21 => 마지막 순위랑 조회된 행수가 같음

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) AS "순위" 
FROM EMPLOYEE;
-- 공동 19위가 2명 그 뒤의 순위는 20 -> 마지막 순위랑 조회된 행수가 다름

SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "순위" 
FROM EMPLOYEE;
--WHERE RANK() OVER(ORDER BY SALARY DESC) <=5; -- window functions are not allowed here
--WHERE 순위 <=5;

-- 인라인 뷰를 쓸 수밖에 없음!
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) AS "순위" 
        FROM EMPLOYEE)
WHERE 순위 <=5;