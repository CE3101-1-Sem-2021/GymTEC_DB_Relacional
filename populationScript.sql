----> Populacion de Puestos
INSERT INTO Puesto(Nombre,Descripcion) VALUES('Administrador','Empleado encargado de la administracion del negocio.');
INSERT INTO Puesto(Nombre,Descripcion) VALUES('Instructor','Empleado encargado de brindar asistencia a los clientes con el uso de las maquinas y creacion de rutinas.');
INSERT INTO Puesto(Nombre,Descripcion) VALUES('Dependiente Spa','Empleado encargado de la atencion de clientes dentro del spa.');
INSERT INTO Puesto(Nombre,Descripcion) VALUES('Dependiente Tienda','Empleado encargado de la atencion de clientes dentro de la tienda del gimnasio.');



----> Populacion de Planilla
INSERT INTO Planilla(Nombre,Descripcion) VALUES('Pago Mensual','Pago por labores realizadas a lo largo de un mes');
INSERT INTO Planilla(Nombre,Descripcion) VALUES('Pago por Horas','Pago por labores realizadas por horas a lo largo de un mes');
INSERT INTO Planilla(Nombre,Descripcion) VALUES('Pago por Clase','Pago por clases impartidas a lo largo de un mes.');



----> Populacion de Equipos
INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('Cinta de Correr','Bandas electricas que permiten al usuario realizar ejercicios de atletismo de manera estatica');
INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('Bicicleta Estacionaria','Bicicletas elipticas que permiten realizar ejercicios de cardio');
INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('Multigimnasio','Estructura que incorpora multiples maquinas para realizar diferentes ejercicios ');
INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('Remos','Maquina diseñada para trabajar la zona de la espalda');
INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('Pesas','Mancuernas y otros equipos pra realizar ejercicios de levantamiento de peso');



----> Populacion de ServiciosINSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('Indoor Cycling','Sesion de ciclismo en bicicletas elipticas con diferentes dificultades');
INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('Pilates','Sesion clasica de pilates guiada por un instructor');
INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('Yoga','Sesion de yoga guiada por un instructor con diferentes niveles de dificultad');
INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('Zumba','Sesion de baile aerobicos guiada por un instructor');
INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('Natacion','Sesion y clases de natacion guiadas por un instructor en la piscina del gimnasio');



----> Populacion de Tratamientos SpaINSERT INTO Tratamiento_Spa(Nombre) VALUES('Masaje Relajante');
INSERT INTO Tratamiento_Spa(Nombre) VALUES('Masaje Descarga Muscular');
INSERT INTO Tratamiento_Spa(Nombre) VALUES('Sauna');
INSERT INTO Tratamiento_Spa(Nombre) VALUES('Baños a Vapor');



