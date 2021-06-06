--SELECT * FROM Administrador;
--SELECT * FROM Puesto;
--SELECT * FROM Planilla;
--SELECT * FROM Tipo_Equipo;
--SELECT * FROM Tipo_Servicio;
--SELECT * FROM Tratamiento_Spa;
--SELECT * FROM Direccion;
--SELECT * FROM Empleado;
--SELECT * FROM Sucursal;





CREATE TABLE Administrador
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Email VARCHAR(50) NOT NULL UNIQUE,
	Nombre VARCHAR(20) NOT NULL,
	Apellidos VARCHAR(45) NOT NULL,
	Contraseña VARCHAR(50) NOT NULL,
	Salt VARCHAR(32) NOT NULL,
	Token VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE Empleado
(
	Cedula VARCHAR(20) PRIMARY KEY,
	Puesto VARCHAR(25) NOT NULL DEFAULT 'Sin Asignar',
	Planilla VARCHAR(25) NOT NULL DEFAULT 'Sin Asignar',
	Distrito VARCHAR(25) NOT NULL,
	Canton VARCHAR(25) NOT NULL,
	Provincia VARCHAR(25) NOT NULL,
	Sucursal VARCHAR(20),
	Nombre VARCHAR(20) NOT NULL,
	Apellidos VARCHAR(45) NOT NULL,
	Salario NUMERIC(7,2) NOT NULL,
	Email VARCHAR(50) NOT NULL UNIQUE,
	Contraseña VARCHAR(50) NOT NULL,
	Salt VARCHAR(32) NOT NULL,
	Token VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE Sucursal
(
	Nombre VARCHAR(20) PRIMARY KEY,
	Distrito VARCHAR(25) NOT NULL,
	Canton VARCHAR(25) NOT NULL,
	Provincia VARCHAR(25) NOT NULL,
	Fecha_Apertura DATE NOT NULL,
	Capacidad_Max INT NOT NULL,
	Gerente VARCHAR(20),
	Tienda_Act BIT DEFAULT 0,
	Spa_Act BIT DEFAULT 0
);

CREATE TABLE Clase
(
	Id INT IDENTITY(1,1) PRIMARY KEY, 
	Hora_Inicio TIME(0),
	Fecha DATE,
	Tipo_Servicio VARCHAR(25) NOT NULL,
	Hora_Final TIME(0) NOT NULL,
	Sucursal VARCHAR(20) NOT NULL,
	Instructor VARCHAR(20),
	Modalidad VARCHAR(10) NOT NULL,
	Capacidad INT NOT NULL
);

CREATE TABLE Maquina
(
	Serial VARCHAR(50) PRIMARY KEY,
	Tipo_Equipo VARCHAR(25) NOT NULL,
	Sucursal VARCHAR(20),
	Marca VARCHAR(30) NOT NULL,
	Costo NUMERIC(7,2) NOT NULL
);

CREATE TABLE Producto
(
	Codigo_Barras VARCHAR(50) PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL,
	Descripcion VARCHAR(300) NOT NULL,
	Costo NUMERIC(7,2)
);

CREATE TABLE Tratamiento_Spa
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Nombre VARCHAR(25) NOT NULL
);

CREATE TABLE Direccion
(
	Distrito VARCHAR(25),
	Canton VARCHAR(25),
	Provincia VARCHAR(25),
	PRIMARY KEY(Provincia,Canton,Distrito)
);

CREATE TABLE Puesto
(
	Nombre VARCHAR(25) PRIMARY KEY,
	Descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE Planilla
(
	Nombre VARCHAR(25) PRIMARY KEY,
	Descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE Producto_Sucursal
(
	Codigo_Barras_Prod VARCHAR(50),
	Sucursal VARCHAR(20),
	PRIMARY KEY(Codigo_Barras_Prod,Sucursal)
);
CREATE TABLE Sucursal_Telefono
(
	Telefono VARCHAR(20) PRIMARY KEY,
	Sucursal VARCHAR(20) NOT NULL
);

CREATE TABLE Cliente_Clase
(
	Id INT PRIMARY KEY,
	Hora_Inicio_Clase TIME,
	Fecha_Clase DATE,
	Tipo_Clase VARCHAR(25),
	Cliente VARCHAR(20),
);

CREATE TABLE Tratamiento_Sucursal
(
	Id_Tratamiento INT,
	Sucursal VARCHAR(20),
	PRIMARY KEY(Id_Tratamiento,Sucursal)
);

CREATE TABLE Tipo_Equipo
(
	Nombre VARCHAR(25) PRIMARY KEY,
	Descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE Tipo_Servicio
(
	Nombre VARCHAR(25) PRIMARY KEY,
	Descripcion VARCHAR(200) NOT NULL
);

ALTER TABLE Empleado ADD CONSTRAINT FKPuesto_Empleado FOREIGN KEY(Puesto) REFERENCES Puesto(Nombre) ON UPDATE CASCADE ON DELETE SET DEFAULT;
ALTER TABLE Empleado ADD CONSTRAINT FKPlanilla_Empleado FOREIGN KEY(Planilla) REFERENCES Planilla(Nombre) ON UPDATE CASCADE ON DELETE SET DEFAULT;
ALTER TABLE Empleado ADD CONSTRAINT FKDireccion_Empleado FOREIGN KEY(Provincia,Canton,Distrito) REFERENCES Direccion(Provincia,Canton,Distrito);
ALTER TABLE Empleado ADD CONSTRAINT FKSucursal_Empleado FOREIGN KEY(Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE Sucursal ADD CONSTRAINT FKDireccion_Sucursal FOREIGN KEY(Provincia,Canton,Distrito) REFERENCES Direccion(Provincia,Canton,Distrito);
ALTER TABLE Sucursal ADD CONSTRAINT FKGerente_Sucursal FOREIGN KEY (Gerente) REFERENCES Empleado(Cedula);-------> CREAR TRIGGER QUE SUSTITUYA ESTE CONSTRAINT(ON DELETE SET NULL ON UPDATE CASCADE)

ALTER TABLE Maquina ADD CONSTRAINT FKTipoEquipo_Maquina FOREIGN KEY(Tipo_Equipo) REFERENCES Tipo_Equipo(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Maquina ADD CONSTRAINT FKSucursal_Maquina FOREIGN KEY (Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE Clase ADD CONSTRAINT FKTipoServicio_Clase FOREIGN KEY(Tipo_Servicio) REFERENCES Tipo_Servicio(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Clase ADD CONSTRAINT FKSucursal_Clase FOREIGN KEY(Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Clase ADD CONSTRAINT FKInstructor_Clase FOREIGN KEY(Instructor) REFERENCES Empleado(Cedula) ;-------> CREAR TRIGGER QUE SUSTITUYA ESTE CONSTRAINT( ON UPDATE CASCADE ON DELETE SET NULL)

ALTER TABLE Producto_Sucursal ADD CONSTRAINT FKProducto_ProdSuc FOREIGN KEY(Codigo_Barras_Prod) REFERENCES Producto(Codigo_Barras) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Producto_Sucursal ADD CONSTRAINT FKSucursal_ProdSuc FOREIGN KEY (Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Tratamiento_Sucursal ADD CONSTRAINT FKIdTrat_TratSuc FOREIGN KEY(Id_Tratamiento) REFERENCES Tratamiento_Spa(Id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Tratamiento_Sucursal ADD CONSTRAINT FKSucursal_TratSuc FOREIGN KEY(Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Cliente_Clase ADD CONSTRAINT FKClase_ClientClase FOREIGN KEY (Id) REFERENCES Clase(Id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Sucursal_Telefono ADD CONSTRAINT FKSucursal_Telefono FOREIGN KEY (Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;
GO

--Stored Procedure para obtener todos los administradores;
CREATE PROCEDURE selectAllAdmins
AS
SELECT * FROM Administrador
GO

--Stored procedure para poder insertar un nuevo administrador
CREATE PROCEDURE insertAdmin
@Email VARCHAR(50),
@Nombre VARCHAR(20),
@Apellidos VARCHAR(45),
@Contraseña VARCHAR(50),
@Salt VARCHAR(32),
@Token VARCHAR(32)
AS
BEGIN
INSERT INTO Administrador(Email,Nombre,Apellidos,Contraseña,Salt,Token) VALUES(@Email,@Nombre,@Apellidos,@Contraseña,@Salt,@Token)
END
GO


--Stored procedure para poder insertar un nuevo empleado
CREATE PROCEDURE insertEmployee
@Cedula VARCHAR(20),
@Puesto VARCHAR(25),
@Planilla VARCHAR(25),
@Distrito VARCHAR(25),
@Canton VARCHAR(25),
@Provincia VARCHAR(25),
@Sucursal VARCHAR(20),
@Nombre VARCHAR(20),
@Apellidos VARCHAR(45),
@Salario NUMERIC(7,2),
@Email VARCHAR(50),
@Contraseña VARCHAR(50),
@Salt VARCHAR(32),
@Token VARCHAR(32)
AS
BEGIN

IF @Puesto IS NULL
	SET @Puesto='Sin Asignar'
IF @Planilla IS NULL
	SET @Planilla='Sin Asignar'

INSERT INTO Empleado(Cedula,Puesto,Planilla,Distrito,Canton,Provincia,Sucursal,Nombre,Apellidos,Salario,Email,Contraseña,Salt,Token) VALUES(@Cedula,@Puesto,@Planilla,@Distrito,@Canton,@Provincia,@Sucursal,@Nombre,@Apellidos,@Salario,@Email,@Contraseña,@Salt,@Token)
END
GO

--Stored procedure para poder insertar un nuevo gimnasio
CREATE PROCEDURE insertGym
@Nombre VARCHAR(20),
@Distrito VARCHAR(25),
@Canton VARCHAR(25),
@Provincia VARCHAR(25),
@Fecha_Apertura DATE,
@Capacidad_Max INT,
@Gerente VARCHAR(20)
AS
BEGIN

INSERT INTO Sucursal(Nombre,Distrito,Canton,Provincia,Fecha_Apertura,Capacidad_Max,Gerente) VALUES(@Nombre,@Distrito,@Canton,@Provincia,@Fecha_Apertura,@Capacidad_Max,@Gerente)

END
GO

--Stored procedure para actualizar los datos de un gimnasio
CREATE PROCEDURE updateGym
@Currentname VARCHAR(20),
@Nombre VARCHAR(20),
@Distrito VARCHAR(25),
@Canton VARCHAR(25),
@Provincia VARCHAR(25),
@Fecha_Apertura DATE,
@Capacidad_Max INT,
@Gerente VARCHAR(20)
AS
BEGIN

UPDATE Sucursal SET Nombre=@Nombre,Distrito=@Distrito,Canton=@Canton,Provincia=@Provincia,Fecha_Apertura=@Fecha_Apertura,Capacidad_Max=@Capacidad_Max,Gerente=@Gerente WHERE Nombre=@Currentname

END
GO

--Stored procedure para eliminar un gimnasio
CREATE PROCEDURE deleteGym
@Nombre VARCHAR(20)
AS
BEGIN

DELETE FROM Sucursal WHERE Nombre=@Nombre

END
GO

--Stored Procedure para obtener todos los gimnasios;
CREATE PROCEDURE selectAllGyms
AS
SELECT * FROM Sucursal
GO

--Stored Procedure para obtener un gimnasio en particular
CREATE PROCEDURE selectGym
@Nombre VARCHAR(20)
AS
SELECT * FROM Sucursal WHERE Nombre=@Nombre
GO

--Stored procedure para poder activar el spa de una sucursal en particular
CREATE PROCEDURE activateGymSpa
@State BIT,
@Nombre VARCHAR(20)
AS
UPDATE Sucursal SET Spa_Act=@State
GO

--Stored procedure para poder activar la tienda de una sucursal en particular
CREATE PROCEDURE activateGymStore
@State BIT,
@Nombre VARCHAR(20)
AS
UPDATE Sucursal SET Tienda_Act=@State
GO

--Stored Procedure para añadir un numero de telefono a un gimnasio
CREATE PROCEDURE addPhoneNumb
@Nombre VARCHAR(20),
@Telefono VARCHAR(20)
AS
BEGIN

INSERT INTO Sucursal_Telefono(Sucursal,Telefono) VALUES(@Nombre,@Telefono)

END
GO

--Stored Procedure para poder actualizar un numero de telefono de un gimnasio
CREATE PROCEDURE updatePhoneNumb
@CurrentNumb VARCHAR(20),
@Nombre VARCHAR(20),
@Telefono VARCHAR(20)
AS
BEGIN

UPDATE Sucursal_Telefono SET Sucursal=@Nombre,Telefono=@Telefono WHERE Telefono=@CurrentNumb

END
GO
--Stored Procedure para poder eliminar un numero de telefono de un gimnasio en particular
CREATE PROCEDURE deletePhoneNumb
@Telefono VARCHAR(20)
AS
BEGIN

DELETE FROM Sucursal_Telefono WHERE Telefono=@Telefono

END
GO

--Stored Procedure para obtener todoss los numeros de telefono de un gimnasio en particular
CREATE PROCEDURE getAllPhoneNumbByGym
@Nombre VARCHAR(20)
AS
BEGIN

SELECT * FROM Sucursal_Telefono WHERE Sucursal=@Nombre

END
GO


--Stored procedure para obtener un empleado por su cedula
CREATE PROCEDURE getEmployeeById
@Cedula VARCHAR(20)
AS
BEGIN

SELECT * FROM Empleado WHERE Cedula=@Cedula;

END
GO

--Stored procedure para obtener un empleado por su email
CREATE PROCEDURE getEmployeeByMail
@Email VARCHAR(50)
AS
BEGIN

SELECT * FROM Empleado WHERE Email=@Email;

END
GO

--Stored procedure para obtener un administrador por su email
CREATE PROCEDURE getAdminByMail
@Email VARCHAR(50)
AS
BEGIN

SELECT * FROM Administrador WHERE Email=@Email;

END
GO

--Stored procedure para asignar un token a un empleado
CREATE PROCEDURE assignTokenEmployee
@Token VARCHAR(32),
@Id VARCHAR(20)
AS
BEGIN
	UPDATE Empleado SET Token=@Token WHERE Cedula=@Id
END
GO

--Stored procedure para asignar un token a un administrador
CREATE PROCEDURE assignTokenAdmin
@Token VARCHAR(32),
@Id INT
AS
BEGIN
	UPDATE Administrador SET Token=@Token WHERE Id=@Id
END
GO
