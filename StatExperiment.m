classdef StatExperiment < handle
    properties
        m_InputData %ссылка на параметры эксперимента
    end

    
    methods
        function obj = StatExperiment(m_InputData_arg)
            if nargin > 0
                obj.m_InputData = m_InputData_arg;
            end
        end
        function outPd = calculate_Pd(obj)
            %метод отвечает за рассчеты
            %загрузить последние данные из InputData;
            Pfa = obj.m_InputData.Pfa;
            fprintf(2,['used ' obj.m_InputData.algName ]);
            halg = obj.m_InputData.algNumber; %номер алгоритма
            fprintf(2,[' and ' obj.m_InputData.NumRLS '\n']);
            NumRot = obj.m_InputData.NumRot;
            MedOn = obj.m_InputData.MedOn;
            NumRLS = obj.m_InputData.NumRLS;
            Azimut = obj.m_InputData.Azimut;
            DistPd = obj.m_InputData.DistPd;
            DistPd = round(DistPd * 0.79);
            Azimut = round(Azimut / 360 * 800);
            Num = 1:70;
            if NumRLS == 1
                signal = 'RLS_1_fileRLS_FFT_009.b'; 
                Num = [1:38 40:60 62:70];
            end
            if NumRLS == 2
                signal = 'RLS_2_fileRLS_FFT_009.b';
                Num = [1:34 36:59 61:70];
            end
            if NumRLS == 3
                signal = 'RLS_3_fileRLS_FFT_010.b';
            end
            if NumRLS == 5
                signal = 'RLS_5_fileRLS_FFT_009.b';
            end
            
 
            flParamSet = 0;
            mraw = memmapfile(signal,...
                'Offset',0,...
                'Repeat',50000,...
                'Format',{...
                'uint32',1,'size';...
                'double',1,'time';...
                'uint32',1,'senderID';...
                'uint32',1,'signalType';...
                'uint32',1,'signalMode';...
                'uint32',1,'line_num';...
                'uint32',1,'pos';...
                'single',4096,'spectr'});
            pos = [];
            k = 1;
            for ii = 1:50000
                pos(ii) = mraw.Data(ii).pos;
                if ii > 1 && pos(ii-1) > pos(ii)
                    posnum(k) = ii - 1;
                    k = k + 1;
                end
            end

            for M = Num
                k = 0; %количество азимутов
                s2 = [];

                for ii = posnum(M) : (posnum(M+1)-1) %формирование массива
                    s2 = [s2 mraw.Data(ii).spectr];
                    k = k + 1;
                end
                s3 = [];
                for j = 1:4096 %интерполяция до 800 точек
                    s3 = [s3 (interp1(1:k, s2(j,1:k), 1:(k/801):k))'];
                end
                s3 = s3';
                rawdata(:,:,M) = s3;
            end  
%             [value1 y] = max(rawdata(800:4096,:,3));
%             [value2 x] = max(value1);
            s4 = rawdata(:,:,1);
            for M = Num

                data = rawdata(:, Azimut, M); 
                switch halg
                    case 1
                        if flParamSet == 0
                            fprintf('Алгоритм не выбран \n');
                            flParamSet = 1;
                        end
                    case 2
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_CA = Detector_CFAR_CA(answer);
                            flParamSet = 1;
                        end
                        outData(:,M) = m_Det_CA.calcPdReal(Pfa,data);

                    case 3
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_GO = Detector_CFAR_GO(answer);
                            flParamSet = 1;
                        end
                        outData(:,M) = m_Det_GO.calcPdReal(Pfa,data);
                    case 4
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_LO = Detector_CFAR_LO(answer);
                            flParamSet = 1;
                        end

                        outData(:,M) = m_Det_LO.calcPdReal(Pfa,data);   
                    case 5
                        %обнаружитель ПУЛТ(OS)
                        if flParamSet == 0
                            prompt = {'Номер элемента выборки:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.k),num2str(obj.m_InputData.os_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_OS = Detector_CFAR_OS(answer);
                            flParamSet = 1;
                        end
                        outData(:,M) = m_Det_OS.calcPdReal(Pfa,data);                            
                end
            end
            outPd = sum(outData(DistPd,:))/length(Num);
            try
                strPdExperiment = sprintf('%1.1d',outPd);

                h = msgbox({'Требуемая Pd = 0.9'  ...
                    ['Расчетная Pd = ' strPdExperiment]},'Расчет вероятности ПО');
                uiwait(h);
            catch
                fprintf(2,'алгоритм не выбран! (отображение) \n');
            end                
            
        end
        
        function outData = show_picture(obj)
            %метод отвечает за рассчеты
            %загрузить последние данные из InputData;
            Pfa = obj.m_InputData.Pfa;
            fprintf(2,['used ' obj.m_InputData.algName ]);
            halg = obj.m_InputData.algNumber; %номер алгоритма
            fprintf(2,[' and ' obj.m_InputData.NumRLS '\n']);
            NumRot = obj.m_InputData.NumRot;
            MedOn = obj.m_InputData.MedOn;
            Distance = obj.m_InputData.Distance;
            NumRLS = obj.m_InputData.NumRLS;
            if NumRLS == 1
                signal = 'RLS_1_fileRLS_FFT_009.b';
            end
            if NumRLS == 2
                signal = 'RLS_2_fileRLS_FFT_009.b';
            end
            if NumRLS == 3
                signal = 'RLS_3_fileRLS_FFT_010.b';
            end
            if NumRLS == 5
                signal = 'RLS_5_fileRLS_FFT_009.b';
            end
            if Distance > 3235
                Distance = 3235;
            end
            flParamSet = 0;
            mraw = memmapfile(signal,...
                'Offset',0,...
                'Repeat',50000,...
                'Format',{...
                'uint32',1,'size';...
                'double',1,'time';...
                'uint32',1,'senderID';...
                'uint32',1,'signalType';...
                'uint32',1,'signalMode';...
                'uint32',1,'line_num';...
                'uint32',1,'pos';...
                'single',4096,'spectr'});
            pos = [];
            k = 1;
            for ii = 1:50000
                pos(ii) = mraw.Data(ii).pos;
                if ii > 1 && pos(ii-1) > pos(ii)
                    posnum(k) = ii - 1;
                    k = k + 1;
                end
            end
            if MedOn == 0
                m = 0;
            else
                m = 2;
            end

            for M = (NumRot - m):NumRot
                k = 0; %количество азимутов
                s2 = [];

                for ii = posnum(M) : (posnum(M+1)-1) %формирование массива
                    s2 = [s2 mraw.Data(ii).spectr];
                    k = k + 1;
                end
                s3 = [];
                for j = 1:4096 %интерполяция до 800 точек
                    s3 = [s3 (interp1(1:k, s2(j,1:k), 1:(k/801):k))'];
                end
                s3 = s3';
                rawdata(:,:,M) = s3;
            end

            if MedOn == 1
                for i = 1:4096
                    for j = 1:800
                        rawdata(i,j,:) = medfilt1(rawdata(i,j,:)); %Медианная фильтрация
                    end
                end
            end


            for i = 1 : 800

                data = rawdata(:, i, NumRot); 
                switch halg
                    case 1
                        outData(:,:) = rawdata(:, :, NumRot);
                    case 2
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_CA = Detector_CFAR_CA(answer);
                            flParamSet = 1;
                        end
                        outData(:,i) = m_Det_CA.calcPdReal(Pfa,data);

                    case 3
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_GO = Detector_CFAR_GO(answer);
                            flParamSet = 1;
                        end
                        outData(:,i) = m_Det_GO.calcPdReal(Pfa,data);
                    case 4
                        if flParamSet == 0
                            prompt = {'Защитный интервал:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_LO = Detector_CFAR_LO(answer);
                            flParamSet = 1;
                        end

                        outData(:,i) = m_Det_LO.calcPdReal(Pfa,data);   
                    case 5
                        %обнаружитель ПУЛТ(OS)
                        if flParamSet == 0
                            prompt = {'Номер элемента выборки:','Ширина полуокна:'};
                            dlg_title = 'Настройка параметров';
                            num_lines = 1;
                            defaultans = {num2str(obj.m_InputData.k),num2str(obj.m_InputData.os_wnd)};
                            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                            %todo проверка на ширину выборки данных
                            m_Det_OS = Detector_CFAR_OS(answer);
                            flParamSet = 1;
                        end
                        outData(:,i) = m_Det_OS.calcPdReal(Pfa,data);                            
                end
            end
            
            Distance = fix(Distance / 0.79);

%                 f1 = figure;

%                 subplot(1,2,1);

            polarplot3d(outData(1:Distance,end:-1:1));
            set(gca,'Xlim',[-1.01 1.01],'Ylim',[-1.01 1.01]);
            if halg == 1
                caxis([0 20])
            end
            view(2);
%                 xlabel('Азимут');
%                 ylabel('Дальность');
            title ('Радиолокационное изображение'); 
%                 subplot(1,2,2);
%                 polarplot3d(rawdata(:,:,NumRot));
%                 caxis([0 20]);
%                 set(gca,'Xlim',[-1.01 1.01],'Ylim',[-1.01 1.01]);
%                 view(2);        
% %                 xlabel('Азимут');
% %                 ylabel('Дальность');
%                 title ('Исходный сигнал');
%                 fprintf(2,' расчет окончен \n'); 
 
            
        end
        
        function outPfa = calculate_Pfa(obj)
            
            %метод отвечает за рассчеты
            
            %загрузить последние данные из InputData;
            Pfa = obj.m_InputData.Pfa;
            fprintf(2,['used ' obj.m_InputData.algName ]);
            halg = obj.m_InputData.algNumber; %номер алгоритма
            fprintf(2,[' and ' obj.m_InputData.NumRLS '\n']);
%             hsignal = obj.m_InputData.signalNumber; %номер сигнала
            NumRLS = obj.m_InputData.NumRLS;
            %количество исследуемых азимутов
            Naz1 = 40;
            Naz2 = 200;
            if NumRLS == 1
                signal = 'RLS_1_fileRLS_FFT_009.b';
                Naz1 = 250;
                Naz2 = 450;
            end
            if NumRLS == 2
                signal = 'RLS_2_fileRLS_FFT_009.b';
            end
            if NumRLS == 3
                signal = 'RLS_3_fileRLS_FFT_010.b';
            end
            if NumRLS == 5
                signal = 'RLS_5_fileRLS_FFT_009.b';
            end
            flParamSet = 0;
            %инициализация массивов для отображения результатов расчет
         
                mraw = memmapfile(signal,...
                    'Offset',0,...
                    'Repeat',50000,...
                    'Format',{...
                    'uint32',1,'size';...
                    'double',1,'time';...
                    'uint32',1,'senderID';...
                    'uint32',1,'signalType';...
                    'uint32',1,'signalMode';...
                    'uint32',1,'line_num';...
                    'uint32',1,'pos';...
                    'single',4096,'spectr'});
                pos = [];
                k = 1;
                for ii = 1:50000
                    pos(ii) = mraw.Data(ii).pos;
                    if ii > 1 && pos(ii-1) > pos(ii)
                        posnum(k) = ii - 1;
                        k = k + 1;
                    end
                end

                rawdata = [];
                
                for j = 1:70
                    m = memmapfile('RLS_2_fileRLS_FFT_001.b',...
                        'Offset',16416*(posnum(j) + Naz1),...
                        'Repeat',(Naz2-Naz1+1),...
                        'Format',{...
                        'uint32',1,'size';...
                        'double',1,'time';...
                        'uint32',1,'senderID';...
                        'uint32',1,'signalType';...
                        'uint32',1,'signalMode';...
                        'uint32',1,'line_num';...
                        'uint32',1,'pos';...
                        'single',4096,'spectr'});
                    for i = 1:(Naz2 - Naz1)
                        noise = m.Data(i).spectr(2000:4096);
                        switch halg
                            case 1
                                if flParamSet == 0
                                    fprintf('Алгоритм не выбран \n');
                                    flParamSet = 1;
                                end
                            case 2
                                if flParamSet == 0
                                    prompt = {'Защитный интервал:','Ширина полуокна:'};
                                    dlg_title = 'Настройка параметров';
                                    num_lines = 1;
                                    defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                                    %todo проверка на ширину выборки данных
                                    m_Det_CA = Detector_CFAR_CA(answer);
                                    flParamSet = 1;
                                end
                                m_Det_CA = Detector_CFAR_CA;
                                outPfa = m_Det_CA.calcPfa(Pfa,noise);
                                PfaRot(i) = outPfa; 
                            case 3
                                if flParamSet == 0
                                    prompt = {'Защитный интервал:','Ширина полуокна:'};
                                    dlg_title = 'Настройка параметров';
                                    num_lines = 1;
                                    defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                                    %todo проверка на ширину выборки данных
                                    m_Det_GO = Detector_CFAR_GO(answer);
                                    flParamSet = 1;
                                end
                                m_Det_GO = Detector_CFAR_GO;
                                outPfa = m_Det_GO.calcPfa(Pfa,noise);
                                PfaRot(i) = outPfa; 
                            case 4
                                if flParamSet == 0
                                    prompt = {'Защитный интервал:','Ширина полуокна:'};
                                    dlg_title = 'Настройка параметров';
                                    num_lines = 1;
                                    defaultans = {num2str(obj.m_InputData.ca_grd),num2str(obj.m_InputData.ca_wnd)};
                                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                                    %todo проверка на ширину выборки данных
                                    m_Det_LO = Detector_CFAR_LO(answer);
                                    flParamSet = 1;
                                end
                                m_Det_LO = Detector_CFAR_LO;
                                outPfa = m_Det_LO.calcPfa(Pfa,noise);
                                PfaRot(i) = outPfa; 
                            case 5
                                %обнаружитель ПУЛТ(OS)
                                if flParamSet == 0
                                    prompt = {'Номер элемента выборки:','Ширина полуокна:'};
                                    dlg_title = 'Настройка параметров';
                                    num_lines = 1;
                                    defaultans = {num2str(obj.m_InputData.k),num2str(obj.m_InputData.os_wnd)};
                                    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                                    %todo проверка на ширину выборки данных
                                    m_Det_OS = Detector_CFAR_OS(answer);
                                    flParamSet = 1;
                                end
                                m_Det_OS = Detector_CFAR_OS;
                                outPfa = m_Det_OS.calcPfa(Pfa,noise);  
                                PfaRot(i) = outPfa; 
                        end
                    end
                    outPfasum1(j) = sum(PfaRot(:))/(Naz2 - Naz1);
                end
                outPfasum = sum(outPfasum1)/68;

                try
                    strPfaTheory = sprintf('%1.1d',Pfa);
                    strPfaExperiment = sprintf('%1.1d',outPfasum);

                    h = msgbox({['Заданная Pfa=' strPfaTheory]  ...
                        ['Расчетная Pfa=' strPfaExperiment]},'Расчет вероятности ЛТ');
                    uiwait(h);
                catch
                    fprintf(2,'алгоритм не выбран! (отображение) \n');
                end
            
        end
    end
end

