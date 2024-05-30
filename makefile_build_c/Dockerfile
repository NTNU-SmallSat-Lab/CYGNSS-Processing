FROM debian:buster-slim
 
RUN apt-get update && apt-get install --assume-yes build-essential libfftw3-dev
RUN apt-get upgrade
 
# NOTE: Folder RawIFData is here assumes to be under the current directory
# and should be moved to /app/ in same structure. Current belief
# is that program is executed from app, so path should be retained
COPY . /app/
 
WORKDIR /app
 
RUN make
 
CMD ["./CYGNSS_DDM_Processor"]