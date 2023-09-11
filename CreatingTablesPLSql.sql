drop table zawody_kon;
drop table nagroda;
drop table wlasciciel_klub;
drop table klub_zawody;
drop table zawody_skokowe;
drop table trener;
drop table kon;
drop table rasa;
drop table wlasciciel_konia;
drop table postac;
drop table stadnina;
drop table lokalizacja;
drop table klub_jezdziecki;

-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-06-25 14:38:58.741

-- tables
-- Table: Klub_jezdziecki
CREATE TABLE Klub_jezdziecki (
    ID int  NOT NULL,
    Nazwa varchar2(100)  NOT NULL,
    CONSTRAINT Klub_jezdziecki_pk PRIMARY KEY (ID)
) ;

-- Table: Klub_zawody
CREATE TABLE Klub_zawody (
    Klub_jezdziecki_ID int  NOT NULL,
    Zawody_skokowe_ID int  NOT NULL,
    CONSTRAINT Klub_zawody_pk PRIMARY KEY (Klub_jezdziecki_ID,Zawody_skokowe_ID)
) ;

-- Table: Kon
CREATE TABLE Kon (
    ID int  NOT NULL,
    Imie varchar2(100)  NOT NULL,
    Wiek int  NOT NULL,
    Plec varchar2(100)  NOT NULL,
    Data_urodzenia date  NOT NULL,
    Wlasciciel_konia_ID int  NOT NULL,
    Rasa_ID int  NOT NULL,
    Stadnina_ID int  NOT NULL,
    CONSTRAINT Kon_pk PRIMARY KEY (ID)
) ;

-- Table: Lokalizacja
CREATE TABLE Lokalizacja (
    ID int  NOT NULL,
    Kraj varchar2(100)  NOT NULL,
    Miasto varchar2(100)  NOT NULL,
    Ulica varchar2(100)  NOT NULL,
    Numer_domu int  NOT NULL,
    CONSTRAINT Lokalizacja_pk PRIMARY KEY (ID)
) ;

-- Table: Nagroda
CREATE TABLE Nagroda (
    ID int  NOT NULL,
    Nagroda_pieniezna int  NOT NULL,
    Medal varchar2(100)  NULL,
    CONSTRAINT Nagroda_pk PRIMARY KEY (ID)
) ;

-- Table: Postac
CREATE TABLE Postac (
    ID int  NOT NULL,
    Imie varchar2(100)  NOT NULL,
    Nazwisko varchar2(100)  NOT NULL,
    Plec varchar2(100)  NOT NULL,
    Wiek int  NOT NULL,
    CONSTRAINT Postac_pk PRIMARY KEY (ID)
) ;

-- Table: Rasa
CREATE TABLE Rasa (
    ID int  NOT NULL,
    Nazwa varchar2(100)  NOT NULL,
    CONSTRAINT Rasa_pk PRIMARY KEY (ID)
) ;

-- Table: Stadnina
CREATE TABLE Stadnina (
    ID int  NOT NULL,
    Nazwa varchar2(100)  NOT NULL,
    Liczba_boksow int  NOT NULL,
    Lokalizacja_ID int  NOT NULL,
    Klub_jezdziecki_ID int  NOT NULL,
    CONSTRAINT Stadnina_pk PRIMARY KEY (ID)
) ;

-- Table: Trener
CREATE TABLE Trener (
    ID int  NOT NULL,
    Osoba_ID int  NOT NULL,
    Klub_jezdziecki_ID int  NOT NULL,
    CONSTRAINT Trener_pk PRIMARY KEY (ID)
) ;

-- Table: Wlasciciel_klub
CREATE TABLE Wlasciciel_klub (
    Klub_jezdziecki_ID int  NOT NULL,
    Wlasciciel_konia_ID int  NOT NULL,
    Data_dolaczenia date  NOT NULL,
    Data_wystapienia date  NULL,
    CONSTRAINT Wlasciciel_klub_pk PRIMARY KEY (Klub_jezdziecki_ID,Wlasciciel_konia_ID)
) ;

-- Table: Wlasciciel_konia
CREATE TABLE Wlasciciel_konia (
    ID int  NOT NULL,
    Osoba_ID int  NOT NULL,
    CONSTRAINT Wlasciciel_konia_pk PRIMARY KEY (ID)
) ;

-- Table: Zawody_kon
CREATE TABLE Zawody_kon (
    Zawody_skokowe_ID int  NOT NULL,
    Pozycja_w_zawodach int  NOT NULL,
    Nagroda_ID int  NULL,
    Kon_ID int  NOT NULL,
    CONSTRAINT Zawody_kon_pk PRIMARY KEY (Zawody_skokowe_ID,Kon_ID)
) ;

-- Table: Zawody_skokowe
CREATE TABLE Zawody_skokowe (
    ID int  NOT NULL,
    Data date  NOT NULL,
    Stadnina_ID int  NOT NULL,
    CONSTRAINT Zawody_skokowe_pk PRIMARY KEY (ID)
) ;

-- foreign keys
-- Reference: Horse_Rasa (table: Kon)
ALTER TABLE Kon ADD CONSTRAINT Horse_Rasa
    FOREIGN KEY (Rasa_ID)
    REFERENCES Rasa (ID);

-- Reference: Horse_Stadnina (table: Kon)
ALTER TABLE Kon ADD CONSTRAINT Horse_Stadnina
    FOREIGN KEY (Stadnina_ID)
    REFERENCES Stadnina (ID);

-- Reference: Horse_Wlasciciel_konia (table: Kon)
ALTER TABLE Kon ADD CONSTRAINT Horse_Wlasciciel_konia
    FOREIGN KEY (Wlasciciel_konia_ID)
    REFERENCES Wlasciciel_konia (ID);

-- Reference: Klub_zawody_Klub_jezdziecki (table: Klub_zawody)
ALTER TABLE Klub_zawody ADD CONSTRAINT Klub_zawody_Klub_jezdziecki
    FOREIGN KEY (Klub_jezdziecki_ID)
    REFERENCES Klub_jezdziecki (ID);

-- Reference: Klub_zawody_Zawody_skokowe (table: Klub_zawody)
ALTER TABLE Klub_zawody ADD CONSTRAINT Klub_zawody_Zawody_skokowe
    FOREIGN KEY (Zawody_skokowe_ID)
    REFERENCES Zawody_skokowe (ID);

-- Reference: Stajnia_Klub_jezdziecki (table: Stadnina)
ALTER TABLE Stadnina ADD CONSTRAINT Stajnia_Klub_jezdziecki
    FOREIGN KEY (Klub_jezdziecki_ID)
    REFERENCES Klub_jezdziecki (ID);

-- Reference: Stajnia_Lokalizacja (table: Stadnina)
ALTER TABLE Stadnina ADD CONSTRAINT Stajnia_Lokalizacja
    FOREIGN KEY (Lokalizacja_ID)
    REFERENCES Lokalizacja (ID);

-- Reference: Trener_Klub_jezdziecki (table: Trener)
ALTER TABLE Trener ADD CONSTRAINT Trener_Klub_jezdziecki
    FOREIGN KEY (Klub_jezdziecki_ID)
    REFERENCES Klub_jezdziecki (ID);

-- Reference: Trener_Osoba (table: Trener)
ALTER TABLE Trener ADD CONSTRAINT Trener_Osoba
    FOREIGN KEY (Osoba_ID)
    REFERENCES Postac (ID);

-- Reference: Wlasciciel_klub_k (table: Wlasciciel_klub)
ALTER TABLE Wlasciciel_klub ADD CONSTRAINT Wlasciciel_klub_k
    FOREIGN KEY (Klub_jezdziecki_ID)
    REFERENCES Klub_jezdziecki (ID);

-- Reference: Wlasciciel_konia_Osoba (table: Wlasciciel_konia)
ALTER TABLE Wlasciciel_konia ADD CONSTRAINT Wlasciciel_konia_Osoba
    FOREIGN KEY (Osoba_ID)
    REFERENCES Postac (ID);

-- Reference: Wlasciciel_wlasciciel (table: Wlasciciel_klub)
ALTER TABLE Wlasciciel_klub ADD CONSTRAINT Wlasciciel_wlasciciel
    FOREIGN KEY (Wlasciciel_konia_ID)
    REFERENCES Wlasciciel_konia (ID);

-- Reference: Zawody_kon_Kon (table: Zawody_kon)
ALTER TABLE Zawody_kon ADD CONSTRAINT Zawody_kon_Kon
    FOREIGN KEY (Kon_ID)
    REFERENCES Kon (ID);

-- Reference: Zawody_kon_Nagroda (table: Zawody_kon)
ALTER TABLE Zawody_kon ADD CONSTRAINT Zawody_kon_Nagroda
    FOREIGN KEY (Nagroda_ID)
    REFERENCES Nagroda (ID);

-- Reference: Zawody_kon_Zawody_skokowe (table: Zawody_kon)
ALTER TABLE Zawody_kon ADD CONSTRAINT Zawody_kon_Zawody_skokowe
    FOREIGN KEY (Zawody_skokowe_ID)
    REFERENCES Zawody_skokowe (ID);

-- Reference: Zawody_skokowe_Stadnina (table: Zawody_skokowe)
ALTER TABLE Zawody_skokowe ADD CONSTRAINT Zawody_skokowe_Stadnina
    FOREIGN KEY (Stadnina_ID)
    REFERENCES Stadnina (ID);

-- End of file.

--Rasa
INSERT INTO rasa VALUES (1, 'Hanower');
INSERT INTO rasa VALUES (2, 'Hucul');
INSERT INTO rasa VALUES (3, 'Arab');
INSERT INTO rasa VALUES (4, 'Mustang');
INSERT INTO rasa VALUES (5, 'Haflinger');

--Osoba
INSERT INTO postac VALUES (1, 'Adrianna', 'Gabrys', 'kobieta', 21);
INSERT INTO postac VALUES (2, 'Katarzyna', 'Kowalczyk', 'kobieta', 30);
INSERT INTO Postac VALUES (3, 'Krzysztof', 'Nowak', 'mezczyzna', 45);
INSERT INTO Postac VALUES (4, 'Anna', 'Cieslar', 'kobieta', 54);
INSERT INTO Postac VALUES (5, 'Piotr', 'Kaleta', 'mezczyzna', 17);
INSERT INTO Postac VALUES (6, 'Hanna', 'Zawada', 'kobieta', 23);
INSERT INTO Postac VALUES (7, 'Alicja', 'Leman', 'kobieta', 21);
INSERT INTO	Postac VALUES (8, 'Pawel', 'Nic', 'mezczyzna', 25);
INSERT INTO Postac VALUES (9, 'Karolina', 'Wojt', 'kobieta', 33);
INSERT INTO Postac VALUES (10, 'Maria', 'Puczek', 'kobieta', 16);
INSERT INTO Postac VALUES (11, 'Maja', 'Bas', 'kobieta', 18);
INSERT INTO Postac VALUES (12, 'Sara', 'Kot', 'kobieta', 22);
INSERT INTO Postac VALUES (13, 'Jan', 'Got', 'mezczyzna', 34);


--Klub jeŸdziecki
INSERT INTO klub_jezdziecki VALUES (1, 'Podkowa');
INSERT INTO klub_jezdziecki VALUES (2, 'Happy Horse');
INSERT INTO klub_jezdziecki VALUES (3, 'Patataj');
INSERT INTO klub_jezdziecki VALUES (4, 'Konikowo');
INSERT INTO klub_jezdziecki VALUES (5, 'Kucykowo');

--Lokalizacja
INSERT INTO lokalizacja VALUES (1, 'Polska', 'Warszawa','Maja', 10);
INSERT INTO lokalizacja VALUES (2, 'Polska', 'Warszawa','Zamkowa', 35);
INSERT INTO lokalizacja VALUES (3, 'Polska', 'Puck','Lotnik', 2);
INSERT INTO lokalizacja VALUES (4, 'Polska', 'Sopot','Stroma', 101);
INSERT INTO lokalizacja VALUES (5, 'Polska', 'Warszawa','Wysoka', 202);

--Stadnina
INSERT INTO stadnina VALUES (1,'Konikowy Raj', 100, 1, 1);
INSERT INTO stadnina VALUES (2,'Stara Stadnina',300, 2, 2);
INSERT INTO stadnina VALUES (3,'Dworek', 250, 3, 3);
INSERT INTO stadnina VALUES (4,'Trawa', 400, 4, 4);
INSERT INTO stadnina VALUES (5,'Galop', 135, 5, 5);

--Trener
INSERT INTO trener VALUES (1,1,1);
INSERT INTO trener VALUES (2,2,2);
INSERT INTO trener VALUES (3,3,3);
INSERT INTO trener VALUES (4,4,4);
INSERT INTO trener VALUES (5,5,5);

--W³aœciciel konia
INSERT INTO wlasciciel_konia VALUES (1,6);
INSERT INTO wlasciciel_konia VALUES (2,7);
INSERT INTO wlasciciel_konia VALUES (3,8);
INSERT INTO wlasciciel_konia VALUES (4,9);
INSERT INTO wlasciciel_konia VALUES (5,10);
INSERT INTO wlasciciel_konia VALUES (6,11);
INSERT INTO wlasciciel_konia VALUES (7,12);
INSERT INTO wlasciciel_konia VALUES (8,13);

--Koñ
INSERT INTO kon VALUES (1, 'Hera', 6, 'klacz', To_DATE('12/12/2015','DD/MM/YYYY'), 1, 1, 1);
INSERT INTO kon VALUES (2, 'Demeter', 7, 'klacz', To_DATE('10/12/2014','DD/MM/YYYY'), 1, 1, 1);
INSERT INTO kon VALUES (3, 'Kronos', 8, 'ogier', To_DATE('05/06/2013','DD/MM/YYYY'), 2, 2, 1);
INSERT INTO kon VALUES (4, 'Ares', 5, 'ogier', To_DATE('12/07/2016','DD/MM/YYYY'), 3, 2, 1);
INSERT INTO kon VALUES (5, 'Atena', 16, 'klacz', To_DATE('07/12/2005','DD/MM/YYYY'), 4, 3, 1);
INSERT INTO kon VALUES (6, 'Hades', 6, 'ogier', To_DATE('03/10/2015','DD/MM/YYYY'), 5, 1, 2);
INSERT INTO kon VALUES (7, 'Zeus', 6, 'ogier', To_DATE('12/11/2015','DD/MM/YYYY'), 6, 5, 2);
INSERT INTO kon VALUES (8, 'Apollo', 10, 'ogier', To_DATE('05/03/2011','DD/MM/YYYY'), 7, 4, 2);
INSERT INTO kon VALUES (9, 'Hestia', 6, 'klacz', To_DATE('08/12/2015','DD/MM/YYYY'), 8, 2, 2);
INSERT INTO kon VALUES (10, 'Afrodyta', 7, 'klacz', To_DATE('18/09/2014','DD/MM/YYYY'), 8, 3, 2);

--W³aœciciel_Klub
INSERT INTO wlasciciel_klub VALUES (1,1,To_DATE('12/12/2014','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (1,2,To_DATE('12/12/2013','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (1,3,To_DATE('02/02/2000','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (1,4,To_DATE('04/11/2014','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (2,5,To_DATE('25/07/2009','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (2,6,To_DATE('25/07/2008','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (2,7,To_DATE('20/07/2004','DD/MM/YYYY'),null);
INSERT INTO wlasciciel_klub VALUES (2,8,To_DATE('21/07/2016','DD/MM/YYYY'),null);

--Zawody skokowe
INSERT INTO zawody_skokowe VALUES (1,To_DATE('08/12/2021','DD/MM/YYYY'), 1);
INSERT INTO zawody_skokowe VALUES (2,To_DATE('10/12/2020','DD/MM/YYYY'), 1);
INSERT INTO zawody_skokowe VALUES (3,To_DATE('10/08/2019','DD/MM/YYYY'), 1);
INSERT INTO zawody_skokowe VALUES (4,To_DATE('11/08/2018','DD/MM/YYYY'), 1);
INSERT INTO zawody_skokowe VALUES (5,To_DATE('12/08/2017','DD/MM/YYYY'), 2);

--Nagroda
INSERT INTO nagroda VALUES (1, 5000, 'zloto');
INSERT INTO nagroda VALUES (2, 4000, 'srebro');
INSERT INTO nagroda VALUES (3, 3000, 'braz');
INSERT INTO nagroda VALUES (4, 10000, 'zloto');
INSERT INTO nagroda VALUES (5, 9000, 'srebro');
INSERT INTO nagroda VALUES (6, 6000, 'braz');


--Zawody_kon 
INSERT INTO zawody_kon VALUES (1,1,1,1);
INSERT INTO zawody_kon VALUES (1,2,2,2);
INSERT INTO zawody_kon VALUES (1,3,3,3);
INSERT INTO zawody_kon VALUES (2,1,4,4);
INSERT INTO zawody_kon VALUES (2,2,5,5);
INSERT INTO zawody_kon VALUES (2,3,6,6);
INSERT INTO zawody_kon VALUES (2,6,null,2);
INSERT INTO zawody_kon VALUES (2,4,null,1);

--Klub_zawody
INSERT INTO klub_zawody VALUES (2,1);
INSERT INTO klub_zawody VALUES (3,1);
INSERT INTO klub_zawody VALUES (1,2);
INSERT INTO klub_zawody VALUES (2,2);

