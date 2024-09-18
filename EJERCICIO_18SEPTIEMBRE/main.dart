import 'dart:io';
void menu(){
  int opcion = 0;

  do {
    print("1. Crear cuenta");
    print("2. Consignar cuenta");
    print("3. Retirar cuenta");
    print("4. Consultar cuenta por codigo");
    print("5. Listar cuentas");
    print("6. salir cuenta");

    opcion = int.parse(stdin.readLineSync().toString());

    switch (opcion){
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
       break;
       
    }
    
  } while (opcion != 6);




}