

//**********************desde un button para invocar a la splash screen

//*******************************************************************************************************************************************
 // Open a Splash Screen
            SplashScreenManager.ShowForm(this, typeof(SplashScreen1), true, true, false);

            // The splash screen will be opened in a separate thread. To interact with it, use the SendCommand method.
            for (int i = 1; i <= 100; i++)
            {
               SplashScreenManager.Default.SendCommand(SplashScreen1.SplashScreenCommand.SetProgress, i);
                //To process commands, override the SplashScreen.ProcessCommand method.
                Thread.Sleep(50);
            }

            // Close the Splash Screen.
            SplashScreenManager.CloseForm(false);
			
			
//*******************************************************************************************************************************************			


//************************* en Form Splash Screen *********************************************************************
//*******************************************************************************************************************************************

public SplashScreen1()
        {
            InitializeComponent();
            Thread.Sleep(25);
        }


        #region Overrides
        public override void ProcessCommand(Enum cmd, object arg)
        {
            base.ProcessCommand(cmd, arg);
            SplashScreenCommand command = (SplashScreenCommand)cmd;
            if (command == SplashScreenCommand.SetProgress)
            {
                int pos = (int)arg;
                ProgressBarControl1.Position = pos;
            }
        }

        #endregion


    
        private void SplashScreen1_Load(object sender, EventArgs e)
        {
          
        }

        
        public enum SplashScreenCommand
        {
            SetProgress,
            Command2,
            Command3
        }