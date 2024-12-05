function [Input,Output,Target]=ValoresIOT(Data,W,i)
Input= [Data(i,1:end-1),-1]; %valores x1,xi
Target=Data(i,end); %clasificación
%a data concatenarle un -1
Output= Signo(Input*W);
end