USE master
CREATE DATABASE AulaCursor
GO
USE AulaCursor
GO
CREATE TABLE Cursos (
Codigo		INT ,
Nome		VARCHAR(100),
Duracao		INT
PRIMARY KEY (Codigo)
)
GO
INSERT INTO Cursos (Codigo, Nome, Duracao) VALUES
(48, 'Análise e Desenvolvimento de Sistemas', 2880),
(51, 'Logística', 2880),
(67, 'Polímeros', 2880),
(73, 'Comércio Exterior', 2600),
(94, 'Gestão Empresarial', 2600);
GO

CREATE TABLE Disciplinas (
Codigo  VARCHAR(10) ,
Nome NVARCHAR(100),
Carga_Horaria INT
PRIMARY KEY (Codigo)
)
GO
INSERT INTO Disciplinas (Codigo, Nome, Carga_Horaria) VALUES
('ALG001', 'Algoritmos', 80),
('ADM001', 'Administração', 80),
('LHW010', 'Laboratório de Hardware', 40),
('LPO001', 'Pesquisa Operacional', 80),
('FIS003', 'Física I', 80),
('FIS007', 'Físico Química', 80),
('CMX001', 'Comércio Exterior', 80),
('MKT002', 'Fundamentos de Marketing', 80),
('INF001', 'Informática', 40),
('ASI001', 'Sistemas de Informação', 80);
GO
CREATE TABLE Disciplina_Curso (
Codigo_Disciplina  VARCHAR(10),
Codigo_Curso    	INT
PRIMARY KEY (Codigo_Disciplina,Codigo_Curso)
FOREIGN KEY (Codigo_Disciplina) REFERENCES Disciplinas(Codigo),
FOREIGN KEY (Codigo_Curso) REFERENCES Cursos(Codigo)
)
GO
INSERT INTO Disciplina_Curso (Codigo_Disciplina, Codigo_Curso) VALUES
('ALG001', 48),
('ADM001', 48),
('ADM001', 51),
('ADM001', 73),
('ADM001', 94),
('LHW010', 48),
('LPO001', 51),
('FIS003', 67),
('FIS007', 67),
('CMX001', 51),
('CMX001', 73),
('MKT002', 51),
('MKT002', 94),
('INF001', 51),
('INF001', 73),
('ASI001', 48),
('ASI001', 94);

CREATE FUNCTION fn_info_curso (@codigo_curso INT)
RETURNS @tabela_info_curso TABLE (
    Codigo_Disciplina			VARCHAR(10),
    Nome_Disciplina				VARCHAR(100),
    Carga_Horaria_Disciplina	INT,
    Nome_Curso					VARCHAR(100)
)
AS
BEGIN
    DECLARE @Codigo_Disciplina		  VARCHAR(10),
            @Nome_Disciplina		  VARCHAR(100),
            @Carga_Horaria_Disciplina INT,
            @Nome_Curso			      VARCHAR(100)

    DECLARE c CURSOR FOR 
        SELECT dc.Codigo_Disciplina, d.Nome, d.Carga_Horaria, c.Nome
        FROM Disciplina_Curso dc
        INNER JOIN Disciplinas d ON dc.Codigo_Disciplina = d.Codigo
        INNER JOIN Cursos c ON dc.Codigo_Curso = c.Codigo
        WHERE dc.Codigo_Curso = @codigo_curso

    OPEN c
    FETCH NEXT FROM c INTO @Codigo_Disciplina, @Nome_Disciplina, @Carga_Horaria_Disciplina, @Nome_Curso

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO @tabela_info_curso (Codigo_Disciplina, Nome_Disciplina, Carga_Horaria_Disciplina, Nome_Curso)
        VALUES (@Codigo_Disciplina, @Nome_Disciplina, @Carga_Horaria_Disciplina, @Nome_Curso)

        FETCH NEXT FROM c INTO @Codigo_Disciplina, @Nome_Disciplina, @Carga_Horaria_Disciplina, @Nome_Curso
    END

    CLOSE c
    DEALLOCATE c

    RETURN
END

SELECT * FROM fn_info_curso(94) 