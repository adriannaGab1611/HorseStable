--1 Wypisze osi¹gniêcia w³aœciciela konia 

CREATE PROCEDURE osiagniecia @wlasciciel int
AS
BEGIN
DECLARE @postacid int, @konId int, @imie varchar(100), @nazwisko varchar(100), @imieK varchar(100), @numerZaw int, @pozycja int, @nagrodaId int ,@medal varchar(100);
SET @postacid = (SELECT id FROM Wlasciciel_konia WHERE ID = @wlasciciel)
SET @imie = (SELECT imie FROM Postac WHERE id = @postacid);
SET @nazwisko = (SELECT nazwisko FROM postac WHERE id = @postacid);
		PRINT @imie + ' ' + @nazwisko; 
		DECLARE kursor2 CURSOR FOR SELECT id FROM kon WHERE Wlasciciel_konia_ID = @postacid
		OPEN kursor2;	
		FETCH NEXT FROM kursor2 INTO @konId;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @imieK = (SELECT imie FROM Kon WHERE id = @konId);
				PRINT 'Koñ: ' + @imieK;
				DECLARE kursor3 CURSOR FOR SELECT Zawody_skokowe_ID, Pozycja_w_zawodach, Nagroda_id FROM Zawody_kon WHERE kon_id = @konId
				OPEN kursor3;	
				FETCH NEXT FROM kursor3 INTO @numerZaw, @pozycja, @nagrodaId;
					WHILE @@FETCH_STATUS = 0
						BEGIN
						IF EXISTS (SELECT medal FROM Nagroda WHERE ID = @nagrodaId)
							BEGIN
								SET @medal = (SELECT medal FROM Nagroda WHERE ID = @nagrodaId)
							END;
						ELSE 
							BEGIN 
								SET @medal = 'brak';
							END;
						PRINT 'Zawody: ' + CAST(@numerZaw as varchar) + ' Pozycja: ' + CAST(@pozycja as varchar) + ' Medal ' + @medal;
						FETCH NEXT FROM kursor3 INTO @numerZaw, @pozycja, @nagrodaId;
						END;
				CLOSE kursor3;
				DEALLOCATE kursor3;
			FETCH NEXT FROM kursor2 INTO @konId;
		END;
		CLOSE kursor2;
		DEALLOCATE kursor2;
END;

drop procedure osiagniecia;
EXEC osiagniecia 1;

--2 Na potrzeby remonu wszystkie konie s¹ transportowane z starej stadniny do nowej 
CREATE PROCEDURE przeprowadzka @obecna varchar(100), @docelowa varchar(100)
AS
BEGIN
DECLARE kursorP CURSOR FOR SELECT k.id, k.Stadnina_ID FROM kon k
DECLARE @idkon int, @idstadnina int;
OPEN kursorP;
FETCH NEXT FROM kursorP INTO @idkon, @idstadnina;
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @idstadnina = (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @obecna)
		BEGIN 
			IF EXISTS (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @docelowa)
			BEGIN
			UPDATE kon SET stadnina_id =  (SELECT id FROM Stadnina WHERE Nazwa = @docelowa) WHERE id = @idkon
			END;
		END;
	FETCH NEXT FROM kursorP INTO @idkon, @idstadnina;
	END;
CLOSE kursorP;
DEALLOCATE kursorP
END;

drop procedure przeprowadzka1;

CREATE PROCEDURE przeprowadzka2 @obecna varchar(100), @docelowa varchar(100)
AS
BEGIN
IF EXISTS (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @docelowa)
	BEGIN
	UPDATE kon SET stadnina_id =  (SELECT id FROM Stadnina WHERE Nazwa = @docelowa) WHERE Stadnina_ID = (SELECT id FROM Stadnina WHERE Nazwa = @obecna)
	END;
END;

EXEC przeprowadzka2 'Konikowy Raj', 'Dworek';
SELECT * FROM Kon k INNER JOIN stadnina s ON k.stadnina_id = s.id;

--3 Dla zawodów wybranych w argumencie procedury za 2 miejsce bêdzie dodatkowa nagroda w postaci 100 z³, a najlepszy koñ otrzyma dodatkowo 1000 z³ 

CREATE PROCEDURE premia @zawody int
AS
BEGIN
DECLARE kursorP CURSOR FOR SELECT k.Pozycja_w_zawodach, k.Nagroda_ID, Zawody_skokowe_ID FROM zawody_kon k
DECLARE @pozycja int, @nagrodaid int, @zawody_skok int;
IF EXISTS (SELECT 1 FROM zawody_kon WHERE Zawody_skokowe_ID = @zawody) 
BEGIN 
OPEN kursorP;
FETCH NEXT FROM kursorP INTO @pozycja, @nagrodaid, @zawody_skok;
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @zawody_skok = @zawody
		BEGIN
			IF @pozycja = 1 
			BEGIN 
				UPDATE Nagroda SET Nagroda_pieniezna = Nagroda_pieniezna + 1000 WHERE id = @nagrodaid
			END;
			IF @pozycja = 2
			BEGIN 
				UPDATE Nagroda SET Nagroda_pieniezna = Nagroda_pieniezna + 100 WHERE id = @nagrodaid
			END;
		END;
	FETCH NEXT FROM kursorP INTO @pozycja, @nagrodaid, @zawody_skok;
	END;
CLOSE kursorP;
DEALLOCATE kursorP
END;
ELSE 
	BEGIN 
	Raiserror('Takie zawody siê nie odby³y',1,2);
	END;
END;

drop procedure premia;
EXEC premia 3
SELECT * FROM zawody_kon k INNER JOIN nagroda s ON k.nagroda_id = s.id;

--4 wyzwalacz nie pozwoli na dodanie do klubu jeŸdzieckiego w³aœciciela konia który ma mniej ni¿ 18 lat
CREATE TRIGGER wiek18 
ON Wlasciciel_klub
FOR INSERT 
AS
BEGIN
	DECLARE @wlasciciel int
	SET @wlasciciel = (SELECT Wlasciciel_konia_ID FROM INSERTED)
	Declare @wiek int
	SET @wiek = (SELECT Wiek FROM Postac o INNER JOIN Wlasciciel_konia wk ON o.id=wk.Osoba_ID WHERE wk.ID = @wlasciciel)
	IF @wiek < 18
		BEGIN
		ROLLBACK;
		Raiserror('Nie przyjmujemy do klubu poni¿ej 18 roku ¿ycia',1,2);
		END;
END;

drop trigger wiek18;

INSERT INTO Wlasciciel_klub VALUES(1, 7, '2018/09/09',null)
INSERT INTO Wlasciciel_klub VALUES(2, 2, '2019/09/09',null)

--5 wyzwalacz nie pozwoli na usuniêcie konia rasy Haflinger 
CREATE TRIGGER usun 
ON kon
FOR DELETE 
AS
BEGIN
	IF EXISTS (SELECT 1 FROM deleted WHERE rasa_id = (SELECT id FROM rasa WHERE nazwa = 'Haflinger'))
		BEGIN
		ROLLBACK;
		Raiserror('Konie Haflingera s¹ potrzebne w naszej stadninie wiêc ich nie oddajemy',1,2);
		END;
END;

drop trigger usun;

DELETE FROM kon WHERE id = 7;


