# Quine-McCluskey-Algorithm-in-Matlab
This file implements Quine McCluskey Algorithm used for minimization of Boolean functions.

At first, We need to set the minterm and don't care term on the top of the code. Then run the file and result will be printed on the command window.

There are some examples and test data in the following. In fact, it also works for more than 6 variables. 

## 4, 5, 6 variables and should consider  “ Don’t Care ”

For example:

f(a, b, c, d) = m(0, 2, 4, 5, 6, 9, 10) + d(7, 11, 12, 13 ,14, 15)

- Input :     
        - minterm type    
        - Variable_number = 4     
        - m = [0, 2, 4, 5, 6, 9, 10]  
        - d = [7, 11, 12, 13 ,14, 15]
        
 - Output : logic type      
        - f(a, b, c, d) = a’d’ + b + ad + cd’  or a’d’ + b + ad + ac 
        
## some test data

### 4 variables:

- m = [0, 1, 5, 8, 10 ,13, 15]
    - Sol:  ab’d’ + abd +  a’b’c’ + a’c’d   or  
        ab’d’ + abd +  a’b’c’ + bc’d    or  
        ab’d’ + abd +  b’c’d’ + a’c’d  
- m = [4, 8, 10, 11, 12, 15], 
  d = [9, 14]     
    - Sol:  bc’d’ + ac + ab’ or         bc’d’ + ac + ad’ 
- m = [4, 6, 9, 10, 11, 13], 
  d = [2, 12, 15] 
    - Sol:  ad + a’bd’ + b’cd’  or          ad + a’bd’ + ab’c

### 5 variables:

- m : [ 4, 6, 9 ,10, 11, 13, 18, 20, 22 ], 
    d : [ 2, 12, 15, 21 ] 
	- Sol : a’be + b’de’ + b’ce’ + a’c’de’ or   
		 a’be + b’de’ + b’ce’ + a’bc’d  
- m : [0, 1, 2, 4, 5, 6, 10, 13, 14, 18, 21, 22, 24, 26, 29, 30, 31]
    - Sol : a’b’d’ + de’ + cd’e + abc’e’ + abcd or  
        a’b’d’ + de’ + cd’e + abc’e’ + abce

### 6 variables:

- m : [ 4, 6, 7, 8,13, 15, 20, 21, 22, 23, 29, 30, 33, 37, 38, 39, 40, 49, 53, 55 ], 
	d : [ 5, 10, 18, 26, 31, 36, 42, 52, 54, 60, 61 ] 
	- Sol :  c’d + a’df + b’cd’f’ + ac’e’f + a’bef’ or  
		  c’d + a’df + b’cd’f’ + ac’e’f + a’bde
- m : [ 6, 9, 13, 18, 19, 25, 27, 29, 41, 45, 57, 61 ] 
    - Sol :  a’b’c’def’ + ce’f + a’bc’d’e + a’bd’ef or  
            a’b’c’def’ + ce’f + a’bc’d’e + a’bcd’f
