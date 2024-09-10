
clear
clc

%% take input 
choose = 0;
choose = input("enter 0 for singel compare and 1 for files: ");

%%single compare part
if(choose == 0)
    number1 = input("enter the first nummber: ");
    number2 = input("enter the second number: ");
    number1 = int64(number1);
    number2 = int64(number2);
    
    num1 = number1;
    num2 = number2;
    
    num1_Length = 0; 
    num2_Length = 0;
    % count the number of bits
    while(num1 > 0)
        num1 = num1 / 10;
        num1_Length = num1_Length + 1;
    end

    while(num2 > 0)
        num2 = num2 / 10;
        num2_Length = num2_Length + 1;
    end
    
    
    % CONVERT  the input into  a array
    i = 0; 
    while(number1 > 0)
        number_1(num1_Length - i) = mod(number1, 10);
        number1 = number1 / 10;
        i = i + 1;
    end
    
    i = 0;
    while(number2 > 0)
        number_2(num2_Length - i) = mod(number2, 10);
        number2 = number2 / 10;
        i = i + 1;
    end
    % handle the case of the length
    
    
    
     %% printing the results
    [E, G, L, result] = Comparator(number_1, number_2); % call the function
    [E2, G2, L2, result2] = Comparator(number_2, number_1); % call the function and reverse the order to get the other cases
    T = table(['number_1 > number_2';'number_1 = number_2';'number_1 < number_2';'number_2 > number_1';'number_2 < number_1'] ...
         ,[G; E; L; G2; L2]);
    %display the results
    disp(T);
    fprintf("%s\n", result);



    %% simulation  part for 3 bit numbers
    if(num1_Length <= 3 && num2_Length <=3) % make sure its  within the bounders of 3 bit binary numbers
        simulation = input(" Do you want to  see the gate level implementain? (if no write No)\n");
        if (simulation == "yes" || simulation =="Yes" || simulation ==  "YES")
            % handle the case  for the zeros  in the beginnig to avoid any
            % crash in the simulation running
            for i = 1:3-num1_Length
                number_1 = [0 number_1];
            end
            for i = 1:3-num2_Length
                number_2 = [0 number_2];
            end
            % intialize the time vector and prepare the bits for the read into
            % simulation process
            time = 1;  % necessary for the simin block
            number_1 = double(number_1);
            number_2 = double(number_2);
            num1_bit1 = [time, number_1(3)];
            num1_bit2 = [time, number_1(2)];
            num1_bit3 = [time, number_1(1)];
            num2_bit1 = [time, number_2(3)];
            num2_bit2 = [time, number_2(2)];
            num2_bit3 = [time, number_2(1)];
        
            % put the data in the workspace;
            assignin('base', 'num1_bit3', num1_bit3);
            assignin('base', 'num1_bit2', num1_bit2);
            assignin('base', 'num1_bit1', num1_bit1);
            assignin('base', 'num2_bit3', num2_bit3);
            assignin('base', 'num2_bit2', num2_bit2);
            assignin('base', 'num2_bit1', num2_bit1);
            pause(2)
        
            open_system('comparitor.slx'); % open simulink
            pause(2)
            sim('comparitor.slx');  % run the simulation

        else
            return;
        end

    else
        return;
    end



%%files part
else

    % input the path name assuming in same folder
    path_one = input("enter the path of the first file: ");
    path_two = input("enter the path of the secnod file: ");
    % first file settings
    opts = detectImportOptions(path_one, 'TextType', 'string');
    opts = setvartype(opts, 'Var1', 'string');
    % second file settings
    opts2 = detectImportOptions(path_two, 'TextType', 'string');
    opts2 = setvartype(opts2, 'Var1', 'string');
  

    %read data as strings to avoid missing data since its a binary data
    data1 = readtable(path_one, opts);
    data2 = readtable(path_two, opts2);
    data1 = table2array(data1);
    data2 = table2array(data2);
    d1 = data1;
    d2 = data2;
    data1 = str2double(data1);
    data2 = str2double(data2);
    
    % handle the case of unequality of the files length
    % loop  in the shortest file
    % ignore the elements in the long file above the max index of the shortest file 
    comp_length = length(data2);
    if(length(data1) > length(data2))
        comp_length = length(data2);
    else 
        comp_length = length(data1);
    end

    % intialize the result vector
    result = strings(comp_length, 1);
  
    for i = 1:comp_length
        num11 = int64(data1(i)); % assign as integer 
        num22 = int64(data2(i)); % assign as integer 
        num1 = int64(data1(i));
        num2 = int64(data2(i));
        num1_Length = 0;
        num2_Length = 0;
        while(num1 > 0)
            num1 = num1 / 10;
            num1_Length = num1_Length + 1;
        end
        j = 0;
        while(num11 > 0)
            fdata1(num1_Length - j) = mod(num11, 10);
            num11 = num11 / 10;
            j = j + 1;
        end

        while(num2 > 0)
            num2 = num2 / 10;
            num2_Length = num2_Length + 1;
        end
        j = 0;
        while(num22 > 0)
            fdata2(num2_Length - j) = mod(num22, 10);
            num22 = num22 / 10;
            j = j + 1;
        end
        [E, G, L, result(i,1)] = Comparator(fdata1, fdata2);
    end
   
    %display results
    T = table(d1, d2, result);
    disp(T);

end
