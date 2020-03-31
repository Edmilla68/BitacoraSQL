using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace inactividad_usuario
{
    public partial class Form1 : Form
    {

	
 TiempoInactivo _TiempoInactivo;
        public Form1()
        {
            InitializeComponent();
            _TiempoInactivo = new TiempoInactivo();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            var inactiveTime = _TiempoInactivo.GetInactiveTime();

            if (inactiveTime == null)
            {
                label1.Text = "Ninguno";
                label1.BackColor = Color.Yellow;
                this.BackColor = Color.Yellow;
            }
            else if (inactiveTime.Value.TotalSeconds > 8)
            {
                label1.Text = string.Format("el usuario esta inactivo -Tiempo inactivo {0}s", (int)inactiveTime.Value.TotalSeconds);
                label1.BackColor = Color.Red;
                this.BackColor = Color.Red;
            }
            else
            {
                label1.Text = "el usuario esta activo trabajando en el pc";
                label1.BackColor = Color.Green;
                this.BackColor = Color.Green;
            }
        }
	}
}