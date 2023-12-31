PGDMP         *                 {            SGTestDatabase    14.9    14.9                 0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16394    SGTestDatabase    DATABASE     m   CREATE DATABASE "SGTestDatabase" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Russian_Russia.1251';
     DROP DATABASE "SGTestDatabase";
                postgres    false            �            1259    16416 
   Department    TABLE     �   CREATE TABLE public."Department" (
    "ID" integer NOT NULL,
    "ParentID" integer,
    "ManagerID" integer,
    "Name" character varying(250) NOT NULL,
    "Phone" character varying(100) NOT NULL
);
     DROP TABLE public."Department";
       public         heap    postgres    false            �            1259    16415    Department_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."Department_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public."Department_ID_seq";
       public          postgres    false    214                       0    0    Department_ID_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."Department_ID_seq" OWNED BY public."Department"."ID";
          public          postgres    false    213            �            1259    16405    Employee    TABLE       CREATE TABLE public."Employee" (
    "ID" integer NOT NULL,
    "Department" integer NOT NULL,
    "FullName" character varying(255) NOT NULL,
    "Login" character varying(100) NOT NULL,
    "Password" character varying(255) NOT NULL,
    "JobTitle" integer NOT NULL
);
    DROP TABLE public."Employee";
       public         heap    postgres    false            �            1259    16404    Employee_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."Employee_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."Employee_ID_seq";
       public          postgres    false    212                       0    0    Employee_ID_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."Employee_ID_seq" OWNED BY public."Employee"."ID";
          public          postgres    false    211            �            1259    16396    JobTitle    TABLE     j   CREATE TABLE public."JobTitle" (
    "ID" integer NOT NULL,
    "Name" character varying(250) NOT NULL
);
    DROP TABLE public."JobTitle";
       public         heap    postgres    false            �            1259    16395    JobTitle_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."JobTitle_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."JobTitle_ID_seq";
       public          postgres    false    210                       0    0    JobTitle_ID_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public."JobTitle_ID_seq" OWNED BY public."JobTitle"."ID";
          public          postgres    false    209            h           2604    16419    Department ID    DEFAULT     t   ALTER TABLE ONLY public."Department" ALTER COLUMN "ID" SET DEFAULT nextval('public."Department_ID_seq"'::regclass);
 @   ALTER TABLE public."Department" ALTER COLUMN "ID" DROP DEFAULT;
       public          postgres    false    214    213    214            g           2604    16408    Employee ID    DEFAULT     p   ALTER TABLE ONLY public."Employee" ALTER COLUMN "ID" SET DEFAULT nextval('public."Employee_ID_seq"'::regclass);
 >   ALTER TABLE public."Employee" ALTER COLUMN "ID" DROP DEFAULT;
       public          postgres    false    212    211    212            f           2604    16399    JobTitle ID    DEFAULT     p   ALTER TABLE ONLY public."JobTitle" ALTER COLUMN "ID" SET DEFAULT nextval('public."JobTitle_ID_seq"'::regclass);
 >   ALTER TABLE public."JobTitle" ALTER COLUMN "ID" DROP DEFAULT;
       public          postgres    false    210    209    210            	          0    16416 
   Department 
   TABLE DATA           V   COPY public."Department" ("ID", "ParentID", "ManagerID", "Name", "Phone") FROM stdin;
    public          postgres    false    214   �$                 0    16405    Employee 
   TABLE DATA           e   COPY public."Employee" ("ID", "Department", "FullName", "Login", "Password", "JobTitle") FROM stdin;
    public          postgres    false    212   �$                 0    16396    JobTitle 
   TABLE DATA           2   COPY public."JobTitle" ("ID", "Name") FROM stdin;
    public          postgres    false    210   %                  0    0    Department_ID_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Department_ID_seq"', 5, true);
          public          postgres    false    213                       0    0    Employee_ID_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."Employee_ID_seq"', 19, true);
          public          postgres    false    211                       0    0    JobTitle_ID_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."JobTitle_ID_seq"', 12, true);
          public          postgres    false    209            r           2606    16421    Department Department_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "Department_pkey" PRIMARY KEY ("ID");
 H   ALTER TABLE ONLY public."Department" DROP CONSTRAINT "Department_pkey";
       public            postgres    false    214            n           2606    16412    Employee Employee_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT "Employee_pkey" PRIMARY KEY ("ID");
 D   ALTER TABLE ONLY public."Employee" DROP CONSTRAINT "Employee_pkey";
       public            postgres    false    212            j           2606    16401    JobTitle JobTitle_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."JobTitle"
    ADD CONSTRAINT "JobTitle_pkey" PRIMARY KEY ("ID");
 D   ALTER TABLE ONLY public."JobTitle" DROP CONSTRAINT "JobTitle_pkey";
       public            postgres    false    210            t           2606    16435 *   Department department_name_parentid_unique 
   CONSTRAINT     u   ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT department_name_parentid_unique UNIQUE ("Name", "ParentID");
 V   ALTER TABLE ONLY public."Department" DROP CONSTRAINT department_name_parentid_unique;
       public            postgres    false    214    214            p           2606    16414 !   Employee employee_fullname_unique 
   CONSTRAINT     d   ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT employee_fullname_unique UNIQUE ("FullName");
 M   ALTER TABLE ONLY public."Employee" DROP CONSTRAINT employee_fullname_unique;
       public            postgres    false    212            l           2606    16403    JobTitle jobtitle_name_unique 
   CONSTRAINT     \   ALTER TABLE ONLY public."JobTitle"
    ADD CONSTRAINT jobtitle_name_unique UNIQUE ("Name");
 I   ALTER TABLE ONLY public."JobTitle" DROP CONSTRAINT jobtitle_name_unique;
       public            postgres    false    210            u           2606    16424    Employee department_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT department_fkey FOREIGN KEY ("Department") REFERENCES public."Department"("ID") NOT VALID;
 D   ALTER TABLE ONLY public."Employee" DROP CONSTRAINT department_fkey;
       public          postgres    false    214    212    3186            v           2606    16436    Employee jobtitle    FK CONSTRAINT     �   ALTER TABLE ONLY public."Employee"
    ADD CONSTRAINT jobtitle FOREIGN KEY ("JobTitle") REFERENCES public."JobTitle"("ID") NOT VALID;
 =   ALTER TABLE ONLY public."Employee" DROP CONSTRAINT jobtitle;
       public          postgres    false    210    212    3178            w           2606    16429    Department manager_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT manager_fkey FOREIGN KEY ("ManagerID") REFERENCES public."Employee"("ID") NOT VALID;
 C   ALTER TABLE ONLY public."Department" DROP CONSTRAINT manager_fkey;
       public          postgres    false    212    3182    214            x           2606    16441    Department parentId_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Department"
    ADD CONSTRAINT "parentId_fkey" FOREIGN KEY ("ParentID") REFERENCES public."Department"("ID") NOT VALID;
 F   ALTER TABLE ONLY public."Department" DROP CONSTRAINT "parentId_fkey";
       public          postgres    false    214    3186    214            	      x������ � �            x������ � �            x������ � �     