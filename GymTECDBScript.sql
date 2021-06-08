
--SELECT * FROM Puesto;
--SELECT * FROM Planilla;
--SELECT * FROM Tipo_Equipo;
--SELECT * FROM Tipo_Servicio;
--SELECT * FROM Tratamiento_Spa;
--SELECT * FROM Direccion;
--SELECT * FROM Empleado;
--SELECT * FROM Sucursal;

DELETE FROM Empleado WHERE Cedula='117320554'



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


----------------------- GESTION DE ADMINISTRADORES---------------------------------

--Stored Procedure para obtener todos los administradores;
CREATE PROCEDURE selectAllAdmins
AS
SELECT * FROM Empleado WHERE Puesto='Administrador'
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE EMPLEADOS----------------------------------------


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
------------------------- FIN DE LA SECCION-----------------------------------------


----------------------- GESTION DE MAQUINAS-----------------------------------------

--Stored Procedure para poder agregar una maquina al sistema
CREATE PROCEDURE insertMachine
@Serial VARCHAR(50),
@Tipo_Equipo VARCHAR(25),
@Sucursal VARCHAR(20),
@Marca VARCHAR(30),
@Costo NUMERIC(7,2)
AS
BEGIN

INSERT INTO Maquina(Serial,Tipo_Equipo,Sucursal,Marca,Costo) VALUES(@Serial,@Tipo_Equipo,@Sucursal,@Marca,@Costo)

END
GO

--Stored Procedure para poder modificar la informacion de una maquina
CREATE PROCEDURE updateMachine
@CurrentSerial VARCHAR(50),
@Serial VARCHAR(50),
@Tipo_Equipo VARCHAR(25),
@Sucursal VARCHAR(20),
@Marca VARCHAR(30),
@Costo NUMERIC(7,2)
AS
BEGIN

UPDATE Maquina SET Serial=@Serial,Tipo_Equipo=@Tipo_Equipo,Sucursal=@Sucursal,Marca=@Marca,Costo=@Costo WHERE Serial=@CurrentSerial

END
GO

--Stored Procedure para poder eliminar una maquina
CREATE PROCEDURE deleteMachine
@Serial VARCHAR(50)
AS
BEGIN

DELETE FROM Maquina WHERE Serial=@Serial

END
GO

--Stored Procedure para poder obtener todas las maquinas registradas en el sistema
CREATE PROCEDURE getAllMachines
AS
BEGIN

SELECT * FROM Maquina

END
GO

--Stored Procedure para poder obtener todas las maquinas asociadas a un gimnasio en particular
CREATE PROCEDURE getMachinesByGym
@Sucursal VARCHAR(20)
AS
BEGIN

SELECT * FROM Maquina WHERE Sucursal=@Sucursal

END
GO

--Stored Procedure para obtener la informacion particular de una maquina
CREATE PROCEDURE getMachine
@Serial VARCHAR(50)
AS
BEGIN

SELECT * FROM Maquina WHERE Serial=@Serial

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE GIMNASIOS----------------------------------------


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
------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE TIPOS DE EQUIPO----------------------------------

--Stored Procedure para obtener todos  los tipos de maquinas
CREATE PROCEDURE getAllMachineTypes
AS
BEGIN

SELECT * FROM Tipo_Equipo

END
GO

--Stored Procedure para obtener un tipo de maquina en particular
CREATE PROCEDURE getMachineType
@TypeName VARCHAR(25)
AS
BEGIN

SELECT * FROM Tipo_Equipo WHERE Nombre=@TypeName

END
GO

--Stored Procedure para crear un nuevo tipo de dispositivo
CREATE PROCEDURE insertMachineType
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES(@Nombre,@Descripcion)

END
GO

-- Stored Procedure para actualizar un tipo de maquina
CREATE PROCEDURE updateMachineType
@CurrentTypeName VARCHAR(25),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

UPDATE Tipo_Equipo SET Nombre=@Nombre,Descripcion=@Descripcion WHERE Nombre=@CurrentTypeName

END
GO

--Stored Procedure para eliminar un tipo de dispositivo 
CREATE PROCEDURE deleteMachineType
@Nombre VARCHAR(25)
AS
BEGIN

DELETE FROM Tipo_Equipo WHERE Nombre=@Nombre

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE PUESTOS----------------------------------

--Stored Procedure para obtener todos los puestos almacenados en la base de datos.
CREATE PROCEDURE gettAllJobs
AS
BEGIN

SELECT * FROM Puesto

END
GO

--Stored Procedure para obetner un puesto en particular
CREATE PROCEDURE getJob
@Nombre VARCHAR(25)
AS
BEGIN

SELECT * FROM Puesto WHERE Nombre=@Nombre

END
GO

-- Stored Procedure para crear un nuevo puesto 
CREATE PROCEDURE insertJob
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

INSERT INTO Puesto(Nombre,Descripcion) VALUES(@Nombre,@Descripcion)

END
GO

--Stored Procedure para actualizar un puesto dentro de la base de datos 
CREATE PROCEDURE updateJob
@CurrentName VARCHAR(25),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

UPDATE Puesto Set Nombre=@Nombre,Descripcion=@Descripcion WHERE Nombre=@CurrentName

END
GO

--Stored Procedure para poder eliminar un puesto de la base de datos
CREATE PROCEDURE deleteJob
@Nombre VARCHAR(25)
AS 
BEGIN

DELETE FROM Puesto WHERE Nombre=@Nombre

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE PLANILLAS----------------------------------

--Stored Procedure para poder obtener todos los tipos de planilla regitrados

CREATE PROCEDURE getAllPayrolls
AS
BEGIN

SELECT * FROM Planilla

END
GO

--Stored Procedure para poder obtener una planilla en particular
CREATE PROCEDURE getPayroll
@Nombre VARCHAR(25)
AS
BEGIN

SELECT * FROM Planilla WHERE Nombre=@Nombre

END
GO

--Stored Procedure para insertar un nuevo tipo de planilla en la base de datos
CREATE PROCEDURE insertPayRoll
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

INSERT INTO Planilla(Nombre,Descripcion) VALUES(@Nombre,@Descripcion)

END
GO

--Stored Procedure para modificar un tipo de planilla en la base de datos
CREATE PROCEDURE updatePayRoll
@CurrentName VARCHAR(25),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

UPDATE Planilla SET Nombre=@Nombre,Descripcion=@Descripcion WHERE Nombre=@CurrentName

END
GO

--Stored Procedure para poder eliminar un tipo de planilla registrado
CREATE PROCEDURE deletePayroll
@Nombre VARCHAR(25)
AS
BEGIN

DELETE FROM Planilla WHERE Nombre=@Nombre

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE TRATAMIENTOS DE SPA----------------------------------

--Stored Procedure para poder obtener todos los tratamientos de spa regitrados

CREATE PROCEDURE getAllTreatments
AS
BEGIN

SELECT * FROM Tratamiento_Spa

END
GO

--Stored Procedure para poder obtener un tratamiento de spa en particular
CREATE PROCEDURE getTreatment
@Id INT
AS
BEGIN

SELECT * FROM Tratamiento_Spa WHERE Id=@Id

END
GO

--Stored Procedure para insertar un nuevo tratamiento de spa en la base de datos
CREATE PROCEDURE insertTreatment
@Nombre VARCHAR(25)
AS
BEGIN

INSERT INTO Tratamiento_Spa(Nombre) VALUES(@Nombre)

END
GO

--Stored Procedure para modificar un tratamiento de spa en la base de datos
CREATE PROCEDURE updateTreatment
@CurrentId INT,
@Nombre VARCHAR(25)
AS
BEGIN

UPDATE Tratamiento_Spa SET Nombre=@Nombre WHERE Id=@CurrentId

END
GO

--Stored Procedure para poder eliminar un tratamiento de spa registrado
CREATE PROCEDURE deleteTreatment
@Id INT
AS
BEGIN

DELETE FROM Tratamiento_Spa WHERE Id=@Id

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- FUNCIONES MISCELANEAS---------------------------------------


--Stored procedure para asignar un token a un empleado
CREATE PROCEDURE assignTokenEmployee
@Token VARCHAR(32),
@Id VARCHAR(20)
AS
BEGIN
	UPDATE Empleado SET Token=@Token WHERE Cedula=@Id
END
GO
------------------------- FIN DE LA SECCION-----------------------------------------
