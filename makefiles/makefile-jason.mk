CC          = icpc
#CFLAGS     = -pg -fopenmp
FFTW_OPENMP = /projects/netpub/fftw_openmp/3.3.4
CFLAGS      = -O3 -openmp -math -Wall -I$(FFTW_OPENMP)/include
LIBS        = -openmp  -lm  -O3 -lfftw3_omp -lfftw3 -lpthread -L$(FFTW_OPENMP)/lib
DIM         = $(shell grep -e "^\#define Dim" globals.h | awk '{print $$NF}')
TARGET      = $(shell echo dmft-$$(git describe --tags)_$(DIM)d)


#############################################################################
# nothing should be changed below here

SRCS = time.cpp stress.cpp main.cpp matrix.cpp array_utils.cpp die.cpp \
       random.cpp grid_utils.cpp torque.cpp quanterions.cpp fftw_wrappers.cpp \
       initialize.cpp config_utils.cpp io_utils.cpp update_euler.cpp \
       update_positions.cpp forces.cpp integ_utils.cpp read_input.cpp \
       bonded.cpp calc_unb.cpp 
       
OBJS = ${SRCS:.cpp=.o}

.cpp.o:
	${CC} ${CFLAGS} ${DFLAGS} -c  $<

dmft:  ${OBJS}
	$(CC) ${CFLAGS} ${DFLAGS} -o $@ ${OBJS} $(LIBS)

commit: dmft
	cp dmft $(TARGET)

clean:
	rm -f *.o
	rm -f dmft
	rm -f *~
