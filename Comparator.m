

function[E, G, L, result] = Comparator(number_1, number_2)


num1_Length = length(number_1);
num2_Length = length(number_2);
if (num1_Length < num2_Length)
        amount = num2_Length - num1_Length;
        for i = 1:amount
            number_1 = [0 number_1];
        end
    elseif(num1_Length > num2_Length)
        amount = num1_Length - num2_Length;
        for i = 1:amount
            number_2 = [0 number_2];
        end
end

%% gate level implementation
%intialize the variabels
num1_Length = length(number_1);
x = zeros(1,num1_Length);
y = zeros(1,num1_Length);
E = 1;
G = 0;

%equal case
for i = 1:num1_Length
    x(i) = ~xor(number_1(i),number_2(i));
    E = E & x(i);
end

% Greater case
for i = 1:num1_Length
    y(i) = number_1(i) & (~number_2(i));
    if( i > 1)
        for j = 1 : i - 1
            y(i) = y(i) & x(j);
        end
    end
    G = G | y(i);
end

% Lower case
L = ~(G | E);

if (E)
    result = "The two numbers are equal";
elseif (G)
    result = "the first number is greater";
elseif(L)
    result = "the first number is smaller";
end

end



