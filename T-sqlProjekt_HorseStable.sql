--1 Writes owners awards

CREATE PROCEDURE awards @wlasciciel int
AS
BEGIN
DECLARE @postacid int, @konId int, @imie varchar(100), @nazwisko varchar(100), @imieK varchar(100), @numerZaw int, @pozycja int, @nagrodaId int ,@medal varchar(100);
SET @postacid = (SELECT id FROM Wlasciciel_konia WHERE ID = @wlasciciel)
SET @imie = (SELECT imie FROM Postac WHERE id = @postacid);
SET @nazwisko = (SELECT nazwisko FROM postac WHERE id = @postacid);
		PRINT @imie + ' ' + @nazwisko; 
		DECLARE cursor2 CURSOR FOR SELECT id FROM kon WHERE Wlasciciel_konia_ID = @postacid
		OPEN cursor2;	
		FETCH NEXT FROM cursor2 INTO @konId;
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @imieK = (SELECT imie FROM Kon WHERE id = @konId);
				PRINT 'Kon: ' + @imieK;
				DECLARE cursor3 CURSOR FOR SELECT Zawody_skokowe_ID, Pozycja_w_zawodach, Nagroda_id FROM Zawody_kon WHERE kon_id = @konId
				OPEN cursor3;	
				FETCH NEXT FROM cursor3 INTO @numerZaw, @pozycja, @nagrodaId;
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
						FETCH NEXT FROM cursor3 INTO @numerZaw, @pozycja, @nagrodaId;
						END;
				CLOSE cursor3;
				DEALLOCATE cursor3;
			FETCH NEXT FROM cursor2 INTO @konId;
		END;
		CLOSE cursor2;
		DEALLOCATE cursor2;
END;

drop procedure awards;
EXEC awards 1;

--2 Transport horses from one stable to another

CREATE PROCEDURE transport @obecna varchar(100), @docelowa varchar(100)
AS
BEGIN
DECLARE cursorP CURSOR FOR SELECT k.id, k.Stadnina_ID FROM kon k
DECLARE @idkon int, @idstadnina int;
OPEN cursorP;
FETCH NEXT FROM cursorP INTO @idkon, @idstadnina;
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @idstadnina = (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @obecna)
		BEGIN 
			IF EXISTS (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @docelowa)
			BEGIN
			UPDATE kon SET stadnina_id =  (SELECT id FROM Stadnina WHERE Nazwa = @docelowa) WHERE id = @idkon
			END;
		END;
	FETCH NEXT FROM cursorP INTO @idkon, @idstadnina;
	END;
CLOSE cursorP;
DEALLOCATE cursorP
END;

drop procedure transport1;

CREATE PROCEDURE transport2 @obecna varchar(100), @docelowa varchar(100)
AS
BEGIN
IF EXISTS (SELECT s.id FROM Stadnina s WHERE s.Nazwa = @docelowa)
	BEGIN
	UPDATE kon SET stadnina_id =  (SELECT id FROM Stadnina WHERE Nazwa = @docelowa) WHERE Stadnina_ID = (SELECT id FROM Stadnina WHERE Nazwa = @obecna)
	END;
END;

EXEC transport2 'Konikowy Raj', 'Dworek';
SELECT * FROM Kon k INNER JOIN stadnina s ON k.stadnina_id = s.id;

--3 For selected competitions for 2 place additional award 100 PLN, the best horse gets additional 1000 PLN

CREATE PROCEDURE bonus @zawody int
AS
BEGIN
DECLARE cursorP CURSOR FOR SELECT k.Pozycja_w_zawodach, k.Nagroda_ID, Zawody_skokowe_ID FROM zawody_kon k
DECLARE @pozycja int, @nagrodaid int, @zawody_skok int;
IF EXISTS (SELECT 1 FROM zawody_kon WHERE Zawody_skokowe_ID = @zawody) 
BEGIN 
OPEN cursorP;
FETCH NEXT FROM cursorP INTO @pozycja, @nagrodaid, @zawody_skok;
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
	FETCH NEXT FROM cursorP INTO @pozycja, @nagrodaid, @zawody_skok;
	END;
CLOSE cursorP;
DEALLOCATE cursorP
END;
ELSE 
	BEGIN 
	Raiserror('This competition did not take place',1,2);
	END;
END;

drop procedure bonus;
EXEC bonus 3
SELECT * FROM zawody_kon k INNER JOIN nagroda s ON k.nagroda_id = s.id;

--4 trigger will not allow to add the owner under 18 years old to horse club 

CREATE TRIGGER age18 
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
		Raiserror('Cannot add owner under 18 years old',1,2);
		END;
END;

drop trigger age18;

INSERT INTO Wlasciciel_klub VALUES(1, 7, '2018/09/09',null)
INSERT INTO Wlasciciel_klub VALUES(2, 2, '2019/09/09',null)

--5 trigger will not allow to delete Haflinger horse
	
CREATE TRIGGER deleteHorse 
ON kon
FOR DELETE 
AS
BEGIN
	IF EXISTS (SELECT 1 FROM deleted WHERE rasa_id = (SELECT id FROM rasa WHERE nazwa = 'Haflinger'))
		BEGIN
		ROLLBACK;
		Raiserror('Cannot delete Haflinger horse',1,2);
		END;
END;

drop trigger deleteHorse;

DELETE FROM kon WHERE id = 7;


