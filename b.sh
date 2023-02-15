for i in a,b c_s,d ; do 
  KEY=${i%,*};
  VAL=${i#*,};
  echo $KEY" XX "$VAL;
done
