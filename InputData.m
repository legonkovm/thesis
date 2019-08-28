classdef InputData < handle
    properties
        Pfa %заданная вероятность ложных тревог
        algName %имя алгоритма
        algNumber %номер алгоритма
        NumRot
        MedOn
        NumRLS
        Distance
        Azimut
        DistPd
        
        %последние параметры алгоритмов
        %ca-cfar
        ca_grd
        ca_wnd
        
        %lo-сfar
        lo_grd
        lo_wnd
        
        %go-cfar
        go_grd
        go_wnd
        
        %os-cfar
        k
        os_wnd
    end
    
    methods
        function obj = InputData
            if ~exist('inputData.mat','file')
                %по умолчанию
                obj.Pfa = 1e-6; %заданная вероятность ложных тревог

                
                obj.algNumber = 1;
                obj.algName = 'Классический (оптимальный)';
                obj.Distance = 3000;
                obj.Azimut = 0;
                obj.DistPd = 1000;
                obj.NumRLS = 1;
                obj.NumRot = 1;
                obj.MedOn = 0;
                
                %ca-cfar
                obj.ca_grd = 2; %защитный интервал
                obj.ca_wnd = 8; %ширина полуокна
                
                %lo-сfar
                obj.lo_grd = 2;
                obj.lo_wnd = 8;
                
                %go-cfar
                obj.go_grd = 2;
                obj.go_wnd = 8;
                
                %os-cfar
                obj.k = 27; %номер отсчета в вариационном ряду
                obj.os_wnd = 16;%объем вариационного ряда
            else
                load inputData.mat obj;
                %todo проверка на правильную загрузку данных
            end
            
        end
        function update(obj)
            save inputData obj;
        end
    end
end

