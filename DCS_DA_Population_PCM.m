clc
clear all
syms x

% Sampling
Pop_Data=readmatrix('Pop_AFG.csv'); 	% csv file contaning the density of Humans in Afghanistan
f=length(Pop_Data);
t=1:1:f;

% Plotting the Population Density Data
subplot(2,3,1);
plot(t,Pop_Data); 	
set(gca, 'FontName','Lexend Deca','FontSize', 13, 'FontWeight', 'bold');
title('Population Density','FontSize',15, 'FontWeight', 'bold');
xlabel('Years (from 1961)','FontSize',12, 'FontWeight', 'bold');
ylabel('Density of Species','FontSize',12, 'FontWeight', 'bold');

% Plotting Sampled Signal
subplot(2,3,2);
stem(Pop_Data); 	
set(gca, 'FontName','Lexend Deca','FontSize', 13, 'FontWeight', 'bold');
title('SAMPLED SIGNAL','FontSize',15, 'FontWeight', 'bold');
xlabel('Years (from 1961)','FontSize',12, 'FontWeight', 'bold');
ylabel('Density of Species','FontSize',12, 'FontWeight', 'bold');

% Modulation done Using PCM
% Quantization
n1=4;                                                 % Number of bits used in Quantization and Modulation
L=2^n1;                                               % Defining number of Quantizatonion Levels
xmax=56.93776001;                                     % Maximum Value of the population data
xmin=14.04498667;                                     % Minimum Value of the population data
del=(xmax-xmin)/L;                                    % Initialising the delta step value based on the Quantization Levels
partition=xmin:del:xmax;                              % Defining decision lines
codebook=xmin-(del/2):del:xmax+(del/2);               % Defining representation levels
[index,quants]=quantiz(Pop_Data,partition,codebook);  % gives rounded off values of the samples

% Plotting the Quanized Data
subplot(2,3,3);
stem(quants);
set(gca, 'FontName','Lexend Deca','FontSize', 13, 'FontWeight', 'bold');
title('QUANTIZED SIGNAL','FontSize',15, 'FontWeight', 'bold');
xlabel('Years (from 1961)','FontSize',12, 'FontWeight', 'bold');
ylabel('Density of Species','FontSize',12, 'FontWeight', 'bold');

% Normalization
l1=length(index);     			  % to convert 1 to n as 0 to n-1 indices
for i=1:l1
    if (index(i)~=0)
        index(i)=index(i)-1;
    end
end
l2=length(quants);
for i=1:l2 			%  to convert the end representation levels within the range.
    if(quants(i)==xmin-(del/2))
        quants(i)=xmin+(del/2);
    end
    if(quants(i)==xmax+(del/2))
        quants(i)=xmax-(del/2);
    end
end

%  Encoding
Code=de2bi(index,'left-msb'); 	% Decimal to Binanry Conversion of Indicies
k=1;
for i=1:l1                      % Converting column vector to row vector
    for j=1:n1
        Encoded_Data(k)=Code(i,j);
        j=j+1;
        k=k+1;
    end
    i=i+1;
end

% Plotting Digital Signal
subplot(2,3,4);
stairs(Encoded_Data);
set(gca, 'FontName','Lexend Deca','FontSize', 13, 'FontWeight', 'bold');
title('DIGITAL SIGNAL','FontSize',15, 'FontWeight', 'bold');
xlabel('Years (from 1961)','FontSize',12, 'FontWeight', 'bold');
ylabel('Density of Species','FontSize',12, 'FontWeight', 'bold');
axis([0 200 -0.1 1.1])

% Demodulation
code1=reshape(Encoded_Data,n1,(length(Encoded_Data)/n1));
index1=bi2de(code1,'left-msb');
resignal=del*index+xmin+(del/2);

% Plotting Demodulated Signal
subplot(2,3,5);
plot(resignal);
set(gca, 'FontName','Lexend Deca','FontSize', 13, 'FontWeight', 'bold');
title('DEMODULATAED SIGNAL','FontSize',15, 'FontWeight', 'bold');
xlabel('Years (from 1961)','FontSize',12, 'FontWeight', 'bold');
ylabel('Density of Species','FontSize',12, 'FontWeight', 'bold');