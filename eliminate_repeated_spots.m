%%%Step-5% Run this program 2 time- for top and bottom. Don't forget to
%%%change the file name at lines 7, 20 and 21. Run "clear" after each run.
%Author: Jerry Chao
%Date created: 9/18/2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inputTextFileName = 'D1wash001.omeoverall_top2.txt';

frameColumnIndex = 1;
xColumnIndex = 2;
yColumnIndex = 5;
signalIntensityColumnIndex = 8;

numFramesToConsider = 3;

xThreshold = 30; %Nanometers
yThreshold = 30; %Nanometers

outputFolderPath = 'C:\H Drive Back Up\Selfmade Programs\ppalm new\'; %Folder where all output will be desposited.
outputListFileName = 'D1wash001.omeoverall_top2_sorted.txt';   %List of remaining spots.
outputStatisticsFileName = 'D1wash001.omeoverall_top2 statistics.txt';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Read the contents of the text file into a 2D double array.
array2D = dlmread(inputTextFileName);

%Get number of spots
numSpots = size(array2D, 1);


%Initialize each spot to be the head of its own linked list
linkedLists = cell(numSpots, 1);

for k = 1:numSpots
    linkedLists{k} = dlnode(array2D(k,:));
end

counter = 1;

while (counter < length(linkedLists))
    currentNode = linkedLists{counter};
    currentFrame = currentNode.Data(frameColumnIndex);
    
    flag = true;    %If true, there is at least one more node to consider.
    innerCounter = counter; %Counter for the processing of the current node.
    
    candidateNodes = {};    %Nodes that contain potentially the same spot as the current node.
    
    while (flag)
        
        innerCounter = innerCounter + 1;
        
        if innerCounter <= length(linkedLists)
            nextNode = linkedLists{innerCounter};

            nextFrame = nextNode.Data(frameColumnIndex);

            frameDifference = nextFrame - currentFrame;

            if (frameDifference > 0 && frameDifference <= numFramesToConsider)
                 [sameSpot, distance] = compareNodes(currentNode, nextNode, xColumnIndex, yColumnIndex, xThreshold, yThreshold);

                 if (sameSpot)
                     candidateNodes(end+1,:) = {[nextFrame, distance, innerCounter]};
                 end
            else
                flag = false;   %We have gone past the frame window.
            end
        else
            flag = false;   %We have gone through the entire list of nodes.
        end
    end
    
    %Look through the candidates for the currentNode and take the closest
    %candidate from each frame.
    idx = 1;
    while (idx < length(candidateNodes))
        
        node1 = candidateNodes{idx};
        node2 = candidateNodes{idx + 1};
        
        %If the two nodes are from the same frame, delete the one that is
        %farther from the current node.
        if node1(1) == node2(1)
            if node1(2) >= node2(2)
                candidateNodes(idx) = [];
            else
                candidateNodes(idx + 1) = [];
            end
        else
            idx = idx + 1;  %Advance the counter only if the two nodes are
                            %from different frames.
        end
    end
    
    %Now we're left with candidate nodes from different frames.
    %Insert them in reverse order after the currentNode.
    %And delete them in reverse order from linkedLists.
    if length(candidateNodes) > 0
        for k = length(candidateNodes):-1:1
            insertAfter(linkedLists{candidateNodes{k}(3)}, currentNode);
            linkedLists(candidateNodes{k}(3)) = [];
        end
    end
    
    %Advance the counter to the next node in linkedLists
    counter = counter + 1;
end

%Open output file for writing statistics.
statisticsFileID = fopen([outputFolderPath, outputStatisticsFileName], 'w');
fprintf(statisticsFileID, 'Tracks of repeat occurrences identified by frame number: \n\n');

%Number of unique molecules.
numUniqueSpots = length(linkedLists);
%Array to keep track of number of frames in which a molecule occurs.
numOccurrences = ones(numUniqueSpots, 1);
for k = 1:numUniqueSpots
    node = linkedLists{k};
    
    frameNumbers = num2str(node.Data(frameColumnIndex));
    
    while ~isempty(node.Next)
        node = node.Next;
        
        frameNumbers = [frameNumbers, ' ', num2str(node.Data(frameColumnIndex))];
        numOccurrences(k) = numOccurrences(k) + 1;
    end
    
    %disp(frameNumbers);
    
    fprintf(statisticsFileID,'%s\n', frameNumbers);
end

fprintf(statisticsFileID, '\n\n\n');

%Report number of unique spots.
fprintf(statisticsFileID, ['Number of unique spots: ', num2str(numUniqueSpots)]);
fprintf(statisticsFileID, '\n\n');

%Report frequencies of occurrences
for k = 1:numFramesToConsider + 1
    frequency = sum(numOccurrences == k);
    fprintf(statisticsFileID, '%s\n', ['Frequency of ', num2str(k), ' occurrences : ', ...
                num2str(frequency), ' (', num2str(sprintf('%.2f', frequency / numUniqueSpots * 100)), '%)']);
end

%Close statistics ouptut file.
fclose(statisticsFileID);


%Array to keep track of the frame to keep for each molecule.
nodeToKeep = cell(numUniqueSpots, 1);

for k = 1:numUniqueSpots
    nodeToKeep{k} = determineNodeToKeep(linkedLists{k}, numOccurrences(k), signalIntensityColumnIndex);
end


%Generate output array with repeat instances of a molecule removed.
outputArray2D = zeros(numUniqueSpots, size(array2D, 2));

for k = 1:numUniqueSpots
    outputArray2D(k,:) = nodeToKeep{k}.Data;
end

dlmwrite([outputFolderPath, outputListFileName], outputArray2D, 'delimiter', ' ', 'newline', 'pc', 'precision', '%10.7f');