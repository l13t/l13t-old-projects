--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: pgsql
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO pgsql;

SET search_path = public, pg_catalog;

--
-- Name: ncc_auth(character varying, character varying, character varying, inet); Type: FUNCTION; Schema: public; Owner: ncc
--

CREATE FUNCTION ncc_auth(character varying, character varying, character varying, inet) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
login alias for $1;
pwd alias for $2;
context alias for $3;
ip alias for $4;
r record;
BEGIN 
select * into r from users where ident = login;
if not found then
return E'NOUSER';
end if;
if r.password <> md5(pwd) then
return E'NOAUTH';
end if;
select * into r from accesslist where ident = login and area = context and zone >>= ip;
if not found then 
return E'NOACCESS';
end if;
select * into r from users where enabled = 't' and ident = login;
if not found then
return E'NOACCESS';
end if;
return E'OK';
end
$_$;


ALTER FUNCTION public.ncc_auth(character varying, character varying, character varying, inet) OWNER TO ncc;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accesslist; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE accesslist (
    ident character varying(32),
    area character varying(32),
    zone cidr,
    permit boolean DEFAULT true NOT NULL
);


ALTER TABLE public.accesslist OWNER TO ncc;

--
-- Name: areas; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE areas (
    area character varying(32) NOT NULL,
    descr text
);


ALTER TABLE public.areas OWNER TO ncc;

--
-- Name: group_accesslist; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE group_accesslist (
    gr character varying(32),
    area character varying(32),
    zone cidr,
    permit boolean DEFAULT true NOT NULL
);


ALTER TABLE public.group_accesslist OWNER TO ncc;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE groups (
    gr character varying(32) NOT NULL,
    descr text
);


ALTER TABLE public.groups OWNER TO ncc;

--
-- Name: reg; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE reg (
    ident character varying(32) NOT NULL,
    password character varying(32),
    descr text,
    plain_pwd character varying(32),
    added boolean DEFAULT false NOT NULL
);


ALTER TABLE public.reg OWNER TO ncc;

--
-- Name: users; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE users (
    ident character varying(32) NOT NULL,
    name text,
    password character varying(32),
    enabled boolean DEFAULT true NOT NULL,
    gr character varying(32) DEFAULT 'support'::character varying NOT NULL,
    inv_hash text
);


ALTER TABLE public.users OWNER TO ncc;

--
-- Name: zones; Type: TABLE; Schema: public; Owner: ncc; Tablespace: 
--

CREATE TABLE zones (
    zone cidr NOT NULL,
    descr text
);


ALTER TABLE public.zones OWNER TO ncc;

--
-- Name: areas_pkey; Type: CONSTRAINT; Schema: public; Owner: ncc; Tablespace: 
--

ALTER TABLE ONLY areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: ncc; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (gr);


--
-- Name: reg_pkey; Type: CONSTRAINT; Schema: public; Owner: ncc; Tablespace: 
--

ALTER TABLE ONLY reg
    ADD CONSTRAINT reg_pkey PRIMARY KEY (ident);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: ncc; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (ident);


--
-- Name: zones_pkey; Type: CONSTRAINT; Schema: public; Owner: ncc; Tablespace: 
--

ALTER TABLE ONLY zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (zone);


--
-- Name: acl; Type: INDEX; Schema: public; Owner: ncc; Tablespace: 
--

CREATE UNIQUE INDEX acl ON accesslist USING btree (ident, area, zone);


--
-- Name: accesslist_area_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY accesslist
    ADD CONSTRAINT accesslist_area_fkey FOREIGN KEY (area) REFERENCES areas(area);


--
-- Name: accesslist_ident_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY accesslist
    ADD CONSTRAINT accesslist_ident_fkey FOREIGN KEY (ident) REFERENCES users(ident);


--
-- Name: accesslist_zone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY accesslist
    ADD CONSTRAINT accesslist_zone_fkey FOREIGN KEY (zone) REFERENCES zones(zone);


--
-- Name: graccesslist_area_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY group_accesslist
    ADD CONSTRAINT graccesslist_area_fkey FOREIGN KEY (area) REFERENCES areas(area);


--
-- Name: graccesslist_ident_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY group_accesslist
    ADD CONSTRAINT graccesslist_ident_fkey FOREIGN KEY (gr) REFERENCES groups(gr);


--
-- Name: graccesslist_zone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY group_accesslist
    ADD CONSTRAINT graccesslist_zone_fkey FOREIGN KEY (zone) REFERENCES zones(zone);


--
-- Name: users_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ncc
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_group_fkey FOREIGN KEY (gr) REFERENCES groups(gr);


--
-- Name: public; Type: ACL; Schema: -; Owner: pgsql
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM pgsql;
GRANT ALL ON SCHEMA public TO pgsql;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

