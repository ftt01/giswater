/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE SEQUENCE doc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE doc_x_node_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE doc_x_arc_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE doc_x_connec_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

CREATE SEQUENCE doc_x_gully_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  
  


CREATE TABLE "doc_type" (
"id" varchar(30)   NOT NULL,
"comment" varchar(512)  ,
CONSTRAINT doc_type_pkey PRIMARY KEY (id)
);
  
  

CREATE TABLE "cat_tag" (
"id" varchar(16)   NOT NULL,
"comment" varchar(512)  ,
CONSTRAINT cat_tag_pkey PRIMARY KEY (id)
);

CREATE TABLE "doc" (
"id" varchar(30) DEFAULT nextval ('"SCHEMA_NAME".doc_seq'::regclass) NOT NULL,
"doc_type" varchar(30),
"path" varchar(512),
"observ" varchar(512),
"tagcat_id" varchar(16),
"date" timestamp(6) DEFAULT now(),
"user_name" varchar(50) DEFAULT user,
CONSTRAINT doc_pkey PRIMARY KEY (id)
);


CREATE TABLE "doc_x_node" (
"id" int8 DEFAULT nextval ('"SCHEMA_NAME".doc_x_node_seq'::regclass) NOT NULL,
"doc_id" varchar(30),
"node_id" varchar(16)  ,
CONSTRAINT doc_x_node_pkey PRIMARY KEY (id)
);


CREATE TABLE "doc_x_arc" (
"id" int8 DEFAULT nextval ('"SCHEMA_NAME".doc_x_arc_seq'::regclass) NOT NULL,
"doc_id" varchar(30),
"arc_id" varchar(16)  ,
CONSTRAINT doc_x_arc_pkey PRIMARY KEY (id)
);


CREATE TABLE "doc_x_connec" (
"id" int8 DEFAULT nextval ('"SCHEMA_NAME".doc_x_connec_seq'::regclass) NOT NULL,
"doc_id" varchar(30),
"connec_id" varchar(16)  ,
CONSTRAINT doc_x_connec_pkey PRIMARY KEY (id)
);


CREATE TABLE "doc_x_gully" (
"id" int8 DEFAULT nextval ('"SCHEMA_NAME".doc_x_connec_seq'::regclass) NOT NULL,
"doc_id" varchar(30),
"gully_id" varchar(16)  ,
CONSTRAINT doc_x_gully_pkey PRIMARY KEY (id)
);
