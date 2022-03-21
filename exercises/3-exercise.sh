cd ..
rm -rf ejercicio3
mkdir ejercicio3
cd ejercicio3
git init

touch hello.txt
echo "Hello World" > hello.txt
git add .
git commit -m "Commit inicial"
echo "Hello World" >> hello.txt
git add .
git commit -m "Segundo commit"
echo "Hello World" >> hello.txt
git add .
git commit -m "Tercer commit"

git checkout -b feature/nueva-rama
git checkout master