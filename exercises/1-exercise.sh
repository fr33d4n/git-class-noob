cd ..
mkdir ejercicio1
cd ejercicio1
git init

touch hello.txt
echo "Hello World" > hello.txt
git add .
git commit -m "Commit inicial"
git tag v1.0
echo "\nHola mundo" >> hello.txt
git add .
git commit -m "Anadido un Hola mundo"
touch test.txt
echo "For testing purposes" > test.txt
rm hello.txt
git add .
git commit -m "Fichero de test introducido"
git tag v2.0