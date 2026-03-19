--
-- PostgreSQL database dump
--

\restrict YeKk7tJm5q1aMmigbeLkdMYnEPpmOBuTRGFTDT1OdFycxrY18ddB1Cg3iQKWuPc

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    email character varying(150) NOT NULL,
    senha character varying(255) NOT NULL,
    nome character varying(100)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: itens_pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itens_pedido (
    id integer NOT NULL,
    pedido_id integer,
    produto_id integer,
    quantidade integer NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


ALTER TABLE public.itens_pedido OWNER TO postgres;

--
-- Name: itens_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.itens_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.itens_pedido_id_seq OWNER TO postgres;

--
-- Name: itens_pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.itens_pedido_id_seq OWNED BY public.itens_pedido.id;


--
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    id integer NOT NULL,
    data_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'pendente'::character varying,
    total numeric(10,2) DEFAULT 0,
    nome_cliente character varying(100) NOT NULL,
    telefone character varying(20),
    forma_pagamento character varying(50) NOT NULL
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- Name: pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedidos_id_seq OWNER TO postgres;

--
-- Name: pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_id_seq OWNED BY public.pedidos.id;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao text,
    preco numeric(10,2) NOT NULL,
    categoria character varying(50),
    imagem text
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produtos_id_seq OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: itens_pedido id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itens_pedido ALTER COLUMN id SET DEFAULT nextval('public.itens_pedido_id_seq'::regclass);


--
-- Name: pedidos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN id SET DEFAULT nextval('public.pedidos_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, email, senha, nome) FROM stdin;
1	admin_cardapio@admin.com	administrador120	\N
2	admin@email.com	$2b$10$nJKjq0Ldqgnfkye3fUDP/uxFEwGLX8AjV4tvwavIA3G1m66b4UsmS	Administrador
\.


--
-- Data for Name: itens_pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itens_pedido (id, pedido_id, produto_id, quantidade, subtotal) FROM stdin;
6	7	3	1	0.99
7	8	3	1	0.99
8	9	3	1	0.99
9	10	16	2	24.00
10	11	6	1	8.00
11	12	5	2	16.00
12	12	9	2	16.00
13	13	3	2	1.98
\.


--
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (id, data_pedido, status, total, nome_cliente, telefone, forma_pagamento) FROM stdin;
5	2025-11-26 17:18:58.454867	entregue	5.99	jque	as	pix
2	2025-11-25 13:51:00.805665	entregue	5.99	Gabriel	11999999999	Pix
3	2025-11-26 17:05:49.162201	entregue	5.99	Jaqueline	16992	pix
4	2025-11-26 17:06:14.847918	entregue	29.95	jqa	q	pix
7	2025-12-01 15:06:45.068317	entregue	0.99	Jaqueline Lopes	1611111	cartao
6	2025-11-26 17:20:16.15994	entregue	5.99	jaque	123	dinheiro
9	2025-12-01 15:29:51.51463	entregue	0.99	3	o	dinheiro
11	2025-12-02 12:37:31.729385	entregue	8.00	Jaqueline	1699999999	dinheiro
13	2025-12-02 12:41:13.835216	entregue	1.98	Jaqueline	1699999999	dinheiro
12	2025-12-02 12:40:26.536612	entregue	32.00	Jaqueline 	1699999999	pix
10	2025-12-02 12:37:09.850603	entregue	24.00	Jaqueline	1699999999	pix
8	2025-12-01 15:24:55.392996	entregue	0.99	JA	Q	cartao
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, nome, descricao, preco, categoria, imagem) FROM stdin;
3	Pão de Queijo	Pão de queijo R$ 0.99 cada!	0.99	lanches	https://amopaocaseiro.com.br/wp-content/uploads/2022/08/yt-069_pao-de-queijo_receita-840x560.jpg
5	Misto Quente	Pão francês com presunto e muçarela derretida	8.00	lanches	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVGRm162IvinUtiY_l25TcXQDRzxzrHn_60A&s
6	Pão na chapa com ovo frito e manteiga	Pão na chapa com ovo frito e manteiga	8.00	lanches	https://padariasantacruz.loji.com.br/storage/uploads/30oWmbGhB7d3xgwjaPfV6xaJ0LMKuwDXCcfzBYeS.jpeg
7	Pão na chapa com requeijão	Crocante e cremoso na medida certa	10.00	lanches	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgPwrml0VzPZhfw5_8eTssFaqwOO1UEuYRIw&s
8	Sanduíche Natural	Pão integral com frango desfiado, cenoura e alface.	12.00	lanches	https://images.mrcook.app/recipe-image/01929254-ff3f-7060-b2c0-2815197697f4?cacheKey=U3VuLCAxMiBKYW4gMjAyNSAwMzozODoyNCBHTVQ=
9	Café Espresso	Clássico, encorpado, extraído de grãos selecionados.	8.00	bebidas	https://img.freepik.com/fotos-premium/xicara-de-cafe-cheia-de-cafe-expresso-fresco_174343-1455.jpg
10	Café com leite	Expresso com leite vaporizado na medida perfeita.	8.00	bebidas	https://www.bongusto.ind.br/wp-content/uploads/2023/06/2023-06-08-foto-cafe-com-leite.jpg
11	Cappuccino tradicional	Expresso, leite vaporizado e espuma de leite, com canela.	8.00	bebidas	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRh3BPXiTd4r8ebQbes7wkjBlC5GT77mCnQ9w&s
12	Cappuccino cremoso com chocolate	Café com leite, espuma cremosa e chocolate meio amargo	8.00	bebidas	https://recipesblob.oetker.com.br/assets/ac222b7a8dc04ef6be16dab85bd728ef/750x910/27192jpg.webp
13	Latte macchiato	Leite vaporizado com um toque de expresso no topo	8.00	bebidas	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVYNnt1rYuAeeA7CQcCbzFUA7-u4AzNYoJNA&s
14	Mocha	Expresso, leite vaporizado e calda de chocolate com chantilly	8.54	bebidas	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXInvkT6S-UKGa0J3jSp8do1xQvOfMHixZPw&s
16	Affogato	Bola de sorvete sabor creme mergulhada no expresso quente.	12.00	sobremesas	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFBIWqb-H12KU0VPKQfi3mYBfsv2_fP51Xag&s
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 2, true);


--
-- Name: itens_pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.itens_pedido_id_seq', 13, true);


--
-- Name: pedidos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_id_seq', 13, true);


--
-- Name: produtos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_id_seq', 17, true);


--
-- Name: admin admin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: itens_pedido itens_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itens_pedido
    ADD CONSTRAINT itens_pedido_pkey PRIMARY KEY (id);


--
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: itens_pedido itens_pedido_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itens_pedido
    ADD CONSTRAINT itens_pedido_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(id) ON DELETE CASCADE;


--
-- Name: itens_pedido itens_pedido_produto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itens_pedido
    ADD CONSTRAINT itens_pedido_produto_id_fkey FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- PostgreSQL database dump complete
--

\unrestrict YeKk7tJm5q1aMmigbeLkdMYnEPpmOBuTRGFTDT1OdFycxrY18ddB1Cg3iQKWuPc

