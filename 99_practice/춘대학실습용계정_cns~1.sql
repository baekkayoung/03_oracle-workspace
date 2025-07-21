--1. 춘 기술대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명", "계열" 으로 표시하도록 한다.

SELECT DEPARTMENT_NAME AS "학과명" ,CATEGORY AS "계열"
FROM TB_DEPARTMENT;

--2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
SELECT (DEPARTMENT_NAME||'의 정원은 '||CAPACITY||'명 입니다.')AS "학과별 정원"
FROM TB_DEPARTMENT;

--3.  "국어국문학과" 에 다니는 여학생 중 현재 휴학중인 여학생을 찾아달라는 요청이 
-- 들어왔다. 누구인가? (국문학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 
-- 찾아 내도록 하자)
SELECT DEPARTMENT_NO, DEPARTMENT_NAME
FROM TB_DEPARTMENT; 
-- 001

SELECT *
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y' AND SUBSTR(STUDENT_SSN,8,1) IN ('2','4') AND DEPARTMENT_NO = '001';


--4. 도서관에서 대출 도서 장기 연체자 들을 찾아 이름을 게시하고자 한다. 그 대상자들의 
-- 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.

SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN('A513079', 'A513090', 'A513091', 'A513110', 'A513119');


--5. 입학정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;

--6. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.  
-- 그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;

-- 7. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 
-- 어떠한 SQL 문장을 사용하면 될 것인지 작성하시오.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;


-- 8. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 
-- 과목들은 어떤 과목인지 과목번호를 조회해보시오.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

--9. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
SELECT DISTINCT CATEGORY 
FROM TB_DEPARTMENT;

-- 10. 02 학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 
-- 학생들의 학번, 이름, 주민번호를 출력하는 구문을 작성하시오. 
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_NO LIKE 'A2%' AND ABSENCE_YN = 'N' AND STUDENT_ADDRESS LIKE '%전주%';










--1. 영어영문학과(학과코드 002) 학생들의 학번과 이름, 입학 년도를 입학 년도가 빠른 
-- 순으로 표시하는 SQL 문장을 작성하시오.( 단, 헤더는 "학번", "이름", "입학년도" 가 
-- 표시되도록 한다)
SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "이름", TO_CHAR(ENTRANCE_DATE,'YYYY-MM-DD') AS "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO =002
ORDER BY 3;

-- 2. 춘 기술대학교의 교수 중 이름이 세 글자가 아닌 교수가 두 명 있다고 핚다. 그 교수의 
-- 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해 보자. (* 이때 올바르게 작성한SQL 
-- 문장의 결과 값이 예상과 다르게 나올 수 있다. 원인이 무엇일지 생각해볼 것) 
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE PROFESSOR_NAME NOT LIKE '___';

-- 3. 춘 기술대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오. 단 
-- 이때 나이가 적은 사람에서 많은 사람 순서로 화면에 출력되도록 맊드시오. (단, 교수 중 
-- 2000 년 이후 출생자는 없으며 출력 헤더는 "교수이름", "나이"로 핚다. 나이는 ‘만’으로 
-- 계산한다.)
SELECT PROFESSOR_NAME AS "교수이름", EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER('19' || SUBSTR(PROFESSOR_SSN, 1, 2))  AS "나이" 
FROM TB_PROFESSOR 
WHERE SUBSTR(PROFESSOR_SSN,8,1)IN('1')
ORDER BY 2;

-- TRUNC(MONTHS_BETWEEN(SYSDATE, 생일) / 12)
-- 내가 처음 시도 했던거((EXTRACT(YEAR FROM SYSDATE))-(INSTR(PROFESSOR_SSN,1,4))) AS "나이"
-- EXTRACT(YEAR FROM SYSDATE) - TO_NUMBER('19' || SUBSTR(PROFESSOR_SSN, 1, 2))
-- FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(EMP_NO, 1, 6),'RRMMDD'))/12)
-- FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE('19' || SUBSTR(PROFESSOR_SSN, 1, 6), 'YYYYMMDD')) / 12)
-- TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(PROFESSOR_SSN, 1, 6), 'RRMMDD'))/12)
-- TO_NUMBER('19' || SUBSTR(PROFESSOR_SSN, 1, 2))
-- FLOOR(MONTHS_BETWEEN(SYSDATE,TO_DATE('19'||SUBSTR(PROFESSOR_SSN, 1,6)


-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 
-- 출력 헤더는 "이름" 이 찍히도록 핚다. (성이 2자인 경우는 교수는 없다고 가정하시오) 

SELECT SUBSTR(PROFESSOR_NAME,2,3) AS "이름"
FROM TB_PROFESSOR;

-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가?  이때, 
-- 19살에 입학하면 재수를 하지 않은 것으로 간주한다.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)- TO_NUMBER(19||SUBSTR(STUDENT_SSN,1,2))> 19;

-- - EXTRACT(YEAR FROM ENTRANCE_DATE)
-- TO_NUMBER(ENTRANCE_DATE , 'YYYY')
-- 19살에 입학하면 재수안한거니까 20살 부터 조회
-- STUDENT_SSN - ENTRANCE_DATE 생년에서 입학한 연도 뺀 값이 19보다 큰?
-- (19||SUBSTR(STUDENT_SSN,1,2) - (ENTRANCE_DATE,'YYYY') > 19;
-- FLOOR(MONTHS_BETWEEN(ENTRANCE_DATE,TO_DATE('19' || SUBSTR(STUDENT_SSN, 1, 6), 'YYYYMMDD')) / 12) 

-- 6. 2020년 크리스마스는 무슨 요일인가?
SELECT TO_CHAR(TO_DATE('20201225','YYYY-MM-DD'),'YYYY-MM-DD DAY') FROM DUAL;

-- 7.TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미핛까? 
-- 또 TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('49/10/11','RR/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까?
/* 
TO_DATE('99/10/11','YY/MM/DD')는 2099년 10월 11일, TO_DATE('49/10/11','YY/MM/DD')는 2049년 10월 11일로 조회된다.
연도 자리의 RR은 앞에 두자리가 50 미만일 경우 현재세기, 이상일 경우 이전세기로 조회된다.
따라서 TO_DATE('99/10/11','RR/MM/DD')는 1999년 10월 11일이고 TO_DATE('49/10/11','RR/MM/DD')는 2049년 10월 11일을 의미한다.
*/


-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
--2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오. 
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%'; 


-- 9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 
--단, 이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 핚 
-- 자리까지맊 표시핚다.

SELECT ROUND(AVG(POINT), 1) AS "평점"
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
WHERE STUDENT_NO = 'A517178';

-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 맊들어 결과값이 출력되도록 하시오.
/*SELECT DEPARTMENT_NO AS "학과번호", CAPACITY AS "학생수(명)"
FROM TB_DEPARTMENT
WHERE */

SELECT DEPARTMENT_NO AS "학과 번호" , COUNT(*) AS "학생수(명)" 
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을 작성하시오.
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고,
-- 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.

SELECT SUBSTR(TERM_NO,1,4) AS "년도", ROUND(AVG(POINT),1) AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY SUBSTR(TERM_NO,1,4)
ORDER BY 1;

-- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.

SELECT DEPARTMENT_NO AS "학과코드명" , COUNT(CASE WHEN ABSENCE_YN = 'Y' THEN 1 END) AS "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 1;

-- 14.  춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 핚다. 어떤 SQL 문장을 사용하면 가능하겠는가?
SELECT STUDENT_NAME AS "동일이름", COUNT(*) AS "동명인 수"
FROM TB_STUDENT
HAVING COUNT(*) >= 2
GROUP BY STUDENT_NAME;

-- 15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점 , 총 평점
-- 을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1자리까지맊 반올림하여 표시한다.)
SELECT NVL(SUBSTR(TERM_NO,1,4),' ') AS "년도" , NVL(SUBSTR(TERM_NO,5,2),' ')AS "학기", ROUND(AVG(POINT),1) AS "학기"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY ROLLUP(SUBSTR(TERM_NO,1,4), SUBSTR(TERM_NO,5,2));

 
 
 
 
 
 
 
 
 
 
 
 
 
 
-- 1. 학생이름과 주소지를 표시하시오. 
-- 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.

SELECT STUDENT_NAME AS "학생이름", STUDENT_ADDRESS AS "주소지"
FROM TB_STUDENT 
ORDER BY 1;

-- 2.  휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.

SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN ='Y'
ORDER BY 2 DESC;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 
-- 주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번", 
-- "거주지 주소" 가 출력되도록 한다.

SELECT STUDENT_NAME AS "학생이름", STUDENT_NO AS "학번", STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO NOT LIKE 'A%' AND STUDENT_ADDRESS LIKE '경기도%' OR STUDENT_ADDRESS LIKE '강원도%'
ORDER BY 1;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오
-- (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자) 
SELECT P.PROFESSOR_NAME, P.PROFESSOR_SSN
FROM TB_PROFESSOR P 
JOIN TB_DEPARTMENT D USING (DEPARTMENT_NO)
WHERE P.DEPARTMENT_NAME = '법학과'
ORDER BY SUBSTR(P.PROFESSOR_SSN, 1, 6) DESC
;------------------------------------------------------------------------------------------------------------


--5 2004년2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다.
-- 학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
SELECT STUDENT_NO, POINT
FROM TB_CLASS
JOIN TB_GRADE USING(CLASS_NO)
WHERE CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO ASC;

--6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오. 
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME ASC;


--7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);


--8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_PROFESSOR USING(DEPARTMENT_NO)
JOIN TB_CLASS_PROFESSOR USING(PROFESSOR_NO);

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO);

--9. 8번의 결과 중 ‘인문사회’ 계열에 속핚 과목의 교수 이름을 찾으려고 핚다. 이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.

SELECT C.CLASS_NAME,P.PROFESSOR_NAME
FROM TB_CLASS C
JOIN TB_CLASS_PROFESSOR CP ON C.CLASS_NO = CP.CLASS_NO
JOIN TB_PROFESSOR P ON CP.PROFESSOR_NO = P.PROFESSOR_NO
JOIN TB_DEPARTMENT D ON P.DEPARTMENT_NO = D.DEPARTMENT_NO
WHERE CATEGORY = '인문사회';



-- 10. 춘 기술대학교 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW를 만들고자 핚만다. 아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오.
GRANT CREATE VIEW TO CNS;

CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT;

SELECT * FROM VW_학생일반정보;


--11. 춘 기술대학교는 1년에 두 번씩 학과별로 학생과 지도교수가 지도 면담을 진행한다. 
-- 이를 위해 사용한 학생이름, 학과이름, 담당교수이름 으로 구성되어 있는 VIEW 를 만드시오. 
-- 이때 지도 교수가 없는 학생이 있을 수 있음을 고려하시오 (단, 이 VIEW 는 단순 SELECT 
-- 만을 할 경우 학과별로 정렬되어 화면에 보여지게 만드시오.) 
CREATE OR REPLACE VIEW VW_지도면담
AS SELECT STUDENT_NAME, DEPARTMENT_NAME, PROFESSOR_NAME
FROM TB_STUDENT S
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO =D.DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR P ON (COACH_PROFESSOR_NO= PROFESSOR_NO);

SELECT * FROM VW_지도면담;

-- 12. 모든 학과의 학과별 학생 수를 확인핛 수 있도록 적절한 VIEW 를 작성해 보자.
CREATE OR REPLACE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NAME, COUNT(STUDENT_NO) AS "STUDENT_COUNT"
FROM TB_DEPARTMENT
LEFT JOIN TB_STUDENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NAME;

SELECT * FROM VW_학과별학생수;

-- 13. 위에서 생성한 학생일반정보 View를 통해서 학번이 A213046인 학생의 이름을 본인 이름으로 변경하는 SQL 문을 작성하시오. 
UPDATE VW_학생일반정보
SET STUDENT_NAME ='백가영'
WHERE STUDENT_NO = 'A213046';

-- 14. 13 번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW를 어떻게 생성해야 하는지 작성하시오.
CREATE OR REPLACE VIEW VW_학생일반정보
AS SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT
WITH READ ONLY; -- 추가

-- 15. 춘 기술대학교는 매년 수강신청 기간만 되면 특정 인기 과목들에 수강 신청이 몰려 문제가 되고 있다. 
-- 최근 5년을 기준으로 수강인원이 가장 많았던 3 과목을 찾는 구문을  작성해보시오.
SELECT *
FROM (SELECT G.CLASS_NO, C.CLASS_NAME, COUNT(*)
        FROM TB_GRADE G
        JOIN TB_CLASS C ON G.CLASS_NO = C.CLASS_NO
       WHERE TERM_NO BETWEEN 200501 AND 200902
       GROUP BY G.CLASS_NO, C.CLASS_NAME
       ORDER BY COUNT(*) DESC)
WHERE ROWNUM <= 3;


-- 1.과목유형 테이블(TB_CLASS_TYPE)에 아래와 같은 데이터를 입력하시오.
CREATE TABLE TB_CLASS_TYPE(
    NUM NUMBER,
    TYPE_NAME VARCHAR2(30)
);

INSERT INTO TB_CLASS_TYPE VALUES (01,'전공필수');
INSERT INTO TB_CLASS_TYPE VALUES (02,'전공선택');
INSERT INTO TB_CLASS_TYPE VALUES (03,'교양필수');
INSERT INTO TB_CLASS_TYPE VALUES (04,'교양선택');
INSERT INTO TB_CLASS_TYPE VALUES (05,'논문지도');



--  2. 춘 기술대학교 학생들의 정보가 포함되어 있는 학생일반정보 테이블을 맊들고자 핚다. 
-- 아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오. (서브쿼리를 이용하시오)

CREATE TABLE TB_학생일반정보
   AS SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "학생이름", STUDENT_ADDRESS AS "주소"
        FROM TB_STUDENT;

-- 3. 국어국문학과 학생들의 정보맊이 포함되어 있는 학과정보 테이블을 맊들고자 핚다. 
--아래 내용을 참고하여 적젃핚 SQL 문을 작성하시오. (힌트 : 방법은 다양함, 소신껏 
--작성하시오)
CREATE TABLE TB_국어국문학과 (
    STUDENT_NO NUMBER,
    STUDENT_NAME VARCHAR2(30),
    BIRTH_YYYY NUMBER,
    PROFESSOR_NAME VARCHAR2(30)
);



--4. 현 학과들의 정원을 10% 증가시키게 되었다. 이에 사용핛 SQL 문을 작성하시오. (단, 
--반올림을 사용하여 소수점 자릿수는 생기지 않도록 핚다) 

UPDATE TB_DEPARTMENT
SET CAPACITY = ROUND(CAPACITY * 1.10);


--5. 학번 A413042 인 박건우 학생의 주소가 "서울시 종로구 숭인동 181-21 "로 변경되었다고 
--핚다. 주소지를 정정하기 위해 사용핛 SQL 문을 작성하시오. 
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '서울시 종로구 숭인동 181-21'
WHERE STUDENT_NAME ='박건우';


--6. 주민등록번호 보호법에 따라 학생정보 테이블에서 주민번호 뒷자리를 저장하지 않기로 
-- 결정하였다. 이 내용을 반영핛 적젃핚 SQL 문장을 작성하시오.  (예. 830530-2124663 ==> 830530 ) 
UPDATE TB_STUDENT
SET STUDENT_SSN = SUBSTR(STUDENT_SSN,1,6);

--7. 의학과 김명훈 학생은 2005년 1학기에 자신이 수강핚 '피부생리학' 점수가 
--잘못되었다는 것을 발견하고는 정정을 요청하였다. 담당 교수의 확인 받은 결과 해당 
--과목의 학점을 3.5로 변경키로 결정되었다. 적젃핚 SQL 문을 작성하시오. 

SELECT *
FROM TB_STUDENT
JOIN TB_CLASS USING(DEPARTMENT_NO)
WHERE STUDENT_NAME ='김명훈' AND CLASS_NAME ='피부생리학' ; 

-- 

UPDATE TB_GRADE
SET POINT = 3.5
WHERE STUDENT_NO =(
        SELECT STUDENT_NO
        FROM TB_STUDENT
        WHERE STUDENT_NO='A331101'
)
AND CLASS_NO = (
        SELECT CLASS_NO
        FROM TB_CLASS
        WHERE CLASS_NO = 'C3843900'
        );


--8. 성적 테이블(TB_GRADE) 에서 휴학생들의 성적항목을 제거하시오.
DELETE TB_GRADE
WHERE STUDENT_NO IN (
    SELECT STUDENT_NO
    FROM TB_STUDENT
    WHERE ABSENCE_YN = 'Y'
);



