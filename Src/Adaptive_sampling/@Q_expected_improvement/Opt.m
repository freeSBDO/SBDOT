function [] = Opt( obj )
    % OPT Launch optimization process
    %
    % Syntax :
    % obj.Opt();

    if obj.display_temp
        
        fprintf('[iter]     min_y     Criterion     Point added \n');
        
    end
    
    while ~obj.opt_stop && ~obj.failed && ~obj.crit_stop
        
        try
            
            obj.iter_num = obj.iter_num + 1;
            
            obj.QV_val = 1;
            EI_temp = 0;
            
            for i = 1:prod(obj.prob.m_t)
                
                EI_temp = obj.Opt_crit(EI_temp); % Main method (in subclass)
                obj.QV_val = obj.QV_val + 1;
                
            end
            
            obj.Conv_check_crit(); % Check convergence
            if ~obj.crit_stop
                obj.Eval(); % Evaluation
                obj.Conv_check(); % Check convergence
            end            
            
            %% Printig Results
            fig = figure();
            fig.Units = 'centimeters';
            fig.OuterPosition = [0, 0, 3*29.7, 3*21];
            fig.PaperSize = [29.7, 21];
            
            hold on;
            
            rgb = {'r', 'b', 'g'};
            
            for i=1:3
                x_eval = [linspace(0,1,1000)',i*ones(1000,1)];
                y_eval = test_ego_unconstrained(x_eval);
                x_samp = obj.prob.x{i}(:,1);
                y_samp = obj.prob.y{i};
                plot(x_eval(:,1),y_eval,'Color',rgb{i});
                plot(x_samp, y_samp,'*','MarkerSize',15,'MarkerEdgeColor',rgb{i},'MarkerFaceColor',rgb{i});
%                 plot(x_eval(:,1),g_eval,':','Color',rgb{i});
            end
            
%             vline([0.14,0.425,0.725],{'k','k','k'});
            hline(0, 'k');
            title(horzcat('EGO iter: ',num2str(obj.iter_num)));
            legend('Y_1',...
                   'D_1',...
                   'Y_2',...
                   'D_2',...
                   'Y_3',...
                   'D_3');
            xlabel('x');
            ylabel('y');
            
            hold off;
            
            print(horzcat('EGO_iter_',num2str(obj.iter_num)),'-dpdf');
            
            
        catch ME
            
            obj.failed = true;
            obj.opt_stop = true;
            obj.error = ME;
            disp(ME.message)
            warning('off','backtrace')
            warning('Check obj.error for more information !')
            
        end
    end
    
    % Display back to its normal value
    obj.prob.display = obj.display_temp;
    if isa( obj.prob , 'Problem_multifi')
        obj.prob.prob_HF.display = obj.display_temp;
        obj.prob.prob_LF.display = obj.display_temp;
    end
    
end

