function TabDemo
%   This function creates a figure with multiple Tabs.
%   The number of tabs can be changed and they are distributed evenly
%   across the top of the figure.  Content is provided for the first 5 tabs
%   to demo the program.  The demo uses the screen size to adjust the size
%   of the figure.  The program uses the ~ character for unused arguments,
%   so if you are not using 2009b, these should be changed to dummy
%   arguments (lines 209 and 233). guidata is set to the TabHandles cell
%   array and is used to pass all arguments and data to the functions.

%%   Set up some varables
%   First clear everything
        clear all
        clc
        
%   Set Number of tabs and tab labels.  Make sure the number of tab labels
%   match the HumberOfTabs setting.
        NumberOfTabs = 2;               % Number of tabs to be generated
        TabLabels = {'Sensor graphs'; 'Raw Data'}; %; 'Summary' 'Tab4'; 'Tab 5'; 'Tab 6'
        if size(TabLabels,1) ~= NumberOfTabs
            errordlg('Number of tabs and tab labels must be the same','Setup Error');
            return
        end
        
%   Get user screen size
        SC = get(0, 'ScreenSize');
        MaxMonitorX = SC(3);
        MaxMonitorY = SC(4);
        
 %   Set the figure window size values
        MainFigScale = 0.98;          % Change this value to adjust the figure size
        ButtonHeight = MaxMonitorY *0.05;
        MaxWindowX = round(MaxMonitorX*1);
        MaxWindowY = round(MaxMonitorY*0.94);
        XBorder = (MaxMonitorX-MaxWindowX)/2 - 0.0651*MaxMonitorX;
        YBorder = (MaxMonitorY-MaxWindowY)/2 - 0.0366*MaxMonitorY; 
        TabOffset = 0;              % This value offsets the tabs inside the figure.
        
        PanelWidth = MaxWindowX-2*TabOffset+4;
        PanelHeight = MaxWindowY-ButtonHeight-2*TabOffset;
        ButtonWidth = round((PanelWidth-NumberOfTabs)/NumberOfTabs);
                
 %   Set the color varables.  
        Grey = [0.9375 0.9375 0.9375];
        White = [1  1  1];            % White - Selected tab color     
        BGColor = .9*White;           % Light Grey - Background color
            
%%   Create a figure for the tabs
        hTabFig = figure(...
            'Units', 'pixels',...
            'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],...
            'NumberTitle', 'off',...
            'Name', 'Tab Demo',...
            'Resize', 'on',...
            'DockControls', 'off',...
            'Toolbar', 'figure',...
            'MenuBar', 'none',... 
            'WindowStyle', 'normal',...
            'Color', White);

   

%%   Define a cell array for panel and pushbutton handles, pushbuttons labels and other data
    %   rows are for each tab + two additional rows for other data
    %   columns are uipanel handles, selection pushbutton handles, and tab label strings - 3 columns.
            TabHandles = cell(NumberOfTabs,3);
            TabHandles(:,3) = TabLabels(:,1);
    %   Add additional rows for other data
            TabHandles{NumberOfTabs+1,1} = hTabFig;         % Main figure handle
            TabHandles{NumberOfTabs+1,2} = PanelWidth;      % Width of tab panel
            TabHandles{NumberOfTabs+1,3} = PanelHeight;     % Height of tab panel
            TabHandles{NumberOfTabs+2,1} = 0;               % Handle to default tab 2 content(set later)
            TabHandles{NumberOfTabs+2,2} = White;           % Selected tab Color
            TabHandles{NumberOfTabs+2,3} = BGColor;         % Background color
            
%%   Build the Tabs
        for TabNumber = 1:NumberOfTabs
        % create a UIPanel   
            TabHandles{TabNumber,1} = uipanel('Units', 'pixels', ...
                'Visible', 'off', ...
                'Backgroundcolor', Grey, ...
                'BorderWidth',1, ...
                'Position', [TabOffset TabOffset ...
                PanelWidth PanelHeight]);

        % create a selection pushbutton
            TabHandles{TabNumber,2} = uicontrol('Style', 'pushbutton',...
                'Units', 'pixels', ...
                'BackgroundColor', BGColor, ...
                'Position', [TabOffset+(TabNumber-1)*ButtonWidth PanelHeight+TabOffset...
                    ButtonWidth ButtonHeight], ...          
                'String', TabHandles{TabNumber,3},...
                'HorizontalAlignment', 'center',...
                'FontName', 'arial',...
                'FontWeight', 'bold',...
                'FontSize', 10);

        end

%%   Define the callbacks for the Tab Buttons
%   All callbacks go to the same function with the additional argument being the Tab number
        for CountTabs = 1:NumberOfTabs
            set(TabHandles{CountTabs,2}, 'callback', ...
                {@TabSellectCallback, CountTabs});
        end

%%   Define content for the Open Image File Tab
    %   Open Image Pushbutton
%         hp = uipanel('Parent', TabHandles{1,1}, ...
%             'Title','Main Panel','FontSize',12,...
%              'BackgroundColor',Grey,...
%              'BorderType','etchedin',...
%              'BorderWidth', 3,...
%              'HighlightColor', 'b',...
%              'Position',[0 0 1 .1])
        uicontrol('Parent', TabHandles{1,1}, ...
            'Units', 'pixels', ...
            'Position', [ 5 5 120 35], ...
            'String', 'Import Data', ...
            'Callback', @OpenCSVCallback , ...
            'Style', 'pushbutton',...
            'HorizontalAlignment', 'center',...
            'FontName', 'arial',...
            'FontWeight', 'normal',...
            'FontSize', 12);
        zeta = 0;
        b = uicontrol('Parent', TabHandles{1,1},'Style','slider','Position',[135,5,419,23],...
              'value',zeta, 'min',0, 'max',1);
        global PlayStrings;
        PlayStrings = {'Play';'Stop'};
        PlayStopButton= uicontrol('Parent', TabHandles{1,1},'Style','push','String',PlayStrings{1},'Position',[560 5 50 30],'Callback',@(s,e) PlayStopCallback);
        tabgp = uitabgroup(TabHandles{1,1},'Position',[0 0.10 .45 .45]);
        tab1 = uitab(tabgp,'Title','Left Heel Acceleration');
        tab2 = uitab(tabgp,'Title','Right Heel Acceleration');
        tab3= uitab(tabgp,'Title','Pelvis Acceleration');
        tabgp1 = uitabgroup(TabHandles{1,1},'Position',[0. .55 .45 .45]);
        tab11 = uitab(tabgp1,'Title','Left Foot Pressure');
        tab22 = uitab(tabgp1,'Title','Right Foot Pressure');
        MonitorArea = MaxMonitorX * MaxMonitorY;
        PlotOffset =(3.05*10.^-5)*MonitorArea;

        global haxes1_2;
        haxes1_2 = axes('Parent', tab1, ...
            'Units', 'pixels', ...
            'Position', [PlotOffset PlotOffset ...
                0.421*MaxMonitorX 0.306*MaxMonitorY]);
       % plot(haxes1_2, 1:200, sin((1:200)./12));
       % hline(0, 'r:', '');
        
        global haxes1_3;
        haxes1_3 = axes('Parent', tab2, ...
            'Units', 'pixels', ...
            'Position', [PlotOffset PlotOffset ...
                0.421*MaxMonitorX 0.306*MaxMonitorY]);
        %plot(haxes1_3, 1:200, cos((1:200)./12));
        %hline(0, 'r:', '');
        axesArray(2) = haxes1_3;
        
        global haxes1_8;
        haxes1_8 = axes('Parent', tab3, ...
            'Units', 'pixels', ...
            'Position', [PlotOffset PlotOffset ...
                0.421*MaxMonitorX 0.306*MaxMonitorY]);
        %plot(haxes1_8, 1:200, cos((1:200)./12));
       % hline(0, 'r:', '');
       axesArray(3) = haxes1_8;
        
       global haxes1_4;
        haxes1_4 = axes('Parent', tab11, ...
            'Units', 'pixels', ...
            'Position', [PlotOffset PlotOffset ...
                0.421*MaxMonitorX 0.306*MaxMonitorY]);
       % plot(haxes1_4, 1:200, sin((1:200)./12));
        %hline(0, 'r:', '');
        axesArray(4) = haxes1_4;
        
        global haxes1_5;
        haxes1_5 = axes('Parent', tab22, ...
            'Units', 'pixels', ...
            'Position', [PlotOffset PlotOffset ...
                0.421*MaxMonitorX 0.306*MaxMonitorY]);
        %plot(haxes1_5, 1:200, cos((1:200)./12));
        %hline(0, 'r:', '');
        axesArray(5) = haxes1_5;
        
        PlotOffset = 0.0521 * MaxMonitorY;
        global haxes1_6;
        haxes1_6 = axes('Parent', TabHandles{1,1}, ...
            'Units', 'pixels', ...
            'Position', [0.4978*MaxMonitorX 0.0651*MaxMonitorY ...
                0.2196*MaxMonitorX PanelHeight-2*PlotOffset]);
       % plot(haxes1_6, 1:200, sin((1:200)./12));
       axesArray(6) = haxes1_6;
        
       global haxes1_7;
        haxes1_7 = axes('Parent', TabHandles{1,1}, ...
            'Units', 'pixels', ...
            'Position', [0.7686*MaxMonitorX 0.0651*MaxMonitorY ...
                0.2196*MaxMonitorX PanelHeight-2*PlotOffset]);
        axesArray(7) = haxes1_7;

%%   Define Tab 2 content
    %   Build a table header
        uicontrol('Style', 'text',...
            'Position', [ round((PanelWidth-ButtonWidth)/2) PanelHeight-round(1.5*ButtonHeight) ...
                ButtonWidth ButtonHeight ],...
            'Parent', TabHandles{2,1}, ...
            'string', '  Tab 3 Table ',...
            'BackgroundColor', White,...
            'HorizontalAlignment', 'center',...
            'FontName', 'arial',...
            'FontWeight', 'bold',...
            'FontSize', 12);

    %   Build the data cell array to display
%         DisplayData = RawData;
%         ColumnNames = {' Column 1 ' ' Column 2 ' ' Column 3 ' ' Column 4 ' ' Column 5 '};
        Width = PanelWidth/12-1;
        ColumnWidths = {Width Width Width Width Width};
        
        global table;
    %   Create the table
        table = uitable('Position',...
            [1 1 PanelWidth PanelHeight-2*ButtonHeight],...
            'Parent', TabHandles{2,1}, ...
            'ColumnWidth', ColumnWidths,...
            'RowName', []);

% 'Data', RawData,...  
%'ColumnName', ColumnNames,...

%%   Define Tab 3 content

%%   Save the TabHandles in guidata
        guidata(hTabFig,TabHandles);

%%   Make Tab 1 active
        TabSellectCallback(0,0,1);
        


end
%%   Callback for Tab Selection
function TabSellectCallback(~,~,SelectedTab)
%   All tab selection pushbuttons are greyed out and uipanels are set to
%   visible off, then the selected panel is made visible and it's selection
%   pushbutton is highlighted.

    %   Set up some varables
        TabHandles = guidata(gcf);
        NumberOfTabs = size(TabHandles,1)-2;
        White = TabHandles{NumberOfTabs+2,2};            % White      
        BGColor = TabHandles{NumberOfTabs+2,3};          % Light Grey
        
    %   Turn all tabs off
        for TabCount = 1:NumberOfTabs
            set(TabHandles{TabCount,1}, 'Visible', 'off');
            set(TabHandles{TabCount,2}, 'BackgroundColor', BGColor);
        end
        
    %   Enable the selected tab
        set(TabHandles{SelectedTab,1}, 'Visible', 'on');        
        set(TabHandles{SelectedTab,2}, 'BackgroundColor', White);

end

%%   Open Image File Callback
function OpenCSVCallback(~,~)
    %   Get TabHandles from guidata and set some varables
        TabHandles = guidata(gcf);
        NumberOfTabs = size(TabHandles,1)-2;
        PanelWidth = TabHandles{NumberOfTabs+1,2};
        PanelHeight = TabHandles{NumberOfTabs+1,3};

    %   Two persistent varables are needed
        persistent StartPicDirectory hImageAxes
        
    %   Initilize the StartPicDirectory if first time through
        if isempty(StartPicDirectory)
            StartPicDirectory = cd;
        end
    
    %   Get the file name from the user
        [PicNameWithTag, PicDirectory] = uigetfile({'*.csv;','Image Files'},...
            'Select a csv file',StartPicDirectory);

        if PicNameWithTag == 0,
            %   If User canceles then display error message
                errordlg('You should select a CSV File');
            return
        end
        
    %   Set the default directory to the currently selected directory
        StartPicDirectory = PicDirectory;

    %   Build path to file
        PicFilePath = strcat(PicDirectory,PicNameWithTag);
        drawGraphs(PicFilePath);
end
