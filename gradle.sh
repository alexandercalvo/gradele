#!/bin/bash
#Autor Alexander Calvo

echo "****************************************************************************************************"
echo "******************************** Aplicaciones Java Con Gradle **************************************"
echo "****************************************************************************************************"
echo ""
echo "Selecione Una Opción"
echo " 1. Aplicación sencilla"
echo " 2. Aplicación Web"
echo " 3. Aplicacion Servlet"
ruta=""
opcion=""
artifact=""
grupId=""
clasName=""
types=""
dependencies=""
jar=""
principal="";
application=""

webxml=''

jsp="<html>\n<body>\n<h2>Hello World!</h2>\n</body>\n</html>"
read -p "" opcion
read -p "Indique la ruta " ruta
read -p "Indique el AtifactId " artifact
read -p "Nombre Clase Principal" clasName
read -p "Indique el grup id " grupId

mkdir -p $ruta/$artifact
cd $ruta/$artifact
mkdir -p src/main/java
mkdir -p src/main/resources
 IFS="."
 read -ra package <<< "$grupId"
for val in "${package[@]}";
do
    principal+="$val/"
done


mkdir -p src/main/java/$principal
mkdir -p src/test/java/$principal

touch src/main/java/$principal$clasName.java
touch build.gradle
echo -e "package $grupId;\n
public class $clasName{\n
\tpublic static void main(String[] args) { \n
\t\t System.out.println(\"HOLA MUNDO\");\n
\t}\n
    
}">>src/main/java/$principal$clasName.java
case $opcion in
    1) types="application" dependencies="implementation 'joda-time:joda-time:2.2'\ntestImplementation group: 'org.junit.jupiter', name: 'junit-jupiter-api', version: '5.8.2' " 
        jar="jar {\narchiveBaseName='$clasName'\narchiveVersion='1.0'\n}" application="application {\n\tmainClass = '$grupId.$clasName'\n}\n";;
    2) types="war" dependencies="compileOnly group: 'jakarta.platform', name: 'jakarta.jakartaee-api', version: '9.1.0' \n \t
        compileOnly group: 'jakarta.servlet', name: 'jakarta.servlet-api', version: '6.0.0'\n 
        testImplementation group: 'org.junit.jupiter', name: 'junit-jupiter-api', version: '5.8.2'"
        mkdir -p src/main/webapp/WEB-INF  
        #touch src/main/webapp/WEB-INF/web.xml touch src/main/webapp/index.jsp 
        echo -e "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<web-app xmlns=\"https://jakarta.ee/xml/ns/jakartaee\" \n\t\t xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n\t\txsi:schemaLocation=\"https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd\"\n\t\tversion=\"5.0\"\n\t\t metadata-complete = \"false\"\n>\n</web-app> ">>src/main/webapp/WEB-INF/web.xml 
        echo -e $jsp>>src/main/webapp/index.jsp;;
        
    3) echo "Selecionaste Java Servet";;
    [4-9]) echo "Opcion no valido";;
    *) echo "no existe la opcion";;
esac
echo -e "plugins{
    id 'java'
    id '$types'
}
     
sourceCompatibility=11
targetCompatibility=11
    
repositories{
    mavenCentral()
}

dependencies{
    $dependencies
}

testing {
    suites {
        test {
            useJUnitJupiter('5.8.1')
        }
    }
}

$application

$jar      

">>build.gradle

gradle tasks
gradle build
chmod og+wrx
