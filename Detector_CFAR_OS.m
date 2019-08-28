classdef Detector_CFAR_OS < handle
    properties
        m_InputData %������ �� ��������� ������������
        os_wnd
        k
    end
    
    methods
        function obj = Detector_CFAR_OS(answer)
            %������������� ������������
            if nargin < 1
                obj.os_wnd = 4; %������ ��������
                obj.k = 5; %����� �������� � �������
            else
                obj.k = str2double(answer{1});
                obj.os_wnd = str2double(answer{2});
            end
        end
        function [outSNR,outPd] = calcPd(obj,Pfa,data,noise)
            %����� �������� �� ��������
            [M,N] = size(noise); %������, �������
            
            noise = abs(noise);
            data = abs(data);
            
            %% ������ �������� ���� � �������
            noise_power = rssq(noise(:)).^2/M/N; % ����� N0*E/2 ����� �� | N0 = 1;
            signal_power = rssq(data(:,N/2)).^2/M-noise_power; % ����� E^2/2
            q = sqrt(2*signal_power/noise_power);
            outSNR = 10*log10(q);
            
            %������ ������������ ��� �������� �������
            k = obj.k;
            n = obj.os_wnd*2;
            c1 = k*nchoosek(n,k);
            c2 = factorial(k-1);
            c3 = c1*c2;
            eqn = @(T) abs(c3/prod((T+n-k+1):(T+n))-Pfa);
            max = n*1e7;
            solT = fminbnd(eqn,1e-20,max);
            while solT*1.1 >= max
                max = max/10;
                solT = fminbnd(eqn,1e-20,max);
            end
            
            %% ������ ������
            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for y = obj.os_wnd + 1:length(data)-obj.os_wnd-1                                                         
                tempdata = data([y-obj.os_wnd:y-1,y+1:y+obj.os_wnd]);
                tempdata = sort(tempdata);
                Detection_data(y) = data(y) >= sqrt(tempdata(k)*solT);
            end
            Detection_data = reshape(Detection_data,[],M);
            Detection_data = Detection_data';
            
            outPd = sum(Detection_data(:,N/2))/M;
           
        end
        function outData = calcPdReal(obj,Pfa,data)
            k = obj.k;
            n = obj.os_wnd*2;
            c1 = k*nchoosek(n,k);
            c2 = factorial(k-1);
            c3 = c1*c2;
            eqn = @(T) abs(c3/prod((T+n-k+1):(T+n))-Pfa);
            max = n*1e7;
            solT = fminbnd(eqn,1e-20,max);
            while solT*1.1 >= max
                max = max/10;
                solT = fminbnd(eqn,1e-20,max);
            end
            
            %% ������ ������
            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for y = obj.os_wnd + 1:length(data)-obj.os_wnd-1                                                         
                tempdata = data([y-obj.os_wnd:y-1,y+1:y+obj.os_wnd]);
                tempdata = sort(tempdata);
                Detection_data(y) = data(y) >= sqrt(tempdata(k)*solT);
            end

            Detection_data = reshape(Detection_data,[],4096);
            Detection_data = Detection_data';
            
            outData = Detection_data;
           
        end
        function outPfa = calcPfa(obj,Pfa,noise)
            %����� �������� �� ��������
            [M,N] = size(noise); %������, �������
            
            noise = abs(noise);
            data = noise;
            
            k = obj.k;
            n = obj.os_wnd*2;
            c1 = k*nchoosek(n,k);
            c2 = factorial(k-1);
            c3 = c1*c2;
            eqn = @(T) abs(c3/prod((T+n-k+1):(T+n))-Pfa);
            max = n*1e7;
            solT = fminbnd(eqn,1e-20,max);
            while solT*1.1 >= max
                max = max/10;
                solT = fminbnd(eqn,1e-20,max);
            end

            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for y = obj.os_wnd + 1:length(data)-obj.os_wnd-1                                                         
                tempdata = data([y-obj.os_wnd:y-1,y+1:y+obj.os_wnd]);
                tempdata = sort(tempdata);
                Detection_data(y) = data(y) >= sqrt(tempdata(k)*solT);
            end

            Detection_data = Detection_data';
            
            outPfa = sum(Detection_data)/(M*N);
        end
    end
end
         
            
                
               