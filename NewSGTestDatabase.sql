--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9
-- Dumped by pg_dump version 14.9

-- Started on 2023-09-04 13:35:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16416)
-- Name: Department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Department" (
    "ID" integer NOT NULL,
    "ParentID" integer,
    "ManagerID" integer,
    "Name" character varying(250) NOT NULL,
    "Phone" character varying(100) NOT NULL
);


ALTER TABLE public."Department" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16415)
-- Name: Department_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Department_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Department_ID_seq" OWNER TO postgres;

--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 213
-- Name: Department_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Department_ID_seq" OWNED BY public."Department"."ID";


--
-- TOC entry 212 (class 1259 OID 16405)
-- Name: Employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Employee" (
    "ID" integer NOT NULL,
    "Department" integer NOT NULL,
    "FullName" character varying(255) NOT NULL,
    "Login" character varying(100) NOT NULL,
    "Password" character varying(255) NOT NULL,
    "JobTitle" integer NOT NULL
);


ALTER TABLE public."Employee" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16404)
-- Name: Employee_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Employee_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Employee_ID_seq" OWNER TO postgres;

--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 211
-- Name: Employee_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Employee_ID_seq" OWNED BY public."Employee"."ID";


--
-- TOC entry 210 (class 1259 OID 16396)
-- Name: JobTitle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."JobTitle" (
    "ID" integer NOT NULL,
    "Name" character varying(250) NOT NULL
);


ALTER TABLE public."JobTitle" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16395)
-- Name: JobTitle_ID_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."JobTitle_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."JobTitle_ID_seq" OWNER TO postgres;

--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 209
-- Name: JobTitle_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."JobTitle_ID_seq" OWNED BY public."JobTitle"."ID";


--
-- TOC entry 3176 (class 2604 OID 16419)
-- Name: Department ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Department" ALTER COLUMN "ID" SET DEFAULT nextval('public."Department_ID_seq"'::regclass);


--
-- TOC entry 3175 (class 2604 OID 16408)
-- Name: Employee ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee" ALTER COLUMN "ID" SET DEFAULT nextval('public."Employee_ID_seq"'::regclass);


--
-- TOC entry 3174 (class 2604 OID 16399)
-- Name: JobTitle ID; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."JobTitle" ALTER COLUMN "ID" SET DEFAULT nextval('public."JobTitle_ID_seq"'::regclass);


--
-- TOC entry 3337 (class 0 OID 16416)
-- Dependencies: 214
-- Data for Name: Department; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3335 (class 0 OID 16405)
-- Dependencies: 212
-- Data for Name: Employee; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3333 (class 0 OID 16396)
-- Dependencies: 210
-- Data for Name: JobTitle; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3346 (class 0 OID 0)
-- Dependencies: 213
-- Name: Department_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Department_ID_seq"', 5, true);


--
-- TOC entry 3347 (class 0 OID 0)
-- Dependencies: 211
-- Name: Employee_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Employee_ID_seq"', 19, true);


--
-- TOC entry 3348 (class 0 OID 0)
-- Dependencies: 209
-- Name: JobTitle_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."JobTitle_ID_seq"', 12, true);


--
-- TOC entry 3186 (class 2606 OID 16421)
-- Name: Department Department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "Department_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3182 (class 2606 OID 16412)
-- Name: Employee Employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "Employee_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3178 (class 2606 OID 16401)
-- Name: JobTitle JobTitle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."JobTitle"
    ADD CONSTRAINT "JobTitle_pkey" PRIMARY KEY ("ID");


--
-- TOC entry 3188 (class 2606 OID 16435)
-- Name: Department department_name_parentid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT department_name_parentid_unique UNIQUE ("Name", "ParentID");


--
-- TOC entry 3184 (class 2606 OID 16414)
-- Name: Employee employee_fullname_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT employee_fullname_unique UNIQUE ("FullName");


--
-- TOC entry 3180 (class 2606 OID 16403)
-- Name: JobTitle jobtitle_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."JobTitle"
    ADD CONSTRAINT jobtitle_name_unique UNIQUE ("Name");


--
-- TOC entry 3189 (class 2606 OID 16424)
-- Name: Employee department_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT department_fkey FOREIGN KEY ("Department") REFERENCES public."Department"("ID") NOT VALID;


--
-- TOC entry 3190 (class 2606 OID 16436)
-- Name: Employee jobtitle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT jobtitle FOREIGN KEY ("JobTitle") REFERENCES public."JobTitle"("ID") NOT VALID;


--
-- TOC entry 3191 (class 2606 OID 16429)
-- Name: Department manager_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT manager_fkey FOREIGN KEY ("ManagerID") REFERENCES public."Employee"("ID") NOT VALID;


--
-- TOC entry 3192 (class 2606 OID 16441)
-- Name: Department parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "parentId_fkey" FOREIGN KEY ("ParentID") REFERENCES public."Department"("ID") NOT VALID;


-- Completed on 2023-09-04 13:35:55

--
-- PostgreSQL database dump complete
--

