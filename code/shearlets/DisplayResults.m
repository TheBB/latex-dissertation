function DisplayResults(I)

    for i = 1:length(I.FunctionTable)
        disp([num2str(I.FunctionTable(i).TotalTime) ' - ' I.FunctionTable(i).FunctionName]);
    end

end
