# Exercice 1

cd /home/omorienjoyer/PPE1-2526/Exercice1/ann

echo "Nombre de Lieux en 2016"
cat 2016/*.ann | grep Location | wc -l 
echo "Nombre de Lieux en 2017"
cat 2017/*.ann | grep Location | wc -l
echo "Nombre de Lieux en 2O18"
cat 2018/*.ann | grep Location | wc -l




