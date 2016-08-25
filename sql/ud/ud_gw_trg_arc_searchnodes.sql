/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_searchnodes() 
RETURNS trigger  LANGUAGE plpgsql    AS
$$
DECLARE 
	nodeRecord1 Record; 
	nodeRecord2 Record;
	optionsRecord Record;
	rec Record;
	z1 double precision;
	z2 double precision;
	z_aux double precision;
	
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    -- Get data from config table
    SELECT * INTO rec FROM config;    

    SELECT * INTO nodeRecord1 FROM node WHERE ST_DWithin(ST_startpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
	    ORDER BY ST_Distance(node.the_geom, ST_startpoint(NEW.the_geom)) LIMIT 1;

    SELECT * INTO nodeRecord2 FROM node WHERE ST_DWithin(ST_endpoint(NEW.the_geom), node.the_geom, rec.arc_searchnodes)
    ORDER BY ST_Distance(node.the_geom, ST_endpoint(NEW.the_geom)) LIMIT 1;


	SELECT * INTO optionsRecord FROM inp_options LIMIT 1;

    -- Control of start/end node
    IF (nodeRecord1.node_id IS NOT NULL) AND (nodeRecord2.node_id IS NOT NULL) THEN	
	
--		Control de lineas de longitud 0
		IF (nodeRecord1.node_id = nodeRecord2.node_id) AND (rec.samenode_init_end_control IS TRUE) THEN
			RETURN audit_function (180,750);
		ELSE

--  	Update coordinates
		NEW.the_geom := ST_SetPoint(NEW.the_geom, 0, nodeRecord1.the_geom);
		NEW.the_geom := ST_SetPoint(NEW.the_geom, ST_NumPoints(NEW.the_geom) - 1, nodeRecord2.the_geom);
		
		IF (optionsRecord.link_offsets = 'DEPTH') THEN
			z1 := (nodeRecord1.top_elev - NEW.y1);
			z2 := (nodeRecord2.top_elev - NEW.y2);
			ELSE
				z1 := NEW.y1;
				z2 := NEW.y2;	
		END IF;

		IF ((z1 > z2) AND NEW.inverted_slope is false) OR ((z1 < z2) AND NEW.inverted_slope is true) THEN

			NEW.node_1 := nodeRecord1.node_id; 
			NEW.node_2 := nodeRecord2.node_id;

		ELSE 

--			Update conduit direction
			NEW.the_geom := ST_reverse(NEW.the_geom);
			z_aux := NEW.y1;
			NEW.y1 := NEW.y2;
			NEW.y2 := z_aux;

--  Update topology info
			NEW.node_1 := nodeRecord2.node_id;
			NEW.node_2 := nodeRecord1.node_id;
		END IF;
        RETURN NEW;
	END IF;
	ELSE
	RETURN audit_function (182,750);
    RETURN NULL;
    END IF;
END; 
$$;




DROP TRIGGER IF EXISTS gw_trg_arc_searchnodes ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_arc_searchnodes BEFORE INSERT OR UPDATE ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_searchnodes"();


