import csv

def generator():
    
    output=open("populationScript.sql","w")

    output.write("----> Populacion de Puestos\n")
    file=open("Puestos.csv",'r')
    for line in file:
        line=line.replace('\n','');
        line=line.split(',')
        output.write("INSERT INTO Puesto(Nombre,Descripcion) VALUES('"+line[0]+"','"+line[1]+"');\n")
    output.write("\n\n\n")

    output.write("----> Populacion de Planilla\n")
    file=open("Planilla.csv",'r')
    for line in file:
        line=line.replace('\n','');
        line=line.split(',')
        output.write("INSERT INTO Planilla(Nombre,Descripcion) VALUES('"+line[0]+"','"+line[1]+"');\n")
    output.write("\n\n\n")

    output.write("----> Populacion de Equipos\n")
    file=open("Equipos.csv",'r')
    for line in file:
        line=line.replace('\n','');
        line=line.split(',')
        output.write("INSERT INTO Tipo_Equipo(Nombre,Descripcion) VALUES('"+line[0]+"','"+line[1]+"');\n")
    output.write("\n\n\n")

    output.write("----> Populacion de Servicios")
    file=open("Servicios.csv",'r')
    for line in file:
        line=line.replace('\n','');
        line=line.split(',')
        output.write("INSERT INTO Tipo_Servicio(Nombre,Descripcion) VALUES('"+line[0]+"','"+line[1]+"');\n")
    output.write("\n\n\n")

    output.write("----> Populacion de Tratamientos Spa")
    file=open("Tratamientos_Spa.csv",'r')
    for line in file:
        line=line.replace('\n','');
        line=line.split(',')
        output.write("INSERT INTO Tratamiento_Spa(Nombre) VALUES('"+line[0]+"');\n")
    output.write("\n\n\n")
generator()
