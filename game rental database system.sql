PGDMP         )                |            game rental database system    15.6    15.6 o    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16559    game rental database system    DATABASE     �   CREATE DATABASE "game rental database system" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Turkish_T�rkiye.1254';
 -   DROP DATABASE "game rental database system";
                postgres    false            �            1255    16738    kira()    FUNCTION     �  CREATE FUNCTION public.kira() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

insert into ödeme_yöntemi (tutar, tarih, kredi_kartı_ödeme_id)
 values ((select ücret from oyun where oyun_id_numarası = new.oyun_id_numarası), now(), default);

insert into kiralama_geçmişi (müşteri_id_numarası,oyun_id_numarası,kiralandığı_tarih) values((select müşteri_id_numarası from kiralama where oyun_id_numarası=new.oyun_id_numarası),new.oyun_id_numarası,(select kiralama_tarihi from kiralama where oyun_id_numarası=new.oyun_id_numarası));

delete from kiralama where oyun_id_numarası=new.oyun_id_numarası;

return new;
end;
$$;
    DROP FUNCTION public.kira();
       public          postgres    false            �            1259    16591 
   çalışan    TABLE     �   CREATE TABLE public."çalışan" (
    "çalışan_id" integer NOT NULL,
    ad character varying(30) NOT NULL,
    soyad character varying(30) NOT NULL
);
     DROP TABLE public."çalışan";
       public         heap    postgres    false            �            1259    16602    asistan    TABLE     �   CREATE TABLE public.asistan (
    "asistan_maaş" character varying(10) NOT NULL,
    "asistan_görev" character varying(30) NOT NULL
)
INHERITS (public."çalışan");
    DROP TABLE public.asistan;
       public         heap    postgres    false    223            �            1259    16606    eleman    TABLE     �   CREATE TABLE public.eleman (
    "eleman_maaş" character varying(10) NOT NULL,
    "eleman_görev" character varying(30) NOT NULL
)
INHERITS (public."çalışan");
    DROP TABLE public.eleman;
       public         heap    postgres    false    223            �            1259    16618    havale_ödeme    TABLE     �   CREATE TABLE public."havale_ödeme" (
    "havale_id_numarası" integer NOT NULL,
    banka_adi character varying(50),
    "ücret" numeric(10,2)
);
 #   DROP TABLE public."havale_ödeme";
       public         heap    postgres    false            �            1259    16617 %   havale_ödeme_havale_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."havale_ödeme_havale_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public."havale_ödeme_havale_id_numarası_seq";
       public          postgres    false    230            �           0    0 %   havale_ödeme_havale_id_numarası_seq    SEQUENCE OWNED BY     u   ALTER SEQUENCE public."havale_ödeme_havale_id_numarası_seq" OWNED BY public."havale_ödeme"."havale_id_numarası";
          public          postgres    false    229            �            1259    16577    kategori    TABLE     z   CREATE TABLE public.kategori (
    "kategori_id_numarası" integer NOT NULL,
    "tür" character varying(20) NOT NULL
);
    DROP TABLE public.kategori;
       public         heap    postgres    false            �            1259    16576 "   kategori_kategori_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."kategori_kategori_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public."kategori_kategori_id_numarası_seq";
       public          postgres    false    219            �           0    0 "   kategori_kategori_id_numarası_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."kategori_kategori_id_numarası_seq" OWNED BY public.kategori."kategori_id_numarası";
          public          postgres    false    218            �            1259    16648    kiralama    TABLE     �   CREATE TABLE public.kiralama (
    "kiralama_id_numarası" integer NOT NULL,
    "müşteri_id_numarası" integer,
    "oyun_id_numarası" integer,
    kiralama_tarihi timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.kiralama;
       public         heap    postgres    false            �            1259    16561 	   müşteri    TABLE     �  CREATE TABLE public."müşteri" (
    "müşteri_id_numarası" integer NOT NULL,
    ad character varying(50) NOT NULL,
    soyad character varying(50) NOT NULL,
    "telefon_numarası" character varying(11),
    mail_adresi character varying(100) NOT NULL,
    il character varying(50) NOT NULL,
    "ilçe" character varying(50) NOT NULL,
    mahalle character varying(50) NOT NULL,
    daire_no character varying(10) NOT NULL
);
    DROP TABLE public."müşteri";
       public         heap    postgres    false            �            1259    16703    müşteri_kategori    TABLE     �   CREATE TABLE public."müşteri_kategori" (
    "id_numarası" integer NOT NULL,
    "müşteri_id_numarası" integer,
    "kategori_id_numarası" integer,
    "tür" character varying(30)
);
 (   DROP TABLE public."müşteri_kategori";
       public         heap    postgres    false            �            1259    16676    oyun_kategori    TABLE     �   CREATE TABLE public.oyun_kategori (
    "id_numarası" integer NOT NULL,
    "oyun_id_numarası" integer,
    "kategori_id_numarası" integer,
    "oyun_adı" character varying(30),
    "tür" character varying(30)
);
 !   DROP TABLE public.oyun_kategori;
       public         heap    postgres    false            �            1259    16729    kiralama_detay_view    VIEW     �  CREATE VIEW public.kiralama_detay_view AS
 SELECT kiralama."kiralama_id_numarası",
    "müşteri"."müşteri_id_numarası" AS "müşteri_id",
    "müşteri".ad,
    "müşteri".soyad,
    kiralama."oyun_id_numarası",
    oyun_kategori."kategori_id_numarası",
    kategori."tür"
   FROM ((((public.kiralama
     JOIN public."müşteri" ON ((kiralama."müşteri_id_numarası" = "müşteri"."müşteri_id_numarası")))
     JOIN public.oyun_kategori ON ((kiralama."oyun_id_numarası" = oyun_kategori."oyun_id_numarası")))
     JOIN public."müşteri_kategori" ON (("müşteri"."müşteri_id_numarası" = "müşteri_kategori"."müşteri_id_numarası")))
     JOIN public.kategori ON ((oyun_kategori."kategori_id_numarası" = kategori."kategori_id_numarası")));
 &   DROP VIEW public.kiralama_detay_view;
       public          postgres    false    234    215    215    238    236    215    219    219    234    236    234            �            1259    16734    kiralama_geçmişi    TABLE     �   CREATE TABLE public."kiralama_geçmişi" (
    "müşteri_id_numarası" integer,
    "oyun_id_numarası" integer,
    "kiralandığı_tarih" timestamp without time zone DEFAULT CURRENT_DATE
);
 (   DROP TABLE public."kiralama_geçmişi";
       public         heap    postgres    false            �            1259    16647 "   kiralama_kiralama_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."kiralama_kiralama_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ;   DROP SEQUENCE public."kiralama_kiralama_id_numarası_seq";
       public          postgres    false    234            �           0    0 "   kiralama_kiralama_id_numarası_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public."kiralama_kiralama_id_numarası_seq" OWNED BY public.kiralama."kiralama_id_numarası";
          public          postgres    false    233            �            1259    16611    kredi_kartı_ödeme    TABLE       CREATE TABLE public."kredi_kartı_ödeme" (
    "kredi_kartı_ödeme_id" integer NOT NULL,
    "kart_adı" character varying(30),
    "kart_soyadı" character varying(30),
    kart_numarasi character varying(16),
    son_kullanma_tarihi character varying(5),
    cvc integer
);
 )   DROP TABLE public."kredi_kartı_ödeme";
       public         heap    postgres    false            �            1259    16610 .   kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq    SEQUENCE     �   CREATE SEQUENCE public."kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 G   DROP SEQUENCE public."kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq";
       public          postgres    false    228            �           0    0 .   kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq    SEQUENCE OWNED BY     �   ALTER SEQUENCE public."kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq" OWNED BY public."kredi_kartı_ödeme"."kredi_kartı_ödeme_id";
          public          postgres    false    227            �            1259    16702 #   müşteri_kategori_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."müşteri_kategori_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."müşteri_kategori_id_numarası_seq";
       public          postgres    false    238            �           0    0 #   müşteri_kategori_id_numarası_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."müşteri_kategori_id_numarası_seq" OWNED BY public."müşteri_kategori"."id_numarası";
          public          postgres    false    237            �            1259    16560 $   müşteri_müşteri_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."müşteri_müşteri_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."müşteri_müşteri_id_numarası_seq";
       public          postgres    false    215            �           0    0 $   müşteri_müşteri_id_numarası_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public."müşteri_müşteri_id_numarası_seq" OWNED BY public."müşteri"."müşteri_id_numarası";
          public          postgres    false    214            �            1259    16570    oyun    TABLE     �   CREATE TABLE public.oyun (
    "oyun_id_numarası" integer NOT NULL,
    "oyun_adı" character varying(30) NOT NULL,
    "çıkış_yılı" character varying(30) NOT NULL,
    "ücret" integer NOT NULL
);
    DROP TABLE public.oyun;
       public         heap    postgres    false            �            1259    16675    oyun_kategori_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."oyun_kategori_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE public."oyun_kategori_id_numarası_seq";
       public          postgres    false    236            �           0    0    oyun_kategori_id_numarası_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."oyun_kategori_id_numarası_seq" OWNED BY public.oyun_kategori."id_numarası";
          public          postgres    false    235            �            1259    16569    oyun_oyun_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."oyun_oyun_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."oyun_oyun_id_numarası_seq";
       public          postgres    false    217            �           0    0    oyun_oyun_id_numarası_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."oyun_oyun_id_numarası_seq" OWNED BY public.oyun."oyun_id_numarası";
          public          postgres    false    216            �            1259    16584    takip_sistemi    TABLE     �   CREATE TABLE public.takip_sistemi (
    "takip_id_numarası" integer NOT NULL,
    kalan_sure character varying(20) NOT NULL
);
 !   DROP TABLE public.takip_sistemi;
       public         heap    postgres    false            �            1259    16583 $   takip_sistemi_takip_id_numarası_seq    SEQUENCE     �   CREATE SEQUENCE public."takip_sistemi_takip_id_numarası_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public."takip_sistemi_takip_id_numarası_seq";
       public          postgres    false    221            �           0    0 $   takip_sistemi_takip_id_numarası_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."takip_sistemi_takip_id_numarası_seq" OWNED BY public.takip_sistemi."takip_id_numarası";
          public          postgres    false    220            �            1259    16598 	   yönetici    TABLE     �   CREATE TABLE public."yönetici" (
    "yönetici_maaş" character varying(10) NOT NULL,
    "yönetici_görev" character varying(30) NOT NULL
)
INHERITS (public."çalışan");
    DROP TABLE public."yönetici";
       public         heap    postgres    false    223            �            1259    16590    çalışan_çalışan_id_seq    SEQUENCE     �   CREATE SEQUENCE public."çalışan_çalışan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."çalışan_çalışan_id_seq";
       public          postgres    false    223            �           0    0    çalışan_çalışan_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."çalışan_çalışan_id_seq" OWNED BY public."çalışan"."çalışan_id";
          public          postgres    false    222            �            1259    16625    ödeme_yöntemi    TABLE     �   CREATE TABLE public."ödeme_yöntemi" (
    "ödeme_id" integer NOT NULL,
    tutar numeric(10,2),
    tarih timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "kredi_kartı_ödeme_id" integer,
    havale_id integer
);
 %   DROP TABLE public."ödeme_yöntemi";
       public         heap    postgres    false            �            1259    16624    ödeme_yöntemi_ödeme_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ödeme_yöntemi_ödeme_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."ödeme_yöntemi_ödeme_id_seq";
       public          postgres    false    232            �           0    0    ödeme_yöntemi_ödeme_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE public."ödeme_yöntemi_ödeme_id_seq" OWNED BY public."ödeme_yöntemi"."ödeme_id";
          public          postgres    false    231            �           2604    16605    asistan çalışan_id    DEFAULT     �   ALTER TABLE ONLY public.asistan ALTER COLUMN "çalışan_id" SET DEFAULT nextval('public."çalışan_çalışan_id_seq"'::regclass);
 F   ALTER TABLE public.asistan ALTER COLUMN "çalışan_id" DROP DEFAULT;
       public          postgres    false    222    225            �           2604    16609    eleman çalışan_id    DEFAULT     �   ALTER TABLE ONLY public.eleman ALTER COLUMN "çalışan_id" SET DEFAULT nextval('public."çalışan_çalışan_id_seq"'::regclass);
 E   ALTER TABLE public.eleman ALTER COLUMN "çalışan_id" DROP DEFAULT;
       public          postgres    false    222    226            �           2604    16621 !   havale_ödeme havale_id_numarası    DEFAULT     �   ALTER TABLE ONLY public."havale_ödeme" ALTER COLUMN "havale_id_numarası" SET DEFAULT nextval('public."havale_ödeme_havale_id_numarası_seq"'::regclass);
 T   ALTER TABLE public."havale_ödeme" ALTER COLUMN "havale_id_numarası" DROP DEFAULT;
       public          postgres    false    230    229    230            �           2604    16580    kategori kategori_id_numarası    DEFAULT     �   ALTER TABLE ONLY public.kategori ALTER COLUMN "kategori_id_numarası" SET DEFAULT nextval('public."kategori_kategori_id_numarası_seq"'::regclass);
 O   ALTER TABLE public.kategori ALTER COLUMN "kategori_id_numarası" DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    16651    kiralama kiralama_id_numarası    DEFAULT     �   ALTER TABLE ONLY public.kiralama ALTER COLUMN "kiralama_id_numarası" SET DEFAULT nextval('public."kiralama_kiralama_id_numarası_seq"'::regclass);
 O   ALTER TABLE public.kiralama ALTER COLUMN "kiralama_id_numarası" DROP DEFAULT;
       public          postgres    false    233    234    234            �           2604    16614 *   kredi_kartı_ödeme kredi_kartı_ödeme_id    DEFAULT     �   ALTER TABLE ONLY public."kredi_kartı_ödeme" ALTER COLUMN "kredi_kartı_ödeme_id" SET DEFAULT nextval('public."kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq"'::regclass);
 ]   ALTER TABLE public."kredi_kartı_ödeme" ALTER COLUMN "kredi_kartı_ödeme_id" DROP DEFAULT;
       public          postgres    false    227    228    228            �           2604    16564     müşteri müşteri_id_numarası    DEFAULT     �   ALTER TABLE ONLY public."müşteri" ALTER COLUMN "müşteri_id_numarası" SET DEFAULT nextval('public."müşteri_müşteri_id_numarası_seq"'::regclass);
 S   ALTER TABLE public."müşteri" ALTER COLUMN "müşteri_id_numarası" DROP DEFAULT;
       public          postgres    false    215    214    215            �           2604    16706    müşteri_kategori id_numarası    DEFAULT     �   ALTER TABLE ONLY public."müşteri_kategori" ALTER COLUMN "id_numarası" SET DEFAULT nextval('public."müşteri_kategori_id_numarası_seq"'::regclass);
 R   ALTER TABLE public."müşteri_kategori" ALTER COLUMN "id_numarası" DROP DEFAULT;
       public          postgres    false    237    238    238            �           2604    16573    oyun oyun_id_numarası    DEFAULT     �   ALTER TABLE ONLY public.oyun ALTER COLUMN "oyun_id_numarası" SET DEFAULT nextval('public."oyun_oyun_id_numarası_seq"'::regclass);
 G   ALTER TABLE public.oyun ALTER COLUMN "oyun_id_numarası" DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    16679    oyun_kategori id_numarası    DEFAULT     �   ALTER TABLE ONLY public.oyun_kategori ALTER COLUMN "id_numarası" SET DEFAULT nextval('public."oyun_kategori_id_numarası_seq"'::regclass);
 K   ALTER TABLE public.oyun_kategori ALTER COLUMN "id_numarası" DROP DEFAULT;
       public          postgres    false    235    236    236            �           2604    16587     takip_sistemi takip_id_numarası    DEFAULT     �   ALTER TABLE ONLY public.takip_sistemi ALTER COLUMN "takip_id_numarası" SET DEFAULT nextval('public."takip_sistemi_takip_id_numarası_seq"'::regclass);
 Q   ALTER TABLE public.takip_sistemi ALTER COLUMN "takip_id_numarası" DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    16601    yönetici çalışan_id    DEFAULT     �   ALTER TABLE ONLY public."yönetici" ALTER COLUMN "çalışan_id" SET DEFAULT nextval('public."çalışan_çalışan_id_seq"'::regclass);
 J   ALTER TABLE public."yönetici" ALTER COLUMN "çalışan_id" DROP DEFAULT;
       public          postgres    false    222    224            �           2604    16594    çalışan çalışan_id    DEFAULT     �   ALTER TABLE ONLY public."çalışan" ALTER COLUMN "çalışan_id" SET DEFAULT nextval('public."çalışan_çalışan_id_seq"'::regclass);
 K   ALTER TABLE public."çalışan" ALTER COLUMN "çalışan_id" DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    16628    ödeme_yöntemi ödeme_id    DEFAULT     �   ALTER TABLE ONLY public."ödeme_yöntemi" ALTER COLUMN "ödeme_id" SET DEFAULT nextval('public."ödeme_yöntemi_ödeme_id_seq"'::regclass);
 L   ALTER TABLE public."ödeme_yöntemi" ALTER COLUMN "ödeme_id" DROP DEFAULT;
       public          postgres    false    232    231    232                      0    16602    asistan 
   TABLE DATA           `   COPY public.asistan ("çalışan_id", ad, soyad, "asistan_maaş", "asistan_görev") FROM stdin;
    public          postgres    false    225   �       �          0    16606    eleman 
   TABLE DATA           ]   COPY public.eleman ("çalışan_id", ad, soyad, "eleman_maaş", "eleman_görev") FROM stdin;
    public          postgres    false    226   Ř       �          0    16618    havale_ödeme 
   TABLE DATA           U   COPY public."havale_ödeme" ("havale_id_numarası", banka_adi, "ücret") FROM stdin;
    public          postgres    false    230   t�       y          0    16577    kategori 
   TABLE DATA           C   COPY public.kategori ("kategori_id_numarası", "tür") FROM stdin;
    public          postgres    false    219   �       �          0    16648    kiralama 
   TABLE DATA           {   COPY public.kiralama ("kiralama_id_numarası", "müşteri_id_numarası", "oyun_id_numarası", kiralama_tarihi) FROM stdin;
    public          postgres    false    234   s�       �          0    16734    kiralama_geçmişi 
   TABLE DATA           u   COPY public."kiralama_geçmişi" ("müşteri_id_numarası", "oyun_id_numarası", "kiralandığı_tarih") FROM stdin;
    public          postgres    false    240   ޚ       �          0    16611    kredi_kartı_ödeme 
   TABLE DATA           �   COPY public."kredi_kartı_ödeme" ("kredi_kartı_ödeme_id", "kart_adı", "kart_soyadı", kart_numarasi, son_kullanma_tarihi, cvc) FROM stdin;
    public          postgres    false    228   ��       u          0    16561 	   müşteri 
   TABLE DATA           �   COPY public."müşteri" ("müşteri_id_numarası", ad, soyad, "telefon_numarası", mail_adresi, il, "ilçe", mahalle, daire_no) FROM stdin;
    public          postgres    false    215   �       �          0    16703    müşteri_kategori 
   TABLE DATA           y   COPY public."müşteri_kategori" ("id_numarası", "müşteri_id_numarası", "kategori_id_numarası", "tür") FROM stdin;
    public          postgres    false    238   ��       w          0    16570    oyun 
   TABLE DATA           ^   COPY public.oyun ("oyun_id_numarası", "oyun_adı", "çıkış_yılı", "ücret") FROM stdin;
    public          postgres    false    217   B�       �          0    16676    oyun_kategori 
   TABLE DATA           z   COPY public.oyun_kategori ("id_numarası", "oyun_id_numarası", "kategori_id_numarası", "oyun_adı", "tür") FROM stdin;
    public          postgres    false    236   �       {          0    16584    takip_sistemi 
   TABLE DATA           I   COPY public.takip_sistemi ("takip_id_numarası", kalan_sure) FROM stdin;
    public          postgres    false    221   �       ~          0    16598 	   yönetici 
   TABLE DATA           h   COPY public."yönetici" ("çalışan_id", ad, soyad, "yönetici_maaş", "yönetici_görev") FROM stdin;
    public          postgres    false    224   3�       }          0    16591 
   çalışan 
   TABLE DATA           B   COPY public."çalışan" ("çalışan_id", ad, soyad) FROM stdin;
    public          postgres    false    223   ڠ       �          0    16625    ödeme_yöntemi 
   TABLE DATA           k   COPY public."ödeme_yöntemi" ("ödeme_id", tutar, tarih, "kredi_kartı_ödeme_id", havale_id) FROM stdin;
    public          postgres    false    232   ��       �           0    0 %   havale_ödeme_havale_id_numarası_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public."havale_ödeme_havale_id_numarası_seq"', 10, true);
          public          postgres    false    229            �           0    0 "   kategori_kategori_id_numarası_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."kategori_kategori_id_numarası_seq"', 10, true);
          public          postgres    false    218            �           0    0 "   kiralama_kiralama_id_numarası_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."kiralama_kiralama_id_numarası_seq"', 10, true);
          public          postgres    false    233            �           0    0 .   kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq    SEQUENCE SET     _   SELECT pg_catalog.setval('public."kredi_kartı_ödeme_kredi_kartı_ödeme_id_seq"', 10, true);
          public          postgres    false    227            �           0    0 #   müşteri_kategori_id_numarası_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."müşteri_kategori_id_numarası_seq"', 10, true);
          public          postgres    false    237            �           0    0 $   müşteri_müşteri_id_numarası_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."müşteri_müşteri_id_numarası_seq"', 10, true);
          public          postgres    false    214            �           0    0    oyun_kategori_id_numarası_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."oyun_kategori_id_numarası_seq"', 10, true);
          public          postgres    false    235            �           0    0    oyun_oyun_id_numarası_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."oyun_oyun_id_numarası_seq"', 10, true);
          public          postgres    false    216            �           0    0 $   takip_sistemi_takip_id_numarası_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public."takip_sistemi_takip_id_numarası_seq"', 10, true);
          public          postgres    false    220            �           0    0    çalışan_çalışan_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."çalışan_çalışan_id_seq"', 17, true);
          public          postgres    false    222            �           0    0    ödeme_yöntemi_ödeme_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."ödeme_yöntemi_ödeme_id_seq"', 20, true);
          public          postgres    false    231            �           2606    16623     havale_ödeme havale_ödeme_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."havale_ödeme"
    ADD CONSTRAINT "havale_ödeme_pkey" PRIMARY KEY ("havale_id_numarası");
 N   ALTER TABLE ONLY public."havale_ödeme" DROP CONSTRAINT "havale_ödeme_pkey";
       public            postgres    false    230            �           2606    16582    kategori kategori_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.kategori
    ADD CONSTRAINT kategori_pkey PRIMARY KEY ("kategori_id_numarası");
 @   ALTER TABLE ONLY public.kategori DROP CONSTRAINT kategori_pkey;
       public            postgres    false    219            �           2606    16654    kiralama kiralama_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.kiralama
    ADD CONSTRAINT kiralama_pkey PRIMARY KEY ("kiralama_id_numarası");
 @   ALTER TABLE ONLY public.kiralama DROP CONSTRAINT kiralama_pkey;
       public            postgres    false    234            �           2606    16616 ,   kredi_kartı_ödeme kredi_kartı_ödeme_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."kredi_kartı_ödeme"
    ADD CONSTRAINT "kredi_kartı_ödeme_pkey" PRIMARY KEY ("kredi_kartı_ödeme_id");
 Z   ALTER TABLE ONLY public."kredi_kartı_ödeme" DROP CONSTRAINT "kredi_kartı_ödeme_pkey";
       public            postgres    false    228            �           2606    16708 *   müşteri_kategori müşteri_kategori_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public."müşteri_kategori"
    ADD CONSTRAINT "müşteri_kategori_pkey" PRIMARY KEY ("id_numarası");
 X   ALTER TABLE ONLY public."müşteri_kategori" DROP CONSTRAINT "müşteri_kategori_pkey";
       public            postgres    false    238            �           2606    16568 #   müşteri müşteri_mail_adresi_key 
   CONSTRAINT     i   ALTER TABLE ONLY public."müşteri"
    ADD CONSTRAINT "müşteri_mail_adresi_key" UNIQUE (mail_adresi);
 Q   ALTER TABLE ONLY public."müşteri" DROP CONSTRAINT "müşteri_mail_adresi_key";
       public            postgres    false    215            �           2606    16566    müşteri müşteri_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."müşteri"
    ADD CONSTRAINT "müşteri_pkey" PRIMARY KEY ("müşteri_id_numarası");
 F   ALTER TABLE ONLY public."müşteri" DROP CONSTRAINT "müşteri_pkey";
       public            postgres    false    215            �           2606    16681     oyun_kategori oyun_kategori_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.oyun_kategori
    ADD CONSTRAINT oyun_kategori_pkey PRIMARY KEY ("id_numarası");
 J   ALTER TABLE ONLY public.oyun_kategori DROP CONSTRAINT oyun_kategori_pkey;
       public            postgres    false    236            �           2606    16575    oyun oyun_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.oyun
    ADD CONSTRAINT oyun_pkey PRIMARY KEY ("oyun_id_numarası");
 8   ALTER TABLE ONLY public.oyun DROP CONSTRAINT oyun_pkey;
       public            postgres    false    217            �           2606    16589     takip_sistemi takip_sistemi_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.takip_sistemi
    ADD CONSTRAINT takip_sistemi_pkey PRIMARY KEY ("takip_id_numarası");
 J   ALTER TABLE ONLY public.takip_sistemi DROP CONSTRAINT takip_sistemi_pkey;
       public            postgres    false    221            �           2606    16596    çalışan çalışan_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public."çalışan"
    ADD CONSTRAINT "çalışan_pkey" PRIMARY KEY ("çalışan_id");
 H   ALTER TABLE ONLY public."çalışan" DROP CONSTRAINT "çalışan_pkey";
       public            postgres    false    223            �           2606    16631 $   ödeme_yöntemi ödeme_yöntemi_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public."ödeme_yöntemi"
    ADD CONSTRAINT "ödeme_yöntemi_pkey" PRIMARY KEY ("ödeme_id");
 R   ALTER TABLE ONLY public."ödeme_yöntemi" DROP CONSTRAINT "ödeme_yöntemi_pkey";
       public            postgres    false    232            �           2620    16739    kiralama kira    TRIGGER     b   CREATE TRIGGER kira BEFORE INSERT ON public.kiralama FOR EACH ROW EXECUTE FUNCTION public.kira();
 &   DROP TRIGGER kira ON public.kiralama;
       public          postgres    false    241    234            �           2606    16697    oyun_kategori fk_kategori    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyun_kategori
    ADD CONSTRAINT fk_kategori FOREIGN KEY ("kategori_id_numarası") REFERENCES public.kategori("kategori_id_numarası");
 C   ALTER TABLE ONLY public.oyun_kategori DROP CONSTRAINT fk_kategori;
       public          postgres    false    3268    236    219            �           2606    16724    müşteri_kategori fk_kategori    FK CONSTRAINT     �   ALTER TABLE ONLY public."müşteri_kategori"
    ADD CONSTRAINT fk_kategori FOREIGN KEY ("kategori_id_numarası") REFERENCES public.kategori("kategori_id_numarası");
 J   ALTER TABLE ONLY public."müşteri_kategori" DROP CONSTRAINT fk_kategori;
       public          postgres    false    238    3268    219            �           2606    16642 &   ödeme_yöntemi fk_kredi_kartı_ödeme    FK CONSTRAINT     �   ALTER TABLE ONLY public."ödeme_yöntemi"
    ADD CONSTRAINT "fk_kredi_kartı_ödeme" FOREIGN KEY ("kredi_kartı_ödeme_id") REFERENCES public."kredi_kartı_ödeme"("kredi_kartı_ödeme_id");
 T   ALTER TABLE ONLY public."ödeme_yöntemi" DROP CONSTRAINT "fk_kredi_kartı_ödeme";
       public          postgres    false    232    3274    228            �           2606    16665    kiralama fk_müşteri    FK CONSTRAINT     �   ALTER TABLE ONLY public.kiralama
    ADD CONSTRAINT "fk_müşteri" FOREIGN KEY ("müşteri_id_numarası") REFERENCES public."müşteri"("müşteri_id_numarası");
 A   ALTER TABLE ONLY public.kiralama DROP CONSTRAINT "fk_müşteri";
       public          postgres    false    234    215    3264            �           2606    16719    müşteri_kategori fk_müşteri    FK CONSTRAINT     �   ALTER TABLE ONLY public."müşteri_kategori"
    ADD CONSTRAINT "fk_müşteri" FOREIGN KEY ("müşteri_id_numarası") REFERENCES public."müşteri"("müşteri_id_numarası");
 M   ALTER TABLE ONLY public."müşteri_kategori" DROP CONSTRAINT "fk_müşteri";
       public          postgres    false    3264    215    238            �           2606    16670    kiralama fk_oyun    FK CONSTRAINT     �   ALTER TABLE ONLY public.kiralama
    ADD CONSTRAINT fk_oyun FOREIGN KEY ("oyun_id_numarası") REFERENCES public.oyun("oyun_id_numarası");
 :   ALTER TABLE ONLY public.kiralama DROP CONSTRAINT fk_oyun;
       public          postgres    false    234    3266    217            �           2606    16692    oyun_kategori fk_oyun    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyun_kategori
    ADD CONSTRAINT fk_oyun FOREIGN KEY ("oyun_id_numarası") REFERENCES public.oyun("oyun_id_numarası");
 ?   ALTER TABLE ONLY public.oyun_kategori DROP CONSTRAINT fk_oyun;
       public          postgres    false    3266    217    236            �           2606    16655 -   kiralama kiralama_müşteri_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.kiralama
    ADD CONSTRAINT "kiralama_müşteri_id_numarası_fkey" FOREIGN KEY ("müşteri_id_numarası") REFERENCES public."müşteri"("müşteri_id_numarası");
 Y   ALTER TABLE ONLY public.kiralama DROP CONSTRAINT "kiralama_müşteri_id_numarası_fkey";
       public          postgres    false    215    234    3264            �           2606    16660 (   kiralama kiralama_oyun_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.kiralama
    ADD CONSTRAINT "kiralama_oyun_id_numarası_fkey" FOREIGN KEY ("oyun_id_numarası") REFERENCES public.oyun("oyun_id_numarası");
 T   ALTER TABLE ONLY public.kiralama DROP CONSTRAINT "kiralama_oyun_id_numarası_fkey";
       public          postgres    false    3266    217    234            �           2606    16714 @   müşteri_kategori müşteri_kategori_kategori_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."müşteri_kategori"
    ADD CONSTRAINT "müşteri_kategori_kategori_id_numarası_fkey" FOREIGN KEY ("kategori_id_numarası") REFERENCES public.kategori("kategori_id_numarası");
 n   ALTER TABLE ONLY public."müşteri_kategori" DROP CONSTRAINT "müşteri_kategori_kategori_id_numarası_fkey";
       public          postgres    false    238    219    3268            �           2606    16709 A   müşteri_kategori müşteri_kategori_müşteri_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."müşteri_kategori"
    ADD CONSTRAINT "müşteri_kategori_müşteri_id_numarası_fkey" FOREIGN KEY ("müşteri_id_numarası") REFERENCES public."müşteri"("müşteri_id_numarası");
 o   ALTER TABLE ONLY public."müşteri_kategori" DROP CONSTRAINT "müşteri_kategori_müşteri_id_numarası_fkey";
       public          postgres    false    238    3264    215            �           2606    16687 6   oyun_kategori oyun_kategori_kategori_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyun_kategori
    ADD CONSTRAINT "oyun_kategori_kategori_id_numarası_fkey" FOREIGN KEY ("kategori_id_numarası") REFERENCES public.kategori("kategori_id_numarası");
 b   ALTER TABLE ONLY public.oyun_kategori DROP CONSTRAINT "oyun_kategori_kategori_id_numarası_fkey";
       public          postgres    false    3268    219    236            �           2606    16682 2   oyun_kategori oyun_kategori_oyun_id_numarası_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.oyun_kategori
    ADD CONSTRAINT "oyun_kategori_oyun_id_numarası_fkey" FOREIGN KEY ("oyun_id_numarası") REFERENCES public.oyun("oyun_id_numarası");
 ^   ALTER TABLE ONLY public.oyun_kategori DROP CONSTRAINT "oyun_kategori_oyun_id_numarası_fkey";
       public          postgres    false    217    236    3266            �           2606    16637 .   ödeme_yöntemi ödeme_yöntemi_havale_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ödeme_yöntemi"
    ADD CONSTRAINT "ödeme_yöntemi_havale_id_fkey" FOREIGN KEY (havale_id) REFERENCES public."havale_ödeme"("havale_id_numarası");
 \   ALTER TABLE ONLY public."ödeme_yöntemi" DROP CONSTRAINT "ödeme_yöntemi_havale_id_fkey";
       public          postgres    false    3276    230    232            �           2606    16632 ;   ödeme_yöntemi ödeme_yöntemi_kredi_kartı_ödeme_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."ödeme_yöntemi"
    ADD CONSTRAINT "ödeme_yöntemi_kredi_kartı_ödeme_id_fkey" FOREIGN KEY ("kredi_kartı_ödeme_id") REFERENCES public."kredi_kartı_ödeme"("kredi_kartı_ödeme_id");
 i   ALTER TABLE ONLY public."ödeme_yöntemi" DROP CONSTRAINT "ödeme_yöntemi_kredi_kartı_ödeme_id_fkey";
       public          postgres    false    3274    232    228               �   x��ͻ� ���2D�H�����&)�3�F�|�H&�C�D��t��s��<����hZ!?_�+���$��s:�訰ԣ�pG����0��TlG%P��dL}\ݾrK��\��%[��	"�衻-y��]#���}�!)��5�F����w���׉R      �   �   x���;
�@����*f��{�9�/�P�Q$���N��6q#��bӟ�������	I?���EQ���N	��2rLڱ�����1���mwˆ�Ó�H���P�R��W0`��Y��#T��̚�}3�K][j�eյ~m>P�7֡�I��	!^v{s�      �   o   x�3��<:_!)1/;���FNCS=.#4Q��1gUfQbb	B�$l�!ldVoʙ�CH����0�!����
���H�ARjn
�D�Xhh������W�j:ؕ1z\\\ ��L�      y   p   x�ɽ�0���)� ��|D'aΉ��)�e2=a/�{�k�)c+^2��v��"����<��K�F�2/�ό��2G:�I�c��g�Ԉf#7V��7��|H�$�      �   [   x�}���0D��R�$HR���!z���0+�JYmp�Cb[n��B�_���[���C���'�pi@"�4`�F�@-�ˎܓ�ت<Q      �      x������ � �      �   
  x�u�AR� Eן�h���g('f��"Ak�L��ޝ�l2��7!��cP.k�؝>סLp�q�6�����PCܲ"����]���Z2��r�CjRC�iD���<�.��g6�*���� �+6_1;�:�@��b��,x�9N�M\E�3d[�B��j�ꡒKYj����}c5��T�'ڐ��*ei�A��^@�9��s<?^ަ�7kM����A����Θ��?��*����B��*�!eӾ>W�Er�6�u���W�l      u   �  x�}�=��0���a����|'hY�Z��̜���f���-� Wm9�.=�����G��Nχ#dJ9WeUn����͡���v���N{�W���o#z��{�;@��T�\����9�)��3�c������	h�GyZ/\���_s!/
f�_�0@�ѣ���pӭU0	��>�_r"��2Y��1��5ӘB�ݷu�����)��k��|}zK������*����.��c&��'^񔬠��O`�=iq!�T��߉����q�kV¬��a�x#e���8'c�N��E���7?�֬^_-���S�@-a9��W�T�Eq��b�S����;��[��z-2V�������`�)�����_����;Ҍ#F��~�y��Q�_�P�'I��ny�R׀��c�/J��      �   s   x�]�1�0Cg�S�� �p�.��(IS�[/��P	U�b�Y60��Ϋ4hТ��9#ˑ_�j65�6>c�t��P��XؿQ�^��װˀ��:8Mwv��{��ôG&Δg%"_5�,�      w   �   x�5�M
�0F�3��	$I��R������r�ҡ�II��[yfCq9o����$H.J�8J���j��2�9&�^�#g��'�ʹ��������:�/et38V�W_&s��:�n�]ct�����N�vLi���"�-(7;M��)a���v�Q��<��$ �(8�6����C��"� �>6�      �   �   x�U�Kj�@D��S�	Bl�'��C�Yd��<v��V{�[� �e��@(�
�^��Ju��� #gSC����ůπ2s2���#��l�����g,��Ѭ`kxP"���s��Y����b���x����a�^� ��������>�˺��o�'XtI�:�vR��v�tȳ8�W�(�2u��^G3��'�����1���R�      {   ;   x�3�4WH?�'�ˈ�� �2�4�0L`SNcÌ��0�4�0,��,a&�$c���� [�      ~   �   x���1� ��s
N�hnc�#� Z�")�i:�"�D�X86n�o� (����X`��Z0	+fjJ�%{�zaA�rG�����5�SM�&҃Q�DH��6�l��(��f4H�
QEG|�mC��ṫk������9�!o5�d�      }      x������ � �      �   �   x�����0�o��4�0;Cd��?G���w��@�DHE�+�+���m�׀El�+y�ܠ�ƍrF��Y9��z��ߝ�tt�QpQ�V���p��?�A��z0_Je��x����~R��:c�&��8��X��	c�#&ܬ�6U��{1�5%��     