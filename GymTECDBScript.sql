
--SELECT * FROM Puesto;
--SELECT * FROM Planilla;
--SELECT * FROM Tipo_Equipo;
--SELECT * FROM Tipo_Servicio;
--SELECT * FROM Tratamiento_Spa;
--SELECT * FROM Direccion;
--SELECT * FROM Empleado;
--SELECT * FROM Sucursal;
--SELECT * FROM Producto_Sucursal
--SELECT * FROM Clase
--SELECT * FROM Tratamiento_Sucursal

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
CREATE TABLE Sucursal_Horario
(
	Dia VARCHAR(15),
	Sucursal VARCHAR(20),
	Hora_Apertura TIME(0),
	Hora_Cierre TIME(0),
	PRIMARY KEY(Dia,Sucursal)
);

CREATE TABLE Cliente_Clase
(
	Id INT,
	Cliente VARCHAR(20),
	PRIMARY KEY(Id,Cliente)
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

ALTER TABLE Sucursal_Horario ADD CONSTRAINT FKSucursal_Horario FOREIGN KEY(Sucursal) REFERENCES Sucursal(Nombre) ON UPDATE CASCADE ON DELETE CASCADE;
GO


----------------------- GESTION DE ADMINISTRADORES---------------------------------

--Stored Procedure para obtener todos los administradores;
CREATE PROCEDURE selectAllAdmins
AS
SELECT * FROM Empleado WHERE Puesto='Administrador'
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE EMPLEADOS----------------------------------------

--Stored Procedure  para obtener todos los empleados registrados en la base de datos
CREATE PROCEDURE selectAllEmployees
AS
SELECT * FROM Empleado
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

--Stored Procedure para poder actualizar la informacion de un empleado en la base de datos
CREATE PROCEDURE updateEmployee
@CurrentId VARCHAR(20),
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
@Email VARCHAR(50)
AS
BEGIN
IF @Puesto IS NULL
	SET @Puesto='Sin Asignar'
IF @Planilla IS NULL
	SET @Planilla='Sin Asignar'

UPDATE Empleado SET Cedula=@Cedula,Puesto=@Puesto,Planilla=@Planilla,Distrito=@Distrito,Canton=@Canton,Provincia=@Provincia,Sucursal=@Sucursal,Nombre=@Nombre,Apellidos=@Apellidos,Salario=@Salario,Email=@Email WHERE Cedula=@CurrentId

END
GO

--Stored Procedure para poder eliminar un empleado de la base de datos.
CREATE PROCEDURE deleteEmployee
@Cedula VARCHAR(20)
AS
BEGIN

DELETE FROM Empleado WHERE Cedula=@Cedula

END

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

--Stored Procedure para añadir un horario a un gimnasio
CREATE PROCEDURE addSchedule
@Dia VARCHAR(15),
@Sucursal VARCHAR(20),
@Hora_Apertura TIME(0),
@Hora_Cierre TIME(0)
AS
BEGIN

INSERT INTO Sucursal_Horario(Dia,Sucursal,Hora_Apertura,Hora_Cierre) VALUES(@Dia,@Sucursal,@Hora_Apertura,@Hora_Cierre)

END
GO

--Stored Procedure para poder actualizar un horario de un gimnasio
CREATE PROCEDURE updateSchedule
@CurrentDay VARCHAR(15),
@Dia VARCHAR(15),
@Sucursal VARCHAR(20),
@Hora_Apertura TIME(0),
@Hora_Cierre TIME(0)
AS
BEGIN

UPDATE Sucursal_Horario SET Dia=@Dia,Sucursal=@Sucursal,Hora_Apertura=@Hora_Apertura,Hora_Cierre=@Hora_Cierre WHERE Dia=@CurrentDay

END
GO

--Stored Procedure para poder eliminar un horario de un gimnasio en particular
CREATE PROCEDURE deleteSchedule
@Dia VARCHAR(15),
@Sucursal VARCHAR(20)
AS
BEGIN

DELETE FROM Sucursal_Horario WHERE Dia=@Dia AND Sucursal=@Sucursal

END
GO

--Stored Procedure para obtener todos los horarios de un gimnasio en particular
CREATE PROCEDURE getAllSchedulesByGym
@Nombre VARCHAR(20)
AS
BEGIN

SELECT * FROM Sucursal_Horario WHERE Sucursal=@Nombre

END
GO
------------------------- FIN DE LA SECCION-----------------------------------------


----------------------- GESTION DE CLASES----------------------------------

--Stored Procedure para poder obtener todas las clases registradas en el sistema
CREATE PROCEDURE getAllClasses
AS
BEGIN

SELECT * FROM Clase

END
GO

--Stored Procedure para poder obtener una clase en particular
CREATE PROCEDURE getClass
@Id INT
AS
BEGIN

SELECT * FROM Clase WHERE Id=@Id

END
GO

--Stored Procedure para poder obtener todas las clases asociadas a un gimnasio en particular
CREATE PROCEDURE getClassesByGym
@Sucursal VARCHAR(20)
AS
BEGIN

SELECT * FROM Clase WHERE Sucursal=@Sucursal

END
GO

--Stored Procedure para poder crear una nueva clase 
CREATE PROCEDURE insertClass
@Hora_Inicio TIME(0),
@Fecha DATE,
@Tipo_Servicio VARCHAR(25),
@Hora_Final TIME(0),
@Sucursal VARCHAR(20),
@Instructor VARCHAR(20),
@Modalidad VARCHAR(10),
@Capacidad INT
AS
BEGIN

INSERT INTO Clase(Hora_Inicio,Fecha,Tipo_Servicio,Hora_Final,Sucursal,Instructor,Modalidad,Capacidad) VALUES(@Hora_Inicio,@Fecha,@Tipo_Servicio,@Hora_Final,@Sucursal,@Instructor,@Modalidad,@Capacidad)

END
GO

--Stored Procedure para poder actualizar la informacion de una clase ya registrada
CREATE PROCEDURE updateClass
@Id INT, 
@Hora_Inicio TIME(0),
@Fecha DATE,
@Tipo_Servicio VARCHAR(25),
@Hora_Final TIME(0),
@Sucursal VARCHAR(20),
@Instructor VARCHAR(20),
@Modalidad VARCHAR(10),
@Capacidad INT
AS
BEGIN

UPDATE Clase SET Hora_Inicio=@Hora_Inicio,Fecha=@Fecha,Tipo_Servicio=@Tipo_Servicio,Hora_Final=@Hora_Final,Sucursal=@Sucursal,Instructor=@Instructor,Modalidad=@Modalidad,Capacidad=@Capacidad WHERE Id=@Id

END
GO

--Stored Procedure para poder eliminar una clase ya registrada
CREATE PROCEDURE deleteClass
@Id INT
AS
BEGIN

DELETE FROM Clase WHERE Id=@Id

END
GO

--Stored Procedure para poder buscar clases para ciertos parametros

CREATE PROCEDURE searchClasses
@Hora_Inicio TIME(0),
@Fecha DATE,
@Tipo_Servicio VARCHAR(25),
@Hora_Final TIME(0),
@Sucursal VARCHAR(20)
AS
BEGIN

SELECT * FROM Clase WHERE (
(@Sucursal IS NULL OR Sucursal=@Sucursal) AND 
(@Fecha IS NULL OR Fecha=@Fecha) AND 
(@Tipo_Servicio IS NULL OR Tipo_Servicio=@Tipo_Servicio) AND 
(@Hora_Inicio IS NULL OR Hora_Inicio=@Hora_Inicio) AND 
(@Hora_Final IS Null OR Hora_Final=@Hora_Final)) 

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

--Stored Procedure para obtener todos los tratamientos asociados a una sucursal en particular
CREATE PROCEDURE getTreatmentsByGym
@Sucursal VARCHAR(20)
AS
BEGIN

SELECT Tratamiento_Spa.Id,Tratamiento_Spa.Nombre FROM 
(Sucursal JOIN (Tratamiento_Spa JOIN Tratamiento_Sucursal ON Tratamiento_Spa.Id=Tratamiento_Sucursal.Id_Tratamiento) ON Tratamiento_Sucursal.Sucursal=Sucursal.Nombre) 
WHERE Sucursal.Nombre=@Sucursal

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

--Stored Procedure para asignar un tratamiento de spa a una sede en especifico
CREATE PROCEDURE assignTreatment
@treatmentId INT,
@gymName VARCHAR(20)
AS
BEGIN

INSERT INTO Tratamiento_Sucursal(Id_Tratamiento,Sucursal) VALUES(@treatmentId,@gymName)

END
GO

--Stored Procedure para desasignar un tratamiento a una sucursal
CREATE PROCEDURE unsignTreatment
@treatmentId INT,
@gymName VARCHAR(20)
AS
BEGIN

DELETE FROM Tratamiento_Sucursal WHERE Id_Tratamiento=@treatmentId AND Sucursal=@gymName

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE PRODUCTOS----------------------------------

--Stored Procedure para obtener todos los productos registrados en la base de datos
CREATE PROCEDURE getAllProducts
AS
BEGIN

SELECT * FROM Producto

END
GO

--Stored Procedure para obtener un producto en particular
CREATE PROCEDURE getProduct
@CodigoBarras VARCHAR(50)
AS
BEGIN

SELECT * FROM Producto WHERE Codigo_Barras=@CodigoBarras

END
GO

--Stored Procedure para obtener los productos asociados a una sucursal en particular
CREATE PROCEDURE getProductsByGym
@Sucursal VARCHAR(20)
AS
BEGIN

SELECT * FROM 
(Sucursal JOIN (Producto_Sucursal JOIN Producto ON Producto_Sucursal.Codigo_Barras_Prod=Producto.Codigo_Barras) ON Sucursal.Nombre=Producto_Sucursal.Sucursal)
WHERE Sucursal.Nombre=@Sucursal

END
GO

--Stored Procedure para registrar un nuevo porducto en la base de datos
CREATE PROCEDURE createProduct
@Codigo_Barras VARCHAR(50),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(300),
@Costo NUMERIC(7,2)
AS
BEGIN

INSERT INTO Producto(Codigo_Barras,Nombre,Descripcion,Costo) VALUES (@Codigo_Barras,@Nombre,@Descripcion,@Costo)

END
GO

--Stored Procedure para actualizar un porducto en la base de datos
CREATE PROCEDURE updateProduct
@CurrentBarCode VARCHAR(50),
@Codigo_Barras VARCHAR(50),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(300),
@Costo NUMERIC(7,2)
AS
BEGIN

UPDATE Producto SET Codigo_Barras=@Codigo_Barras,Nombre=@Nombre,Descripcion=@Descripcion,Costo=@Costo WHERE Codigo_Barras=@CurrentBarCode

END
GO

--Stored Procedure para eliminar un producto de la base de datos
CREATE PROCEDURE deleteProduct
@BarCode VARCHAR(50)
AS
BEGIN

DELETE FROM Producto WHERE Codigo_Barras=@BarCode

END
GO

--Stored Procedure para poder asignar un producto a una sucursal
CREATE PROCEDURE assignProduct
@BarCode VARCHAR(50),
@GymName VARCHAR(20)
AS
BEGIN

INSERT INTO Producto_Sucursal(Codigo_Barras_Prod,Sucursal) VALUES(@BarCode,@GymName)

END
GO

--Stored Procedure para poder desasignar un producto de una sucursal
CREATE PROCEDURE unsignProduct
@BarCode VARCHAR(50),
@GymName VARCHAR(20)
AS
BEGIN

DELETE FROM Producto_Sucursal WHERE Codigo_Barras_Prod=@BarCode AND Sucursal=@GymName

END
GO

------------------------- FIN DE LA SECCION-----------------------------------------

----------------------- GESTION DE SERVICIOS----------------------------------

--Stored Procedure para obtener todos los servicios registrados
CREATE PROCEDURE getAllServices
AS
BEGIN

SELECT * FROM Tipo_Servicio

END
GO

--Stored Procedure  para obtener un servicio en particular
CREATE PROCEDURE getService
@Nombre VARCHAR(25)
AS 
BEGIN

SELECT * FROM Tipo_Servicio WHERE Nombre=@Nombre

END
GO

--Stored Procedure para crear un nuevo tipo de servicio
CREATE PROCEDURE createService
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES (@Nombre,@Descripcion)

END
GO

--Stored Procedure para actualizar un servicio
CREATE PROCEDURE updateService
@CurrentName VARCHAR(25),
@Nombre VARCHAR(25),
@Descripcion VARCHAR(200)
AS
BEGIN

UPDATE Tipo_Servicio SET Nombre=@Nombre,Descripcion=@Descripcion WHERE Nombre= @CurrentName

END
GO

--Stored Procedure para eliminar un servicio de la base de datos
CREATE PROCEDURE deleteService
@Nombre VARCHAR(25)
AS
BEGIN

DELETE FROM Tipo_Servicio WHERE Nombre=@Nombre

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


------------------------- TRIGGERS -------------------------------------------------

--Trigger para evitar que se eliminen/actualicen los tratamientos por default
CREATE TRIGGER modifyDeleteTreatment
ON Tratamiento_Spa
AFTER UPDATE,DELETE
AS
BEGIN
	DECLARE @treatmentName VARCHAR(25)
	DECLARE @treatmentId INT
	SELECT @treatmentName=deleted.Nombre FROM deleted
	SELECT @treatmentId=deleted.Id FROM deleted
	IF @treatmentName IN ('Masaje Relajante','Masaje Descarga Muscular','Sauna','Baños a Vapor')
	BEGIN
		RAISERROR('defaultTreatmentModification',16,1)
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT * FROM Tratamiento_Sucursal WHERE Id_Tratamiento=@treatmentId)
		BEGIN
			RAISERROR('assignedTreatment',16,1)
			ROLLBACK TRANSACTION
		END
	END
END
GO
--Trigger par determinar si el horario de una clase es correcto
CREATE TRIGGER verifySchedule
ON Clase
AFTER INSERT,UPDATE
AS
BEGIN
	DECLARE @horaInicio TIME(0)
	DECLARE @horaFinal TIME(0)
	SELECT @horaInicio=inserted.Hora_Inicio FROM inserted
	SELECT @horaFinal=inserted.Hora_Final FROM inserted
	
	IF @horaInicio>@horaFinal
	BEGIN

		RAISERROR('wrongSchedule',16,1)
		ROLLBACK TRANSACTION
		
	END

END
GO


------------------------- FIN DE LA SECCION-----------------------------------------
