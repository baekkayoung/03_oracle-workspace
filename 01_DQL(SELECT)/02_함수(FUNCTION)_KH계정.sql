/*
    < 함수 FUNCTION >
    전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환함
    
    - 단일행 함수 : N개의 값을 읽어들여서 N개의 결과값을 리턴
    - 그룹 함수 : N개의 값을 읽어들여서 1개의 결과값을 리턴
    
    >> SELECT 절에 단일행함수랑 그룹함수를 함께 사용 못함!
        왜? 결과 행의 개수가 다르기 때문에!
            
    >> 함수 쓸 수 있는 위치 : SELECT절, WHERE절, ORDER BY 절, GROUP BY절, HAVING 절
*/

/*
    <문자 처리 함수>
    *LENGTH / LENGTH => 결과값 NUMBER 타입
    
    LENGTH(컬럼|'문자열값') : 해당 문자열값의 글자수 변환 
    LENGTHB(컬럼|'문자열값') : 해당 문자열값의 바이트수 변환 
    
    '김', '나', 'ㄱ' 한글자당 3BYTE
    영문자, 숫자, 특수문자 한글자당 1BYTE 
*/

SELECT SYSDATE FROM DUAL; -- 가상 테이블

SELECT LENGTH ('티니핑'), LENGTHB('티니핑')
FROM DUAL;

SELECT LENGTH('PING'), LENGTHB('PING')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM EMPLOYEE; -- 매행마다 다 실행되고 있음! => 단일행 함수

/*
    * INSTR
    문자열로부터 특정 문자의 시작 위치를 찾아서 반환
    
    INSTR(컬럼|'문자열'|'찾고자하는문자'['찾을위치의 시작값', 순번]) => 결과값은 NUMER 타입!
    
    찾을위치의 시작값
    1 : 앞에서부터
    -1 : 뒤에서부터
*/

SELECT INSTR('AABAACAABBAA','B') FROM DUAL; --3
SELECT INSTR('AABAACAABBAA','B', 1) FROM DUAL; --3
SELECT INSTR('AABAACAABBAA','B', -1) FROM DUAL; -- 10 : 뒤에서부터 1
SELECT INSTR('AABAACAABBAA','B', 1, 2) FROM DUAL; -- 앞에서부터 찾는데 2번째
SELECT INSTR('AABAACAABBAA','B', -1, 3) FROM DUAL; -- 뒤에서부터 찾는데 3번째

SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) AS "_의 위치", INSTR(EMAIL,'@') AS "@의 위치"
FROM EMPLOYEE;
---------------------------------------------------------------------------------------------------
/*
    * SUBSTR
    문자열에서 특정 문자열을 추출해서 반환 (자바에서의 SUBSTRING() 메소드와 굉장히 유사)
    
    SUBSTR (STRING, POSITION, [LENGTH]) => 결과값이 CHARACTER 타입
*/

SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL; --T부터
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL; -- M포함 두개
SELECT SUBSTR('SHOWMETHEMONEY', 1,6) FROM DUAL; 
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL; -- T로부터 3글자

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8,1) AS "성별"
FROM EMPLOYEE;

-- 여자 사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO, 8, 1 ) = '2' OR SUBSTR(EMP_NO,8,1) = '4' ;
WHERE SUBSTR(EMP_NO, 8, 1 ) IN ('2','4');

-- 남자 사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN (1, 3) -- 내부적으로 자동형변환이 된다
ORDER BY 1; --컬럼 순서

-- 함수 중첩 사용
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1 , INSTR(EMAIL,'@')-1) AS "아이디"
FROM EMPLOYEE;

----------------------------------------------------------------------------------

/*
    *LPAD/ RPAD
    문자열을 조회할 때 통일감있게 조회하고자할 때 사용
    LPAD/RAPD(STRING 최종적으로 반환할 문자의 길이 [덧붙이고나하는 문자])
*/
SELECT EMP_NAME, LPAD(EMAIL,20) -- 덧붙이고자하는 문자 생략시 기본값이 공백!
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,20, '#' ) 
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,20, '#' ) 
FROM EMPLOYEE;

-- 850101-2****** 14글자
SELECT RPAD('850101-2', 14, '*')
FROM DUAL;

SELECT RPAD(SUBSTR(EMP_NO, 1, 8),14, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8)|| '******'
FROM EMPLOYEE;

----------------------------------------------------------------------------------------

/*
    LTRIM / RTRIM
    문자열에서 특정 문자를 제거한 나머지를 반환
    
    LTRIM / RTIM(STRING, ['제거할문자들']) => 생략하면 공백 제거!
*/
SELECT LTRIM('       K  H   ')FROM DUAL; -- 공백 찾아 제거하다가 문자 나오면 멈춤
SELECT LTRIM('123123KH123','123')FROM DUAL; -- 문자 찾다가 다른 문자 나오면 멈춤
SELECT LTRIM('ACCAAAKH', 'ABC') FROM DUAL; -- A또는 B 또는 C 제거

SELECT RTRIM('5782KH123','0123456789') FROM DUAL; -- 오른쪽부터 0123456798 제거

/*
    * TRIM
    문자열의 앞 / 뒤 / 양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    
    TRIM([LEADING | TRAILING | BOTH ][제거하고자하는 문자들 FROM] STRING)
*/
-- 기본적으로는 양쪽에 있는 문자들을 다 찾아서 제거
SELECT TRIM('       K   H ') FROM DUAL; -- 양옆 공백 제거
--SELECT TRIM('ZZZZKHZZZ','Z') FROM DUAL; 
SELECT TRIM('Z' FROM 'ZZZZKHZZZZ') FROM DUAL; --이렇게 해야 공백 제거
SELECT TRIM(LEADING'Z' FROM 'ZZZZKHZZZZ') FROM DUAL; -- 앞에 있는 Z를 제거
SELECT TRIM(TRAILING'Z' FROM 'ZZZZKHZZZZ') FROM DUAL; -- 뒤에 있는 Z를 제거
SELECT TRIM(BOTH'Z' FROM 'ZZZZKHZZZZ') FROM DUAL; -- 양옆 제거

--------------------------------------------------------------------------------
/*
    *LOWER / UPPER / INITCAP
    
    LOWER / UPPER / INITCAP(STRING) => 결과값은 CHARCTER 타입!
*/

SELECT LOWER('Welcome To The Show') FROM DUAL;
SELECT UPPER('Welcome To The Show') FROM DUAL;
SELECT INITCAP('welcome to the show') FROM DUAL;

--------------------------------------------------------------------------------
/*
    CONCAT
    문자열 두 개 전달 받아서 하나로 합친 후 결과 반환
    
    CONCAT(STRING1, STRING2)
*/
SELECT CONCAT('ABC','초콜릿') FROM DUAL;
SELECT 'ABC'||'초콜릿' FROM DUAL;

SELECT CONCAT('ABC','초콜릿','맛있다') FROM DUAL; -- 오류 발생!
SELECT 'ABC'||'초콜릿'||'맛있다' FROM DUAL;

--------------------------------------------------------------------------------
/*
    * REPLACE(STRING, STR1, STR2) -- 1->2
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL,'kh.ok.kr','gmail.com')
FROM EMPLOYEE;

--------------------------------------------------------------------------------

/*
    < 숫자 처리 함수 >
    * ABS 숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER)
*/

SELECT ABS(-10.5) FROM DUAL;

--------------------------------------------------------------------------------
/*
     * MOD
     두 수를 나눈 나머지값을 반환해주는 함수
     
     MOD(NUMBER, NUMBER)
*/

SELECT MOD (10.9, 3 ) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * ROUND
    반올림한 결과를 반환
    
    ROUND(NUMBER)
*/

SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456,1) FROM DUAL;

--------------------------------------------------------------------------------
/*
    *CEIL
    올림처리 해주는 함수
*/
SELECT CEIL(123.152) FROM DUAL;

--------------------------------------------------------------------------------
/*
    *FLOOR
    소수점 바로 아래 버림처리 하는 함수
    
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.951)FROM DUAL;
--------------------------------------------------------------------------------
    /*
    TRUNC (절삭하다)
    위치 지정 가능한 버림 처리 해주는 함수
    TRUNC(NUMBER, [위치])
    */
    
SELECT TRUNC (123.456) FROM DUAL;
SELECT TRUNC (123.456 , 1 ) FROM DUAL;

--------------------------------------------------------------------------------
/*
    <날짜 처리 함수>

    SYSDATE : 시스템 날짜 및 시간 변환
*/ 
SELECT SYSDATE FROM DUAL;

--* MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜의 개월수
-- EMPLOYEE에서 사원명, 근무일수, 근무 개월수
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE) ||'일' AS "근무일수", CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' AS "근무개월수"
FROM EMPLOYEE;


--* ADD_MONTHS(DATE, NUMBER) : 특정 날짜에 해당숫자만큼 개월수 더해서 알려줌
SELECT ADD_MONTHS(SYSDATE, 6) FROM DUAL;

-- 사원명, 입사일, 입사후 3개월이 된 날짜
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3) AS "수습이 끝나는 날짜"
FROM EMPLOYEE;

-- *NEXT_DAY(DATE,요일) : 해당 날짜 이후에 가장 가까운 요일의 반환해주는 함수
--SELECT SYSDATE, NEXT_DAY(SYSDATE, '화요일' /*'화'*/) FROM DUAL;
--SELECT SYSDATE, NEXT_DAY(SYSDATE, '화') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 3) FROM DUAL;
-- 1 : 일요일 2 : 월요일 3 : 화요일,... 7 : 토요일


-- *LAST_DAY(DATE) : 해당월의 마지막 날짜를 구해서 반환+-
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원명, 입사일, 입사한달의 마지막 날짜, 입사한달에 근무한 일수
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE)- HIRE_DATE
FROM EMPLOYEE;

/*
    * EXTRACT : 특정날짜로부터 년도|월|일 값을 추출해서 반환하는 함수
    
    EXTRACT(YEAR FROM DATE) : 년도만 추출
    EXTRACT(MONTH FROM DATE) : 월만 추출
    EXTRACT(DAY FROM DATE) : 일만 추출
    
*/

-- 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME, 
EXTRACT (YEAR FROM HIRE_DATE) AS "입사년도",
EXTRACT (MONTH FROM HIRE_DATE) AS "입사월",
EXTRACT (DAY FROM HIRE_DATE) AS "입사일"
FROM EMPLOYEE
ORDER BY "입사년도", "입사월", "입사일"; -- 첫번째 컬럼의 값이 같을 경우 두번째 컬럼 값 기준으로 정렬

--------------------------------------------------------------------------------

/*
    <형변환 함수>
    
    * TO_ CHAR : 숫자 타입이나 날짜 타입의 값을 문자타입으로 변환 시켜주는 함수
    
      TO_CHAR(숫자|날짜, [포맷])
*/

-- 숫자타입 => 문자타입
SELECT TO_CHAR(1234) FROM DUAL; -- '1234'로 바뀌어 있는거임
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 앞에 공백
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라의 화폐 단위
SELECT TO_CHAR(1234, '$99999') FROM DUAL; 
SELECT TO_CHAR(1234, 'L99,999') FROM DUAL; -- 데이터를 원하는 형태로 출력 가능

SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999')
FROM EMPLOYEE;

-- 날짜타입 => 문자타입
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL; -- HH : 12시간 형식
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; -- HH : 24시간 형식
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') FROM DUAL; -- 2025-07-11
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;  -- 2025-07-11 금

SELECT EMP_NAME, HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
FROM EMPLOYEE;

-- EX) 1990년 02월 06일 형식
--SELECT EMP_NAME, HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY년 MM월 DD일') -- 오류 : 없는 포멧


SELECT EMP_NAME, HIRE_DATE, TO_CHAR(HIRE_DATE, 'YYYY"년"-MM"월"-DD"일"') -- 없는 포멧 제시시 ""로 묶기
FROM EMPLOYEE;

-- 년도와 관련된 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM')
FROM DUAL;

-- 일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 올해 기준으로 오늘이 며칠 째 인지
       TO_CHAR(SYSDATE, 'DD'), -- 월 기준으로 오늘이 며칠째인지
       TO_CHAR(SYSDATE, 'D') -- 주를 기준으로 오늘이 며칠째인지 (6-금)
FROM DUAL;

    -- 요일에 대한 포맷
    SELECT TO_CHAR(SYSDATE, 'DAY'), --금요일
           TO_CHAR(SYSDATE, 'DY') --금
    FROM DUAL;

--------------------------------------------------------------------------------

/*
    *TO_DATE : 숫자타입 또는 문자타입 데이터를 날짜 타입으로 변환시켜주는 함수
    
    TO_DATE(숫자|문자,[포맷])
*/

SELECT TO_DATE(20100101) FROM DUAL;
SELECT TO_DATE(100101) FROM DUAL;

--SELECT TO_DATE(070101) FROM DUAL; -- 에러
SELECT TO_DATE('070101') FROM DUAL; -- 첫글자가 0인 경우에는 무조건 문자 타입으로 변경해야함

SELECT TO_DATE('041030 143000', 'YYMMDD HH24MISS') FROM DUAL;
SELECT TO_CHAR(TO_DATE('041030 143000', 'YYMMDD HH24MISS'), 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

SELECT TO_DATE('140630','YYMMDD') FROM DUAL; --2014
SELECT TO_DATE('980630','YYMMDD') FROM DUAL; -- 2098 => 무조건 현재 세기로 반영!

SELECT TO_DATE('140630','RRMMDD') FROM DUAL; --2014
SELECT TO_DATE('980630','RRMMDD') FROM DUAL; -- 1998
-- RR: 해당 두자리 년도 값이 50미만일 경우 현재세기 반영, 50이상일 경우 이전세기 반영

-- 웹상에서 날짜의 데이터를 넘겨도 무조건 문자로 넘어옴!!


--------------------------------------------------------------------------------
/*
    *TO_NUMBER : 문자타입의 데이터를 숫자타입으로 변환시켜주는 함수
    
    TO_NUMBER(문자,[포맷])
*/

SELECT TO_NUMBER('01052565979') FROM DUAL; -- 맨 앞 0은 날아감

SELECT '1000000' + '55000' FROM DUAL; -- 워라클은 자동형변환이 돼서 연산 가능
--SELECT '1,000,000' + '55,000' FROM DUAL; 형변환은 자동이지만 숫자만 있어야 자동

SELECT TO_NUMBER ('1,000,000','9,999,999') + TO_NUMBER('55,000','999,999') FROM DUAL;

----------------------------------------------------------------------------------------
/*
    < NULL 처리 함수 >
*/

-- NVL(컬럼, 해당 컬럼값이 NULL일 경우 반환할 값)
SELECT EMP_NAME, BONUS, NVL(BONUS, 0)
FROM EMPLOYEE;

-- 이름, 보너스포함 연봉
SELECT EMP_NAME, BONUS, (SALARY + SALARY * BONUS)*12, (SALARY + SALARY * NVL(BONUS, 0))*12
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, 0)
FROM EMPLOYEE;


-- NVL2(컬럼, 반환값1, 반환값2)
-- 컬럼값이 존재할 경우 반환값 1을 반환
-- 컬럼값이 NULL일 경우 반환값2 반환

SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.1)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서있음','부서없음')
FROM EMPLOYEE;

-- NULLIF(비교대상1, 비교대상2)
-- 두 개의 값이 일치하면 NULL을 반환
-- 두 개의 값이 일치하지 않으면 비교대상1 값을 반환

SELECT NULLIF('123','123')FROM DUAL;
SELECT NULLIF('123','456')FROM DUAL;

/*
    <선택 함수>
    
    * DECODE(비교하고자하는대상, 비교값1, 결과값1, 비교값2, 결과값2, ....)

    SWITCH(비교대상){
    CASE 비교값1
    CASE 비교값2
    .....
    DEFAULT
    }
*/

-- 사번, 사원명, 주민번호
SELECT EMP_ID, EMP_NAME, EMP_NO, SUBSTR(EMP_NO,8,1),
DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') AS "성별"
FROM EMPLOYEE;

-- 직원의 급여 조회시 각 직급별로 인상해서 조회
-- J7 사원은 급여를 10% 인상(SLALRY *1.1)
-- J6 사원은 급여를 15% 인상 (SALARY *1.15)
-- J5 사원은 급여를 15% 인상 (SALARY *1.2)
-- 그 외의 사원은 급여를 5% 인상 (SALARY * 1.05)

-- 사원명, 직급코드, 기존급여, 인상된급여
SELECT EMP_NAME, JOB_CODE, SALARY,
     DECODE(JOB_CODE,'J7',SALARY *1.1,
                    'J6', SALARY *1.15,
                    'J5', SALARY *1.2,
                    SALARY * 1.05) AS "인상된 급여"
FROM EMPLOYEE;

/*
    *CASE WHEN THEN
    
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
    END
         
*/

SELECT EMP_NAME, SALARY,
CASE WHEN SALARY >= 5000000 THEN '고급 개발자'
     WHEN SALARY >= 3500000 THEN '중급 개발자'
     ELSE '초급 개발자'
    END AS "레벨"
FROM EMPLOYEE;

----------------------------------< 그룹함수 >------------------------------------

-- 1.SUM(숫자타입컬럼) : 해당 컬럼 값들의 총 합계를 구해서 반환해주는 함수

-- 전체 사원의 총 급여합
SELECT SUM(SALARY)
FROM EMPLOYEE; -- 전체사원이 한 그룹으로 묶임
-- 남자 사원들의  총 급여합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN ('1','3'); -- 남자 사원들이 한 그룹으로 묶임

-- 부서코드가 D5인 사원들의 총 연봉합(보너스 미포함)

SELECT SUM(SALARY*12)
FROM EMPLOYEE /*, EMP_NAME*/
WHERE DEPT_CODE = 'D5'; -- 그룹함수는 그룹함수끼리 단일함수는 단일 함수끼리

-- 2.AVG(숫자타입): 해당 컬럼값들의 평균값을 구해서 변환
-- 전체사원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE;

--3. MIN(여러타입) : 해당 컬럼값들 중에 가장 작은 값 구해서 반환
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE) -- 각각임!!
FROM EMPLOYEE;

--4. MAX(여러타입) : 해당 컬럼값들 중에 가장 큰 값 구해서 반환
SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;

--5. COUNT(*|컬럼|DISTINCT 컬럼) : 조회된 행 개수를 세서 반환
-- COUNT(*) : 조회된 결과의 모든 행의 개수를 세서 반환
-- COUNT(컬럼) : 제시한 해당 컬럼값이 NULL이 아닌 것만 행 개수 세서 반환
-- COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복 제거한 후 행 개수 세서 반환

-- 전체사원수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 보너스를 받는 사원 수
SELECT COUNT(BONUS)
FROM EMPLOYEE;

-- 남자 사원 중 보너스를 받는 사원 수
SELECT COUNT(BONUS)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN('1','3');

-- 부서배치를 받은 사원 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

-- 현재 사원들이 총 몇 개의 부서에 분포되어있는지
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

















