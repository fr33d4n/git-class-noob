cd ..
rm -rf ejercicio4
mkdir ejercicio4
cd ejercicio4
git init

touch hello.txt
echo "Hello World" > hello.txt
git add .
git commit -m "Commit inicial"
echo "\nBye World" >> hello.txt
git add .
git commit -m "Segundo commit"

git  checkout -b feature/rama1
echo "\nGit sux" >> hello.txt
git add .
git commit -m "Quinto commit"

git checkout master
git  checkout -b feature/rama2
echo "\nGit r00lz" >> hello.txt
git add .
git commit -m "Cuarto commit"

git checkout master
echo "\nLinus is a god" >> hello.txt
git add .
git commit -m "Tercer commit"
