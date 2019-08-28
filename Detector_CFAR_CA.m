classdef Detector_CFAR_CA < handle
    properties
        m_InputData %������ �� ��������� ������������
        wnd
        grd
    end
    
    methods
        function obj = Detector_CFAR_CA(answer)
            %������������� ������������
            if nargin < 1
                obj.wnd = 8;
                obj.grd = 2;
            else
                obj.grd = str2double(answer{1});
                obj.wnd = str2double(answer{2});
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
            outSNR = abs(10*log10(q));

            %% ������ ������
            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for i=obj.grd+obj.wnd+1:length(data)-(obj.grd+obj.wnd)
                idxLeft = i-obj.grd-obj.wnd:i-obj.grd-1;
                idxRight = i+obj.grd+1:i+obj.grd+obj.wnd;
                noiseLeft = rssq(data(idxLeft)).^2/obj.wnd;
                noiseRight = rssq(data(idxRight)).^2/obj.wnd;
                noiseCA = 0.5*(noiseLeft+noiseRight)/2;
                T = sqrt(-2*log(Pfa)*noiseCA);
                Detection_data(i) = data(i) >= T;
            end
            Detection_data = reshape(Detection_data,[],M);
            Detection_data = Detection_data';
            
            outPd = sum(Detection_data(:,N/2))/M;
           
        end
        
        function outData = calcPdReal(obj,Pfa,data)
            %����� �������� �� ��������

            %% ������ ������
            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for i=obj.grd+obj.wnd+1:length(data)-(obj.grd+obj.wnd)
                idxLeft = i-obj.grd-obj.wnd:i-obj.grd-1;
                idxRight = i+obj.grd+1:i+obj.grd+obj.wnd;
                noiseLeft = rssq(data(idxLeft)).^2/obj.wnd;
                noiseRight = rssq(data(idxRight)).^2/obj.wnd;
                noiseCA = 0.5*(noiseLeft+noiseRight)/2;
                T = sqrt(-2*log(Pfa)*noiseCA);
                Detection_data(i) = data(i) >= T;
            end
            Detection_data = reshape(Detection_data,[],4096);
            Detection_data = Detection_data';
            
            outData = Detection_data;
           
        end
        
        function  outPfa = calcPfa(obj,Pfa,noise)
            %����� �������� �� ��������
            [M,N] = size(noise); %������, �������
            
            noise = abs(noise);
            data = noise;
            data = data';
            data = data(:);
            Detection_data = zeros(size(data));
            for i=obj.grd+obj.wnd+1:length(data)-(obj.grd+obj.wnd)
                idxLeft = i-obj.grd-obj.wnd:i-obj.grd-1;
                idxRight = i+obj.grd+1:i+obj.grd+obj.wnd;
                noiseLeft = rssq(data(idxLeft)).^2/obj.wnd;
                noiseRight = rssq(data(idxRight)).^2/obj.wnd;
                noiseCA = 0.5*(noiseLeft+noiseRight)/2;
                T = sqrt(-2*log(Pfa)*noiseCA);
                Detection_data(i) = data(i) >= T;
            end

            Detection_data = Detection_data';
            
            outPfa = sum(Detection_data)/(M*N);
        end
    end
end