EX=$1
yasm -f elf64 -P ../../ebe/ebe.inc -g dwarf2 -l ${EX}.lst ${EX}.asm
gcc -o ${EX}.exe ${EX}.o
./${EX}.exe

