
-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_polygon();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_polygon()
RETURNS trigger AS
$BODY$
DECLARE 

    polygon_id_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';



-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
    

		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
					
	-- FEATURE INSERT      

			IF (NEW.pol_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.pol_id:= (SELECT nextval('urn_id_seq'));
			END IF;
				
			INSERT INTO polygon (pol_id, text, the_geom, undelete, expl_id)
			VALUES (NEW.pol_id, NEW.text, NEW.the_geom, NEW.undelete, expl_id_int);
		
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- MANAGEMENT UPDATE
			UPDATE polygon 
			SET pol_id=NEW.pol_id, text=NEW.text, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id
			WHERE pol_id=NEW.pol_id;

			PERFORM audit_function(2,430); 
			RETURN NEW;
    

-- DELETE

	ELSIF TG_OP = 'DELETE' THEN

			DELETE FROM polygon WHERE pol_id=OLD.pol_id;
		
		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_edit_polygon ON "SCHEMA_NAME".v_edit_polygon;
CREATE TRIGGER gw_trg_edit_polygon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_polygon FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_polygon('polygon');
