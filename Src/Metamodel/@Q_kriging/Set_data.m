function obj = Set_data( obj, samples, values )
    % SET_DATA reduces and centers the previously normalized input and
    % output data
    %
    %   Inputs:
    %       obj is an object of class Q_kriging
    %       samples is the normalized input
    %       values is the normalized output
    %
    %   Output:
    %       obj is the updated input obj
    %
    % Syntax :
    % Tau = obj.Init_tau_id();
    
    q_var = cellfun(@(x) x(:,(obj.prob.m_x+1):end), samples, 'UniformOutput', false);
    samples = cellfun(@(x) x(:,1:obj.prob.m_x), samples, 'UniformOutput', false);
    
    % Reduces and centers samples and values
    
    inputAvg = cellfun(@(k) mean(k), samples,'UniformOutput',false);
    inputAvg = cell2mat(inputAvg');
    inputStd = cellfun(@(k) std(k), samples,'UniformOutput',false);
    inputStd = cell2mat(inputStd');

    outputAvg = cellfun(@(k) mean(k), values)';
    outputStd = cellfun(@(k) std(k), values)';

    samples = arrayfun(@(k) (samples{k} - repmat(inputAvg(k,:),obj.prob.n_x(k),1)) ./ repmat(inputStd(k,:),obj.prob.n_x(k),1),1:length(samples),'UniformOutput',false);
    values = arrayfun(@(k) (values{k} - outputAvg(k).*ones(obj.prob.n_x(k),1)) ./ outputStd(k).*ones(obj.prob.n_x(k),1),1:length(values),'UniformOutput',false);

    obj.input_scaling = [inputAvg, inputStd];
    obj.output_scaling = [outputAvg, outputStd];
    
    obj.q_var = q_var;
    obj.samples = samples;
    obj.values = values;
    
end