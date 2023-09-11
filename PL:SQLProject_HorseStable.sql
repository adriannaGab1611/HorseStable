SET SERVEROUTPUT ON;
--1 Wypisze osi¹gniêcia w³aœciciela konia 
CREATE OR REPLACE PROCEDURE osiagniecia (v_wlasciciel int)
AS
v_postacid int; v_konId int; v_imie varchar2(100); v_nazwisko varchar2(100); v_imieK varchar2(100); v_numerZaw int; v_pozycja int; v_nagrodaId int ; v_medal varchar2(100); v_temp int;
CURSOR kursor2 IS SELECT id FROM kon WHERE Wlasciciel_konia_ID = v_postacid;
CURSOR kursor3 IS SELECT Zawody_skokowe_ID, Pozycja_w_zawodach, Nagroda_id FROM Zawody_kon WHERE kon_id = v_konId;
BEGIN
SELECT id INTO v_postacid FROM Wlasciciel_konia WHERE ID = v_wlasciciel;
SELECT imie INTO v_imie FROM Postac WHERE id = v_postacid;
SELECT nazwisko INTO v_nazwisko FROM postac WHERE id = v_postacid;
dbms_output.put_line(v_imie || ' ' || v_nazwisko);
    OPEN kursor2;
    LOOP
		FETCH kursor2 INTO v_konId;
		EXIT WHEN kursor2%NOTFOUND;
        SELECT imie INTO v_imieK FROM Kon WHERE id = v_konId;
        dbms_output.put_line('Koñ: ' || v_imieK);
        OPEN kursor3;	
            LOOP
                FETCH kursor3 INTO v_numerZaw, v_pozycja, v_nagrodaId;
                EXIT WHEN kursor3%NOTFOUND;
                SELECT COUNT(medal) INTO v_temp FROM Nagroda WHERE ID = v_nagrodaId;
                IF v_temp >0 THEN
                SELECT medal INTO v_medal FROM Nagroda WHERE ID = v_nagrodaId;
                ELSE 
                v_medal := 'brak';
                END IF;
                dbms_output.put_line('Zawody: ' || v_numerZaw || ' Pozycja: ' || v_pozycja || ' Medal ' || v_medal);
            END LOOP;
        CLOSE kursor3;
    END LOOP;
    CLOSE kursor2;
END;

CALL osiagniecia (1);

--2 Na potrzeby remonu wszystkie konie s¹ transportowane z starej stadniny do nowej 
CREATE OR REPLACE PROCEDURE przeprowadzka2 (v_obecna varchar2, v_docelowa varchar2)
AS
temp int;
BEGIN
SELECT COUNT(s.id) INTO temp FROM Stadnina s WHERE s.Nazwa = v_docelowa;
IF temp > 0 THEN
	UPDATE kon SET stadnina_id = (SELECT id FROM Stadnina WHERE Nazwa = v_docelowa) WHERE Stadnina_ID = (SELECT id FROM Stadnina WHERE Nazwa = v_obecna);
    END IF;
END;

CALL przeprowadzka2('Konikowy Raj', 'Dworek');
SELECT * FROM Kon k INNER JOIN stadnina s ON k.stadnina_id = s.id;

--3 Dla zawodów wybranych w argumencie procedury za 2 miejsce bêdzie dodatkowa nagroda w postaci 100 z³, a najlepszy koñ otrzyma dodatkowo 1000 z³ 

CREATE OR REPLACE PROCEDURE premia (v_zawody int)
AS
CURSOR kursorP IS SELECT k.Pozycja_w_zawodach, k.Nagroda_ID, k.Zawody_skokowe_ID FROM zawody_kon k;
v_pozycja int; v_nagrodaid int; v_zawody_skok int; temp int;
BEGIN
SELECT COUNT(1) INTO temp FROM zawody_kon WHERE Zawody_skokowe_ID = v_zawody;
IF temp > 0 THEN 
OPEN kursorP;
LOOP
    FETCH kursorP INTO v_pozycja, v_nagrodaid, v_zawody_skok;
    EXIT WHEN kursorP%NOTFOUND;
		IF v_zawody_skok = v_zawody THEN
			IF v_pozycja = 1 THEN 
				UPDATE Nagroda SET Nagroda_pieniezna = Nagroda_pieniezna + 1000 WHERE id = v_nagrodaid;
                END IF;
			IF v_pozycja = 2 THEN 
				UPDATE Nagroda SET Nagroda_pieniezna = Nagroda_pieniezna + 100 WHERE id = v_nagrodaid;
                END IF;
		END IF;
END LOOP;
CLOSE kursorP;
ELSE 
	dbms_output.put_line('Takie zawody siê nie odby³y');
END IF;
END;

CALL premia(3);
SELECT * FROM zawody_kon k INNER JOIN nagroda s ON k.nagroda_id = s.id;

--4 wyzwalacz nie pozwoli na dodanie do klubu jeŸdzieckiego w³aœciciela konia który ma mniej ni¿ 18 lat
CREATE OR REPLACE TRIGGER wiek18 
AFTER INSERT 
ON Wlasciciel_klub
FOR EACH ROW
DECLARE
v_wiek int;
BEGIN
    SELECT Wiek INTO v_wiek FROM Postac o INNER JOIN Wlasciciel_konia wk ON o.id=wk.Osoba_ID WHERE wk.id = :new.wlasciciel_konia_id;
	IF v_wiek < 18 THEN
        Raise_Application_Error(-20100,'Nie przyjmujemy do klubu poni¿ej 18 roku ¿ycia');
		END IF;
END;

INSERT INTO Wlasciciel_klub VALUES(1, 5, '2018/09/09',null);
INSERT INTO Wlasciciel_klub VALUES(2, 2, '2019/09/09',null);

--5 wyzwalacz nie pozwoli na usuniêcie konia rasy Haflinger 
CREATE OR REPLACE TRIGGER usun 
BEFORE DELETE 
ON kon
FOR EACH ROW
DECLARE 
v_rasa int;
BEGIN
	IF :old.rasa_id = 5 THEN
		Raise_Application_Error(-20100,'Konie Haflingera s¹ potrzebne w naszej stadninie wiêc ich nie oddajemy');
		END IF;
END;

DELETE FROM kon WHERE id = 7;

SELECT * FROM kon;