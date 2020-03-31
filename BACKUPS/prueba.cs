using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using IntefazFacturacion.Conec;
using IntefazFacturacion.Code;
using System.IO;

namespace IntefazFacturacion
{
    public partial class frmVerificaDespachador : Form
    {
        conec strConex = null;

        public frmVerificaDespachador()
        {
            InitializeComponent();
        }

        static frmVerificaDespachador()
        {
            var myPath = new Uri(typeof(frmVerificaDespachador).Assembly.CodeBase).LocalPath;
            var myFolder = Path.GetDirectoryName(myPath);

            var is64 = IntPtr.Size == 8;
            var subfolder = is64 ? "\\win64\\" : "\\win32\\";

            LoadLibrary(myFolder + subfolder + "ftrScanAPI.dll");
            LoadLibrary(myFolder + subfolder + "FTRSUPPL.dll");
            LoadLibrary(myFolder + subfolder + "ftrWSQ.dll");
            LoadLibrary(myFolder + subfolder + "ftrAnsiSdk.dll");
            LoadLibrary(myFolder + subfolder + "ftrMathAPI.dll");
            LoadLibrary(myFolder + subfolder + "FSBIO_SDK.dll");
        }

        [DllImport("kernel32.dll")]
        private static extern IntPtr LoadLibrary(string dllToLoad);

        [DllImport("user32", CharSet = CharSet.Ansi, SetLastError = true)]
        private static extern long GetForegroundWindow();

        [DllImport("FSBIO_SDK.dll", CharSet = CharSet.Ansi, SetLastError = true)]
        public static extern int verificar(ref int calidad, int nivelSeguridad, int tipoTemplate, byte[] templateBase, int templateSize, ref int verificacion, int generarBmp, int generarWsq, int generarIso, int generarAnsi, int generarFtr, int lfdEnable, int lfdStrength, int habilitarRepetir, int autoClose, long handle);

        private void btnVerificar_Click(object sender, EventArgs e)
        {
            int calidad = 2;
            long foregroundWindow = frmVerificaDespachador.GetForegroundWindow();
            int generarAnsi = 0;
            int generarIso = 0;
            int generarBmp = 0;
            int generarWsq = 0;
            int autoClose = 1;
            int habilitarRepetir = 1;
            int lfdEnable = 0;
            int lfdStrength = 2;
            byte[] templateEntrada = new byte[0]; ;

            if (this.leerDatos(ref templateEntrada))
            {
                int length = templateEntrada.Length;
                int tipoTemplate = 0;
                int nivelSeguridad = 4;
                int verificacion = 0;
                strConex = new conec();
                string valor = string.Empty;

                int num5 = frmVerificaDespachador.verificar(ref calidad, nivelSeguridad, tipoTemplate, templateEntrada, length, ref verificacion, generarBmp, generarWsq, generarIso, generarAnsi, 0, lfdEnable, lfdStrength, habilitarRepetir, autoClose, foregroundWindow);

                if (verificacion == 1)
                {
                    valor = csImpo.registrarControlBiometrico(strConex.ConexImpo, txtDNI.Text.Trim());

                    if (valor != "")
                    {
                        MessageBox.Show("Verificacion de Huella Correcta", "Control Biometrico", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

                    }
                    Close();
                }
                if (num5 == -1)
                {
                    MessageBox.Show("Huella no detectada", "Control Biometrico", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }

                if (verificacion == 0)
                {
                    MessageBox.Show("Huella no coincide con el DNI ingresado", "Control Biometrico", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                }
            }
            else
            {
                MessageBox.Show("Huella no Registrada en Garita", "Control Biometrico", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            }
        }

        private bool leerDatos(ref byte[] templateEntrada)
        {
            strConex = new conec();

            DataTable dataTable2 = csImpo.obtenerHuellaBiometrica(strConex.conexSolmar, txtDNI.Text.Trim());

            byte[] numArray;
            bool flag = false;

            if (dataTable2.Rows.Count > 0)
            {
                numArray = (byte[])dataTable2.Rows[0][2];

                try
                {
                    templateEntrada = numArray;
                    flag = true;
                }
                catch (Exception ex)
                {
                    flag = false;
                }
                finally
                {
                    dataTable2.Dispose();
                }
            }

            return flag;
        }
    }
}
