module c

#flag -I @VMODROOT/HieroglyphVM/src
#flag @VMODROOT/HieroglyphVM/src/vm.c
#flag @VMODROOT/HieroglyphVM/src/loader.c
#flag @VMODROOT/HieroglyphVM/src/chunk.c
#flag @VMODROOT/HieroglyphVM/src/value.c
#flag @VMODROOT/HieroglyphVM/src/memory.c
#include "chunk.h"
#include "vm.h"

fn C.loadAndInterpret([]byte, int)
