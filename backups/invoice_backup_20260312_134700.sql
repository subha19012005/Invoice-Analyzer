--
-- PostgreSQL database dump
--

\restrict pI1cI5Z7Z5bOezRCuACxdr52bcxnZa0ka8AWwSzhQ0Wymotjp2xy1DmbSfAtRn2

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: invoice_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.invoice_status AS ENUM (
    'in review',
    'done',
    'yet to start',
    'reject'
);


ALTER TYPE public.invoice_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    key_hash text NOT NULL,
    owner_name character varying(100),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_used timestamp without time zone
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_keys_id_seq OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: email_ingestion_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_ingestion_logs (
    id integer NOT NULL,
    email_subject character varying,
    filename character varying,
    email_from character varying,
    email_date timestamp without time zone,
    status character varying,
    invoice_id integer,
    error_message character varying,
    drive_file_id character varying,
    drive_link character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.email_ingestion_logs OWNER TO postgres;

--
-- Name: email_ingestion_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_ingestion_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_ingestion_logs_id_seq OWNER TO postgres;

--
-- Name: email_ingestion_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_ingestion_logs_id_seq OWNED BY public.email_ingestion_logs.id;


--
-- Name: invoice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice (
    id integer NOT NULL,
    invoice_no character varying(100),
    customer_name character varying(255),
    vendor_name character varying(255),
    po_number character varying(100),
    invoice_date date,
    total_amount numeric(12,2),
    total_tax numeric(12,2),
    file_link text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.invoice OWNER TO postgres;

--
-- Name: invoice_audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_audit_logs (
    id integer NOT NULL,
    invoice_id integer,
    user_id integer,
    action character varying,
    old_value json,
    new_value json,
    notes character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.invoice_audit_logs OWNER TO postgres;

--
-- Name: invoice_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoice_audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoice_audit_logs_id_seq OWNER TO postgres;

--
-- Name: invoice_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_audit_logs_id_seq OWNED BY public.invoice_audit_logs.id;


--
-- Name: invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoice_id_seq OWNER TO postgres;

--
-- Name: invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_id_seq OWNED BY public.invoice.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    invoice_number character varying,
    vendor_name character varying,
    vendor_email character varying,
    customer_name character varying,
    po_number character varying,
    invoice_date timestamp without time zone,
    amount double precision,
    tax double precision,
    total_amount double precision,
    status character varying,
    email_id character varying,
    email_subject character varying,
    pdf_url character varying,
    drive_file_id character varying,
    ocr_data json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reviewed_by character varying(255),
    reviewed_at timestamp without time zone
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO postgres;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: line_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.line_items (
    id integer NOT NULL,
    invoice_id integer,
    description character varying,
    quantity double precision,
    unit_price double precision,
    total_price double precision,
    created_at timestamp without time zone
);


ALTER TABLE public.line_items OWNER TO postgres;

--
-- Name: line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.line_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.line_items_id_seq OWNER TO postgres;

--
-- Name: line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.line_items_id_seq OWNED BY public.line_items.id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_logs (
    id integer NOT NULL,
    username character varying,
    action character varying,
    details character varying,
    ip_address character varying,
    created_at timestamp without time zone
);


ALTER TABLE public.system_logs OWNER TO postgres;

--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_logs_id_seq OWNER TO postgres;

--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_logs_id_seq OWNED BY public.system_logs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    role character varying,
    is_active boolean,
    created_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: email_ingestion_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_ingestion_logs ALTER COLUMN id SET DEFAULT nextval('public.email_ingestion_logs_id_seq'::regclass);


--
-- Name: invoice id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice ALTER COLUMN id SET DEFAULT nextval('public.invoice_id_seq'::regclass);


--
-- Name: invoice_audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.invoice_audit_logs_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: line_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_items ALTER COLUMN id SET DEFAULT nextval('public.line_items_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN id SET DEFAULT nextval('public.system_logs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: api_keys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.api_keys (id, key_hash, owner_name, is_active, created_at, last_used) FROM stdin;
\.


--
-- Data for Name: email_ingestion_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_ingestion_logs (id, email_subject, filename, email_from, email_date, status, invoice_id, error_message, drive_file_id, drive_link, created_at) FROM stdin;
1	Fwd: Bill	cam invoice GOOD MORNING TECHNOLOGY INDIA July 16, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 15:08:07	failed	\N	OCR extraction failed	\N	\N	2026-02-27 15:35:42.963336
2	Fwd: Bill	cam invoice GOOD MORNING TECHNOLOGY INDIA July 16, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 15:38:38	failed	\N	OCR extraction failed	\N	\N	2026-02-27 17:41:39.267567
3	Invoice	22049.png	Sakthi Priya <priya.krish051@gmail.com>	2026-02-26 11:06:21	failed	\N	OCR extraction failed	\N	\N	2026-02-27 18:04:00.059147
4	Invoice	N/A	Sakthi Priya <priya.krish051@gmail.com>	2026-02-26 11:00:03	skipped	\N	No valid attachments	\N	\N	2026-02-27 18:05:31.867162
5	Bill	Nova 3D July 31, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 18:23:01	success	9	\N	1JY-MJUucaLHOQXl4RkOJ7ebCxAFl7pGj	https://drive.google.com/file/d/1JY-MJUucaLHOQXl4RkOJ7ebCxAFl7pGj/view?usp=drivesdk	2026-02-27 18:25:03.970017
6	Fwd: Bill	cam invoice GOOD MORNING TECHNOLOGY INDIA July 16, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 18:38:55	success	\N	\N	\N	\N	2026-02-27 20:40:51.056141
7	Fwd: Bill	Numakers Asia LLP Aug 23, 2025 - 1.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 20:27:54	success	14	\N	1HbQ3uapXN7NROBNjP16NPiGYuJQG96XL	https://drive.google.com/file/d/1HbQ3uapXN7NROBNjP16NPiGYuJQG96XL/view?usp=drivesdk	2026-02-27 20:47:13.176812
8	Bill	Numakers Asia LLP Aug 23, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-02-27 21:40:49	success	15	\N	1KBa7AFW6OP13y9Fhj9aHmuUj_fHGUhZA	https://drive.google.com/file/d/1KBa7AFW6OP13y9Fhj9aHmuUj_fHGUhZA/view?usp=drivesdk	2026-02-27 22:11:55.26049
9	Invoice	22063.webp	Sakthi Priya <priya.krish051@gmail.com>	2026-03-02 17:37:46	success	\N	\N	1_QcLwHTJz_khOXWNBzrkgXYsW2L5VeqK	https://drive.google.com/file/d/1_QcLwHTJz_khOXWNBzrkgXYsW2L5VeqK/view?usp=drivesdk	2026-03-02 17:39:49.658855
10	Invoice	35.webp	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-02 17:39:03	success	16	\N	1dusR7stfcID6twWD5qIPzmJl4UbfU9Kd	https://drive.google.com/file/d/1dusR7stfcID6twWD5qIPzmJl4UbfU9Kd/view?usp=drivesdk	2026-03-02 17:53:57.889336
11	Payment	Numakers Asia LLP Aug 23, 2025 - 1.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 17:53:59	success	\N	\N	1YFKYBK66Q5HV5HEUWva5t1rFceMKqvTS	https://drive.google.com/file/d/1YFKYBK66Q5HV5HEUWva5t1rFceMKqvTS/view?usp=drivesdk	2026-03-02 18:05:27.320656
12	Invoice	purchase_invoice_template_xls-o.jpg	Subha <subharaja1905@gmail.com>	2026-03-02 17:56:33	success	18	\N	1UB4RXkKwSzzoi_hdNUUwM4s11GkZWuvn	https://drive.google.com/file/d/1UB4RXkKwSzzoi_hdNUUwM4s11GkZWuvn/view?usp=drivesdk	2026-03-02 18:05:42.551626
13	Invoice	1000108622.webp	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-02 17:57:05	success	\N	\N	1oMYKzFFObcyegceRQ6MzAfDz0mDyR8ts	https://drive.google.com/file/d/1oMYKzFFObcyegceRQ6MzAfDz0mDyR8ts/view?usp=drivesdk	2026-03-02 18:05:59.445116
14	Payment	SD_Card_invoice CLICKTECH RETAIL PRIVATE LIMITED July 16, 25.pdf	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-02 17:59:37	success	20	\N	1ovhZwhgN2KYgXbhYutDKk7n-ZjgMfRo2	https://drive.google.com/file/d/1ovhZwhgN2KYgXbhYutDKk7n-ZjgMfRo2/view?usp=drivesdk	2026-03-02 18:06:19.816367
15	Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 18:01:23	success	21	\N	1ZZPaVPeZ2ThJA-bCVKqzcZf9r43ymHqv	https://drive.google.com/file/d/1ZZPaVPeZ2ThJA-bCVKqzcZf9r43ymHqv/view?usp=drivesdk	2026-03-02 18:06:39.033055
16	Invoice	22050.webp	Sakthi Priya <priya.krish051@gmail.com>	2026-03-02 17:19:20	success	\N	\N	1-4w20srzvoND-ebWqJesULlxcFoXMn-7	https://drive.google.com/file/d/1-4w20srzvoND-ebWqJesULlxcFoXMn-7/view?usp=drivesdk	2026-03-02 23:32:56.615471
17	Invoice	35.webp	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-02 17:46:41	success	\N	\N	1mEjXYwSAluQtCn1NuhZKyh95Kwx6vhWS	https://drive.google.com/file/d/1mEjXYwSAluQtCn1NuhZKyh95Kwx6vhWS/view?usp=drivesdk	2026-03-02 23:33:31.116222
18	Invoice	1000108621.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-02 17:55:56	success	24	\N	1w6TKU-NblH3UhxND76i_vmsY5H8-g8WI	https://drive.google.com/file/d/1w6TKU-NblH3UhxND76i_vmsY5H8-g8WI/view?usp=drivesdk	2026-03-02 23:34:03.635366
19	Invoice	22064.webp	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-02 17:56:41	success	25	\N	18rC1qAXKao4So9OYnEsXfClIO-4kwB2k	https://drive.google.com/file/d/18rC1qAXKao4So9OYnEsXfClIO-4kwB2k/view?usp=drivesdk	2026-03-02 23:34:28.332974
20	INVOICE	N/A	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-02 17:59:03	skipped	\N	No valid attachments	\N	\N	2026-03-02 23:34:33.463162
21	Invoice	1000108620.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-02 17:56:12	success	\N	\N	\N	\N	2026-03-02 23:35:11.54443
22	Invoice	SD_Card_invoice CLICKTECH RETAIL PRIVATE LIMITED July 16, 25.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 18:00:18	success	\N	\N	118L1anagBaqFVsV629Z8RDOekOA2wKw5	https://drive.google.com/file/d/118L1anagBaqFVsV629Z8RDOekOA2wKw5/view?usp=drivesdk	2026-03-02 23:35:12.868278
23	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:07:14	success	\N	\N	1V0EmjrD0OGxeun7s_goxOZipRaiPxtdy	https://drive.google.com/file/d/1V0EmjrD0OGxeun7s_goxOZipRaiPxtdy/view?usp=drivesdk	2026-03-02 23:35:59.303645
24	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:07:14	success	\N	\N	\N	\N	2026-03-02 23:36:06.052196
25	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:13:03	success	\N	\N	1GGI8Jnzs80SEXztVXd2jKPA1zIpQ0Bn0	https://drive.google.com/file/d/1GGI8Jnzs80SEXztVXd2jKPA1zIpQ0Bn0/view?usp=drivesdk	2026-03-02 23:36:24.980329
26	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:13:03	success	\N	\N	\N	\N	2026-03-02 23:36:26.077433
27	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:14:53	success	\N	\N	\N	\N	2026-03-02 23:36:37.113085
28	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:14:53	success	\N	\N	1gArGjfb68wQHiVPaJgFPJZkouDUom2z9	https://drive.google.com/file/d/1gArGjfb68wQHiVPaJgFPJZkouDUom2z9/view?usp=drivesdk	2026-03-02 23:36:43.006944
29	Fwd: Bill	Numakers Asia LLP Aug 23, 2025 - 1.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 23:19:56	success	\N	\N	\N	\N	2026-03-02 23:36:51.157005
30	Invoice	N/A	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-02 23:26:13	skipped	\N	No valid attachments	\N	\N	2026-03-02 23:36:52.578886
31	Fwd: Bill	Numakers Asia LLP Aug 23, 2025 - 1.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 23:19:56	success	\N	\N	1dOvTF8RKP6ZfbhedKBx-B2XCQ7L1rR-s	https://drive.google.com/file/d/1dOvTF8RKP6ZfbhedKBx-B2XCQ7L1rR-s/view?usp=drivesdk	2026-03-02 23:37:02.909609
32	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:26:32	success	\N	\N	\N	\N	2026-03-02 23:37:12.086951
33	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:27:49	success	\N	\N	\N	\N	2026-03-02 23:37:29.596941
34	Fwd: Invoice -2	ROHIT JAIN July 2025.pdf	Subha <subharaja1905@gmail.com>	2026-03-02 23:26:32	success	\N	\N	1F_ibBcuZRrh0fKMl_m4NzC9zM13FjsuT	https://drive.google.com/file/d/1F_ibBcuZRrh0fKMl_m4NzC9zM13FjsuT/view?usp=drivesdk	2026-03-02 23:37:35.11638
35	Payment	Rishab electronics July 29, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 23:46:40	success	39	\N	\N	\N	2026-03-02 23:50:27.620777
36	Bill	3D Galaxy July 22, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 23:48:38	success	40	\N	\N	\N	2026-03-02 23:55:22.932239
37	Payment	GST-202501179.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-02 23:59:24	success	41	\N	\N	\N	2026-03-03 00:05:28.566574
38	Quote	cam invoice GOOD MORNING TECHNOLOGY INDIA July 16, 2025.pdf	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 07:42:48	success	12	\N	1krYIEEXkoJVPtEaDE9xAQfbiWW16Q87v	https://drive.google.com/file/d/1krYIEEXkoJVPtEaDE9xAQfbiWW16Q87v/view?usp=drivesdk	2026-03-03 07:46:28.157011
39	Invoice	invoice-temp.jpg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 07:55:48	success	42	\N	1e34OkETifaNWTZsiLlEAvOsA5pN3ujbM	https://drive.google.com/file/d/1e34OkETifaNWTZsiLlEAvOsA5pN3ujbM/view?usp=drivesdk	2026-03-03 08:03:53.760448
40	Invoice	invoice-temp.jpg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 07:55:48	success	42	\N	1vV8v79EyjT6NEq6cWzzpbDUHt3AIaYQy	https://drive.google.com/file/d/1vV8v79EyjT6NEq6cWzzpbDUHt3AIaYQy/view?usp=drivesdk	2026-03-03 08:04:19.326251
41	Payment	images.jpeg	Elayaraji M <elayaraji13502@gmail.com>	2026-03-03 08:13:44	success	43	\N	1zZyepiN6AKFqqZ-9qZHRjpD3tZSnIxK7	https://drive.google.com/file/d/1zZyepiN6AKFqqZ-9qZHRjpD3tZSnIxK7/view?usp=drivesdk	2026-03-03 08:20:36.404465
42	Payment	surabhi.jpg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 09:27:23	success	43	\N	1Wnr6WbokEUKtRnl5bUISecM4UGzP2RE5	https://drive.google.com/file/d/1Wnr6WbokEUKtRnl5bUISecM4UGzP2RE5/view?usp=drivesdk	2026-03-03 09:41:31.397338
43	Bill	Global_industries.png	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 09:35:12	success	44	\N	1e9f-G-kuxQyhI1oJE-o6Q7_uCDqEX38J	https://drive.google.com/file/d/1e9f-G-kuxQyhI1oJE-o6Q7_uCDqEX38J/view?usp=drivesdk	2026-03-03 09:42:01.465053
44	Invoice	22064.webp	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-03 17:35:41	success	25	\N	1PoFzdFLFRaw-OBoF_uKTyRdbOWEIALdl	https://drive.google.com/file/d/1PoFzdFLFRaw-OBoF_uKTyRdbOWEIALdl/view?usp=drivesdk	2026-03-03 17:40:20.034825
45	Payment	inv1.JPG	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-03 17:45:20	success	45	\N	1BzRsU4L6CPA7Er2qeU3qEVePzL7ySEfk	https://drive.google.com/file/d/1BzRsU4L6CPA7Er2qeU3qEVePzL7ySEfk/view?usp=drivesdk	2026-03-03 17:50:12.615864
46	Invoice	1000108748.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-03 17:54:58	success	46	\N	11WmNSK3BJ9I1QYnQfrHbNq7e38ijOilc	https://drive.google.com/file/d/11WmNSK3BJ9I1QYnQfrHbNq7e38ijOilc/view?usp=drivesdk	2026-03-03 18:01:19.418103
47	Invoice	1000108747.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-03 17:55:11	success	47	\N	1X4G-a6Hduq4Mkrnsnc4pNojma_Cy3DT1	https://drive.google.com/file/d/1X4G-a6Hduq4Mkrnsnc4pNojma_Cy3DT1/view?usp=drivesdk	2026-03-03 18:01:49.888493
48	Invoice	1000108749.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-03 17:57:13	success	48	\N	1ZduM-MeMVwnHDgmPdrcAt_av63N2Uxpf	https://drive.google.com/file/d/1ZduM-MeMVwnHDgmPdrcAt_av63N2Uxpf/view?usp=drivesdk	2026-03-03 18:02:18.196947
49	Invoice	1000061412.png	Subha <subharaja1905@gmail.com>	2026-03-03 18:02:38	success	48	\N	19Lxt7H1_B3jAnc_sHP_puPiiOuJbBt4P	https://drive.google.com/file/d/19Lxt7H1_B3jAnc_sHP_puPiiOuJbBt4P/view?usp=drivesdk	2026-03-03 18:06:16.349603
50	Invoice	1000061421.jpg	Subha <subharaja1905@gmail.com>	2026-03-03 18:15:51	success	49	\N	17jL2y1-UcJg5xVhfk5auLHljYjW05TH-	https://drive.google.com/file/d/17jL2y1-UcJg5xVhfk5auLHljYjW05TH-/view?usp=drivesdk	2026-03-03 18:18:19.686421
51	Invoice payment	IMG-20260303-WA0041.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-03 18:15:53	success	50	\N	1Dqf16LHlfoR-PYCRMhL-f2Vq-aEi7Nrz	https://drive.google.com/file/d/1Dqf16LHlfoR-PYCRMhL-f2Vq-aEi7Nrz/view?usp=drivesdk	2026-03-03 18:18:45.71154
52	Bill	Gym.jpeg	Elayaraji M <elayaraji13502@gmail.com>	2026-03-03 18:16:00	success	49	\N	1hF0asQyZ5WJqYCKorqXmzv2PDmH0G0_8	https://drive.google.com/file/d/1hF0asQyZ5WJqYCKorqXmzv2PDmH0G0_8/view?usp=drivesdk	2026-03-03 18:19:11.20494
53	Invoice	1000108751.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-03 18:15:58	success	51	\N	1s0FjRdGLnR66U7P4oh57Be6mCUDs13bt	https://drive.google.com/file/d/1s0FjRdGLnR66U7P4oh57Be6mCUDs13bt/view?usp=drivesdk	2026-03-03 18:19:36.322438
54	Invoice	1000061420.jpg	Subha <subharaja1905@gmail.com>	2026-03-03 18:16:06	success	52	\N	1LJxe-KIuNaQx2C7l5Y0tHFhKKZzBGFWD	https://drive.google.com/file/d/1LJxe-KIuNaQx2C7l5Y0tHFhKKZzBGFWD/view?usp=drivesdk	2026-03-03 18:20:02.531257
55	Invoice check	N/A	71772218155 VARSHIGA M K <vars.71772218155@gct.ac.in>	2026-03-03 18:16:05	skipped	\N	No valid attachments	\N	\N	2026-03-03 18:20:12.902797
56	Invoice	1000108753.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-03 18:16:21	success	53	\N	1ssIwnKjh9OkvO8rAWI4ZRmaLE_NUVueN	https://drive.google.com/file/d/1ssIwnKjh9OkvO8rAWI4ZRmaLE_NUVueN/view?usp=drivesdk	2026-03-03 18:20:32.183765
57		N/A	145 SANJEEV KRISHNA <sanj.71772317145@gct.ac.in>	2026-03-03 18:17:19	skipped	\N	No invoice keywords	\N	\N	2026-03-03 18:20:42.587217
58	Fwd: Invoice	1000061420.jpg	Subha <subharaja1905@gmail.com>	2026-03-03 18:27:17	success	52	\N	1qqI-IqTpHqToWd-gDzi_BDz8BTKC56BB	https://drive.google.com/file/d/1qqI-IqTpHqToWd-gDzi_BDz8BTKC56BB/view?usp=drivesdk	2026-03-03 18:28:23.438467
59	Fwd: Invoice	1000061420.jpg	Subha <subharaja1905@gmail.com>	2026-03-03 18:31:56	success	52	\N	1gMP7-4uFk3HrhV4JMXT3HJriRfxGas-Y	https://drive.google.com/file/d/1gMP7-4uFk3HrhV4JMXT3HJriRfxGas-Y/view?usp=drivesdk	2026-03-03 18:33:21.349614
60	Bill	Testing.jpeg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 22:27:53	success	52	\N	1yUfTLnIfJ_TagGPNv4Fs-Vmvs5ChS_NG	https://drive.google.com/file/d/1yUfTLnIfJ_TagGPNv4Fs-Vmvs5ChS_NG/view?usp=drivesdk	2026-03-03 22:58:14.889528
61	Payment	648b4ed042e563a55df9c2e9_google-docs-business-services-invoice-template-p-800.png	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 22:34:25	success	54	\N	1bIWBicBYcyZe5BaYhtaGjX-giphqnDic	https://drive.google.com/file/d/1bIWBicBYcyZe5BaYhtaGjX-giphqnDic/view?usp=drivesdk	2026-03-03 22:58:41.068442
62	Invoice	service-invoice-template-2x.jpg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 22:35:04	success	55	\N	1s01kqifqzr3Xk9o0ozte2Beok-1R5GNh	https://drive.google.com/file/d/1s01kqifqzr3Xk9o0ozte2Beok-1R5GNh/view?usp=drivesdk	2026-03-03 22:59:06.407639
63	Bill	sample-construction-invoice-template.jpg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-03 23:26:44	success	56	\N	1aSoqpEQQicFTutRL_6Wnrcnenk9dCnzA	https://drive.google.com/file/d/1aSoqpEQQicFTutRL_6Wnrcnenk9dCnzA/view?usp=drivesdk	2026-03-03 23:34:11.453774
64	Invoice	1000061523.webp	Subha <subharaja1905@gmail.com>	2026-03-04 12:11:39	success	16	\N	1ftq6evJn0H4hzrbIa08VXFWGzo_LrlCt	https://drive.google.com/file/d/1ftq6evJn0H4hzrbIa08VXFWGzo_LrlCt/view?usp=drivesdk	2026-03-04 15:01:29.23476
65	Invoice	1000061523.webp	Subha <subharaja1905@gmail.com>	2026-03-04 12:11:49	success	16	\N	1rqLf8lWU8bfb1g0_73TL-Q-r9vQV0awd	https://drive.google.com/file/d/1rqLf8lWU8bfb1g0_73TL-Q-r9vQV0awd/view?usp=drivesdk	2026-03-04 15:01:45.311454
66	Invoice	1000061524.jpg	Subha <subharaja1905@gmail.com>	2026-03-04 12:13:34	success	57	\N	1Daf7w9wvbPI4Vs0L-0-gY3aQyFfq2dok	https://drive.google.com/file/d/1Daf7w9wvbPI4Vs0L-0-gY3aQyFfq2dok/view?usp=drivesdk	2026-03-04 15:02:01.969927
67	Invoice	1000061525.jpg	Subha <subharaja1905@gmail.com>	2026-03-04 12:17:16	success	58	\N	1kpW5uLt7c4_GGaVlX6D-U7-fRKAMmZLk	https://drive.google.com/file/d/1kpW5uLt7c4_GGaVlX6D-U7-fRKAMmZLk/view?usp=drivesdk	2026-03-04 15:02:19.120939
68	Manual Upload by admin	3D Galaxy July 22, 2025.pdf	admin	2026-03-04 16:14:46.057715	success	40	\N	18MSAkSQI4RQktk3pVp7lIntLUqoA9NSe	https://drive.google.com/file/d/18MSAkSQI4RQktk3pVp7lIntLUqoA9NSe/view?usp=drivesdk	2026-03-04 16:14:46.079988
69	Manual Upload by admin	3D Galaxy July 22, 2025.pdf	admin	2026-03-04 17:01:34.867078	success	40	\N	1LvlDlEGsAqDw01ZpmHFBM80YO0uzYdEi	https://drive.google.com/file/d/1LvlDlEGsAqDw01ZpmHFBM80YO0uzYdEi/view?usp=drivesdk	2026-03-04 17:01:34.869917
70	Manual Upload by admin	GST-202501179.pdf	admin	2026-03-04 17:47:42.980422	success	41	\N	13a_jlRpQCXbVjZGO8qJSxk8PfE11YAa0	https://drive.google.com/file/d/13a_jlRpQCXbVjZGO8qJSxk8PfE11YAa0/view?usp=drivesdk	2026-03-04 17:47:42.983478
71	Manual Upload by admin	GST-202501179.pdf	admin	2026-03-04 17:49:10.002797	success	41	\N	1rTOUxXYiFYO223wXpxykt5nyLPnMMKGU	https://drive.google.com/file/d/1rTOUxXYiFYO223wXpxykt5nyLPnMMKGU/view?usp=drivesdk	2026-03-04 17:49:10.004688
72	Manual Upload by admin	GST-202501179.pdf	admin	2026-03-04 17:52:21.84303	success	41	\N	1B04LCvasqsk33xCytWCIJMK-_AfZDpkn	https://drive.google.com/file/d/1B04LCvasqsk33xCytWCIJMK-_AfZDpkn/view?usp=drivesdk	2026-03-04 17:52:21.845366
73	Manual Upload by admin	cam invoice GOOD MORNING TECHNOLOGY INDIA July 16, 2025.pdf	admin	2026-03-04 17:59:49.492823	success	12	\N	1VGE8cL4rs7ctgQr--E6Z28ecYWBq0rEJ	https://drive.google.com/file/d/1VGE8cL4rs7ctgQr--E6Z28ecYWBq0rEJ/view?usp=drivesdk	2026-03-04 17:59:49.496957
74	Manual Upload	3D Galaxy July 22, 2025.pdf	admin	2026-03-04 12:40:22.381155	failed	\N	Duplicate invoice detected: 25-26/130 already exists	\N	\N	2026-03-04 18:10:22.401856
75	Manual Upload	PC Builds.jpeg	admin	2026-03-04 12:40:57.532985	failed	\N	Duplicate invoice detected: INV-000001 already exists	\N	\N	2026-03-04 18:10:57.537108
76	Manual Upload by admin	malsthue brothers.jpeg	admin	2026-03-04 18:12:37.558328	success	59	\N	1iJSrzegfj17GO4WrfI2jXASTJKmfhS0D	https://drive.google.com/file/d/1iJSrzegfj17GO4WrfI2jXASTJKmfhS0D/view?usp=drivesdk	2026-03-04 18:12:37.560508
77	Invoice	23648.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-04 18:21:45	success	60	\N	11l9JaUgx_FU_LlTuU57dDEgJulbiglX4	https://drive.google.com/file/d/11l9JaUgx_FU_LlTuU57dDEgJulbiglX4/view?usp=drivesdk	2026-03-04 18:23:40.158081
78	Bulk Order Invoice	invoice-template-us-classic-white-750px.png	71772314120 JAIALWIN M <jaia.71772314120@gct.ac.in>	2026-03-04 18:30:38	success	11	\N	1B1hV8QSScy1g8jcZQDufQuYGjYdAQ4eS	https://drive.google.com/file/d/1B1hV8QSScy1g8jcZQDufQuYGjYdAQ4eS/view?usp=drivesdk	2026-03-04 18:31:48.65715
79	Invoice	1000108872.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-04 18:31:05	success	59	\N	1Js0CoYygzgwlfW3QJfCCUJjQY_7brwUY	https://drive.google.com/file/d/1Js0CoYygzgwlfW3QJfCCUJjQY_7brwUY/view?usp=drivesdk	2026-03-04 18:33:19.835571
80	Invoice	1000108875.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-04 18:31:19	success	61	\N	19_sEl2bu47v90sJd-8ixQGwj--Bued5e	https://drive.google.com/file/d/19_sEl2bu47v90sJd-8ixQGwj--Bued5e/view?usp=drivesdk	2026-03-04 18:33:42.241776
81	Invoice	1000108880.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-04 18:31:38	success	43	\N	1S94dbLfD_WCJeyItNdWSFgHSGqRI-pZF	https://drive.google.com/file/d/1S94dbLfD_WCJeyItNdWSFgHSGqRI-pZF/view?usp=drivesdk	2026-03-04 18:34:02.530713
82	Invoice	1000108886.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-04 18:49:44	success	62	\N	1lHmR0xuA1_WCe_MY4cVEcVrQXEs71U2h	https://drive.google.com/file/d/1lHmR0xuA1_WCe_MY4cVEcVrQXEs71U2h/view?usp=drivesdk	2026-03-04 18:51:56.7391
83	Invoice	1000108887.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-04 18:50:18	success	63	\N	1Xya9fZaYOaWq2cczBkzkg1ygZsI5gDjz	https://drive.google.com/file/d/1Xya9fZaYOaWq2cczBkzkg1ygZsI5gDjz/view?usp=drivesdk	2026-03-04 18:52:26.478567
84	Manual Upload	PC Builds.jpeg	admin	2026-03-04 13:26:19.348994	failed	\N	Duplicate invoice detected: INV-000001 already exists	\N	\N	2026-03-04 18:56:19.352338
85	Invoice	1000108887.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-05 12:44:32	success	63	\N	1XD7TN7JskVHf4TVkM0yPTrNmbxs3xIif	https://drive.google.com/file/d/1XD7TN7JskVHf4TVkM0yPTrNmbxs3xIif/view?usp=drivesdk	2026-03-05 17:33:36.664053
86	Invoice	1000108880.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-05 12:44:47	success	43	\N	16gg6vZhgTL_ZRO3emuQOe995vmKLaVzn	https://drive.google.com/file/d/16gg6vZhgTL_ZRO3emuQOe995vmKLaVzn/view?usp=drivesdk	2026-03-05 17:33:51.594122
87	Invoice payment	23648.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:01:53	success	60	\N	1tPqaGR3YMYYG6-QXvftUbFPEiOc3FQPU	https://drive.google.com/file/d/1tPqaGR3YMYYG6-QXvftUbFPEiOc3FQPU/view?usp=drivesdk	2026-03-05 17:34:06.329201
88	Payment	23539.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:14:20	success	52	\N	1SxSQDPpyPIbHgn6bKtcIF1oxxlRMCDtE	https://drive.google.com/file/d/1SxSQDPpyPIbHgn6bKtcIF1oxxlRMCDtE/view?usp=drivesdk	2026-03-05 17:34:21.552147
89	Invoice	23542.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:22:24	success	53	\N	15DNwZeaiSDr1jCDQnBmHbnCW35aFvLH3	https://drive.google.com/file/d/15DNwZeaiSDr1jCDQnBmHbnCW35aFvLH3/view?usp=drivesdk	2026-03-05 17:34:35.685109
90	Payment	07-Sales-Invoice-Lines_1.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:46:50	success	53	\N	1-C2EeTYEZMhMJzQhBwTfD7j1JLsNoABe	https://drive.google.com/file/d/1-C2EeTYEZMhMJzQhBwTfD7j1JLsNoABe/view?usp=drivesdk	2026-03-05 17:34:49.479621
91	Invoice	oub-einvoice-details-print.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:46:55	success	64	\N	1ecGHPIw_Z-meB3jD0AUNtoNzr80F-vtY	https://drive.google.com/file/d/1ecGHPIw_Z-meB3jD0AUNtoNzr80F-vtY/view?usp=drivesdk	2026-03-05 17:35:02.462896
92	Payment	23925.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 16:55:49	success	64	\N	1atgyGlvfY3qOonTcbWhHCcj0gt1hb3sz	https://drive.google.com/file/d/1atgyGlvfY3qOonTcbWhHCcj0gt1hb3sz/view?usp=drivesdk	2026-03-05 17:35:15.593256
93	Invoice	oub-invoice-qrcode.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 17:33:26	success	65	\N	19qEbgAN474ezS-dotUAh3IPfHAms6-Nz	https://drive.google.com/file/d/19qEbgAN474ezS-dotUAh3IPfHAms6-Nz/view?usp=drivesdk	2026-03-05 17:38:30.404008
94	Invoice	23947.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 17:48:59	success	65	\N	1YM-UwA75eVtYkXeqZnzXx_G3ae8PJ-m7	https://drive.google.com/file/d/1YM-UwA75eVtYkXeqZnzXx_G3ae8PJ-m7/view?usp=drivesdk	2026-03-05 17:53:30.258141
95	Quote	Nexa.jpeg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-05 18:07:26	success	66	\N	1D5qDH5P61igrtJIA2ivTTJEAp0kwcbfI	https://drive.google.com/file/d/1D5qDH5P61igrtJIA2ivTTJEAp0kwcbfI/view?usp=drivesdk	2026-03-05 18:08:39.283429
96	Invoice	23953.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 18:13:22	success	67	\N	173F2PTfsaReriYq4brSDqPV6fBXlitF6	https://drive.google.com/file/d/173F2PTfsaReriYq4brSDqPV6fBXlitF6/view?usp=drivesdk	2026-03-05 18:18:32.978559
97	Invoice	content-gst-invoice.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 18:20:25	success	67	\N	1swVtBR1AMBsc74T6BPwxCYqCLYNMqSHQ	https://drive.google.com/file/d/1swVtBR1AMBsc74T6BPwxCYqCLYNMqSHQ/view?usp=drivesdk	2026-03-05 18:23:33.570673
98	Invoice	23954.png	Sakthi Priya <priya.krish051@gmail.com>	2026-03-05 18:25:28	success	68	\N	1e_dzZXJ54t0IVXz5Ry2LqVZg0unhjAQn	https://drive.google.com/file/d/1e_dzZXJ54t0IVXz5Ry2LqVZg0unhjAQn/view?usp=drivesdk	2026-03-05 18:50:28.651756
99	Invoice	23954.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-05 18:25:45	success	68	\N	16HRfx7npz0y8pRKqIpttb5S3E6mSNTYL	https://drive.google.com/file/d/16HRfx7npz0y8pRKqIpttb5S3E6mSNTYL/view?usp=drivesdk	2026-03-05 18:50:43.75145
100	Quote	codewave.jpeg	Elayaraji M 2303717710421706 CSE <elay.2303717710421706@gct.ac.in>	2026-03-05 18:29:23	success	69	\N	1JDul4ZZUV6pSDbB7cwuCTo0fU_qz0d99	https://drive.google.com/file/d/1JDul4ZZUV6pSDbB7cwuCTo0fU_qz0d99/view?usp=drivesdk	2026-03-05 18:51:00.347921
101	Invoice	ChatGPT Image Mar 5, 2026, 07_54_00 PM.png	Subha <subharaja1905@gmail.com>	2026-03-05 19:55:11	success	70	\N	1U0d4aQ8RvtaGTm4ZRYfzm6Ajaxr8qhtB	https://drive.google.com/file/d/1U0d4aQ8RvtaGTm4ZRYfzm6Ajaxr8qhtB/view?usp=drivesdk	2026-03-05 20:06:06.150505
102	Fwd: Invoice	SD_Card_invoice CLICKTECH RETAIL PRIVATE LIMITED July 16, 25.pdf	Subha <subharaja1905@gmail.com>	2026-03-05 20:41:12	success	20	\N	1lJ-JiK5uOqFyd_61R9kgCXuB5lYVokd1	https://drive.google.com/file/d/1lJ-JiK5uOqFyd_61R9kgCXuB5lYVokd1/view?usp=drivesdk	2026-03-05 20:45:12.655631
103	Fwd: Invoice	SD_Card_invoice CLICKTECH RETAIL PRIVATE LIMITED July 16, 25.pdf	Subha <subharaja1905@gmail.com>	2026-03-05 20:41:12	success	20	\N	1UdkW6rJXKk14uUq6MQxeaSJCPY5aoYfu	https://drive.google.com/file/d/1UdkW6rJXKk14uUq6MQxeaSJCPY5aoYfu/view?usp=drivesdk	2026-03-05 20:45:14.214089
104	Invoice	1000108886.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-06 17:56:19	success	62	\N	1IOaQiVD2-ickv2HIpZhpobRW5LYxJodA	https://drive.google.com/file/d/1IOaQiVD2-ickv2HIpZhpobRW5LYxJodA/view?usp=drivesdk	2026-03-06 18:00:04.511773
105	Manual Upload	Testing.jpeg	admin	2026-03-07 11:08:51.306825	failed	\N	OCR extraction failed	\N	\N	2026-03-07 16:38:51.32788
106	Manual Upload	Testing.jpeg	admin	2026-03-07 12:47:48.259097	failed	\N	OCR extraction failed	\N	\N	2026-03-07 18:17:48.265265
107	Manual Upload	Testing.jpeg	admin	2026-03-07 12:48:55.141853	failed	\N	OCR extraction failed	\N	\N	2026-03-07 18:18:55.143345
108	Manual Upload	Testing.jpeg	admin	2026-03-07 12:52:08.083155	failed	\N	Duplicate invoice detected: IV-00036 already exists	\N	\N	2026-03-07 18:22:08.085482
109	Invoice	IMG-20260306-WA0011.jpg	Sakthi Priya <priya.krish051@gmail.com>	2026-03-06 18:17:47	success	71	\N	1Fsz2Cyongwm-UMZHT3jRs1CM6X5FTsXa	https://drive.google.com/file/d/1Fsz2Cyongwm-UMZHT3jRs1CM6X5FTsXa/view?usp=drivesdk	2026-03-07 18:26:41.69169
110	Invoice	IMG-20260306-WA0011.jpg	Sakthi Priya <priya.krish051@gmail.com>	2026-03-06 18:17:47	success	71	\N	1QRvqRL8nEc_PrbM7gAE0Uw1zK9kvHUGJ	https://drive.google.com/file/d/1QRvqRL8nEc_PrbM7gAE0Uw1zK9kvHUGJ/view?usp=drivesdk	2026-03-07 18:26:42.617916
111	Payment	IMG-20260306-WA0011.jpg	Sakthi Priya <priya.krish051@gmail.com>	2026-03-06 18:26:19	success	71	\N	1Exiyr3FM0DkmAF9-OKAag2HRpEX7BJ7n	https://drive.google.com/file/d/1Exiyr3FM0DkmAF9-OKAag2HRpEX7BJ7n/view?usp=drivesdk	2026-03-07 18:26:57.051245
112	Payment	IMG-20260306-WA0011.jpg	Sakthi Priya <priya.krish051@gmail.com>	2026-03-06 18:26:19	success	71	\N	1s5WUxCdBTZa9uRWItJKmjgNnN6owXcfP	https://drive.google.com/file/d/1s5WUxCdBTZa9uRWItJKmjgNnN6owXcfP/view?usp=drivesdk	2026-03-07 18:26:58.200381
113	Invoice	24078.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-06 18:29:07	success	71	\N	1TKHZ_Oq9LdsKmNC22LMbIzi3Rh0erEJf	https://drive.google.com/file/d/1TKHZ_Oq9LdsKmNC22LMbIzi3Rh0erEJf/view?usp=drivesdk	2026-03-07 18:27:14.768451
114	Invoice	24078.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-06 18:29:07	success	71	\N	1H0F3kj0adrg3gHy-f2ZSP_HahaMc_2Ih	https://drive.google.com/file/d/1H0F3kj0adrg3gHy-f2ZSP_HahaMc_2Ih/view?usp=drivesdk	2026-03-07 18:27:15.726018
115	Invoice	24078.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-06 19:00:31	success	71	\N	17894QlGfEXEJVkjgup0MwoSEJnZmzdtV	https://drive.google.com/file/d/17894QlGfEXEJVkjgup0MwoSEJnZmzdtV/view?usp=drivesdk	2026-03-07 18:27:29.256037
116	Introducing GPT-5.4	N/A	OpenAI <noreply@email.openai.com>	2026-03-07 01:00:13	skipped	\N	No invoice keywords	\N	\N	2026-03-07 18:27:30.851397
117	Invoice	24078.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-06 19:00:31	success	71	\N	1OK0TT-AYtt8Gj_euGYFevxpn_xGxtHbw	https://drive.google.com/file/d/1OK0TT-AYtt8Gj_euGYFevxpn_xGxtHbw/view?usp=drivesdk	2026-03-07 18:27:31.644129
118	Manual Upload by admin	unnamed.jpg	admin	2026-03-07 18:28:04.551208	success	72	\N	1sKgwbiwC7D8YW-UmuZoL1vN1e8wPE0HW	https://drive.google.com/file/d/1sKgwbiwC7D8YW-UmuZoL1vN1e8wPE0HW/view?usp=drivesdk	2026-03-07 18:28:04.552565
119	Write faster with ChatGPT	N/A	ChatGPT <noreply@email.openai.com>	2026-03-09 17:05:03	skipped	\N	No invoice keywords	\N	\N	2026-03-10 17:36:21.14149
120	Invoice	IMG-20260306-WA0011.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-09 18:37:57	success	71	\N	1IObc6qE81TkY-5SY2DW8Z-7OXJe78lT5	https://drive.google.com/file/d/1IObc6qE81TkY-5SY2DW8Z-7OXJe78lT5/view?usp=drivesdk	2026-03-10 17:36:40.879882
121	Payment	invoice-format-A6.png	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-09 18:48:50	success	73	\N	18v7VNBFG9oGHvYuw6GAfF11dQUDrV-96	https://drive.google.com/file/d/18v7VNBFG9oGHvYuw6GAfF11dQUDrV-96/view?usp=drivesdk	2026-03-10 17:37:00.105768
122	Invoice	1000109886.png	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-10 17:47:49	success	74	\N	1opAzbqXwqDvmze9mvM3L7G_FFUVbXXjR	https://drive.google.com/file/d/1opAzbqXwqDvmze9mvM3L7G_FFUVbXXjR/view?usp=drivesdk	2026-03-10 17:52:05.445874
123	Invoice	ChatGPT Image Mar 10, 2026, 05_30_17 PM.png	Subha <subharaja1905@gmail.com>	2026-03-10 17:47:53	success	75	\N	1zuhWh93VKPW5dVrzps1T5TEflze-pIfQ	https://drive.google.com/file/d/1zuhWh93VKPW5dVrzps1T5TEflze-pIfQ/view?usp=drivesdk	2026-03-10 17:52:28.621144
124	Payment	IMG-20260310-WA0120.jpg	Sakthi Priya <sakthi.krish051@gmail.com>	2026-03-10 18:33:31	success	76	\N	1-xXeRLYpzik468TxhFRRMq-WwLizZ9-E	https://drive.google.com/file/d/1-xXeRLYpzik468TxhFRRMq-WwLizZ9-E/view?usp=drivesdk	2026-03-10 18:35:06.559162
125	Invoice	ChatGPT Image Mar 10, 2026, 05_59_22 PM.png	Subha <subharaja1905@gmail.com>	2026-03-10 18:33:55	success	77	\N	1uTMmbsjkHIIJIHbtRYkyxW2PeFPcww1W	https://drive.google.com/file/d/1uTMmbsjkHIIJIHbtRYkyxW2PeFPcww1W/view?usp=drivesdk	2026-03-10 18:35:48.287733
126	Invoice	1000109894.jpg	Gayathri S <gayathrisubramani.gs@gmail.com>	2026-03-10 18:34:08	success	77	\N	1xQ4h53OKDbIVeDgdaxpv7ORcWumqFSTr	https://drive.google.com/file/d/1xQ4h53OKDbIVeDgdaxpv7ORcWumqFSTr/view?usp=drivesdk	2026-03-10 18:36:08.561115
127	Manual Upload by admin	Performa invoice.jpeg	admin	2026-03-10 18:36:29.637403	success	78	\N	1lCEGhdOSmfG9UUyLo9Uq9jSispVFQ8Df	https://drive.google.com/file/d/1lCEGhdOSmfG9UUyLo9Uq9jSispVFQ8Df/view?usp=drivesdk	2026-03-10 18:36:29.637988
\.


--
-- Data for Name: invoice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice (id, invoice_no, customer_name, vendor_name, po_number, invoice_date, total_amount, total_tax, file_link, created_at) FROM stdin;
1	US-001	John Smith	East Repair Inc.	2312/2019	2019-02-11	154.06	9.06	https://drive.google.com/file/d/1oSEY_2Jfx5ByKVZoqCdnS2mawp-faVRy/view?usp=drivesdk	2026-02-25 23:49:28.636204
2	074292	DGTech SOLUTIONS	novo3D	290627	2025-07-31	885.00	135.00	https://drive.google.com/file/d/1ATkzFzt--kjK99UutSmnGA8ZZIWVVAJN/view?usp=drivesdk	2026-02-26 17:10:14.709875
3	IN-387	DGTech SOLUTIONS	GOOD MORNING TECHNOLOGY INDIA PRIVATE LIMITED	\N	2025-07-16	2359.00	359.85	https://drive.google.com/file/d/1y6MlVPrD3gvdfRNLSe09TP1vNIVT8GOZ/view?usp=drivesdk	2026-02-26 18:10:49.258731
\.


--
-- Data for Name: invoice_audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_audit_logs (id, invoice_id, user_id, action, old_value, new_value, notes, created_at) FROM stdin;
1	9	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-02-27 20:45:43.911691
2	14	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-02-27 21:38:38.130367
3	11	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by testreviewer	2026-02-27 21:39:09.002231
4	12	\N	status_updated	{"status": "pending"}	{"status": "rejected"}	Reviewed by reviewer	2026-02-27 21:40:01.172193
5	15	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-03 18:26:07.43336
6	18	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-03 18:46:33.578136
7	16	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-03 23:30:01.494947
8	56	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-03 23:36:02.661857
9	43	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-04 14:58:46.69931
10	46	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by reviewer	2026-03-04 15:04:15.762245
11	53	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by Elaya	2026-03-04 15:48:42.316512
12	39	\N	status_updated	{"status": "pending"}	{"status": "rejected"}	Reviewed by jai alwin	2026-03-04 18:59:23.345342
13	40	\N	status_updated	{"status": "pending"}	{"status": "rejected"}	Reviewed by jai alwin	2026-03-04 18:59:28.511965
14	60	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by Sakthi	2026-03-10 17:34:00.512415
15	77	\N	status_updated	{"status": "pending"}	{"status": "accepted"}	Reviewed by elaya	2026-03-10 18:40:53.40052
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, invoice_number, vendor_name, vendor_email, customer_name, po_number, invoice_date, amount, tax, total_amount, status, email_id, email_subject, pdf_url, drive_file_id, ocr_data, created_at, updated_at, reviewed_by, reviewed_at) FROM stdin;
11	US-001	East Repair Inc.	\N	John Smith	2312/2019	2019-02-11 00:00:00	145	9.06	154.06	accepted	\N	\N	https://drive.google.com/file/d/1oSEY_2Jfx5ByKVZoqCdnS2mawp-faVRy/view?usp=drivesdk	1oSEY_2Jfx5ByKVZoqCdnS2mawp-faVRy	\N	\N	2026-02-27 21:39:09.005896	testreviewer	2026-02-27 21:39:09.005942
9	074292	novo3D	\N	DGTech SOLUTIONS	290627	2025-07-31 00:00:00	885	135	1020	accepted	\N	Bill	https://drive.google.com/file/d/1JY-MJUucaLHOQXl4RkOJ7ebCxAFl7pGj/view?usp=drivesdk	1JY-MJUucaLHOQXl4RkOJ7ebCxAFl7pGj	{"invoice_number": "074292", "customer_name": "DGTech SOLUTIONS", "date": "2025-07-31", "vendor_name": "novo3D", "po_number": "290627", "amount": 885.0, "tax": 135.0, "line_items": [{"description": "P1P Bambu Lab Heater 24v 65w Ceramic heate Heater and Temperature Sensor 350 for 3D Printer", "quantity": 3.0, "unit_price": 250.0, "total_price": 750.0}], "total_amount": 1020.0}	2026-02-27 18:25:03.92969	2026-02-27 20:54:46.965287	\N	\N
14	NM/SP/2526/3708	Numakers Asia LLP	\N	Dgtech Solutions	\N	2025-08-23 00:00:00	1984.76	302.76	2287.52	accepted	\N	Fwd: Bill	https://drive.google.com/file/d/1HbQ3uapXN7NROBNjP16NPiGYuJQG96XL/view?usp=drivesdk	1HbQ3uapXN7NROBNjP16NPiGYuJQG96XL	{"invoice_number": "NM/SP/2526/3708", "customer_name": "Dgtech Solutions", "date": "2025-08-23", "vendor_name": "Numakers Asia LLP", "po_number": null, "amount": 1984.76, "tax": 302.76, "line_items": [{"description": "ASA - Filament/1.75 mm / 1 kg /Pitch Black", "quantity": 2.0, "unit_price": 775.0, "total_price": 1550.0}, {"description": "OutState Shipping Charges 18%", "quantity": 0.0, "unit_price": 0.0, "total_price": 132.0}, {"description": "IGST 18%", "quantity": 0.0, "unit_price": 0.0, "total_price": 302.76}], "total_amount": 2287.52}	2026-02-27 20:47:13.133168	2026-02-27 21:38:38.13224	system	2026-02-27 21:38:38.132288
18	1521	INV24.COM	\N	[My company name]	cdvdfv	2024-01-29 00:00:00	1096.94	85.94	1182.88	accepted	\N	Invoice	https://drive.google.com/file/d/1UB4RXkKwSzzoi_hdNUUwM4s11GkZWuvn/view?usp=drivesdk	1UB4RXkKwSzzoi_hdNUUwM4s11GkZWuvn	{"invoice_number": "1521", "customer_name": "[My company name]", "date": "2024-01-29", "vendor_name": "INV24.COM", "po_number": null, "amount": 1096.94, "tax": 85.94, "line_items": [{"description": "Product", "quantity": 3.0, "unit_price": 177.0, "total_price": 531.0}, {"description": "Service", "quantity": 1.0, "unit_price": 600.0, "total_price": 600.0}, {"description": "Service (Discount 20%)", "quantity": 1.0, "unit_price": -120.0, "total_price": -120.0}], "total_amount": 1182.88}	2026-03-02 18:05:42.522543	2026-03-03 18:46:33.579447	reviewer	2026-03-03 18:46:33.579473
16	INV1000	YOUR COMPANY NAME	\N	\N		2016-08-27 00:00:00	1320	120	1440	accepted	\N	Invoice	https://drive.google.com/file/d/1dusR7stfcID6twWD5qIPzmJl4UbfU9Kd/view?usp=drivesdk	1dusR7stfcID6twWD5qIPzmJl4UbfU9Kd	{"invoice_number": "INV1000", "customer_name": null, "date": "2016-08-27", "vendor_name": "YOUR COMPANY NAME", "po_number": null, "amount": 1320.0, "tax": 120.0, "line_items": [{"description": "Test Product 3 (Non-taxable)", "quantity": 1.0, "unit_price": 300.0, "total_price": 300.0}, {"description": "Test Product 2 (Service)", "quantity": 1.0, "unit_price": 200.0, "total_price": 200.0}, {"description": "Test Product 1", "quantity": 1.0, "unit_price": 100.0, "total_price": 100.0}, {"description": "Test Product 3 (Non-taxable)", "quantity": 1.0, "unit_price": 300.0, "total_price": 300.0}, {"description": "Test Product 2 (Service)", "quantity": 1.0, "unit_price": 200.0, "total_price": 200.0}, {"description": "Test Product 1", "quantity": 1.0, "unit_price": 100.0, "total_price": 100.0}], "total_amount": 1440.0}	2026-03-02 17:53:57.784181	2026-03-03 23:30:01.503881	reviewer	2026-03-03 23:30:01.504123
12	IN-387	GOOD MORNING TECHNOLOGY INDIA PRIVATE LIMITED	\N	DGTech SOLUTIONS	\N	2025-07-16 00:00:00	2359	359.85	2718.85	pending	\N	Manual Upload by admin	https://drive.google.com/file/d/1VGE8cL4rs7ctgQr--E6Z28ecYWBq0rEJ/view?usp=drivesdk	1VGE8cL4rs7ctgQr--E6Z28ecYWBq0rEJ	{"invoice_number": "IN-387", "customer_name": "DGTech SOLUTIONS", "date": "2025-07-16", "vendor_name": "GOOD MORNING TECHNOLOGY INDIA PRIVATE LIMITED", "po_number": null, "amount": 2359.0, "tax": 359.85, "line_items": [{"description": "Tapo C220 Pan/Tilt Smart AI 2K 4MP QHD 1440p Home Security Wi-Fi Camera Alexa & Google Assistant Enabled |Night Vision Two-Way Audio Motion Detection | BOCDCL6FLC ( WB-9POF-HG7D)", "quantity": 1.0, "unit_price": 1999.15, "total_price": 1999.15}], "total_amount": 2718.85}	\N	2026-03-04 17:59:49.414995	\N	\N
20	CJB1-1332637	CLICKTECH RETAIL PRIVATE LIMITED	\N	DGTech SOLUTIONS	\N	2025-07-19 00:00:00	1049	160.02	1209.02	pending	\N	Payment	https://drive.google.com/file/d/1ovhZwhgN2KYgXbhYutDKk7n-ZjgMfRo2/view?usp=drivesdk	1ovhZwhgN2KYgXbhYutDKk7n-ZjgMfRo2	{"invoice_number": "CJB1-1332637", "customer_name": "DGTech SOLUTIONS", "date": "2025-07-19", "vendor_name": "CLICKTECH RETAIL PRIVATE LIMITED", "po_number": null, "amount": 1049.0, "tax": 160.02, "line_items": [{"description": "Samsung EVO Plus 128GB Micro SDXC w/SD Adaptor,\\nUp-to 160MB/s, Expanded Storage for Gaming Devices,\\nAndroid Tablets and Smart Phones, Memory Card,\\nMB-MC128SA/IN | BOCXJ2FTBR (B0CXJ2FTBR)\\nHSN:85235100", "quantity": 1.0, "unit_price": 888.98, "total_price": 888.98}, {"description": "Shipping Charges\\nHSN:85235100", "quantity": 1.0, "unit_price": 33.9, "total_price": 0.0}], "total_amount": 1209.02}	2026-03-02 18:06:19.74744	2026-03-02 18:06:19.74744	\N	\N
21	IN-1302	amazon.in	\N	DGTech SOLUTIONS	\N	2025-06-25 00:00:00	2209	336.97	2545.9700000000003	pending	\N	Invoice -2	https://drive.google.com/file/d/1ZZPaVPeZ2ThJA-bCVKqzcZf9r43ymHqv/view?usp=drivesdk	1ZZPaVPeZ2ThJA-bCVKqzcZf9r43ymHqv	{"invoice_number": "IN-1302", "customer_name": "DGTech SOLUTIONS", "date": "2025-06-25", "vendor_name": "amazon.in", "po_number": null, "amount": 2209.0, "tax": 336.97, "line_items": [{"description": "ELBME\\u00ae 70W Foldable Solar Panel_1 |\\nBOF3X66SSK (ELALLBR-641223980467)\\nHSN:90184900", "quantity": 1.0, "unit_price": 1905.93, "total_price": 1872.03}], "total_amount": 2545.9700000000003}	2026-03-02 18:06:39.026815	2026-03-02 18:06:39.026815	\N	\N
24	12345	STUDIO SHODWE	\N	Ketut Susilo	\N	2022-06-25 00:00:00	8798	1148	9946	pending	\N	Invoice	https://drive.google.com/file/d/1w6TKU-NblH3UhxND76i_vmsY5H8-g8WI/view?usp=drivesdk	1w6TKU-NblH3UhxND76i_vmsY5H8-g8WI	{"invoice_number": "12345", "customer_name": "Ketut Susilo", "date": "2022-06-25", "vendor_name": "STUDIO SHODWE", "po_number": null, "amount": 8798.0, "tax": 1148.0, "line_items": [{"description": "Logo Design", "quantity": 5.0, "unit_price": 100.0, "total_price": 500.0}, {"description": "Website Design", "quantity": 2.0, "unit_price": 800.0, "total_price": 1600.0}, {"description": "Brand Design", "quantity": 3.0, "unit_price": 300.0, "total_price": 900.0}, {"description": "Banner Design", "quantity": 2.0, "unit_price": 300.0, "total_price": 600.0}, {"description": "Flyer Design", "quantity": 2.0, "unit_price": 400.0, "total_price": 800.0}, {"description": "Social Media Template", "quantity": 10.0, "unit_price": 50.0, "total_price": 500.0}, {"description": "Name Card", "quantity": 15.0, "unit_price": 25.0, "total_price": 750.0}, {"description": "Web Developer", "quantity": 2.0, "unit_price": 1000.0, "total_price": 2000.0}], "total_amount": 9946.0}	2026-03-02 23:34:03.581485	2026-03-02 23:34:03.581485	\N	\N
25	202506-1042	Raaka Chocolate	\N	Acme Pvt. Ltd.	202506-1042	2025-09-06 00:00:00	222.75	24.75	247.5	pending	\N	Invoice	https://drive.google.com/file/d/18rC1qAXKao4So9OYnEsXfClIO-4kwB2k/view?usp=drivesdk	18rC1qAXKao4So9OYnEsXfClIO-4kwB2k	{"invoice_number": "202506-1042", "customer_name": "Acme Pvt. Ltd.", "date": "2025-09-06", "vendor_name": "Raaka Chocolate", "po_number": "202506-1042", "amount": 222.75, "tax": 24.75, "line_items": [{"description": "Converse All Star", "quantity": 1.0, "unit_price": 54.44, "total_price": 49.0}, {"description": "Ray-Ban Wayfarer", "quantity": 1.0, "unit_price": 159.0, "total_price": 149.0}], "total_amount": 247.5}	2026-03-02 23:34:28.322754	2026-03-02 23:34:28.322754	\N	\N
39	0498/2025-26	RISABH ELECTRONIC SYSTEMS	\N	DGTech Solutions	\N	2025-07-29 00:00:00	1400	213.56	1613.56	rejected	\N	Payment	\N	\N	{"invoice_number": "0498/2025-26", "customer_name": "DGTech Solutions", "date": "2025-07-29", "vendor_name": "RISABH ELECTRONIC SYSTEMS", "po_number": null, "amount": 1400.0, "tax": 213.56, "line_items": [{"description": "PLA PRO+ Black 1 Kg", "quantity": 2.0, "unit_price": 593.22, "total_price": 1186.44}], "total_amount": 1613.56}	2026-03-02 23:50:27.581783	2026-03-04 18:59:23.346239	jai alwin	2026-03-04 18:59:23.346922
41	GST-202501179	Panther3D	\N	DGTech SOLUTIONS	\N	2026-02-06 00:00:00	11909	908.35	12817.35	pending	\N	Manual Upload by admin	https://drive.google.com/file/d/1B04LCvasqsk33xCytWCIJMK-_AfZDpkn/view?usp=drivesdk	1B04LCvasqsk33xCytWCIJMK-_AfZDpkn	{"invoice_number": "GST-202501179", "customer_name": "DGTech SOLUTIONS", "date": "2026-02-06", "vendor_name": "Panther3D", "po_number": null, "amount": 11909.0, "tax": 908.35, "line_items": [{"description": "Lemon Yellow PLA+ Numakers", "quantity": 4.0, "unit_price": 600.0, "total_price": 2400.0}, {"description": "Jamghe TZ PLA +Filament 1.75 mm\\nRed", "quantity": 4.0, "unit_price": 618.64, "total_price": 2474.56}, {"description": "Pure White PLA+ Numakers", "quantity": 2.0, "unit_price": 625.0, "total_price": 1250.0}, {"description": "Pitch Black PLA+ Numakers", "quantity": 3.0, "unit_price": 625.0, "total_price": 1875.0}, {"description": "Bambu Lab Hotend Cooling Fan", "quantity": 1.0, "unit_price": 1101.69, "total_price": 1101.69}], "total_amount": 12817.35}	2026-03-03 00:05:28.509768	2026-03-04 17:52:21.786941	\N	\N
40	25-26/130	3D Galaxy	\N	DGTech SOLUTIONS	\N	2025-07-22 00:00:00	519	68.49	587.49	rejected	\N	Bill	\N	\N	{"invoice_number": "25-26/130", "customer_name": "DGTech SOLUTIONS", "date": "2025-07-22", "vendor_name": "3D Galaxy", "po_number": null, "amount": 519.0, "tax": 68.49, "line_items": [{"description": "THERMISTOR\\n(Neptune 4 Max)", "quantity": 1.0, "unit_price": 380.51, "total_price": 449.0}], "total_amount": 587.49}	2026-03-02 23:55:22.926593	2026-03-04 18:59:28.513176	jai alwin	2026-03-04 18:59:28.513212
42	INV09080012	XinCube Inc	\N	Synex Inc	\N	2009-08-14 00:00:00	10243.7	780.7	11024.400000000001	pending	\N	Invoice	https://drive.google.com/file/d/1e34OkETifaNWTZsiLlEAvOsA5pN3ujbM/view?usp=drivesdk	1e34OkETifaNWTZsiLlEAvOsA5pN3ujbM	{"invoice_number": "INV09080012", "customer_name": "Synex Inc", "date": "2009-08-14", "vendor_name": "XinCube Inc", "po_number": null, "amount": 10243.7, "tax": 780.7, "line_items": [{"description": "AMD Athlon X2DC-7450,\\n2.4GHz/1GB/160GB/SMP-DVD/VB", "quantity": 6.0, "unit_price": 580.0, "total_price": 3480.0}, {"description": "PDC-E5300 - 2.6GHz/1GB/320GB/SMP-DVD/FDD/VB", "quantity": 4.0, "unit_price": 645.0, "total_price": 2580.0}, {"description": "LG 18.5\\" WLCD", "quantity": 10.0, "unit_price": 230.0, "total_price": 2300.0}, {"description": "HP LaserJet 5200", "quantity": 1.0, "unit_price": 1103.0, "total_price": 1103.0}], "total_amount": 11024.400000000001}	2026-03-03 08:03:53.673159	2026-03-03 08:03:53.673159	\N	\N
44	01	Global Industries	\N	P. P. Sharma & Co.		2026-03-03 09:41:55.883496	82600	0	82600	pending	\N	Bill	https://drive.google.com/file/d/1e9f-G-kuxQyhI1oJE-o6Q7_uCDqEX38J/view?usp=drivesdk	1e9f-G-kuxQyhI1oJE-o6Q7_uCDqEX38J	{"invoice_number": null, "customer_name": "P. P. Sharma & Co.", "date": "2026-03-03T09:41:55.883496", "vendor_name": "Global Industries", "po_number": null, "amount": 82600.0, "tax": 0.0, "line_items": [{"description": "Tax Audit Under I.T. Act", "quantity": 0.0, "unit_price": 0.0, "total_price": 50000.0}, {"description": "Review & Consolidation of Branch Acoounts", "quantity": 0.0, "unit_price": 0.0, "total_price": 10000.0}, {"description": "Filling Of Income Tax Return Of The Firm", "quantity": 0.0, "unit_price": 0.0, "total_price": 10000.0}], "total_amount": 82600.0}	2026-03-03 09:42:01.389383	2026-03-03 09:43:06.153967	\N	\N
45	789	Company Name	\N	Customer Name	\N	2017-08-28 00:00:00	258.8	0	258.8	pending	\N	Payment	https://drive.google.com/file/d/1BzRsU4L6CPA7Er2qeU3qEVePzL7ySEfk/view?usp=drivesdk	1BzRsU4L6CPA7Er2qeU3qEVePzL7ySEfk	{"invoice_number": "789", "customer_name": "Customer Name", "date": "2017-08-28", "vendor_name": "Company Name", "po_number": null, "amount": 258.8, "tax": 0.0, "line_items": [{"description": "Item name and description goes here", "quantity": 3.0, "unit_price": 25.0, "total_price": 75.0}, {"description": "Item name and description goes here", "quantity": 1.0, "unit_price": 25.0, "total_price": 25.0}, {"description": "Item name and description goes here", "quantity": 2.0, "unit_price": 25.0, "total_price": 50.0}, {"description": "Item name and description goes here", "quantity": 3.0, "unit_price": 33.0, "total_price": 99.0}, {"description": "Item name and description goes here", "quantity": 1.0, "unit_price": 33.0, "total_price": 33.0}], "total_amount": 258.8}	2026-03-03 17:50:12.320136	2026-03-03 17:50:12.320136	\N	\N
47	123 4567	COMPANY	\N	NAME SURENAME	\N	2026-03-03 18:01:42.623994	2398	218	2616	pending	\N	Invoice	https://drive.google.com/file/d/1X4G-a6Hduq4Mkrnsnc4pNojma_Cy3DT1/view?usp=drivesdk	1X4G-a6Hduq4Mkrnsnc4pNojma_Cy3DT1	{"invoice_number": "123 4567", "customer_name": "NAME SURENAME", "date": "2026-03-03T18:01:42.623994", "vendor_name": "COMPANY", "po_number": null, "amount": 2398.0, "tax": 218.0, "line_items": [{"description": "Product Name Here", "quantity": 2.0, "unit_price": 100.0, "total_price": 200.0}, {"description": "Product Name Here", "quantity": 3.0, "unit_price": 150.0, "total_price": 450.0}, {"description": "Product Name Here", "quantity": 1.0, "unit_price": 120.0, "total_price": 120.0}, {"description": "Product Name Here", "quantity": 3.0, "unit_price": 150.0, "total_price": 450.0}, {"description": "Product Name Here", "quantity": 2.0, "unit_price": 100.0, "total_price": 200.0}, {"description": "Product Name Here", "quantity": 3.0, "unit_price": 120.0, "total_price": 360.0}, {"description": "Product Name Here", "quantity": 1.0, "unit_price": 100.0, "total_price": 100.0}, {"description": "Product Name Here", "quantity": 2.0, "unit_price": 150.0, "total_price": 300.0}], "total_amount": 2616.0}	2026-03-03 18:01:49.87697	2026-03-03 18:01:49.87697	\N	\N
48	001	Saldo Apps	\N	Shepard corp.	\N	2021-07-13 00:00:00	8480	450	8930	pending	\N	Invoice	https://drive.google.com/file/d/1ZduM-MeMVwnHDgmPdrcAt_av63N2Uxpf/view?usp=drivesdk	1ZduM-MeMVwnHDgmPdrcAt_av63N2Uxpf	{"invoice_number": "001", "customer_name": "Shepard corp.", "date": "2021-07-13", "vendor_name": "Saldo Apps", "po_number": null, "amount": 8480.0, "tax": 450.0, "line_items": [{"description": "Prototype\\nPrototype-based programming is a style\\nof object-oriented programming", "quantity": 2000.0, "unit_price": 20230450.0, "total_price": 20230450.0}, {"description": "Design", "quantity": 2000.0, "unit_price": 20230450.0, "total_price": 20230450.0}], "total_amount": 8930.0}	2026-03-03 18:02:18.183044	2026-03-03 18:02:18.183044	\N	\N
49	SO-00001	Testing Gym Manufacturer Sdn Bhd	\N	HERO FITNESS CLUB	\N	2018-09-01 00:00:00	37191.5	7926.5	45118	pending	\N	Invoice	https://drive.google.com/file/d/17jL2y1-UcJg5xVhfk5auLHljYjW05TH-/view?usp=drivesdk	17jL2y1-UcJg5xVhfk5auLHljYjW05TH-	{"invoice_number": "SO-00001", "customer_name": "HERO FITNESS CLUB", "date": "2018-09-01", "vendor_name": "Testing Gym Manufacturer Sdn Bhd", "po_number": null, "amount": 37191.5, "tax": 7926.5, "line_items": [{"description": "Barbell Rack DM-419", "quantity": 10.0, "unit_price": 638.0, "total_price": 7018.0}, {"description": "Junge Stack DM-075", "quantity": 20.0, "unit_price": 2150.0, "total_price": 47300.0}, {"description": "Treadmill DM-424", "quantity": 5.0, "unit_price": 3279.0, "total_price": 18034.5}, {"description": "Set Up Bench DM-020", "quantity": 10.0, "unit_price": 1349.0, "total_price": 14839.0}], "total_amount": 45118.0}	2026-03-03 18:18:19.591997	2026-03-03 18:18:19.591997	\N	\N
50	GST-3425-26	GUJARAT FREIGHT TOOLS	\N	Shiv Engineering	\N	2025-07-23 00:00:00	4490	684.9	5174.9	pending	\N	Invoice payment	https://drive.google.com/file/d/1Dqf16LHlfoR-PYCRMhL-f2Vq-aEi7Nrz/view?usp=drivesdk	1Dqf16LHlfoR-PYCRMhL-f2Vq-aEi7Nrz	{"invoice_number": "GST-3425-26", "customer_name": "Shiv Engineering", "date": "2025-07-23", "vendor_name": "GUJARAT FREIGHT TOOLS", "po_number": null, "amount": 4490.0, "tax": 684.9, "line_items": [{"description": "Bosch All-in-One Metal Hand Tool Kit", "quantity": 1.0, "unit_price": 2535.0, "total_price": 2535.0}, {"description": "Taparia Universal Tool Kit", "quantity": 1.0, "unit_price": 1270.0, "total_price": 1270.0}], "total_amount": 5174.9}	2026-03-03 18:18:45.701606	2026-03-03 18:18:45.701606	\N	\N
51	I-000010	DEMO COMPANY SDN BHD	\N	DEMO HYPERMARKET SDN BHD	123	2017-10-10 00:00:00	3096.3	175.26	3271.5600000000004	pending	\N	Invoice	https://drive.google.com/file/d/1s0FjRdGLnR66U7P4oh57Be6mCUDs13bt/view?usp=drivesdk	1s0FjRdGLnR66U7P4oh57Be6mCUDs13bt	{"invoice_number": "I-000010", "customer_name": "DEMO HYPERMARKET SDN BHD", "date": "2017-10-10", "vendor_name": "DEMO COMPANY SDN BHD", "po_number": "123", "amount": 3096.3, "tax": 175.26, "line_items": [{"description": "PRODUCT DESCRIPTION MODEL A-123", "quantity": 1.0, "unit_price": 1000.0, "total_price": 950.0}, {"description": "PRODUCT DESCRIPTION MODEL A-123", "quantity": 1.0, "unit_price": 1000.0, "total_price": 970.0}, {"description": "PRODUCT DESCRIPTION MODEL A-123", "quantity": 1.0, "unit_price": 1000.0, "total_price": 990.0}, {"description": "PRODUCT DESCRIPTION MODEL A-123", "quantity": 1.0, "unit_price": 11.12, "total_price": 11.02}], "total_amount": 3271.5600000000004}	2026-03-03 18:19:36.301911	2026-03-03 18:19:36.301911	\N	\N
52	IV-00036	Testing Company Sdn Bhd	\N	E Stream Software Sdn Bhd	\N	2025-01-20 00:00:00	255	0	255	pending	\N	Invoice	https://drive.google.com/file/d/1LJxe-KIuNaQx2C7l5Y0tHFhKKZzBGFWD/view?usp=drivesdk	1LJxe-KIuNaQx2C7l5Y0tHFhKKZzBGFWD	{"invoice_number": "IV-00036", "customer_name": "E Stream Software Sdn Bhd", "date": "2025-01-20", "vendor_name": "Testing Company Sdn Bhd", "po_number": null, "amount": 255.0, "tax": 0.0, "line_items": [{"description": "Creative Curvy Modern Style Eames Chair (Grey)", "quantity": 1.0, "unit_price": 85.0, "total_price": 85.0}, {"description": "Creative Curvy Modern Style Eames Chair (White)", "quantity": 1.0, "unit_price": 85.0, "total_price": 85.0}, {"description": "Creative Curvy Modern Style Eames Chair (Black)", "quantity": 1.0, "unit_price": 85.0, "total_price": 85.0}], "total_amount": 255.0}	2026-03-03 18:20:02.516649	2026-03-03 18:20:02.516649	\N	\N
15	NM/SP/2526/3703	Numakers Asia LLP	\N	Dgtech Solutions	\N	2025-08-23 00:00:00	3239.1	494.1	3733.2	accepted	\N	Bill	https://drive.google.com/file/d/1KBa7AFW6OP13y9Fhj9aHmuUj_fHGUhZA/view?usp=drivesdk	1KBa7AFW6OP13y9Fhj9aHmuUj_fHGUhZA	{"invoice_number": "NM/SP/2526/3703", "customer_name": "Dgtech Solutions", "date": "2025-08-23", "vendor_name": "Numakers Asia LLP", "po_number": null, "amount": 3239.1, "tax": 494.1, "line_items": [{"description": "PLA+ Filament/1.75 mm / 1 kg/\\nPitch Black", "quantity": 2.0, "unit_price": 625.0, "total_price": 1250.0}, {"description": "PLA+ Filament/1.75 mm / 1 kg\\n/Pure White", "quantity": 2.0, "unit_price": 625.0, "total_price": 1250.0}, {"description": "OutState Shipping Charges 18%", "quantity": 0.0, "unit_price": 0.0, "total_price": 245.0}, {"description": "Goods and Services", "quantity": 0.0, "unit_price": 0.0, "total_price": 494.1}], "total_amount": 3733.2}	2026-02-27 22:11:55.122498	2026-03-03 18:26:07.439479	reviewer	2026-03-03 18:26:07.440856
54	325FR125	Company Name	\N	Hania Madden	\N	2022-12-28 00:00:00	4725	225	4950	pending	\N	Payment	https://drive.google.com/file/d/1bIWBicBYcyZe5BaYhtaGjX-giphqnDic/view?usp=drivesdk	1bIWBicBYcyZe5BaYhtaGjX-giphqnDic	{"invoice_number": "325FR125", "customer_name": "Hania Madden", "date": "2022-12-28", "vendor_name": "Company Name", "po_number": null, "amount": 4725.0, "tax": 225.0, "line_items": [{"description": "Lorem ipsum dolor sit amet,\\nconsectetur adipiscing elit, sed do\\neiusmod tempor incididunt ut\\nlabore et dolore magna aliqua. Ut\\nenim ad minim veniam, quis\\nnostrud exercitation ullamco\\nlaboris nisi ut aliquip ex ea\\ncommodo consequat.", "quantity": 3.0, "unit_price": 1500.0, "total_price": 4500.0}], "total_amount": 4950.0}	2026-03-03 22:58:40.961897	2026-03-03 22:58:40.961897	\N	\N
55	INV-000001	Zylker Design Labs	\N	Jack Little	\N	2023-05-18 00:00:00	19320	920	20240	pending	\N	Invoice	https://drive.google.com/file/d/1s01kqifqzr3Xk9o0ozte2Beok-1R5GNh/view?usp=drivesdk	1s01kqifqzr3Xk9o0ozte2Beok-1R5GNh	{"invoice_number": "INV-000001", "customer_name": "Jack Little", "date": "2023-05-18", "vendor_name": "Zylker Design Labs", "po_number": null, "amount": 19320.0, "tax": 920.0, "line_items": [{"description": "Brochure Design\\nBrochure design - Single sided (Color)", "quantity": 1.0, "unit_price": 900.0, "total_price": 900.0}, {"description": "Web Design packages (Simple)\\n10 Pages, Slider, Free Logo, Dynamic Website, Free Domain, Hosting Free\\nfor 1st year,", "quantity": 1.0, "unit_price": 10000.0, "total_price": 10000.0}, {"description": "Print Ad - Newspaper\\nA full-page ad, Nationwide Circulation (Colour)", "quantity": 1.0, "unit_price": 7500.0, "total_price": 7500.0}], "total_amount": 20240.0}	2026-03-03 22:59:06.364513	2026-03-03 22:59:06.364513	\N	\N
56	ABCR	HOLM CUSTOM CONSTRUCTION	\N	John Abercrombie	1234	2008-05-31 00:00:00	2430	0	2430	accepted	\N	Bill	https://drive.google.com/file/d/1aSoqpEQQicFTutRL_6Wnrcnenk9dCnzA/view?usp=drivesdk	1aSoqpEQQicFTutRL_6Wnrcnenk9dCnzA	{"invoice_number": "ABCR", "customer_name": "John Abercrombie", "date": "2008-05-31", "vendor_name": "HOLM CUSTOM CONSTRUCTION", "po_number": "1234", "amount": 2430.0, "tax": 0.0, "line_items": [{"description": "Job Phase: Excavation\\nExcavation", "quantity": 0.0, "unit_price": 0.0, "total_price": 630.0}, {"description": "Job Phase: Foundation\\nKit Foundation", "quantity": 0.0, "unit_price": 0.0, "total_price": 1800.0}], "total_amount": 2430.0}	2026-03-03 23:34:11.352315	2026-03-03 23:36:02.66984	reviewer	2026-03-03 23:36:02.6699
43	SHB/456/20	Surabhi Hardwares, Bangalore	\N	Kiran Enterprises	\N	2020-12-20 00:00:00	4130	630	4760	accepted	\N	Payment	https://drive.google.com/file/d/1zZyepiN6AKFqqZ-9qZHRjpD3tZSnIxK7/view?usp=drivesdk	1zZyepiN6AKFqqZ-9qZHRjpD3tZSnIxK7	{"invoice_number": "SHB/456/20", "customer_name": "Kiran Enterprises", "date": "2020-12-20", "vendor_name": "Surabhi Hardwares, Bangalore", "po_number": null, "amount": 4130.0, "tax": 630.0, "line_items": [{"description": "12MM**", "quantity": 7.0, "unit_price": 500.0, "total_price": 3500.0}], "total_amount": 4760.0}	2026-03-03 08:20:36.384	2026-03-04 14:58:46.70572	reviewer	2026-03-04 14:58:46.705781
57	INV-001	Invocreto	\N	Merry Carm	\N	2024-12-09 00:00:00	88	18	106	pending	\N	Invoice	https://drive.google.com/file/d/1Daf7w9wvbPI4Vs0L-0-gY3aQyFfq2dok/view?usp=drivesdk	1Daf7w9wvbPI4Vs0L-0-gY3aQyFfq2dok	{"invoice_number": "INV-001", "customer_name": "Merry Carm", "date": "2024-12-09", "vendor_name": "Invocreto", "po_number": null, "amount": 88.0, "tax": 18.0, "line_items": [{"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}, {"description": "Taurus", "quantity": 1.0, "unit_price": 10.0, "total_price": 10.0}], "total_amount": 106.0}	2026-03-04 15:02:01.892523	2026-03-04 15:02:01.892523	\N	\N
58	665	\N	\N	[Client's Company Name]	\N	2025-11-05 00:00:00	1650	150	1800	pending	\N	Invoice	https://drive.google.com/file/d/1kpW5uLt7c4_GGaVlX6D-U7-fRKAMmZLk/view?usp=drivesdk	1kpW5uLt7c4_GGaVlX6D-U7-fRKAMmZLk	{"invoice_number": "665", "customer_name": "[Client's Company Name]", "date": "2025-11-05", "vendor_name": null, "po_number": null, "amount": 1650.0, "tax": 150.0, "line_items": [{"description": "Your Products", "quantity": 2.0, "unit_price": 1000.0, "total_price": 2000.0}, {"description": "Discount", "quantity": 1.0, "unit_price": -500.0, "total_price": -500.0}], "total_amount": 1800.0}	2026-03-04 15:02:18.799536	2026-03-04 15:02:18.799536	\N	\N
46	000000	\N	\N	Client Name	\N	2014-10-07 00:00:00	4520	520	5040	accepted	\N	Invoice	https://drive.google.com/file/d/11WmNSK3BJ9I1QYnQfrHbNq7e38ijOilc/view?usp=drivesdk	11WmNSK3BJ9I1QYnQfrHbNq7e38ijOilc	{"invoice_number": "000000", "customer_name": "Client Name", "date": "2014-10-07", "vendor_name": null, "po_number": null, "amount": 4520.0, "tax": 520.0, "line_items": [{"description": "Your item Name\\nItem description goes here", "quantity": 1.0, "unit_price": 1000.0, "total_price": 1000.0}, {"description": "Your item Name\\nItem description goes here", "quantity": 1.0, "unit_price": 1000.0, "total_price": 1000.0}, {"description": "Your item Name\\nItem description goes here", "quantity": 1.0, "unit_price": 1000.0, "total_price": 1000.0}, {"description": "Your item Name\\nItem description goes here", "quantity": 1.0, "unit_price": 1000.0, "total_price": 1000.0}], "total_amount": 5040.0}	2026-03-03 18:01:19.331808	2026-03-04 15:04:15.763772	reviewer	2026-03-04 15:04:15.763792
53	IV-00100	ABC SOFTWARE CO.LTD	\N	AB ENTERPRISE SDN BHD	\N	2020-02-11 00:00:00	926000	0	926000	accepted	\N	Invoice	https://drive.google.com/file/d/1ssIwnKjh9OkvO8rAWI4ZRmaLE_NUVueN/view?usp=drivesdk	1ssIwnKjh9OkvO8rAWI4ZRmaLE_NUVueN	{"invoice_number": "IV-00100", "customer_name": "AB ENTERPRISE SDN BHD", "date": "2020-02-11", "vendor_name": "ABC SOFTWARE CO.LTD", "po_number": null, "amount": 926000.0, "tax": 0.0, "line_items": [{"description": "ABC English Translator Software", "quantity": 1.0, "unit_price": 700500.0, "total_price": 700500.0}, {"description": "WPP Office Suite 360", "quantity": 1.0, "unit_price": 225500.0, "total_price": 225500.0}], "total_amount": 926000.0}	2026-03-03 18:20:32.161082	2026-03-04 15:48:42.317794	Elaya	2026-03-04 15:48:42.317818
59	MB-23-24/CR-1563	Malushte Brothers	\N	Malushte Brothers	\N	2023-10-21 00:00:00	89747	13689.9	103436.9	pending	\N	Manual Upload by admin	https://drive.google.com/file/d/1iJSrzegfj17GO4WrfI2jXASTJKmfhS0D/view?usp=drivesdk	1iJSrzegfj17GO4WrfI2jXASTJKmfhS0D	{"invoice_number": "MB-23-24/CR-1563", "customer_name": "Malushte Brothers", "date": "2023-10-21", "vendor_name": "Malushte Brothers", "po_number": null, "amount": 89747.0, "tax": 13689.9, "line_items": [{"description": "GP SHS 50'50 APOLLO IS", "quantity": 70.0, "unit_price": 1006.53, "total_price": 76057.1}], "total_amount": 103436.9}	2026-03-04 18:12:37.506052	2026-03-04 18:12:37.506052	\N	\N
61	GST002/2019	Green Leaf Ltd.	\N	Aadarsh & Com	\N	2019-05-01 00:00:00	80100.5	58100.5	138201	pending	\N	Invoice	https://drive.google.com/file/d/19_sEl2bu47v90sJd-8ixQGwj--Bued5e/view?usp=drivesdk	19_sEl2bu47v90sJd-8ixQGwj--Bued5e	{"invoice_number": "GST002/2019", "customer_name": "Aadarsh & Com", "date": "2019-05-01", "vendor_name": "Green Leaf Ltd.", "po_number": null, "amount": 80100.5, "tax": 58100.5, "line_items": [{"description": "T-Shirt 32\\"", "quantity": 10.0, "unit_price": 1000.0, "total_price": 10000.0}, {"description": "T-Shirt 34", "quantity": 10.0, "unit_price": 200.0, "total_price": 2000.0}, {"description": "T-Shirt 36", "quantity": 20.0, "unit_price": 500.0, "total_price": 10000.0}], "total_amount": 138201.0}	2026-03-04 18:33:42.226622	2026-03-04 18:33:42.226622	\N	\N
62	2023-789	NORTHSTAR SOLUTIONS	\N	\N	\N	2023-01-15 00:00:00	3348	248	3596	pending	\N	Invoice	https://drive.google.com/file/d/1lHmR0xuA1_WCe_MY4cVEcVrQXEs71U2h/view?usp=drivesdk	1lHmR0xuA1_WCe_MY4cVEcVrQXEs71U2h	{"invoice_number": "2023-789", "customer_name": null, "date": "2023-01-15", "vendor_name": "NORTHSTAR SOLUTIONS", "po_number": null, "amount": 3348.0, "tax": 248.0, "line_items": [{"description": "Website Design & Development", "quantity": 1.0, "unit_price": 1500.0, "total_price": 1500.0}, {"description": "SEO Optimization", "quantity": 1.0, "unit_price": 600.0, "total_price": 600.0}, {"description": "Content Writing", "quantity": 10.0, "unit_price": 50.0, "total_price": 500.0}, {"description": "Social Media Management", "quantity": 1.0, "unit_price": 400.0, "total_price": 400.0}, {"description": "Monthly Hosting Fee", "quantity": 1.0, "unit_price": 100.0, "total_price": 100.0}], "total_amount": 3596.0}	2026-03-04 18:51:56.676884	2026-03-04 18:51:56.676884	\N	\N
63	2024-457	NORTHSTAR SOLUTIONS	\N	\N	\N	2023-01-15 00:00:00	3348	248	3596	pending	\N	Invoice	https://drive.google.com/file/d/1Xya9fZaYOaWq2cczBkzkg1ygZsI5gDjz/view?usp=drivesdk	1Xya9fZaYOaWq2cczBkzkg1ygZsI5gDjz	{"invoice_number": "2024-457", "customer_name": null, "date": "2023-01-15", "vendor_name": "NORTHSTAR SOLUTIONS", "po_number": null, "amount": 3348.0, "tax": 248.0, "line_items": [{"description": "Website Design & Development", "quantity": 1.0, "unit_price": 1500.0, "total_price": 1500.0}, {"description": "SEO Optimization", "quantity": 1.0, "unit_price": 600.0, "total_price": 600.0}, {"description": "Content Writing", "quantity": 10.0, "unit_price": 50.0, "total_price": 500.0}, {"description": "Social Media Management", "quantity": 1.0, "unit_price": 400.0, "total_price": 400.0}, {"description": "Monthly Hosting Fee", "quantity": 1.0, "unit_price": 100.0, "total_price": 100.0}], "total_amount": 3596.0}	2026-03-04 18:52:26.452486	2026-03-04 18:52:26.452486	\N	\N
64	INV110/22-23	Ram Pharmaceutical	\N	Kannan	\N	2022-09-20 00:00:00	1260	60	1320	pending	\N	Invoice	https://drive.google.com/file/d/1ecGHPIw_Z-meB3jD0AUNtoNzr80F-vtY/view?usp=drivesdk	1ecGHPIw_Z-meB3jD0AUNtoNzr80F-vtY	{"invoice_number": "INV110/22-23", "customer_name": "Kannan", "date": "2022-09-20", "vendor_name": "Ram Pharmaceutical", "po_number": null, "amount": 1260.0, "tax": 60.0, "line_items": [{"description": "Bepanthen\\nBatch : 503\\nMfg.Date: 08-05-2019\\nExp.Date: 11-06-2024\\nManufacturer: Groove Pharamaceuticals", "quantity": 10.0, "unit_price": 120.0, "total_price": 1200.0}], "total_amount": 1320.0}	2026-03-05 17:35:02.419805	2026-03-05 17:35:02.419805	\N	\N
65	INV4	Swetha Mobiles	\N	Harish	\N	2021-03-22 00:00:00	9790	1493.46	11283.46	pending	\N	Invoice	https://drive.google.com/file/d/19qEbgAN474ezS-dotUAh3IPfHAms6-Nz/view?usp=drivesdk	19qEbgAN474ezS-dotUAh3IPfHAms6-Nz	{"invoice_number": "INV4", "customer_name": "Harish", "date": "2021-03-22", "vendor_name": "Swetha Mobiles", "po_number": null, "amount": 9790.0, "tax": 1493.46, "line_items": [{"description": "SAMSUNG Galaxy M02s + 64 GB + 4GB RAM\\nColor: White", "quantity": 1.0, "unit_price": 8297.0, "total_price": 8297.0}], "total_amount": 11283.46}	2026-03-05 17:38:30.393236	2026-03-05 17:38:30.393236	\N	\N
66	PI-001	NexaTech Solutions	\N	Rajesh Kumar	\N	2026-03-05 00:00:00	33040	5040	38080	pending	\N	Quote	https://drive.google.com/file/d/1D5qDH5P61igrtJIA2ivTTJEAp0kwcbfI/view?usp=drivesdk	1D5qDH5P61igrtJIA2ivTTJEAp0kwcbfI	{"invoice_number": "PI-001", "customer_name": "Rajesh Kumar", "date": "2026-03-05", "vendor_name": "NexaTech Solutions", "po_number": null, "amount": 33040.0, "tax": 5040.0, "line_items": [{"description": "Website Development", "quantity": 1.0, "unit_price": 18000.0, "total_price": 18000.0}, {"description": "UI/UX Design", "quantity": 1.0, "unit_price": 6000.0, "total_price": 6000.0}, {"description": "Testing and Deployment", "quantity": 1.0, "unit_price": 4000.0, "total_price": 4000.0}], "total_amount": 38080.0}	2026-03-05 18:08:39.21572	2026-03-05 18:08:39.21572	\N	\N
67	INV-0867	Wear Your Opinion	\N	Rajveen	3432532	2017-09-22 00:00:00	7400	1383.05	8783.05	pending	\N	Invoice	https://drive.google.com/file/d/173F2PTfsaReriYq4brSDqPV6fBXlitF6/view?usp=drivesdk	173F2PTfsaReriYq4brSDqPV6fBXlitF6	{"invoice_number": "INV-0867", "customer_name": "Rajveen", "date": "2017-09-22", "vendor_name": "Wear Your Opinion", "po_number": "3432532", "amount": 7400.0, "tax": 1383.05, "line_items": [{"description": "Pearl Pink\\nPearl Pink Jewellery.", "quantity": 10.0, "unit_price": 360.0, "total_price": 3050.85}, {"description": "Pearl Green\\nPearl Green Jewellery.", "quantity": 10.0, "unit_price": 350.0, "total_price": 2966.1}], "total_amount": 8783.05}	2026-03-05 18:18:32.934429	2026-03-05 18:18:32.934429	\N	\N
68	1	Kantech Solutions Private Limited	\N	Vijaya Traders Private Limited	\N	2017-06-30 00:00:00	157500	32500	190000	pending	\N	Invoice	https://drive.google.com/file/d/1e_dzZXJ54t0IVXz5Ry2LqVZg0unhjAQn/view?usp=drivesdk	1e_dzZXJ54t0IVXz5Ry2LqVZg0unhjAQn	{"invoice_number": "1", "customer_name": "Vijaya Traders Private Limited", "date": "2017-06-30", "vendor_name": "Kantech Solutions Private Limited", "po_number": null, "amount": 157500.0, "tax": 32500.0, "line_items": [{"description": "Shampoo", "quantity": 10000.0, "unit_price": 10.0, "total_price": 100000.0}, {"description": "Soap", "quantity": 5000.0, "unit_price": 5.0, "total_price": 25000.0}], "total_amount": 190000.0}	2026-03-05 18:50:28.529541	2026-03-05 18:50:28.529541	\N	\N
69	PI-002	CodeWave Technologies	\N	Priya Sharma	\N	2026-03-05 00:00:00	37760	5760	43520	pending	\N	Quote	https://drive.google.com/file/d/1JDul4ZZUV6pSDbB7cwuCTo0fU_qz0d99/view?usp=drivesdk	1JDul4ZZUV6pSDbB7cwuCTo0fU_qz0d99	{"invoice_number": "PI-002", "customer_name": "Priya Sharma", "date": "2026-03-05", "vendor_name": "CodeWave Technologies", "po_number": null, "amount": 37760.0, "tax": 5760.0, "line_items": [{"description": "Mobile App Development", "quantity": 1.0, "unit_price": 22000.0, "total_price": 22000.0}, {"description": "Database Setup", "quantity": 1.0, "unit_price": 7000.0, "total_price": 6000.0}, {"description": "Technical Support", "quantity": 1.0, "unit_price": 3000.0, "total_price": 3000.0}], "total_amount": 43520.0}	2026-03-05 18:51:00.267627	2026-03-05 18:51:00.267627	\N	\N
70	77777	CodeWave Technologies	\N	Priya Sharma	\N	2026-03-05 00:00:00	37760	5760	43520	pending	\N	Invoice	https://drive.google.com/file/d/1U0d4aQ8RvtaGTm4ZRYfzm6Ajaxr8qhtB/view?usp=drivesdk	1U0d4aQ8RvtaGTm4ZRYfzm6Ajaxr8qhtB	{"invoice_number": "77777", "customer_name": "Priya Sharma", "date": "2026-03-05", "vendor_name": "CodeWave Technologies", "po_number": null, "amount": 37760.0, "tax": 5760.0, "line_items": [{"description": "Mobile App Development", "quantity": 0.0, "unit_price": 0.0, "total_price": 22000.0}, {"description": "Database Setup", "quantity": 0.0, "unit_price": 0.0, "total_price": 7000.0}, {"description": "Technical Support", "quantity": 0.0, "unit_price": 0.0, "total_price": 3000.0}], "total_amount": 43520.0}	2026-03-05 20:06:06.071092	2026-03-05 20:06:06.071092	\N	\N
71	PI-006	Innovatech Systems	\N	Meera Iyer	\N	2026-03-05 00:00:00	21240	3240	24480	pending	\N	Invoice	https://drive.google.com/file/d/1Fsz2Cyongwm-UMZHT3jRs1CM6X5FTsXa/view?usp=drivesdk	1Fsz2Cyongwm-UMZHT3jRs1CM6X5FTsXa	{"invoice_number": "PI-006", "customer_name": "Meera Iyer", "date": "2026-03-05", "vendor_name": "Innovatech Systems", "po_number": null, "amount": 21240.0, "tax": 3240.0, "line_items": [{"description": "Software Installation", "quantity": 1.0, "unit_price": 7000.0, "total_price": 7000.0}, {"description": "Database Configuration", "quantity": 1.0, "unit_price": 5000.0, "total_price": 5000.0}, {"description": "Technical Training", "quantity": 1.0, "unit_price": 6000.0, "total_price": 6000.0}], "total_amount": 24480.0}	2026-03-07 18:26:41.577354	2026-03-07 18:26:41.577354	\N	\N
72	VTX/992/21	Surabhi Hardwares, Bangalore	\N	Cloud-Nine Solutions, Pune	\N	2021-01-12 00:00:00	31360	6860	38220	pending	\N	Manual Upload by admin	https://drive.google.com/file/d/1sKgwbiwC7D8YW-UmuZoL1vN1e8wPE0HW/view?usp=drivesdk	1sKgwbiwC7D8YW-UmuZoL1vN1e8wPE0HW	{"invoice_number": "VTX/992/21", "customer_name": "Cloud-Nine Solutions, Pune", "date": "2021-01-12", "vendor_name": "Surabhi Hardwares, Bangalore", "po_number": null, "amount": 31360.0, "tax": 6860.0, "line_items": [{"description": "Wireless Access Points", "quantity": 25.0, "unit_price": 1200.0, "total_price": 30000.0}], "total_amount": 38220.0}	2026-03-07 18:28:04.528991	2026-03-07 18:28:04.528991	\N	\N
60	INV-2050-001	Pharmacy	\N	Lyda Fadel		2050-03-01 00:00:00	2231.25	106.25	2337.5	accepted	\N	Invoice	https://drive.google.com/file/d/11l9JaUgx_FU_LlTuU57dDEgJulbiglX4/view?usp=drivesdk	11l9JaUgx_FU_LlTuU57dDEgJulbiglX4	{"invoice_number": "INV-2050-001", "customer_name": "Lyda Fadel", "date": "2050-03-01", "vendor_name": null, "po_number": null, "amount": 2231.25, "tax": 106.25, "line_items": [{"description": "Website Development Services", "quantity": 1.0, "unit_price": 1500.0, "total_price": 1500.0}, {"description": "Monthly Maintenance", "quantity": 3.0, "unit_price": 200.0, "total_price": 600.0}, {"description": "Domain Registration", "quantity": 1.0, "unit_price": 25.0, "total_price": 25.0}], "total_amount": 2337.5}	2026-03-04 18:23:40.11068	2026-03-10 17:34:00.516403	Sakthi	2026-03-10 17:34:00.516533
73	IN-15	Sleek Bill	\N	Cash Sales	\N	2025-01-23 00:00:00	968	68	1036	pending	\N	Payment	https://drive.google.com/file/d/18v7VNBFG9oGHvYuw6GAfF11dQUDrV-96/view?usp=drivesdk	18v7VNBFG9oGHvYuw6GAfF11dQUDrV-96	{"invoice_number": "IN-15", "customer_name": "Cash Sales", "date": "2025-01-23", "vendor_name": "Sleek Bill", "po_number": null, "amount": 968.0, "tax": 68.0, "line_items": [{"description": "Orange Powder", "quantity": 1.0, "unit_price": 400.0, "total_price": 448.0}, {"description": "Walnuts 5% Tax Item", "quantity": 1.0, "unit_price": 100.0, "total_price": 105.0}, {"description": "Coin 3% Tax Item", "quantity": 1.0, "unit_price": 100.0, "total_price": 103.0}, {"description": "Rose Water", "quantity": 1.0, "unit_price": 150.0, "total_price": 150.0}, {"description": "Glicerene", "quantity": 1.0, "unit_price": 50.0, "total_price": 50.0}, {"description": "Cheese 12% Tax Item", "quantity": 1.0, "unit_price": 100.0, "total_price": 112.0}], "total_amount": 1036.0}	2026-03-10 17:37:00.059327	2026-03-10 17:37:00.059327	\N	\N
74	1002	Fusion IT Services	\N	Kavya Reddy	\N	2026-03-06 00:00:00	23600	3600	27200	pending	\N	Invoice	https://drive.google.com/file/d/1opAzbqXwqDvmze9mvM3L7G_FFUVbXXjR/view?usp=drivesdk	1opAzbqXwqDvmze9mvM3L7G_FFUVbXXjR	{"invoice_number": "1002", "customer_name": "Kavya Reddy", "date": "2026-03-06", "vendor_name": "Fusion IT Services", "po_number": null, "amount": 23600.0, "tax": 3600.0, "line_items": [{"description": "Software Installation", "quantity": 1.0, "unit_price": 10000.0, "total_price": 10000.0}, {"description": "Database Configuration", "quantity": 1.0, "unit_price": 6000.0, "total_price": 6000.0}, {"description": "System Maintenance", "quantity": 1.0, "unit_price": 4000.0, "total_price": 4000.0}], "total_amount": 27200.0}	2026-03-10 17:52:05.428011	2026-03-10 17:52:05.428011	\N	\N
75	009	SmartLogic Solutions	\N	\N	\N	2026-03-05 00:00:00	35400	5400	40800	pending	\N	Invoice	https://drive.google.com/file/d/1zuhWh93VKPW5dVrzps1T5TEflze-pIfQ/view?usp=drivesdk	1zuhWh93VKPW5dVrzps1T5TEflze-pIfQ	{"invoice_number": "009", "customer_name": null, "date": "2026-03-05", "vendor_name": "SmartLogic Solutions", "po_number": null, "amount": 35400.0, "tax": 5400.0, "line_items": [{"description": "System Analysis", "quantity": 0.0, "unit_price": 0.0, "total_price": 10000.0}, {"description": "Software Development", "quantity": 0.0, "unit_price": 0.0, "total_price": 15000.0}, {"description": "Testing", "quantity": 0.0, "unit_price": 0.0, "total_price": 5000.0}], "total_amount": 40800.0}	2026-03-10 17:52:28.524854	2026-03-10 17:52:28.524854	\N	\N
76	PI-1320	DataCore Technologies	\N	Anjali Desai	\N	2026-03-05 00:00:00	24780	3780	28560	pending	\N	Payment	https://drive.google.com/file/d/1-xXeRLYpzik468TxhFRRMq-WwLizZ9-E/view?usp=drivesdk	1-xXeRLYpzik468TxhFRRMq-WwLizZ9-E	{"invoice_number": "PI-1320", "customer_name": "Anjali Desai", "date": "2026-03-05", "vendor_name": "DataCore Technologies", "po_number": null, "amount": 24780.0, "tax": 3780.0, "line_items": [{"description": "Database Design", "quantity": 1.0, "unit_price": 9000.0, "total_price": 9000.0}, {"description": "System Setup", "quantity": 1.0, "unit_price": 8000.0, "total_price": 8000.0}, {"description": "Maintenance", "quantity": 1.0, "unit_price": 4000.0, "total_price": 4000.0}], "total_amount": 28560.0}	2026-03-10 18:35:06.514056	2026-03-10 18:35:06.514056	\N	\N
78	015	NovaTech Solutions	\N	Aditya Sharma	\N	2026-03-06 00:00:00	47200	7200	54400	pending	\N	Manual Upload by admin	https://drive.google.com/file/d/1lCEGhdOSmfG9UUyLo9Uq9jSispVFQ8Df/view?usp=drivesdk	1lCEGhdOSmfG9UUyLo9Uq9jSispVFQ8Df	{"invoice_number": "015", "customer_name": "Aditya Sharma", "date": "2026-03-06", "vendor_name": "NovaTech Solutions", "po_number": null, "amount": 47200.0, "tax": 7200.0, "line_items": [{"description": "E-commerce Website Development", "quantity": 0.0, "unit_price": 0.0, "total_price": 25000.0}, {"description": "Payment Gateway Integration", "quantity": 0.0, "unit_price": 0.0, "total_price": 10000.0}, {"description": "Support & Maintenance", "quantity": 0.0, "unit_price": 0.0, "total_price": 5000.0}], "total_amount": 54400.0}	2026-03-10 18:36:29.627422	2026-03-10 18:36:29.627422	\N	\N
77	020	NextGen Technologies	\N	Ananya Singh	234	2026-03-07 00:00:00	25960	3960	29920	accepted	\N	Invoice	https://drive.google.com/file/d/1uTMmbsjkHIIJIHbtRYkyxW2PeFPcww1W/view?usp=drivesdk	1uTMmbsjkHIIJIHbtRYkyxW2PeFPcww1W	{"invoice_number": "020", "customer_name": "Ananya Singh", "date": "2026-03-07", "vendor_name": "NextGen Technologies", "po_number": null, "amount": 25960.0, "tax": 3960.0, "line_items": [{"description": "Cloud Services Setup", "quantity": 1.0, "unit_price": 12000.0, "total_price": 12000.0}, {"description": "Software Installation", "quantity": 1.0, "unit_price": 6000.0, "total_price": 6000.0}, {"description": "Technical Training", "quantity": 1.0, "unit_price": 4000.0, "total_price": 4000.0}], "total_amount": 29920.0}	2026-03-10 18:35:48.145876	2026-03-10 18:40:53.402372	elaya	2026-03-10 18:40:53.40246
\.


--
-- Data for Name: line_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.line_items (id, invoice_id, description, quantity, unit_price, total_price, created_at) FROM stdin;
20	9	P1P Bambu Lab Heater 24v 65w Ceramic heate Heater and Temperature Sensor 350 for 3D Printer	3	250	750	2026-02-27 18:25:03.92969
21	14	ASA - Filament/1.75 mm / 1 kg /Pitch Black	2	775	1550	2026-02-27 20:47:13.133168
22	14	OutState Shipping Charges 18%	0	0	132	2026-02-27 20:47:13.133168
23	14	IGST 18%	0	0	302.76	2026-02-27 20:47:13.133168
24	15	PLA+ Filament/1.75 mm / 1 kg/\nPitch Black	2	625	1250	2026-02-27 22:11:55.122498
25	15	PLA+ Filament/1.75 mm / 1 kg\n/Pure White	2	625	1250	2026-02-27 22:11:55.122498
26	15	OutState Shipping Charges 18%	0	0	245	2026-02-27 22:11:55.122498
27	15	Goods and Services	0	0	494.1	2026-02-27 22:11:55.122498
28	16	Test Product 3 (Non-taxable)	1	300	300	2026-03-02 17:53:57.784181
29	16	Test Product 2 (Service)	1	200	200	2026-03-02 17:53:57.784181
30	16	Test Product 1	1	100	100	2026-03-02 17:53:57.784181
31	16	Test Product 3 (Non-taxable)	1	300	300	2026-03-02 17:53:57.784181
32	16	Test Product 2 (Service)	1	200	200	2026-03-02 17:53:57.784181
33	16	Test Product 1	1	100	100	2026-03-02 17:53:57.784181
34	18	Product	3	177	531	2026-03-02 18:05:42.522543
35	18	Service	1	600	600	2026-03-02 18:05:42.522543
36	18	Service (Discount 20%)	1	-120	-120	2026-03-02 18:05:42.522543
37	20	Samsung EVO Plus 128GB Micro SDXC w/SD Adaptor,\nUp-to 160MB/s, Expanded Storage for Gaming Devices,\nAndroid Tablets and Smart Phones, Memory Card,\nMB-MC128SA/IN | BOCXJ2FTBR (B0CXJ2FTBR)\nHSN:85235100	1	888.98	888.98	2026-03-02 18:06:19.74744
38	20	Shipping Charges\nHSN:85235100	1	33.9	0	2026-03-02 18:06:19.74744
39	21	ELBME® 70W Foldable Solar Panel_1 |\nBOF3X66SSK (ELALLBR-641223980467)\nHSN:90184900	1	1905.93	1872.03	2026-03-02 18:06:39.026815
40	24	Logo Design	5	100	500	2026-03-02 23:34:03.581485
41	24	Website Design	2	800	1600	2026-03-02 23:34:03.581485
42	24	Brand Design	3	300	900	2026-03-02 23:34:03.581485
43	24	Banner Design	2	300	600	2026-03-02 23:34:03.581485
44	24	Flyer Design	2	400	800	2026-03-02 23:34:03.581485
45	24	Social Media Template	10	50	500	2026-03-02 23:34:03.581485
46	24	Name Card	15	25	750	2026-03-02 23:34:03.581485
47	24	Web Developer	2	1000	2000	2026-03-02 23:34:03.581485
48	25	Converse All Star	1	54.44	49	2026-03-02 23:34:28.322754
49	25	Ray-Ban Wayfarer	1	159	149	2026-03-02 23:34:28.322754
50	39	PLA PRO+ Black 1 Kg	2	593.22	1186.44	2026-03-02 23:50:27.581783
51	40	THERMISTOR\n(Neptune 4 Max)	1	380.51	449	2026-03-02 23:55:22.926593
57	42	AMD Athlon X2DC-7450,\n2.4GHz/1GB/160GB/SMP-DVD/VB	6	580	3480	2026-03-03 08:03:53.673159
58	42	PDC-E5300 - 2.6GHz/1GB/320GB/SMP-DVD/FDD/VB	4	645	2580	2026-03-03 08:03:53.673159
59	42	LG 18.5" WLCD	10	230	2300	2026-03-03 08:03:53.673159
60	42	HP LaserJet 5200	1	1103	1103	2026-03-03 08:03:53.673159
61	43	12MM**	7	500	3500	2026-03-03 08:20:36.384
62	44	Tax Audit Under I.T. Act	0	0	50000	2026-03-03 09:42:01.389383
63	44	Review & Consolidation of Branch Acoounts	0	0	10000	2026-03-03 09:42:01.389383
64	44	Filling Of Income Tax Return Of The Firm	0	0	10000	2026-03-03 09:42:01.389383
65	45	Item name and description goes here	3	25	75	2026-03-03 17:50:12.320136
66	45	Item name and description goes here	1	25	25	2026-03-03 17:50:12.320136
67	45	Item name and description goes here	2	25	50	2026-03-03 17:50:12.320136
68	45	Item name and description goes here	3	33	99	2026-03-03 17:50:12.320136
69	45	Item name and description goes here	1	33	33	2026-03-03 17:50:12.320136
70	46	Your item Name\nItem description goes here	1	1000	1000	2026-03-03 18:01:19.331808
71	46	Your item Name\nItem description goes here	1	1000	1000	2026-03-03 18:01:19.331808
72	46	Your item Name\nItem description goes here	1	1000	1000	2026-03-03 18:01:19.331808
73	46	Your item Name\nItem description goes here	1	1000	1000	2026-03-03 18:01:19.331808
74	47	Product Name Here	2	100	200	2026-03-03 18:01:49.87697
75	47	Product Name Here	3	150	450	2026-03-03 18:01:49.87697
76	47	Product Name Here	1	120	120	2026-03-03 18:01:49.87697
77	47	Product Name Here	3	150	450	2026-03-03 18:01:49.87697
78	47	Product Name Here	2	100	200	2026-03-03 18:01:49.87697
79	47	Product Name Here	3	120	360	2026-03-03 18:01:49.87697
80	47	Product Name Here	1	100	100	2026-03-03 18:01:49.87697
81	47	Product Name Here	2	150	300	2026-03-03 18:01:49.87697
82	48	Prototype\nPrototype-based programming is a style\nof object-oriented programming	2000	20230450	20230450	2026-03-03 18:02:18.183044
83	48	Design	2000	20230450	20230450	2026-03-03 18:02:18.183044
84	49	Barbell Rack DM-419	10	638	7018	2026-03-03 18:18:19.591997
85	49	Junge Stack DM-075	20	2150	47300	2026-03-03 18:18:19.591997
86	49	Treadmill DM-424	5	3279	18034.5	2026-03-03 18:18:19.591997
87	49	Set Up Bench DM-020	10	1349	14839	2026-03-03 18:18:19.591997
88	50	Bosch All-in-One Metal Hand Tool Kit	1	2535	2535	2026-03-03 18:18:45.701606
89	50	Taparia Universal Tool Kit	1	1270	1270	2026-03-03 18:18:45.701606
90	51	PRODUCT DESCRIPTION MODEL A-123	1	1000	950	2026-03-03 18:19:36.301911
91	51	PRODUCT DESCRIPTION MODEL A-123	1	1000	970	2026-03-03 18:19:36.301911
92	51	PRODUCT DESCRIPTION MODEL A-123	1	1000	990	2026-03-03 18:19:36.301911
93	51	PRODUCT DESCRIPTION MODEL A-123	1	11.12	11.02	2026-03-03 18:19:36.301911
94	52	Creative Curvy Modern Style Eames Chair (Grey)	1	85	85	2026-03-03 18:20:02.516649
95	52	Creative Curvy Modern Style Eames Chair (White)	1	85	85	2026-03-03 18:20:02.516649
96	52	Creative Curvy Modern Style Eames Chair (Black)	1	85	85	2026-03-03 18:20:02.516649
97	53	ABC English Translator Software	1	700500	700500	2026-03-03 18:20:32.161082
98	53	WPP Office Suite 360	1	225500	225500	2026-03-03 18:20:32.161082
99	54	Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, sed do\neiusmod tempor incididunt ut\nlabore et dolore magna aliqua. Ut\nenim ad minim veniam, quis\nnostrud exercitation ullamco\nlaboris nisi ut aliquip ex ea\ncommodo consequat.	3	1500	4500	2026-03-03 22:58:40.961897
100	55	Brochure Design\nBrochure design - Single sided (Color)	1	900	900	2026-03-03 22:59:06.364513
101	55	Web Design packages (Simple)\n10 Pages, Slider, Free Logo, Dynamic Website, Free Domain, Hosting Free\nfor 1st year,	1	10000	10000	2026-03-03 22:59:06.364513
102	55	Print Ad - Newspaper\nA full-page ad, Nationwide Circulation (Colour)	1	7500	7500	2026-03-03 22:59:06.364513
103	56	Job Phase: Excavation\nExcavation	0	0	630	2026-03-03 23:34:11.352315
104	56	Job Phase: Foundation\nKit Foundation	0	0	1800	2026-03-03 23:34:11.352315
105	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
106	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
107	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
108	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
109	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
110	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
111	57	Taurus	1	10	10	2026-03-04 15:02:01.892523
112	58	Your Products	2	1000	2000	2026-03-04 15:02:18.799536
113	58	Discount	1	-500	-500	2026-03-04 15:02:18.799536
124	41	Lemon Yellow PLA+ Numakers	4	600	2400	2026-03-04 17:52:21.782845
125	41	Jamghe TZ PLA +Filament 1.75 mm\nRed	4	618.64	2474.56	2026-03-04 17:52:21.782845
126	41	Pure White PLA+ Numakers	2	625	1250	2026-03-04 17:52:21.782845
127	41	Pitch Black PLA+ Numakers	3	625	1875	2026-03-04 17:52:21.782845
128	41	Bambu Lab Hotend Cooling Fan	1	1101.69	1101.69	2026-03-04 17:52:21.782845
129	12	Tapo C220 Pan/Tilt Smart AI 2K 4MP QHD 1440p Home Security Wi-Fi Camera Alexa & Google Assistant Enabled |Night Vision Two-Way Audio Motion Detection | BOCDCL6FLC ( WB-9POF-HG7D)	1	1999.15	1999.15	2026-03-04 17:59:49.383567
130	59	GP SHS 50'50 APOLLO IS	70	1006.53	76057.1	2026-03-04 18:12:37.506052
131	60	Website Development Services	1	1500	1500	2026-03-04 18:23:40.11068
132	60	Monthly Maintenance	3	200	600	2026-03-04 18:23:40.11068
133	60	Domain Registration	1	25	25	2026-03-04 18:23:40.11068
134	61	T-Shirt 32"	10	1000	10000	2026-03-04 18:33:42.226622
135	61	T-Shirt 34	10	200	2000	2026-03-04 18:33:42.226622
136	61	T-Shirt 36	20	500	10000	2026-03-04 18:33:42.226622
137	62	Website Design & Development	1	1500	1500	2026-03-04 18:51:56.676884
138	62	SEO Optimization	1	600	600	2026-03-04 18:51:56.676884
139	62	Content Writing	10	50	500	2026-03-04 18:51:56.676884
140	62	Social Media Management	1	400	400	2026-03-04 18:51:56.676884
141	62	Monthly Hosting Fee	1	100	100	2026-03-04 18:51:56.676884
142	63	Website Design & Development	1	1500	1500	2026-03-04 18:52:26.452486
143	63	SEO Optimization	1	600	600	2026-03-04 18:52:26.452486
144	63	Content Writing	10	50	500	2026-03-04 18:52:26.452486
145	63	Social Media Management	1	400	400	2026-03-04 18:52:26.452486
146	63	Monthly Hosting Fee	1	100	100	2026-03-04 18:52:26.452486
147	64	Bepanthen\nBatch : 503\nMfg.Date: 08-05-2019\nExp.Date: 11-06-2024\nManufacturer: Groove Pharamaceuticals	10	120	1200	2026-03-05 17:35:02.419805
148	65	SAMSUNG Galaxy M02s + 64 GB + 4GB RAM\nColor: White	1	8297	8297	2026-03-05 17:38:30.393236
149	66	Website Development	1	18000	18000	2026-03-05 18:08:39.21572
150	66	UI/UX Design	1	6000	6000	2026-03-05 18:08:39.21572
151	66	Testing and Deployment	1	4000	4000	2026-03-05 18:08:39.21572
152	67	Pearl Pink\nPearl Pink Jewellery.	10	360	3050.85	2026-03-05 18:18:32.934429
153	67	Pearl Green\nPearl Green Jewellery.	10	350	2966.1	2026-03-05 18:18:32.934429
154	68	Shampoo	10000	10	100000	2026-03-05 18:50:28.529541
155	68	Soap	5000	5	25000	2026-03-05 18:50:28.529541
156	69	Mobile App Development	1	22000	22000	2026-03-05 18:51:00.267627
157	69	Database Setup	1	7000	6000	2026-03-05 18:51:00.267627
158	69	Technical Support	1	3000	3000	2026-03-05 18:51:00.267627
159	70	Mobile App Development	0	0	22000	2026-03-05 20:06:06.071092
160	70	Database Setup	0	0	7000	2026-03-05 20:06:06.071092
161	70	Technical Support	0	0	3000	2026-03-05 20:06:06.071092
162	71	Software Installation	1	7000	7000	2026-03-07 18:26:41.577354
163	71	Database Configuration	1	5000	5000	2026-03-07 18:26:41.577354
164	71	Technical Training	1	6000	6000	2026-03-07 18:26:41.577354
165	72	Wireless Access Points	25	1200	30000	2026-03-07 18:28:04.528991
166	73	Orange Powder	1	400	448	2026-03-10 17:37:00.059327
167	73	Walnuts 5% Tax Item	1	100	105	2026-03-10 17:37:00.059327
168	73	Coin 3% Tax Item	1	100	103	2026-03-10 17:37:00.059327
169	73	Rose Water	1	150	150	2026-03-10 17:37:00.059327
170	73	Glicerene	1	50	50	2026-03-10 17:37:00.059327
171	73	Cheese 12% Tax Item	1	100	112	2026-03-10 17:37:00.059327
172	74	Software Installation	1	10000	10000	2026-03-10 17:52:05.428011
173	74	Database Configuration	1	6000	6000	2026-03-10 17:52:05.428011
174	74	System Maintenance	1	4000	4000	2026-03-10 17:52:05.428011
175	75	System Analysis	0	0	10000	2026-03-10 17:52:28.524854
176	75	Software Development	0	0	15000	2026-03-10 17:52:28.524854
177	75	Testing	0	0	5000	2026-03-10 17:52:28.524854
178	76	Database Design	1	9000	9000	2026-03-10 18:35:06.514056
179	76	System Setup	1	8000	8000	2026-03-10 18:35:06.514056
180	76	Maintenance	1	4000	4000	2026-03-10 18:35:06.514056
181	77	Cloud Services Setup	1	12000	12000	2026-03-10 18:35:48.145876
182	77	Software Installation	1	6000	6000	2026-03-10 18:35:48.145876
183	77	Technical Training	1	4000	4000	2026-03-10 18:35:48.145876
184	78	E-commerce Website Development	0	0	25000	2026-03-10 18:36:29.627422
185	78	Payment Gateway Integration	0	0	10000	2026-03-10 18:36:29.627422
186	78	Support & Maintenance	0	0	5000	2026-03-10 18:36:29.627422
\.


--
-- Data for Name: system_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_logs (id, username, action, details, ip_address, created_at) FROM stdin;
1	reviewer	accept_invoice	Accepted invoice 074292	127.0.0.1	2026-02-27 20:45:44.070244
2	reviewer	accept_invoice	Accepted invoice NM/SP/2526/3708	127.0.0.1	2026-02-27 21:38:38.239895
3	reviewer	reject_invoice	Rejected invoice IN-387	127.0.0.1	2026-02-27 21:40:01.274967
4	reviewer	update_invoice	Updated invoice 	127.0.0.1	2026-03-03 09:43:06.286665
5	reviewer	accept_invoice	Accepted invoice NM/SP/2526/3703	127.0.0.1	2026-03-03 18:26:07.868885
6	reviewer	update_invoice	Updated invoice INV1000	127.0.0.1	2026-03-03 18:45:44.893137
7	reviewer	update_invoice	Updated invoice INV1000	127.0.0.1	2026-03-03 18:45:58.299543
8	reviewer	update_invoice	Updated invoice 1521	127.0.0.1	2026-03-03 18:46:27.487641
9	reviewer	accept_invoice	Accepted invoice 1521	127.0.0.1	2026-03-03 18:46:33.626027
10	reviewer	update_invoice	Updated invoice INV1000	127.0.0.1	2026-03-03 23:29:54.237858
11	reviewer	accept_invoice	Accepted invoice INV1000	127.0.0.1	2026-03-03 23:30:01.617285
12	reviewer	accept_invoice	Accepted invoice ABCR	127.0.0.1	2026-03-03 23:36:02.75984
13	reviewer	accept_invoice	Accepted invoice SHB/456/20	127.0.0.1	2026-03-04 14:58:47.129326
14	reviewer	accept_invoice	Accepted invoice 000000	127.0.0.1	2026-03-04 15:04:15.993514
15	Elaya	accept_invoice	Accepted invoice IV-00100	127.0.0.1	2026-03-04 15:48:42.43777
16	jai alwin	reject_invoice	Rejected invoice 0498/2025-26	127.0.0.1	2026-03-04 18:59:23.43592
17	jai alwin	reject_invoice	Rejected invoice 25-26/130	127.0.0.1	2026-03-04 18:59:28.549382
18	Sakthi	update_invoice	Updated invoice INV-2050-001	127.0.0.1	2026-03-10 17:33:53.633598
19	Sakthi	accept_invoice	Accepted invoice INV-2050-001	127.0.0.1	2026-03-10 17:34:00.573547
20	elaya	update_invoice	Updated invoice 020	127.0.0.1	2026-03-10 18:40:49.084073
21	elaya	accept_invoice	Accepted invoice 020	127.0.0.1	2026-03-10 18:40:53.623179
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password, role, is_active, created_at) FROM stdin;
3	admin	admin@invoicehub.com	$2b$12$we2h3MUk6YZjwfKei2pE6OflBv3Qe1Pc.WxQIx1RV7Tp0qnuTPu0e	admin	t	2026-02-27 13:20:03.754371
4	reviewer	reviewer@invoicehub.com	$2b$12$n9psQ/pciZGEEI2XVT.8n.ByLgnFLfeSHW9tnz8IpIEshwuaFuaFy	reviewer	t	2026-02-27 13:20:03.754402
6	sanjeev	sk338567@gmail.com	$2b$12$ugResgVO/ACuKAyPbiiYcOUs2UQHpEEawhpLbv3lrwawd76AE5FcG	reviewer	t	2026-03-03 23:14:59.185488
10	Sakthi	sakthi123@gmail.com	$2b$12$p0x/bC1wp6LQdN1Vw5GWQOa7k6F9EOH9CucPKPt4cYxi399KQFuOK	reviewer	t	2026-03-04 17:21:28.015701
11	jai alwin	jaialwin123@gmail.com	$2b$12$482JLkKEfEzzYZ8.seKLnOt8k9kIpOkRGguXkFEdzSGpgOLy0sRay	reviewer	t	2026-03-04 18:57:04.383549
12	elaya	elayaraji13502@gmail.com	$2b$12$wnABH.QaBOQkourlrORY2.3UrdrX1iAh9K/xi.4kL7griKc.nfjAO	reviewer	t	2026-03-10 18:38:10.211297
\.


--
-- Name: api_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.api_keys_id_seq', 1, false);


--
-- Name: email_ingestion_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_ingestion_logs_id_seq', 127, true);


--
-- Name: invoice_audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_audit_logs_id_seq', 15, true);


--
-- Name: invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_id_seq', 3, true);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoices_id_seq', 78, true);


--
-- Name: line_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.line_items_id_seq', 186, true);


--
-- Name: system_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_logs_id_seq', 21, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 12, true);


--
-- Name: api_keys api_keys_key_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_key_hash_key UNIQUE (key_hash);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: email_ingestion_logs email_ingestion_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_ingestion_logs
    ADD CONSTRAINT email_ingestion_logs_pkey PRIMARY KEY (id);


--
-- Name: invoice_audit_logs invoice_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_audit_logs
    ADD CONSTRAINT invoice_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: line_items line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_items
    ADD CONSTRAINT line_items_pkey PRIMARY KEY (id);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: ix_email_ingestion_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_email_ingestion_logs_id ON public.email_ingestion_logs USING btree (id);


--
-- Name: ix_invoice_audit_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoice_audit_logs_id ON public.invoice_audit_logs USING btree (id);


--
-- Name: ix_invoices_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_invoices_id ON public.invoices USING btree (id);


--
-- Name: ix_invoices_invoice_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_invoices_invoice_number ON public.invoices USING btree (invoice_number);


--
-- Name: ix_line_items_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_line_items_id ON public.line_items USING btree (id);


--
-- Name: ix_system_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_system_logs_action ON public.system_logs USING btree (action);


--
-- Name: ix_system_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_system_logs_id ON public.system_logs USING btree (id);


--
-- Name: ix_system_logs_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_system_logs_username ON public.system_logs USING btree (username);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_username ON public.users USING btree (username);


--
-- Name: email_ingestion_logs email_ingestion_logs_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_ingestion_logs
    ADD CONSTRAINT email_ingestion_logs_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoice_audit_logs invoice_audit_logs_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_audit_logs
    ADD CONSTRAINT invoice_audit_logs_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoice_audit_logs invoice_audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_audit_logs
    ADD CONSTRAINT invoice_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: line_items line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.line_items
    ADD CONSTRAINT line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- PostgreSQL database dump complete
--

\unrestrict pI1cI5Z7Z5bOezRCuACxdr52bcxnZa0ka8AWwSzhQ0Wymotjp2xy1DmbSfAtRn2

