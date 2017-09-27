function [T_corr] = Info_display( obj )
% INFO_DISPLAY display BQQV Kriging informations
% 
% T_corr correspond to L*L'(correlation not covariance even for heteroskedastic)


%% T_corr plot

switch obj.tau_type
    
    case 'isotropic'
        
        T_corr = arrayfun( @(k)vect2full( ...
            obj.prob.m_t(k),...
            obj.Build_tau( obj.hyp_tau(k),obj.prob.m_t(k),'isotropic', []),...
            0 ) , 1:length(obj.prob.m_t), 'UniformOutput', false );
        
    case {'choleski','heteroskedastic'}
        Id_Tau = [1, cumsum(arrayfun(@(k) sum(1:k), obj.prob.m_t-1))];
        Id_Tau = [(Id_Tau(1:(end-1))+[0,ones(1,(length(obj.prob.m_t)-1))]); Id_Tau(2:end)];

        T_corr = arrayfun( @(k)vect2full( ...
            obj.prob.m_t(k),...
            obj.Build_tau( obj.hyp_tau(Id_Tau(1,k):Id_Tau(2,k))',obj.prob.m_t(k),'choleski', []),...
            0 ) , 1:length(obj.prob.m_t), 'UniformOutput', false ); 
        
end

if length(obj.prob.m_t) == 1
    size_plot = 1;
else
    size_plot = 2;
end

figure
hold on
for i = 1:length(obj.prob.m_t)
    subplot(ceil(length(obj.prob.m_t)/2),size_plot,i)  
    % Color plot  
    imagesc(1:obj.prob.m_t(i),1:obj.prob.m_t(i),T_corr{i})  
    title(['Qualitative variable ',num2str(i)])
    % Get matrix value for display
    textStrings = num2str(T_corr{i}(:),'%0.2f');
    textStrings = strtrim(cellstr(textStrings));
    [x_s,y_s] = meshgrid(1:obj.prob.m_t(i));
    hStrings = text(x_s(:),y_s(:),textStrings(:),'HorizontalAlignment','center');
    % Change the text colors black or white
    textColors = repmat(T_corr{i}(:) < 0,1,3);  
    set(hStrings,{'Color'},num2cell(textColors,2));  
    
    set(gca,'XTick',1:obj.prob.m_t(i))
    set(gca,'YTick',1:obj.prob.m_t(i),'YDir' ,'reverse')
    colormap('hot')      
    caxis([-1,1])
    axis square
end
hold off   

%% Sigma plot for heteroskedastic case
% TODO
%if strcmp(obj.tau_type,'heteroskedastic')
%    
%end

end

