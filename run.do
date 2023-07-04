// this is the file for getting full coverage report from the design in compiler aldec riveria pro only.
vsim +access+r;
run -all;
acdb save;
acdb report -db  fcover.acdb -txt -o cov.txt -verbose  
exec cat cov.txt;
exit
