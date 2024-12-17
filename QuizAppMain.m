classdef QuizAppMain < matlab.apps.AppBase
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        QuizImage            matlab.ui.control.Image
        QuestionLabel        matlab.ui.control.Label
        AButton              matlab.ui.control.Button
        BButton              matlab.ui.control.Button
        CButton              matlab.ui.control.Button
        DButton              matlab.ui.control.Button
        ScoreLabel           matlab.ui.control.Label
        AptitudeButton       matlab.ui.control.Button
        HistoryButton        matlab.ui.control.Button
        PhysicsButton        matlab.ui.control.Button
        RestartButton        matlab.ui.control.Button
        BackButton           matlab.ui.control.Button 
        NextButton           matlab.ui.control.Button 
    end
    properties (Access = private)
        Questions            
        Options              
        CorrectAnswers       
        CurrentQuestionIndex 
        Score             
        QuizTimer              % Timer object for countdown
        TimerLabel             matlab.ui.control.Label % Label to display remaining time
        ResultAxes  matlab.ui.control.UIAxes
    end
    methods (Access = private)
        function startupFcn(app)
            app.hideQuizComponents();
            app.showFieldSelectionComponents();
        end
        function hideQuizComponents(app)
            app.QuestionLabel.Visible = 'off';
            app.AButton.Visible = 'off';
            app.BButton.Visible = 'off';
            app.CButton.Visible = 'off';
            app.DButton.Visible = 'off';
            app.ScoreLabel.Visible = 'off';
            app.RestartButton.Visible = 'off';
        end
        function showFieldSelectionComponents(app)
            app.AptitudeButton.Visible = 'on';
            app.HistoryButton.Visible = 'on';
            app.PhysicsButton.Visible = 'on';
            app.QuestionLabel.Text = 'Select a field to start the quiz';
            app.QuestionLabel.Visible = 'on';
        end
        function showQuizComponents(app)
            app.QuestionLabel.Visible = 'on';
            app.AButton.Visible = 'on';
            app.BButton.Visible = 'on';
            app.CButton.Visible = 'on';
            app.DButton.Visible = 'on';
            app.ScoreLabel.Visible = 'on';
            app.RestartButton.Visible = 'on';
            app.BackButton.Visible = 'on'; % Show Back button
            app.NextButton.Visible = 'on'; % Show Next button
        end
        function handleFieldSelection(app, field)
            app.hideQuizComponents();
            app.showQuizComponents();
            app.setFieldQuestions(field);
            % Create the timer
            app.QuizTimer = timer( ...
           'ExecutionMode', 'fixedRate', ...  % Execute at fixed intervals
           'Period', 1, ...                   % Update every second
           'TasksToExecute', 300, ...         % 15 minutes = 900 seconds
           'TimerFcn', @(~, ~) app.updateTimer(), ... % Callback to update timer display
           'StopFcn', @(~, ~) app.restartApp());      % Callback when timer ends
            start(app.QuizTimer);

        end
        function goBack(app)
    if app.CurrentQuestionIndex > 1
        app.CurrentQuestionIndex = app.CurrentQuestionIndex - 1;
        app.updateQuestion();
    end  
        end
function goNext(app)
    if app.CurrentQuestionIndex < length(app.Questions)
        app.CurrentQuestionIndex = app.CurrentQuestionIndex + 1;
        app.updateQuestion();
    end
end
        function setFieldQuestions(app, field)
            switch field
                case 'Aptitude'
                    app.Questions = {
                        'If a person travels at 60 km/hr for 2 hours, what distance does he cover?';
                        'Find the next number in the sequence: 2, 4, 8, 16, ...';
                        'What is the least common multiple (LCM) of 4 and 6?';
                        'A train 100 meters long is moving at 30 m/s. How long will it take to cross a bridge 200 meters long?';
                        'What is the average of 10, 20, and 30?'
                    };
                    app.Options = {
                        {'A) 100 km', 'B) 110 km', 'C) 120 km', 'D) 130 km'};
                        {'A) 24', 'B) 32', 'C) 40', 'D) 48'};
                        {'A) 10', 'B) 12', 'C) 14', 'D) 18'};
                        {'A) 10 seconds', 'B) 15 seconds', 'C) 20 seconds', 'D) 25 seconds'};
                        {'A) 15', 'B) 20', 'C) 25', 'D) 30'}
                    };
                    app.CorrectAnswers = {'C', 'B', 'B', 'B', 'B'};
                case 'History'
                    app.Questions = {
                        'Who discovered America?';
                        'When did World War I begin?';
                        'Who was the first Emperor of Rome?';
                        'What year did the Berlin Wall fall?';
                        'Which civilization built the pyramids?'
                    };
                    app.Options = {
                        {'A) Christopher Columbus', 'B) Vasco da Gama', 'C) Ferdinand Magellan', 'D) James Cook'};
                        {'A) 1912', 'B) 1914', 'C) 1916', 'D) 1918'};
                        {'A) Julius Caesar', 'B) Augustus', 'C) Nero', 'D) Constantine'};
                        {'A) 1987', 'B) 1988', 'C) 1989', 'D) 1990'};
                        {'A) Mesopotamian', 'B) Roman', 'C) Greek', 'D) Egyptian'}
                    };
                    app.CorrectAnswers = {'A', 'B', 'B', 'C', 'D'};
                case 'Physics'
                    app.Questions = {
                        'What is the speed of light in a vacuum?';
                        'What is the SI unit of force?';
                        'Which law states that every action has an equal and opposite reaction?';
                        'What is the charge of an electron?';
                        'What is the formula for kinetic energy?'
                    };
                    app.Options = {
                        {'A) 300,000 m/s', 'B) 3,000 m/s', 'C) 3 × 10^8 m/s', 'D) 30 × 10^6 m/s'};
                        {'A) Pascal', 'B) Joule', 'C) Newton', 'D) Watt'};
                        {'A) Newton''s First Law', 'B) Newton''s Second Law', 'C) Newton''s Third Law', 'D) Law of Gravity'};
                        {'A) Positive', 'B) Negative', 'C) Neutral', 'D) None of the above'};
                        {'A) KE = 1/2 mv^2', 'B) KE = mv^2', 'C) KE = mgh', 'D) KE = 1/2 m^2 v'}
                    };
                    app.CorrectAnswers = {'C', 'C', 'C', 'B', 'A'};
            end
            app.CurrentQuestionIndex = 1;
            app.Score = 0;
            app.updateQuestion();
        end
        function updateQuestion(app)
            index = app.CurrentQuestionIndex;
            app.QuestionLabel.Text = app.Questions{index};
            app.AButton.Text = app.Options{index}{1};
            app.BButton.Text = app.Options{index}{2};
            app.CButton.Text = app.Options{index}{3};
            app.DButton.Text = app.Options{index}{4};
            app.ScoreLabel.Text = ['Score: ' num2str(app.Score)];
            app.BackButton.Enable = app.CurrentQuestionIndex > 1;
            app.NextButton.Enable = app.CurrentQuestionIndex < length(app.Questions);
        end
        function handleAnswer(app, answer)
            correct = app.CorrectAnswers{app.CurrentQuestionIndex};
            if strcmp(answer, correct)
                app.Score = app.Score + 1;
            end
            app.CurrentQuestionIndex = app.CurrentQuestionIndex + 1;
            if app.CurrentQuestionIndex > length(app.Questions)
                % End of quiz
                app.QuestionLabel.Text = ['Quiz Complete! Final Score: ' num2str(app.Score)];
                app.AButton.Visible = 'off';
                app.BButton.Visible = 'off';
                app.CButton.Visible = 'off';
                app.DButton.Visible = 'off';
                app.ResultAxes.Visible = 'on'; % Make the axes visible
                correctAnswers = app.Score;
                totalQuestions = length(app.Questions);
                incorrectAnswers = totalQuestions - correctAnswers;

        % Plot a pie chart
        pie(app.ResultAxes, [correctAnswers, incorrectAnswers], {'Correct', 'Incorrect'});
        title(app.ResultAxes, 'Quiz Performance');
            else
                app.updateQuestion();
            end
        end
        function RestartButtonPushed(app, ~)
     if isvalid(app.QuizTimer)
        stop(app.QuizTimer);
        delete(app.QuizTimer);
    end
            app.startupFcn();
        end
    end
    methods (Access = private)
        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 600 400];
            app.UIFigure.Name = 'QuizApp';
            app.UIFigure.SizeChangedFcn = @(~, ~) app.updateBackgroundImage();
            app.QuizImage = uiimage(app.UIFigure);
            app.QuizImage.ImageSource = 'background1.png'; 
            app.QuizImage.Position = [0, 0, app.UIFigure.Position(3), app.UIFigure.Position(4)];
            app.QuizImage.ScaleMethod = 'stretch';
            app.QuizImage.ImageSource = 'background1.png'; 
            app.AptitudeButton = uibutton(app.UIFigure, 'push');
            app.AptitudeButton.Text = 'Aptitude';
            app.AptitudeButton.Position = [50 300 150 40];
            app.AptitudeButton.ButtonPushedFcn = @(~, ~) app.handleFieldSelection('Aptitude');
            app.HistoryButton = uibutton(app.UIFigure, 'push');
            app.HistoryButton.Text = 'History';
            app.HistoryButton.Position = [220 300 150 40];
            app.HistoryButton.ButtonPushedFcn = @(~, ~) app.handleFieldSelection('History');
            app.PhysicsButton = uibutton(app.UIFigure, 'push');
            app.PhysicsButton.Text = 'Physics';
            app.PhysicsButton.Position = [390 300 150 40];
            app.PhysicsButton.ButtonPushedFcn = @(~, ~) app.handleFieldSelection('Physics');
            app.QuestionLabel = uilabel(app.UIFigure);
            app.QuestionLabel.Position = [50 220 500 40];
            app.QuestionLabel.Text = 'Select a field to start the quiz';
            app.QuestionLabel.FontWeight = 'bold';
% Back Button
app.BackButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.goBack());
app.BackButton.Position = [100 50 100 30];
app.BackButton.Text = 'Back';
app.BackButton.Visible = 'off'; % Initially hidden

% Next Button
app.NextButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.goNext());
app.NextButton.Position = [400 50 100 30];
app.NextButton.Text = 'Next';
app.NextButton.Visible = 'off'; % Initially hidden

            app.AButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.handleAnswer('A'));
            app.AButton.Position = [50 160 100 30];
            app.BButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.handleAnswer('B'));
            app.BButton.Position = [170 160 100 30];
            app.CButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.handleAnswer('C'));
            app.CButton.Position = [290 160 100 30];
            app.DButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.handleAnswer('D'));
            app.DButton.Position = [410 160 100 30];
            app.ScoreLabel = uilabel(app.UIFigure);
            app.ScoreLabel.Position = [50 50 150 30];
            app.ScoreLabel.Text = 'Score: 0';
            app.RestartButton = uibutton(app.UIFigure, 'push', 'ButtonPushedFcn', @(~, ~) app.RestartButtonPushed());
            app.RestartButton.Position = [250 50 100 30];
            app.RestartButton.Text = 'Restart';
            app.UIFigure.Visible = 'on';
            % Create Timer Label
            app.TimerLabel = uilabel(app.UIFigure);
            app.TimerLabel.Position = [450, 350, 120, 30]; % Adjust position and size
            app.TimerLabel.Text = 'Time Left: 5:00';
            app.TimerLabel.FontSize = 14;
            app.TimerLabel.HorizontalAlignment = 'right';
          % Create Axes for Result Pie Chart
            app.ResultAxes = uiaxes(app.UIFigure);
            app.ResultAxes.Position = [170, 50, 80, 70]; % Adjusted position and size
            app.ResultAxes.Visible = 'off'; % Initially hidden
            title(app.ResultAxes, 'Quiz Performance'); % Title for the chart
            % Turn off default axes lines and labels for a cleaner look
            app.ResultAxes.XColor = 'none';
            app.ResultAxes.YColor = 'none';

        end
        function updateBackgroundImage(app)
    app.QuizImage.Position = [0, 0, app.UIFigure.Position(3), app.UIFigure.Position(4)];
        end
    end
    methods (Access = private)

    % Update timer display
    function updateTimer(app)
        remainingTime = app.QuizTimer.TasksToExecute - app.QuizTimer.TasksExecuted;
        minutes = floor(remainingTime / 60);
        seconds = mod(remainingTime, 60);
        app.TimerLabel.Text = sprintf('Time Left: %02d:%02d', minutes, seconds);
    end

    % Restart app when timer stops
    function restartApp(app)
        stop(app.QuizTimer);  % Stop the timer
        delete(app.QuizTimer); % Delete the timer
        app.RestartButtonPushed(); % Restart the app
    end

end

    methods (Access = public)
        function app = QuizAppMain
            createComponents(app);
            startupFcn(app);
        end
    end
end