cd ..
rm -rf ejercicio2
mkdir ejercicio2
cd ejercicio2
git init

touch hello.txt
echo "Hello World" > hello.txt
git add .
git commit -m "Commit inicial"
git tag v1.0
echo "\nHello World" >> hello.txt
git add .
git commit -m "Commit a eliminar"
echo "\nHola mundo" >> hello.txt
git add .
echo "\nAdios mundo" >> hello.txt
touch test1.txt
touch test2.txt