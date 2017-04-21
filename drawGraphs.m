function [ output_args ] = drawGraphs( csvFilePath )
%DRAWGRAPHS Summary of this function goes here
%   Detailed explanation goes here
%   Set global variables
    global haxes1_2;
    global haxes1_3;
    global haxes1_4;
    global haxes1_5;
    %     global haxes1_6;
    global haxes1_7;
    global haxes1_8;
    global L1;
    global L2;
    global L3;
    global L4;
    global L5;
    global table;
    %Put a wait box here
    filename1 = csvFilePath;
    waitbar_handle = waitbar(0,'Please wait...');

    %READ CSV FILES
    RawData = csvread(filename1,1,0);
    table.Data = RawData;
    fid = fopen(filename1, 'rb');
    %# Get file size.
    fseek(fid, 0, 'eof');
    fileSize = ftell(fid);
    frewind(fid);
    %# Read the whole file.
    data = fread(fid, fileSize, 'uint8');
    %# Count number of line-feeds and increase by one.
    numLines = (sum(data == 10));
    fclose(fid);


    %VARIABLES AND VALUES USED THROUGHOUT ALGORITHM
    %=========================================================================

    walkingPressureConstantR =  100;
    lowerThresholdWalkingPressureR = walkingPressureConstantR - (walkingPressureConstantR * 0.15);
    upperThresholdWalkingPressureR = walkingPressureConstantR + (walkingPressureConstantR * 0.15);


    pressureHeuristicCostRight = 0;
    accelerationHeuristicCostRight = 0;
    totalHeuristicCostRight = 0;


    walkingPressureConstantL =  120;
    lowerThresholdWalkingPressureL = walkingPressureConstantL - (walkingPressureConstantL * 0.2);
    upperThresholdWalkingPressureL = walkingPressureConstantL + (walkingPressureConstantL * 0.2);


    pressureHeuristicCostLeft = 0;
    accelerationHeuristicCostLeft = 0;
    totalHeuristicCostLeft = 0;
    %=========================================================================



    %THIS REMOVES ROWS WITH PRESSURE VALUES THAT DO NOT MAKE SENSE
    %==========================================================================
    %EXAMPLE: a row where the pressure values is low but the row above and
    %below are high

    for y = 1: 105
       RawData(y,:) = [];
       numLines = numLines - 1;
    end

    RawData(numLines-1, :) = [];
    numLines = numLines-1;

    for c = 1:numLines
        if((c+1) > numLines)
            break;
        end
        if((RawData(c, 1) > RawData(c+1, 1)))
            RawData(c+1,:)= [];
            numLines = numLines -1;
        end     
    end

    z= 2;

    while(z < numLines -1)
        if(((RawData(z-1,5)) - (RawData(z,5)) > 20 ) && ((RawData(z + 1,5)) - (RawData(z,5)) > 20) || ((RawData(z-1,6)) - (RawData(z,6)) > 20) && ((RawData(z+1,6)) - (RawData(z,6)) > 20) || ((RawData(z-1,7)) - (RawData(z,7)) > 20) && ((RawData(z+1,7)) - (RawData(z,7)) > 20) || ((RawData(z-1,8)) - (RawData(z,8)) > 20) && ((RawData(z+1,8)) - (RawData(z,8)) > 20) || ((RawData(z-1,9)) - (RawData(z,9)) > 20) && ((RawData(z+1,9)) - (RawData(z,9)) > 20) || ((RawData(z-1,10)) - (RawData(z,10)) > 20) && ((RawData(z+1,10)) - (RawData(z,10)) > 20) || ((RawData(z-1,11)) - (RawData(z,11)) > 20) && ((RawData(z+1,11)) - (RawData(z,11)) > 20)) 
           RawData(z,:)= [];
           numLines = numLines -1;
       end
       z=z+1;
    end
    %==========================================================================


    %TIME DATA (Heel and Pelvis)
    timeHeel = RawData(:, 1);

    %ACCEL AND ADC DATA FOR HEEL
    accelerationXRHeel = RawData(:, 2);
    accelerationYRHeel = RawData(:, 3);
    accelerationZRHeel = RawData(:, 4);
    pressureADC1RHeel = RawData(:, 6);
    pressureADC1RHeel(pressureADC1RHeel >= 60000) = 0;
    pressureADC2RHeel = RawData(:, 5);
    pressureADC2RHeel(pressureADC2RHeel >=60000) = 0;
    pressureADC3RHeel = RawData(:, 9);
    pressureADC3RHeel(pressureADC3RHeel >=60000) = 0;
    pressureADC4RHeel = RawData(:, 8);
    pressureADC4RHeel(pressureADC4RHeel >=60000) = 0;
    pressureADC5RHeel = RawData(:, 11);
    pressureADC5RHeel(pressureADC5RHeel >=60000) = 0;
    pressureADC6RHeel = RawData(:, 7);
    pressureADC6RHeel(pressureADC6RHeel >=60000) = 0;
    pressureADC7RHeel = RawData(:, 10);
    pressureADC7RHeel(pressureADC7RHeel >=60000) = 0;

    accelerationXLHeel = RawData(:, 12);
    accelerationYLHeel = RawData(:, 13);
    accelerationZLHeel = RawData(:, 14);
    pressureADC1LHeel = RawData(:, 20);
    pressureADC1LHeel(pressureADC1LHeel >= 60000) = 0;
    pressureADC2LHeel = RawData(:, 18);
    pressureADC2LHeel(pressureADC2LHeel >=60000) = 0;
    pressureADC3LHeel = RawData(:, 16);
    pressureADC3LHeel(pressureADC3LHeel >=60000) = 0;
    pressureADC4LHeel = RawData(:, 19);
    pressureADC4LHeel(pressureADC4LHeel >=60000) = 0;
    pressureADC5LHeel = RawData(:, 15);
    pressureADC5LHeel(pressureADC5LHeel >=60000) = 0;
    pressureADC6LHeel = RawData(:, 21);
    pressureADC6LHeel(pressureADC6LHeel >=60000) = 0;
    pressureADC7LHeel = RawData(:, 17);
    pressureADC7LHeel(pressureADC7LHeel >=60000) = 0;


    accelerationXPelvis = RawData(:, 22);
    accelerationYPelvis = RawData(:, 23);
    accelerationZPelvis = RawData(:, 24);

    axes(haxes1_2)
    AxisLim = axis;
    plot(timeHeel, accelerationXRHeel, 'r', timeHeel, accelerationYRHeel, 'b', timeHeel, accelerationZRHeel, 'g');
    legend('X acceleration', 'Y acceleration', 'Z acceleration' )
    L1 = line([AxisLim(1) AxisLim(1)],[AxisLim(3) AxisLim(4)],'color','b','Marker','*','MarkerEdgeColor','b','LineStyle','-','linewidth',2);
    axes(haxes1_3)
    plot(timeHeel, accelerationXLHeel, 'r', timeHeel, accelerationYLHeel, 'b', timeHeel, accelerationZLHeel, 'g');
    legend('X acceleration', 'Y acceleration', 'Z acceleration' )
    L2 = line([AxisLim(1) AxisLim(1)],[AxisLim(3) AxisLim(4)],'color','b','Marker','*','MarkerEdgeColor','b','LineStyle','-','linewidth',2);    
    axes(haxes1_8)
    plot(timeHeel, accelerationXPelvis, 'r', timeHeel, accelerationYPelvis, 'b', timeHeel, accelerationZPelvis, 'g');
    legend('X acceleration', 'Y acceleration', 'Z acceleration' )
    L3 = line([AxisLim(1) AxisLim(1)],[AxisLim(3) AxisLim(4)],'color','b','Marker','*','MarkerEdgeColor','b','LineStyle','-','linewidth',2);
    axes(haxes1_4)
    plot(timeHeel, pressureADC1LHeel, 'r', timeHeel, pressureADC2LHeel, 'b', timeHeel, pressureADC3LHeel, 'g' ...
        , timeHeel, pressureADC4LHeel, 'c', timeHeel, pressureADC5LHeel, 'm', timeHeel, pressureADC6LHeel, 'y'...
        , timeHeel, pressureADC7LHeel, 'k')
    legend('Position 1', 'Position 2', 'Position 3', 'Position 4', 'Position 5', 'Position 6', 'Position 7')
    L4 = line([AxisLim(1) AxisLim(1)],[AxisLim(3) AxisLim(4)],'color','b','Marker','*','MarkerEdgeColor','b','LineStyle','-','linewidth',2);
    axes(haxes1_5)
    plot(timeHeel, pressureADC1RHeel, 'r', timeHeel, pressureADC2RHeel, 'b', timeHeel, pressureADC3RHeel, 'g' ...
        , timeHeel, pressureADC4RHeel, 'c', timeHeel, pressureADC5RHeel, 'm', timeHeel, pressureADC6RHeel, 'y'...
        , timeHeel, pressureADC7RHeel, 'k')
    legend('Position 1', 'Position 2', 'Position 3', 'Position 4', 'Position 5', 'Position 6', 'Position 7')
    L5 = line([AxisLim(1) AxisLim(1)],[AxisLim(3) AxisLim(4)],'color','b','Marker','*','MarkerEdgeColor','b','LineStyle','-','linewidth',2);
    waitbar(300/1000);
    % ITERATION 1: EXTRACT DATA THAT INVOLVES FOOT ON THE GROUND VS FOOT IN AIR
    %==========================================================================
    % 1) While loop gooes through all the rows, checks if there is a row that
    %    has a change in any of the pressure ADCs (change from low to high pressure)
    % 2) Store that row number in a vector (startRowArray)
    % 3) Increase the number of rows, until the pressure of any of the pressure 
    %    sensors goes from high back to low
    % 4) Store that row number into another vector (endRowArray)
    % 5) Increment th row number and vector size by 1 and re-enter while loop
    i = 1;
    k = 1;
    arrayStartRowRight = [];
    arrayEndRowRight = [];
    myNumLinesRight = numLines;
    %for i = updateValue : numLines-1
    while (i < myNumLinesRight)
        startADC1R = RawData(i,5);
        startADC2R = RawData(i,6);
        startADC3R = RawData(i,7);
        startADC4R = RawData(i,8);
        startADC5R = RawData(i,9);
        startADC6R = RawData(i,10);
        startADC7R = RawData(i,11);
        if ((startADC1R >= 100) || (startADC2R >= 100) || (startADC3R >= 100) || (startADC4R >= 100) || (startADC5R >= 100) || (startADC6R >= 100) || (startADC7R >= 100))
            arrayStartRowRight(:,k) = i;
            i=i+1;
            %updateValue = i;
            check = 1;
            while(check == 1 && i < myNumLinesRight)
                endADC1R = RawData(i,5);
                endADC2R = RawData(i,6);
                endADC3R = RawData(i,7);
                endADC4R = RawData(i,8);
                endADC5R = RawData(i,9);
                endADC6R = RawData(i,10);
                endADC7R = RawData(i,11);
                if((endADC1R >= 100) || (endADC2R >= 100) || (endADC3R >= 100) || (endADC4R >= 100) || (endADC5R >= 100) || (endADC6R >= 100) || (endADC7R >= 100))
                    i=i+1;
                    %updateValue = i;
                else
                    check = 0;
                end
            end
            arrayEndRowRight(:,k) = i;
            %i=i+1;
            k=k+1;
        end
        i = i+1;
    end
    waitbar(400/1000);
    %==========================================================================
    %LEFT SOLE:

    j = 1;
    l = 1;
    arrayStartRowLeft = [];
    arrayEndRowLeft = [];
    myNumLinesLeft = numLines;
    %for i = updateValue : numLines-1
    while (j < myNumLinesLeft)
        startADC1L = RawData(j,15);
        startADC2L = RawData(j,16);
        %startADC3L = RawData(j,17);
        startADC4L = RawData(j,18);
        startADC5L = RawData(j,19);
        startADC6L = RawData(j,20);
        startADC7L = RawData(j,21);
        if ((startADC1L >= 100) || (startADC2L >= 100) ||  (startADC4L >= 100) || (startADC5L >= 100) || (startADC6L >= 100) || (startADC7L >= 100))
            arrayStartRowLeft(:,l) = j;
            j=j+1;
            %updateValue = i;
            check = 1;
            while(check == 1 && j < myNumLinesLeft)
                endADC1L = RawData(j,15);
                endADC2L = RawData(j,16);
                %endADC3L = RawData(j,17);
                endADC4L = RawData(j,18);
                endADC5L = RawData(j,19);
                endADC6L = RawData(j,20);
                endADC7L = RawData(j,21);
                if((endADC1L >= 100) || (endADC2L >= 100) ||  (endADC4L >= 100) || (endADC5L >= 100) || (endADC6L >= 100) || (endADC7L >= 100))
                    j=j+1;
                    %updateValue = i;
                else
                    check = 0;
                end
            end
            arrayEndRowLeft(:,l) = j;
            %i=i+1;
            l=l+1;
        end
        j = j+1;
    end

    waitbar(500/1000);
    %==========================================================================
    %ITERATION 2: HEURISTIC TO DETECT SLIP (CHANGE IN AVERAGE PRESSURE)
    %==========================================================================

    a = 1; %index for startArray
    b = 1; %index for endArray
    sizeOfTheArraysRight = length(arrayStartRowRight);
    pressureHeuristicCostArrayRight = [];

    averagedADCArrayRight = [];
    for a = 1: sizeOfTheArraysRight-1
        startRowNumberRight = arrayStartRowRight(a); %arrayStartRow(a) is the value in the table at a
        endRowNumberRight = arrayEndRowRight(a);
        sumADC1R = 0;
        sumADC2R = 0;
        sumADC3R = 0;
        sumADC4R = 0;
        sumADC5R = 0;
        sumADC6R = 0;
        sumADC7R = 0;
        while(startRowNumberRight < endRowNumberRight)
            sumADC1R = sumADC1R + RawData( startRowNumberRight, 5);
            sumADC2R = sumADC2R + RawData( startRowNumberRight, 6);
            sumADC3R = sumADC3R + RawData( startRowNumberRight, 7);
            sumADC4R = sumADC4R + RawData( startRowNumberRight, 8);
            sumADC5R = sumADC5R + RawData( startRowNumberRight, 9);
            sumADC6R = sumADC6R + RawData( startRowNumberRight, 10);
            sumADC7R = sumADC7R + RawData( startRowNumberRight, 11);
            startRowNumberRight = startRowNumberRight + 1;
        end
        diffBetweenNumOfRowsRight = 0;
        averageADC1R = 0;
        averageADC2R = 0;
        averageADC3R = 0;
        averageADC4R = 0;
        averageADC5R = 0;
        averageADC6R = 0;
        averageADC7R = 0;
        diffBetweenNumOfRowsRight = ((arrayEndRowRight(a))- (arrayStartRowRight(a)));
        averageADC1R = sumADC1R/diffBetweenNumOfRowsRight;
        averageADC2R = sumADC2R/diffBetweenNumOfRowsRight;
        averageADC3R = sumADC3R/diffBetweenNumOfRowsRight;
        averageADC4R = sumADC4R/diffBetweenNumOfRowsRight;
        averageADC5R = sumADC5R/diffBetweenNumOfRowsRight;
        averageADC6R = sumADC6R/diffBetweenNumOfRowsRight;
        averageADC7R = sumADC7R/diffBetweenNumOfRowsRight;

        sumOfAveragedADCsR = averageADC1R + averageADC2R + averageADC3R + averageADC4R + averageADC5R + averageADC6R + averageADC7R;

        %NOTE: Right now doing the average of all the sums (126), and will
        %compare threshold with average expected pressure
        %IF THIS DOESNT WORK: Compare the total sum rather than the average
        averageOfSumOfAverageR = sumOfAveragedADCsR/7;

        averagedADCArrayRight(:,a) = averageOfSumOfAverageR;

        %THRESHOLD CHECK AND ASSIGNED COST: If this changes to sum and not
        %average the threshold value and cost may change

        if((averageOfSumOfAverageR <= (upperThresholdWalkingPressureR)) && (averageOfSumOfAverageR >= (lowerThresholdWalkingPressureR)))
            pressureHeuristicCostRight = 0;
        elseif((averageOfSumOfAverageR <= (walkingPressureConstantR * 1.20)) && (averageOfSumOfAverageR >= (walkingPressureConstantR * 0.8)))
              pressureHeuristicCostRight = 10;
        elseif((averageOfSumOfAverageR <= (walkingPressureConstantR * 1.30)) && (averageOfSumOfAverageR >= (walkingPressureConstantR * 0.7)))
              pressureHeuristicCostRight = 20;
        elseif((averageOfSumOfAverageR <= (walkingPressureConstantR * 1.40)) && (averageOfSumOfAverageR >= (walkingPressureConstantR * 0.6)))
              pressureHeuristicCostRight = 30;
        elseif((averageOfSumOfAverageR <= (walkingPressureConstantR * 1.50)) && (averageOfSumOfAverageR >= (walkingPressureConstantR * 0.5)))
              pressureHeuristicCostRight = 40;
        elseif((averageOfSumOfAverageR > (walkingPressureConstantR * 1.50)) || (averageOfSumOfAverageR < (walkingPressureConstantR * 0.5)))
              pressureHeuristicCostRight = 50;
        end

        pressureHeuristicCostArrayRight(:,a) = pressureHeuristicCostRight;
    end

    %==========================================================================
    %FOR THE LEFT SOLE:
    c = 1; %index for startArray
    b = 1; %index for endcrray
    sizeOfTheArraysLeft = length(arrayStartRowLeft);
    pressureHeuristicCostArrayLeft = [];

    averagedADCArrayLeft = [];
    for c = 1: sizeOfTheArraysLeft-1
        startRowNumberLeft = arrayStartRowLeft(c); %arrayStartRow(a) is the value in the table at a
        endRowNumberLeft = arrayEndRowLeft(c);
        sumADC1L = 0;
        sumADC2L = 0;
        %sumADC3L = 0;
        sumADC4L = 0;
        sumADC5L = 0;
        sumADC6L = 0;
        sumADC7L = 0;
        while(startRowNumberLeft < endRowNumberLeft)
            sumADC1L = sumADC1L + RawData( startRowNumberLeft, 15);
            sumADC2L = sumADC2L + RawData( startRowNumberLeft, 16);
            %sumADC3L = sumADC3L + RawData( startRowNumberLeft, 17);
            sumADC4L = sumADC4L + RawData( startRowNumberLeft, 18);
            sumADC5L = sumADC5L + RawData( startRowNumberLeft, 19);
            sumADC6L = sumADC6L + RawData( startRowNumberLeft, 20);
            sumADC7L = sumADC7L + RawData( startRowNumberLeft, 21);
            startRowNumberLeft = startRowNumberLeft + 1;
        end
        diffBetweenNumOfRowsLeft = 0;
        averageADC1L = 0;
        averageADC2L = 0;
        %averageADC3R = 0;
        averageADC4L = 0;
        averageADC5L = 0;
        averageADC6L = 0;
        averageADC7L = 0;
        diffBetweenNumOfRowsLeft = ((arrayEndRowLeft(c))- (arrayStartRowLeft(c)));
        averageADC1L = sumADC1L/diffBetweenNumOfRowsLeft;
        averageADC2L = sumADC2L/diffBetweenNumOfRowsLeft;
        %averageADC3R = sumADC3R/diffBetweenNumOfRowsLeft;
        averageADC4L = sumADC4L/diffBetweenNumOfRowsLeft;
        averageADC5L = sumADC5L/diffBetweenNumOfRowsLeft;
        averageADC6L = sumADC6L/diffBetweenNumOfRowsLeft;
        averageADC7L = sumADC7L/diffBetweenNumOfRowsLeft;

        sumOfAveragedADCsL = averageADC1L + averageADC2L  + averageADC4L + averageADC5L + averageADC6L + averageADC7L;

        %NOTE: Right now doing the average of all the sums (126), and will
        %compare threshold with average expected pressure
        %IF THIS DOESNT WORK: Compare the total sum rather than the average
        averageOfSumOfAverageL = sumOfAveragedADCsL/7;

        averagedADCArrayLeft(:,c) = averageOfSumOfAverageL;

        %THRESHOLD CHECK AND ASSIGNED COST: If this changes to sum and not
        %average the threshold value and cost may change

        if((averageOfSumOfAverageL <= (upperThresholdWalkingPressureL)) && (averageOfSumOfAverageL >= (lowerThresholdWalkingPressureL)))
            pressureHeuristicCostLeft = 0;
        elseif((averageOfSumOfAverageL <= (walkingPressureConstantL * 1.30)) && (averageOfSumOfAverageL >= (walkingPressureConstantL * 0.7)))
              pressureHeuristicCostLeft = 10;
        elseif((averageOfSumOfAverageL <= (walkingPressureConstantL * 1.40)) && (averageOfSumOfAverageL >= (walkingPressureConstantL * 0.6)))
              pressureHeuristicCostLeft = 20;
        elseif((averageOfSumOfAverageL <= (walkingPressureConstantL * 1.50)) && (averageOfSumOfAverageL >= (walkingPressureConstantL * 0.5)))
              pressureHeuristicCostLeft = 30;
        elseif((averageOfSumOfAverageL <= (walkingPressureConstantL * 1.60)) && (averageOfSumOfAverageL >= (walkingPressureConstantL * 0.4)))
              pressureHeuristicCostLeft = 40;
        elseif((averageOfSumOfAverageL > (walkingPressureConstantL * 1.60)) || (averageOfSumOfAverageL < (walkingPressureConstantL * 0.4)))
              pressureHeuristicCostLeft = 50;
        end

        pressureHeuristicCostArrayLeft(:,c) = pressureHeuristicCostLeft;
    end

    
    %==========================================================================
    %ITERATION 3: HEURISTIC TO DETECT SLIP (CHANGE IN ACCELERATION AT HEEL STRIKE)
    %==========================================================================


    t = 1; %index for startArray

    arrayMaxAccelHeelRightR = [];
    arrayMaxAccelHeelRightL = [];
    arrayMaxAccelPelvisRight = [];
    accelerationHeuristicCostArrayRight = [];

    % for t = 1: sizeOfTheArrays
    while(t < sizeOfTheArraysRight)
        startOnGroundR = arrayStartRowRight(t);
        endOnGroundR = arrayEndRowRight(t);
        maxOfAccelerationHeelRightR = 0;
        maxOfAccelerationHeelRightL = 0;

    %     averageAccelerationHeelRightR = 0;
    %     averageAccelerationHeelRightL = 0;

        maxOfAccelerationPelvisRight = 0;
    %     averageAccelerationPelvisRight = 0;

        while(startOnGroundR <= endOnGroundR)
            maxOfAccelerationHeelRightR = max( abs((RawData(startOnGroundR, 4))));
            maxOfAccelerationHeelRightL = max( abs((RawData(startOnGroundR, 14))));
            maxOfAccelerationPelvisRight = max(abs((RawData(startOnGroundR, 24))));

            startOnGroundR = startOnGroundR + 1;
        end

    %     averageAccelerationHeelRightR = sumOfAccelerationHeelRightR / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));
    %     averageAccelerationHeelRightL = sumOfAccelerationHeelRightL / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));
    %     averageAccelerationPelvisRight = sumOfAccelerationPelvisRight / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));

        arrayMaxAccelHeelRightR(:,t) = maxOfAccelerationHeelRightR;
        arrayMaxAccelHeelRightL(:,t) = maxOfAccelerationHeelRightL ;
        arrayMaxAccelPelvisRight(:,t) = maxOfAccelerationPelvisRight;


        if((((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) < 40)) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) < 40))
            accelerationHeuristicCostRight = 0;
        elseif (((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) < 60) && ((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) > 41) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) < 60) && ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) > 41))
            accelerationHeuristicCostRight = 10;
        elseif ((((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) < 80) && ((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) > 61)) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) < 80) && ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) > 61))
            accelerationHeuristicCostRight = 20;
        elseif ((((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) < 100) && ((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) > 81)) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) < 100) && ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) > 81))
            accelerationHeuristicCostRight = 30;
        elseif ((((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) < 120) && ((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) > 101)) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) < 120) && ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) > 101))
            accelerationHeuristicCostRight = 40;
        elseif (((abs(maxOfAccelerationHeelRightR - maxOfAccelerationPelvisRight)) > 121 )) || ((abs(maxOfAccelerationHeelRightL - maxOfAccelerationPelvisRight)) > 121 )
            accelerationHeuristicCostRight = 50;
        end

        accelerationHeuristicCostArrayRight(:, t) = accelerationHeuristicCostRight;

        t = t+1;
    end



    %==========================================================================

    %FOR THE LEFT
    w = 1; %index for startArray

    arrayMaxAccelHeelLeftR = [];
    arrayMaxAccelHeelLeftL = [];
    arrayMaxAccelPelvisLeft = [];
    accelerationHeuristicCostArrayLeft = [];

    % for t = 1: sizeOfTheArrays
    while(w < sizeOfTheArraysLeft)
        startOnGroundL = arrayStartRowLeft(w);
        endOnGroundL = arrayEndRowLeft(w);
        maxOfAccelerationHeelLeftR = 0;
        maxOfAccelerationHeelLeftL = 0;

    %     averageAccelerationHeelRightR = 0;
    %     averageAccelerationHeelRightL = 0;

        maxOfAccelerationPelvisLeft = 0;
    %     averageAccelerationPelvisRight = 0;

        while(startOnGroundL <= endOnGroundL)
            maxOfAccelerationHeelLeftR = max( abs((RawData(startOnGroundL, 4))));
            maxOfAccelerationHeelLeftL = max( abs((RawData(startOnGroundL, 14))));
            maxOfAccelerationPelvisLeft = max(abs((RawData(startOnGroundL, 24))));

            startOnGroundL = startOnGroundL + 1;
        end

    %     averageAccelerationHeelRightR = sumOfAccelerationHeelRightR / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));
    %     averageAccelerationHeelRightL = sumOfAccelerationHeelRightL / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));
    %     averageAccelerationPelvisRight = sumOfAccelerationPelvisRight / ((arrayEndRowRight(t)) - (arrayStartRowRight(t)));

        arrayMaxAccelHeelLeftR(:,w) = maxOfAccelerationHeelLeftR;
        arrayMaxAccelHeelLeftL(:,w) = maxOfAccelerationHeelLeftL ;
        arrayMaxAccelPelvisLeft(:,w) = maxOfAccelerationPelvisLeft;


        if(((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) < 40) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) < 40))
            accelerationHeuristicCostLeft = 0;
        elseif ((((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) < 60) && ((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) > 41) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) < 60) && ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) > 41)))
            accelerationHeuristicCostLeft = 10;
        elseif ((((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) < 80) && ((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) > 61)) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) < 80) && ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) > 61))
            accelerationHeuristicCostLeft = 20;
        elseif ((((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) < 100) && ((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) > 81)) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) < 100) && ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) > 81))
            accelerationHeuristicCostLeft = 30;
        elseif ((((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) < 120) && ((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) > 101)) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) < 120) && ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) > 101))
            accelerationHeuristicCostLeft = 40;
        elseif (((abs(maxOfAccelerationHeelLeftR - maxOfAccelerationPelvisLeft)) > 121 )) || ((abs(maxOfAccelerationHeelLeftL - maxOfAccelerationPelvisLeft)) > 121 )
            accelerationHeuristicCostLeft = 50;
        end

        accelerationHeuristicCostArrayLeft(:, w) = accelerationHeuristicCostLeft;



        w = w+1;
    end



    %==========================================================================
    %ITERATION 4: HEURISTIC TO DETECT SLIP (CHANGE IN ACCELERATION AT HEEL STRIKE)
    %==========================================================================
    sizeOfHeuristicArrayR = length(pressureHeuristicCostArrayRight);
    noSlipStartArrayR = [];
    noSlipEndArrayR = [];
    maybeSlipStartArrayR = [];
    maybeSlipEndArrayR = [];
    slipStartArrayR = [];
    slipEndArrayR = [];
    waitbar(550/1000)
    for q = 1: sizeOfHeuristicArrayR
        totalHeuristicCostRight = 0;
        totalHeuristicCostRight =  pressureHeuristicCostArrayRight(q);

        if(totalHeuristicCostRight == 0)
            noSlipStartArrayR(:,q) = arrayStartRowRight(q);
            noSlipEndArrayR(:,q) = arrayEndRowRight(q);

        elseif((totalHeuristicCostRight < 21) && (totalHeuristicCostRight > 9))
            maybeSlipStartArrayR(:,q) = arrayStartRowRight(q);
            maybeSlipEndArrayR(:,q) = arrayEndRowRight(q);

        elseif((totalHeuristicCostRight == 50))
            slipStartArrayR(:,q) = arrayStartRowRight(q);
            slipEndArrayR(:,q) = arrayEndRowRight(q);
        end

        q=q+1;

    end

    sizeOfHeuristicArrayL = length(pressureHeuristicCostArrayLeft);
    noSlipStartArrayL = [];
    noSlipEndArrayL = [];
    maybeSlipStartArrayL = [];
    maybeSlipEndArrayL = [];
    slipStartArrayL = [];
    slipEndArrayL = [];

    for r = 1: sizeOfHeuristicArrayL
        totalHeuristicCostLeft = 0;
        totalHeuristicCostLeft =  pressureHeuristicCostArrayLeft(r);


        if(totalHeuristicCostLeft == 0)
            noSlipStartArrayL(:,r) = arrayStartRowLeft(r);
            noSlipEndArrayL(:,r) = arrayEndRowLeft(r);

        elseif((totalHeuristicCostLeft < 21) && (totalHeuristicCostLeft > 9))
            maybeSlipStartArrayL(:,r) = arrayStartRowLeft(r);
            maybeSlipEndArrayL(:,r) = arrayEndRowLeft(r);

        elseif((totalHeuristicCostLeft == 50) )
            slipStartArrayL(:,r) = arrayStartRowLeft(r);
            slipEndArrayL(:,r) = arrayEndRowLeft(r);
        end



    end



    sizeOfSlipDetectionResultR = length(slipStartArrayR);
    sizeOfSlipDetectionResultL = length(slipStartArrayL);
    fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nSUMMARY OF SLIP DETECTION RESULTS\n');
    fprintf('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\n\n\n\n');

    fprintf('\nSLIP DETECTION INTERVALS ON RIGHT FOOT:\n');
    fprintf('=====================================================================================\n\n');

    for f = 1: sizeOfSlipDetectionResultR

        if(slipStartArrayR(f) ~= 0)
            fprintf('Slip Detected by RIGHT FOOT between Rows: %d to %d\n', slipStartArrayR(f), slipEndArrayR(f))
        end

    end

    fprintf('\n\nSLIP DETECTION INTERVALS ON LEFT FOOT:\n');
    fprintf('=====================================================================================\n\n');
    for h = 1: sizeOfSlipDetectionResultL

        if(slipStartArrayL(h) ~= 0)
            fprintf('Slip Detected by LEFT FOOT between Rows: %d to %d\n', slipStartArrayL(h), slipEndArrayL(h))
        end

    end
    
    

    
%{
filename = 'TEST1.csv';    
delimiter = ',';
startRow = 1;
endRow = inf;
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue', NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray(col) = [dataArray(col);dataArrayBlock(col)];
    end
end

%% Close the text file.
fclose(fileID);
M = dataArray; 
%}
%{ 
FSR1 = M(1,6)';
FSR2 = M(1,5)';
FSR3 = M(1,9)';
FSR4 = M(1,8)';
FSR5 = M(1,11)';
FSR6 = M(1,7);
FSR7 = M(1,10)';
zsign = [1.1 2.2 1.4 0.5 0.9 2.6 3.1 3.3 1.2 1.5 2.3 3.0 0.5 1.7 1.0 1.2 0.7 0.2 3.3 1.4 1.9 0.2 0.6 3.1 2.3 2.9 1.5 1.2 3.3 1.2 1.5 2.3 3.0 0.5 1.7 1.0 1.2 0.7 0.2 3.3 1.4 1.9 0.2 0.6 3.1 2.3 2.9 1.5 1.2 3.3 1.2 1.5 2.3 3.0 0.5 1.7 1.0 1.2 0.7 0.2 3.3 1.4 1.9 0.2 0.6 3.1 2.3 2.9 1.5 1.2 3.3 1.2 1.5 2.3 3.0 0.5 1.7 1.0 1.2 0.7 0.2 3.3 1.4 1.9 0.2 0.6 3.1 2.3 2.9 1.5 1.2];
%}
    
X = [-1.7 -0.1 -2.7 -0.9 0.5 1.2 -1.4];
Y = [15 13.2 6.7 6.0 5.8 -2.6 -10.2]; 
[x,y] = meshgrid(-15:0.3:15);
z = exp(-x.^2-y.^2);
    
t = 1;


axes(haxes1_7)
hold on 
    plotZ1 = surf(x+X(1),y+Y(1),(z * pressureADC1RHeel(1)));
    plotZ2 = surf(x+X(2),y+Y(2),(z * pressureADC2RHeel(1))); 
    plotZ3 = surf(x+X(3),y+Y(3),(z * pressureADC3RHeel(1)));
    plotZ4 = surf(x+X(4),y+Y(4),(z * pressureADC4RHeel(1)));  
    plotZ5 = surf(x+X(5),y+Y(5),(z * pressureADC5RHeel(1)));  
    plotZ6 = surf(x+X(6),y+Y(6),(z * pressureADC6RHeel(1))); 
    plotZ7 = surf(x+X(7),y+Y(7),(z * pressureADC7RHeel(1))); 
%   caxis([0 5]);
%   colorbar();
hold off
 waitbar(600/1000);
 
 while t < 20  %(length(pressureADC7RHeel)
     hold on 
        set(plotZ1,'ZData',z * pressureADC1RHeel(t));
        set(plotZ2,'ZData',z * pressureADC2RHeel(t));
        set(plotZ3,'ZData',z * pressureADC3RHeel(t));
        set(plotZ4,'ZData',z * pressureADC4RHeel(t));
        set(plotZ5,'ZData',z * pressureADC5RHeel(t));
        set(plotZ6,'ZData',z * pressureADC6RHeel(t));
        set(plotZ7,'ZData',z * pressureADC7RHeel(t));    
    hold off
    t= t + 1;
    drawnow
    pause(0.05);
 end
    

waitbar(1000/1000)
close(waitbar_handle)

    %==========================================================================
    %{
    for i = 1:numLines-1
        k = 0;
        if(accelerationXHeel(i) == -80)
            k=k+1;
            accelerationXHeelParsed(k)= accelerationXHeel(i);
            display(accelerationXHeelParsed);
        end
    end


    numLines = 2494;

    for c = 1:numLines
        if((c+1) > numLines)
            break;
        end
        if((RawData(c, 1) > RawData(c+1, 1)))
            RawData(c+1,:)= [];
            numLines = numLines -1;
        end     
    end
    openfile = fopen(filename1, 'a');
    dlmwrite(filename1,RawData,'delimiter',',','-append');
    status = fclose(openfile);




    }

    %}

%{
    % %PLOT GRAPH
    % figure;
    % %plot(timeHeel, pressureADC1Heel, timeHeel, pressureADC2Heel, timeHeel, pressureADC3Heel, timeHeel, pressureADC4Heel, timeHeel, pressureADC5Heel, timeHeel, pressureADC6Heel, timeHeel, pressureADC7Heel);
    % figure;
    % %plot(timeHeel, accelerationXRHeel, 'r', timeHeel, accelerationYRHeel, 'b', timeHeel, accelerationZRHeel, 'g', timeHeel, accelerationYRHeel, 'b', timeHeel, accelerationZRHeel, 'g')
    % 
    % 
    % % plot(timeHeel, accelerationXRHeel, 'r', timeHeel, accelerationXPelvis, 'b');
    % % figure;
    % % plot(timeHeel, accelerationYRHeel, 'r', timeHeel, accelerationYPelvis, 'b');
    % % figure;
    % plot(timeHeel, accelerationZRHeel, 'r', timeHeel, accelerationZPelvis, 'b');
    % 
    % % plot(timeHeel, accelerationXLHeel, 'r', timeHeel, accelerationXPelvis, 'b');
    % % figure;
    % % plot(timeHeel, accelerationYLHeel, 'r', timeHeel, accelerationYPelvis, 'b');
    % figure;
    % plot(timeHeel, accelerationZLHeel, 'r', timeHeel, accelerationZPelvis, 'b');

    % figure;
    % plot(timeHeel, accelerationXRHeel, 'r', timeHeel, accelerationYRHeel, 'b', timeHeel, accelerationZRHeel, 'g');
    % figure;
    % plot(timeHeel, accelerationXLHeel, 'r', timeHeel, accelerationYLHeel, 'b', timeHeel, accelerationZLHeel, 'g');       
%}
end

