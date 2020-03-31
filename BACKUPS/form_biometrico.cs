[DesignerGenerated]
public class frmBiometrico : Form
{
    // Fields
    private static List<WeakReference> __ENCList = new List<WeakReference>();
    private IContainer components;
    [AccessedThroughProperty("dg_empleados")]
    private DataGridView _dg_empleados;
    [AccessedThroughProperty("col_dg_clientes_codigo")]
    private DataGridViewTextBoxColumn _col_dg_clientes_codigo;
    [AccessedThroughProperty("ColItem")]
    private DataGridViewTextBoxColumn _ColItem;
    [AccessedThroughProperty("col_dg_clientes_ruc")]
    private DataGridViewTextBoxColumn _col_dg_clientes_ruc;
    [AccessedThroughProperty("col_dg_clientes_nombres")]
    private DataGridViewTextBoxColumn _col_dg_clientes_nombres;
    [AccessedThroughProperty("ColEmpresa")]
    private DataGridViewTextBoxColumn _ColEmpresa;
    [AccessedThroughProperty("col_dg_clientes_estado")]
    private DataGridViewTextBoxColumn _col_dg_clientes_estado;
    [AccessedThroughProperty("ToolStrip1")]
    private ToolStrip _ToolStrip1;
    [AccessedThroughProperty("toolbt_listaNegra")]
    private ToolStripButton _toolbt_listaNegra;
    [AccessedThroughProperty("ToolStripSeparator1")]
    private ToolStripSeparator _ToolStripSeparator1;
    [AccessedThroughProperty("toolbt_Limpiar")]
    private ToolStripButton _toolbt_Limpiar;
    [AccessedThroughProperty("ToolStripSeparator2")]
    private ToolStripSeparator _ToolStripSeparator2;
    [AccessedThroughProperty("toolbtVerificar")]
    private ToolStripButton _toolbtVerificar;
    [AccessedThroughProperty("ToolStripSeparator3")]
    private ToolStripSeparator _ToolStripSeparator3;
    [AccessedThroughProperty("GroupBox4")]
    private GroupBox _GroupBox4;
    [AccessedThroughProperty("txtBuscar")]
    private TextBox _txtBuscar;
    [AccessedThroughProperty("rbApellidos")]
    private RadioButton _rbApellidos;
    [AccessedThroughProperty("rbDNI")]
    private RadioButton _rbDNI;
    [AccessedThroughProperty("GroupBox1")]
    private GroupBox _GroupBox1;
    [AccessedThroughProperty("GroupBox2")]
    private GroupBox _GroupBox2;
    [AccessedThroughProperty("lblEmpresa")]
    private Label _lblEmpresa;
    [AccessedThroughProperty("lblApellidos")]
    private Label _lblApellidos;
    [AccessedThroughProperty("lblNombres")]
    private Label _lblNombres;
    [AccessedThroughProperty("lblDNI")]
    private Label _lblDNI;
    [AccessedThroughProperty("lblTipoPersonal")]
    private Label _lblTipoPersonal;
    [AccessedThroughProperty("Label7")]
    private Label _Label7;
    [AccessedThroughProperty("Label6")]
    private Label _Label6;
    [AccessedThroughProperty("Label9")]
    private Label _Label9;
    [AccessedThroughProperty("Label3")]
    private Label _Label3;
    [AccessedThroughProperty("Label2")]
    private Label _Label2;
    [AccessedThroughProperty("pbxImagen")]
    private PictureBox _pbxImagen;
    private clase_personal gestor_personal;
    private clase_movimiento gestorMovimientos;
    private string nroDNI;
    private string bioFoto;

    // Methods
    public frmBiometrico()
    {
        base.Load += new EventHandler(this.frmBiometrico_Load);
        __ENCAddToList(this);
        this.gestor_personal = new clase_personal();
        this.gestorMovimientos = new clase_movimiento();
        this.nroDNI = "";
        this.bioFoto = "";
        this.InitializeComponent();
    }

    [DebuggerNonUserCode]
    private static void __ENCAddToList(object value)
    {
        List<WeakReference> list = __ENCList;
        lock (list)
        {
            if (__ENCList.Count == __ENCList.Capacity)
            {
                int index = 0;
                int num3 = __ENCList.Count - 1;
                int num2 = 0;
                while (true)
                {
                    int num4 = num3;
                    if (num2 > num4)
                    {
                        __ENCList.RemoveRange(index, __ENCList.Count - index);
                        __ENCList.Capacity = __ENCList.Count;
                        break;
                    }
                    WeakReference reference = __ENCList[num2];
                    if (reference.IsAlive)
                    {
                        if (num2 != index)
                        {
                            __ENCList[index] = __ENCList[num2];
                        }
                        index++;
                    }
                    num2++;
                }
            }
            __ENCList.Add(new WeakReference(value));
        }
    }

    [DllImport("FSBIO_SDK.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    public static extern int capturar(ref int calidad, int generarBmp, int generarWsq, int generarIso, int generarAnsi, int generarFtr, int lfdEnable, int lfdStrength, int habilitarRepetir, int autoClose, long handle);
    [DllImport("FSBIO_SDK.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    public static extern int capturarEx(ref int calidad, int generarBmp, int generarWsq, int generarIso, int generarAnsi, int generarFtr, int lfdEnable, int lfdStrength, int habilitarRepetir, int autoClose, long handle);
    private void dg_empleados_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
    {
        int index = -1;
        clase_personal _personal = new clase_personal();
        int result = -1;
        try
        {
            if (this.dg_empleados.RowCount > 0)
            {
                index = this.dg_empleados.CurrentRow.Index;
                int.TryParse(Conversions.ToString(this.dg_empleados[0, index].Value), out result);
                switch (_personal.listar_personal_a_modificar(result))
                {
                    case 1:
                        switch (_personal.codigo_tipo_personal)
                        {
                            case 1:
                                this.lblTipoPersonal.Text = "PROPIO";
                                break;

                            case 2:
                                this.lblTipoPersonal.Text = "VISITANTE   ";
                                break;

                            case 3:
                                this.lblTipoPersonal.Text = "TERCERO";
                                break;

                            default:
                                break;
                        }
                        this.lblDNI.Text = _personal.dni_personal;
                        this.lblNombres.Text = _personal.nombre1 + " " + _personal.nombre2;
                        this.lblApellidos.Text = _personal.apellidos1 + " " + _personal.apellidos2;
                        this.lblEmpresa.Text = Conversions.ToString(this.dg_empleados.Rows[index].Cells[4].Value);
                        this.bioFoto = _personal.rutaFoto;
                        if (_personal.tieneFoto != 1)
                        {
                            string str3 = modulo_general.local_pers_sexo;
                            if (str3 == "M")
                            {
                                this.pbxImagen.Image = SICOS_CONTROL_2014.My.Resources.Resources.man;
                            }
                            else
                            {
                                this.pbxImagen.Image = (str3 != "F") ? SICOS_CONTROL_2014.My.Resources.Resources.man : SICOS_CONTROL_2014.My.Resources.Resources.woman;
                            }
                        }
                        else if (File.Exists(this.bioFoto))
                        {
                            this.pbxImagen.ImageLocation = Strings.Trim(this.bioFoto);
                        }
                        else
                        {
                            string str2 = modulo_general.local_pers_sexo;
                            if (str2 == "M")
                            {
                                this.pbxImagen.Image = SICOS_CONTROL_2014.My.Resources.Resources.man;
                            }
                            else
                            {
                                this.pbxImagen.Image = (str2 != "F") ? SICOS_CONTROL_2014.My.Resources.Resources.man : SICOS_CONTROL_2014.My.Resources.Resources.woman;
                            }
                        }
                        this.pbxImagen.SizeMode = PictureBoxSizeMode.Zoom;
                        break;

                    default:
                        break;
                }
            }
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-dg_empleados_CellDoubleClick", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    [DebuggerNonUserCode]
    protected override void Dispose(bool disposing)
    {
        try
        {
            int num1;
            if (!disposing || (this.components == null))
            {
                num1 = 0;
            }
            else
            {
                num1 = 1;
            }
            if (num1 != 0)
            {
                this.components.Dispose();
            }
        }
        finally
        {
            base.Dispose(disposing);
        }
    }

    private void frmBiometrico_Load(object sender, EventArgs e)
    {
        try
        {
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-frmBiometrico_Load", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    [DllImport("user32", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    private static extern long GetForegroundWindow();
    [DebuggerStepThrough]
    private void InitializeComponent()
    {
        DataGridViewCellStyle style = new DataGridViewCellStyle();
        DataGridViewCellStyle style2 = new DataGridViewCellStyle();
        DataGridViewCellStyle style3 = new DataGridViewCellStyle();
        this.dg_empleados = new DataGridView();
        this.col_dg_clientes_codigo = new DataGridViewTextBoxColumn();
        this.ColItem = new DataGridViewTextBoxColumn();
        this.col_dg_clientes_ruc = new DataGridViewTextBoxColumn();
        this.col_dg_clientes_nombres = new DataGridViewTextBoxColumn();
        this.ColEmpresa = new DataGridViewTextBoxColumn();
        this.col_dg_clientes_estado = new DataGridViewTextBoxColumn();
        this.ToolStrip1 = new ToolStrip();
        this.toolbt_Limpiar = new ToolStripButton();
        this.ToolStripSeparator1 = new ToolStripSeparator();
        this.toolbt_listaNegra = new ToolStripButton();
        this.ToolStripSeparator2 = new ToolStripSeparator();
        this.toolbtVerificar = new ToolStripButton();
        this.ToolStripSeparator3 = new ToolStripSeparator();
        this.GroupBox4 = new GroupBox();
        this.txtBuscar = new TextBox();
        this.rbApellidos = new RadioButton();
        this.rbDNI = new RadioButton();
        this.GroupBox1 = new GroupBox();
        this.GroupBox2 = new GroupBox();
        this.pbxImagen = new PictureBox();
        this.lblEmpresa = new Label();
        this.lblApellidos = new Label();
        this.lblNombres = new Label();
        this.lblDNI = new Label();
        this.lblTipoPersonal = new Label();
        this.Label7 = new Label();
        this.Label6 = new Label();
        this.Label9 = new Label();
        this.Label3 = new Label();
        this.Label2 = new Label();
        ((ISupportInitialize) this.dg_empleados).BeginInit();
        this.ToolStrip1.SuspendLayout();
        this.GroupBox4.SuspendLayout();
        this.GroupBox1.SuspendLayout();
        this.GroupBox2.SuspendLayout();
        ((ISupportInitialize) this.pbxImagen).BeginInit();
        this.SuspendLayout();
        this.dg_empleados.AllowUserToAddRows = false;
        this.dg_empleados.AllowUserToOrderColumns = true;
        this.dg_empleados.AllowUserToResizeColumns = false;
        this.dg_empleados.AllowUserToResizeRows = false;
        style.BackColor = Color.White;
        style.Font = new Font("Calibri", 9f, FontStyle.Regular, GraphicsUnit.Point, 0);
        style.ForeColor = Color.Black;
        this.dg_empleados.AlternatingRowsDefaultCellStyle = style;
        style2.Alignment = DataGridViewContentAlignment.MiddleCenter;
        style2.BackColor = Color.FromArgb(0, 0x4a, 0x6f);
        style2.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        style2.ForeColor = Color.White;
        style2.SelectionBackColor = SystemColors.Highlight;
        style2.SelectionForeColor = SystemColors.HighlightText;
        style2.WrapMode = DataGridViewTriState.True;
        this.dg_empleados.ColumnHeadersDefaultCellStyle = style2;
        this.dg_empleados.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
        DataGridViewColumn[] dataGridViewColumns = new DataGridViewColumn[] { this.col_dg_clientes_codigo, this.ColItem, this.col_dg_clientes_ruc, this.col_dg_clientes_nombres, this.ColEmpresa, this.col_dg_clientes_estado };
        this.dg_empleados.Columns.AddRange(dataGridViewColumns);
        this.dg_empleados.Dock = DockStyle.Fill;
        this.dg_empleados.EnableHeadersVisualStyles = false;
        Point point2 = new Point(3, 0x12);
        this.dg_empleados.Location = point2;
        this.dg_empleados.MultiSelect = false;
        this.dg_empleados.Name = "dg_empleados";
        this.dg_empleados.ReadOnly = true;
        this.dg_empleados.RowHeadersVisible = false;
        style3.Font = new Font("Calibri", 9f, FontStyle.Regular, GraphicsUnit.Point, 0);
        style3.ForeColor = Color.Black;
        this.dg_empleados.RowsDefaultCellStyle = style3;
        this.dg_empleados.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
        Size size2 = new Size(530, 0x80);
        this.dg_empleados.Size = size2;
        this.dg_empleados.TabIndex = 2;
        this.col_dg_clientes_codigo.HeaderText = "CODIGO";
        this.col_dg_clientes_codigo.Name = "col_dg_clientes_codigo";
        this.col_dg_clientes_codigo.ReadOnly = true;
        this.col_dg_clientes_codigo.Visible = false;
        this.ColItem.HeaderText = "ITM";
        this.ColItem.Name = "ColItem";
        this.ColItem.ReadOnly = true;
        this.ColItem.Width = 30;
        this.col_dg_clientes_ruc.HeaderText = "DNI";
        this.col_dg_clientes_ruc.Name = "col_dg_clientes_ruc";
        this.col_dg_clientes_ruc.ReadOnly = true;
        this.col_dg_clientes_ruc.Width = 80;
        this.col_dg_clientes_nombres.HeaderText = "NOMBRES Y APELLIDOS";
        this.col_dg_clientes_nombres.Name = "col_dg_clientes_nombres";
        this.col_dg_clientes_nombres.ReadOnly = true;
        this.col_dg_clientes_nombres.Width = 240;
        this.ColEmpresa.HeaderText = "EMPRESA";
        this.ColEmpresa.Name = "ColEmpresa";
        this.ColEmpresa.ReadOnly = true;
        this.ColEmpresa.Width = 160;
        this.col_dg_clientes_estado.HeaderText = "ESTADO";
        this.col_dg_clientes_estado.Name = "col_dg_clientes_estado";
        this.col_dg_clientes_estado.ReadOnly = true;
        this.col_dg_clientes_estado.Visible = false;
        this.ToolStrip1.BackColor = Color.MidnightBlue;
        this.ToolStrip1.Font = new Font("Calibri", 9f, FontStyle.Bold);
        ToolStripItem[] toolStripItems = new ToolStripItem[] { this.toolbt_Limpiar, this.ToolStripSeparator1, this.toolbt_listaNegra, this.ToolStripSeparator2, this.toolbtVerificar, this.ToolStripSeparator3 };
        this.ToolStrip1.Items.AddRange(toolStripItems);
        point2 = new Point(3, 3);
        this.ToolStrip1.Location = point2;
        this.ToolStrip1.Name = "ToolStrip1";
        size2 = new Size(0x218, 0x19);
        this.ToolStrip1.Size = size2;
        this.ToolStrip1.TabIndex = 0;
        this.ToolStrip1.Text = "ToolStrip1";
        this.toolbt_Limpiar.ForeColor = Color.White;
        this.toolbt_Limpiar.Image = SICOS_CONTROL_2014.My.Resources.Resources.edit_clear;
        this.toolbt_Limpiar.ImageTransparentColor = Color.Magenta;
        this.toolbt_Limpiar.Name = "toolbt_Limpiar";
        size2 = new Size(0x40, 0x16);
        this.toolbt_Limpiar.Size = size2;
        this.toolbt_Limpiar.Text = "&Limpiar";
        this.ToolStripSeparator1.Name = "ToolStripSeparator1";
        size2 = new Size(6, 0x19);
        this.ToolStripSeparator1.Size = size2;
        this.toolbt_listaNegra.ForeColor = Color.White;
        this.toolbt_listaNegra.Image = SICOS_CONTROL_2014.My.Resources.Resources.cargo_empleado;
        this.toolbt_listaNegra.ImageTransparentColor = Color.Magenta;
        this.toolbt_listaNegra.Name = "toolbt_listaNegra";
        size2 = new Size(0x48, 0x16);
        this.toolbt_listaNegra.Size = size2;
        this.toolbt_listaNegra.Text = "&Registrar";
        this.ToolStripSeparator2.Name = "ToolStripSeparator2";
        size2 = new Size(6, 0x19);
        this.ToolStripSeparator2.Size = size2;
        this.toolbtVerificar.ForeColor = Color.White;
        this.toolbtVerificar.Image = SICOS_CONTROL_2014.My.Resources.Resources.accept;
        this.toolbtVerificar.ImageTransparentColor = Color.Magenta;
        this.toolbtVerificar.Name = "toolbtVerificar";
        size2 = new Size(0x44, 0x16);
        this.toolbtVerificar.Size = size2;
        this.toolbtVerificar.Text = "&Verificar";
        this.ToolStripSeparator3.Name = "ToolStripSeparator3";
        size2 = new Size(6, 0x19);
        this.ToolStripSeparator3.Size = size2;
        this.GroupBox4.Controls.Add(this.txtBuscar);
        this.GroupBox4.Controls.Add(this.rbApellidos);
        this.GroupBox4.Controls.Add(this.rbDNI);
        this.GroupBox4.Dock = DockStyle.Top;
        point2 = new Point(3, 0x1c);
        this.GroupBox4.Location = point2;
        this.GroupBox4.Name = "GroupBox4";
        size2 = new Size(0x218, 0x3e);
        this.GroupBox4.Size = size2;
        this.GroupBox4.TabIndex = 4;
        this.GroupBox4.TabStop = false;
        this.GroupBox4.Text = "Par\x00e1metros de B\x00fasqueda";
        this.txtBuscar.BackColor = Color.LemonChiffon;
        this.txtBuscar.BorderStyle = BorderStyle.FixedSingle;
        point2 = new Point(0xb0, 0x15);
        this.txtBuscar.Location = point2;
        this.txtBuscar.Name = "txtBuscar";
        size2 = new Size(0x100, 0x16);
        this.txtBuscar.Size = size2;
        this.txtBuscar.TabIndex = 8;
        this.rbApellidos.AutoSize = true;
        point2 = new Point(0x51, 0x15);
        this.rbApellidos.Location = point2;
        this.rbApellidos.Name = "rbApellidos";
        size2 = new Size(0x59, 0x12);
        this.rbApellidos.Size = size2;
        this.rbApellidos.TabIndex = 7;
        this.rbApellidos.Text = "Por Apellidos";
        this.rbApellidos.UseVisualStyleBackColor = true;
        this.rbDNI.AutoSize = true;
        this.rbDNI.Checked = true;
        point2 = new Point(12, 0x15);
        this.rbDNI.Location = point2;
        this.rbDNI.Name = "rbDNI";
        size2 = new Size(0x3f, 0x12);
        this.rbDNI.Size = size2;
        this.rbDNI.TabIndex = 6;
        this.rbDNI.TabStop = true;
        this.rbDNI.Text = "Por DNI";
        this.rbDNI.UseVisualStyleBackColor = true;
        this.GroupBox1.Controls.Add(this.dg_empleados);
        this.GroupBox1.Dock = DockStyle.Top;
        point2 = new Point(3, 90);
        this.GroupBox1.Location = point2;
        this.GroupBox1.Name = "GroupBox1";
        size2 = new Size(0x218, 0x95);
        this.GroupBox1.Size = size2;
        this.GroupBox1.TabIndex = 6;
        this.GroupBox1.TabStop = false;
        this.GroupBox1.Text = "Lista Encontrada";
        this.GroupBox2.Controls.Add(this.pbxImagen);
        this.GroupBox2.Controls.Add(this.lblEmpresa);
        this.GroupBox2.Controls.Add(this.lblApellidos);
        this.GroupBox2.Controls.Add(this.lblNombres);
        this.GroupBox2.Controls.Add(this.lblDNI);
        this.GroupBox2.Controls.Add(this.lblTipoPersonal);
        this.GroupBox2.Controls.Add(this.Label7);
        this.GroupBox2.Controls.Add(this.Label6);
        this.GroupBox2.Controls.Add(this.Label9);
        this.GroupBox2.Controls.Add(this.Label3);
        this.GroupBox2.Controls.Add(this.Label2);
        this.GroupBox2.Dock = DockStyle.Fill;
        point2 = new Point(3, 0xef);
        this.GroupBox2.Location = point2;
        this.GroupBox2.Name = "GroupBox2";
        size2 = new Size(0x218, 0xf3);
        this.GroupBox2.Size = size2;
        this.GroupBox2.TabIndex = 7;
        this.GroupBox2.TabStop = false;
        this.GroupBox2.Text = "Detalles de la Persona";
        this.pbxImagen.Image = SICOS_CONTROL_2014.My.Resources.Resources.User_256x256;
        point2 = new Point(0x169, 0x16);
        this.pbxImagen.Location = point2;
        this.pbxImagen.Name = "pbxImagen";
        size2 = new Size(0x9f, 0xc4);
        this.pbxImagen.Size = size2;
        this.pbxImagen.SizeMode = PictureBoxSizeMode.Zoom;
        this.pbxImagen.TabIndex = 0x3d;
        this.pbxImagen.TabStop = false;
        this.lblEmpresa.BorderStyle = BorderStyle.FixedSingle;
        this.lblEmpresa.Enabled = false;
        this.lblEmpresa.ForeColor = Color.Black;
        point2 = new Point(70, 0xaf);
        this.lblEmpresa.Location = point2;
        this.lblEmpresa.Name = "lblEmpresa";
        size2 = new Size(0xd8, 0x19);
        this.lblEmpresa.Size = size2;
        this.lblEmpresa.TabIndex = 60;
        this.lblEmpresa.TextAlign = ContentAlignment.MiddleLeft;
        this.lblApellidos.BorderStyle = BorderStyle.FixedSingle;
        this.lblApellidos.Enabled = false;
        this.lblApellidos.ForeColor = Color.Black;
        point2 = new Point(70, 0x86);
        this.lblApellidos.Location = point2;
        this.lblApellidos.Name = "lblApellidos";
        size2 = new Size(0xd8, 0x19);
        this.lblApellidos.Size = size2;
        this.lblApellidos.TabIndex = 0x3a;
        this.lblApellidos.TextAlign = ContentAlignment.MiddleLeft;
        this.lblNombres.BorderStyle = BorderStyle.FixedSingle;
        this.lblNombres.Enabled = false;
        this.lblNombres.ForeColor = Color.Black;
        point2 = new Point(70, 0x5f);
        this.lblNombres.Location = point2;
        this.lblNombres.Name = "lblNombres";
        size2 = new Size(0xd8, 0x19);
        this.lblNombres.Size = size2;
        this.lblNombres.TabIndex = 0x39;
        this.lblNombres.TextAlign = ContentAlignment.MiddleLeft;
        this.lblDNI.BorderStyle = BorderStyle.FixedSingle;
        this.lblDNI.Enabled = false;
        this.lblDNI.ForeColor = Color.Black;
        point2 = new Point(70, 0x38);
        this.lblDNI.Location = point2;
        this.lblDNI.Name = "lblDNI";
        size2 = new Size(0x7b, 0x19);
        this.lblDNI.Size = size2;
        this.lblDNI.TabIndex = 0x38;
        this.lblDNI.TextAlign = ContentAlignment.MiddleLeft;
        this.lblTipoPersonal.BorderStyle = BorderStyle.FixedSingle;
        this.lblTipoPersonal.Enabled = false;
        this.lblTipoPersonal.ForeColor = Color.Black;
        point2 = new Point(70, 0x12);
        this.lblTipoPersonal.Location = point2;
        this.lblTipoPersonal.Name = "lblTipoPersonal";
        size2 = new Size(0x7b, 0x19);
        this.lblTipoPersonal.Size = size2;
        this.lblTipoPersonal.TabIndex = 0x37;
        this.lblTipoPersonal.TextAlign = ContentAlignment.MiddleLeft;
        this.Label7.AutoSize = true;
        this.Label7.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.Label7.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        point2 = new Point(12, 0x16);
        this.Label7.Location = point2;
        this.Label7.Name = "Label7";
        size2 = new Size(0x34, 14);
        this.Label7.Size = size2;
        this.Label7.TabIndex = 0x36;
        this.Label7.Text = "Personal:";
        this.Label6.AutoSize = true;
        this.Label6.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.Label6.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        point2 = new Point(12, 180);
        this.Label6.Location = point2;
        this.Label6.Name = "Label6";
        size2 = new Size(0x35, 14);
        this.Label6.Size = size2;
        this.Label6.TabIndex = 0x34;
        this.Label6.Text = "Empresa:";
        this.Label9.AutoSize = true;
        this.Label9.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.Label9.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        point2 = new Point(12, 0x3b);
        this.Label9.Location = point2;
        this.Label9.Name = "Label9";
        size2 = new Size(0x1d, 14);
        this.Label9.Size = size2;
        this.Label9.TabIndex = 0x33;
        this.Label9.Text = "DNI:";
        this.Label3.AutoSize = true;
        this.Label3.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.Label3.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        point2 = new Point(12, 0x8b);
        this.Label3.Location = point2;
        this.Label3.Name = "Label3";
        size2 = new Size(0x37, 14);
        this.Label3.Size = size2;
        this.Label3.TabIndex = 50;
        this.Label3.Text = "Apellidos:";
        this.Label2.AutoSize = true;
        this.Label2.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.Label2.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        point2 = new Point(12, 100);
        this.Label2.Location = point2;
        this.Label2.Name = "Label2";
        size2 = new Size(0x37, 14);
        this.Label2.Size = size2;
        this.Label2.TabIndex = 0x31;
        this.Label2.Text = "Nombres:";
        SizeF ef2 = new SizeF(6f, 14f);
        this.AutoScaleDimensions = ef2;
        this.AutoScaleMode = AutoScaleMode.Font;
        this.BackColor = Color.White;
        size2 = new Size(0x21e, 0x1e5);
        this.ClientSize = size2;
        this.Controls.Add(this.GroupBox2);
        this.Controls.Add(this.GroupBox1);
        this.Controls.Add(this.GroupBox4);
        this.Controls.Add(this.ToolStrip1);
        this.Font = new Font("Calibri", 9f, FontStyle.Bold, GraphicsUnit.Point, 0);
        this.ForeColor = Color.FromArgb(0, 0x4a, 0x6f);
        this.Name = "frmBiometrico";
        Padding padding2 = new Padding(3);
        this.Padding = padding2;
        this.Text = "Registro y Verificaci\x00f3n de Huellas";
        ((ISupportInitialize) this.dg_empleados).EndInit();
        this.ToolStrip1.ResumeLayout(false);
        this.ToolStrip1.PerformLayout();
        this.GroupBox4.ResumeLayout(false);
        this.GroupBox4.PerformLayout();
        this.GroupBox1.ResumeLayout(false);
        this.GroupBox2.ResumeLayout(false);
        this.GroupBox2.PerformLayout();
        ((ISupportInitialize) this.pbxImagen).EndInit();
        this.ResumeLayout(false);
        this.PerformLayout();
    }

    private bool leerDatos(ref byte[] templateEntrada)
    {
        bool flag;
        byte[] buffer;
        this.nroDNI = this.lblDNI.Text.Trim();
        DataTable table = new DataTable();
        table = this.gestorMovimientos.listarDatosBioIdentidad(this.nroDNI);
        if (table.Rows.Count > 0)
        {
            buffer = (byte[]) table.Rows[0][2];
        }
        else
        {
            table.Dispose();
        }
        try
        {
            templateEntrada = buffer;
            flag = true;
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            flag = false;
            ProjectData.ClearProjectError();
            return flag;
        }
        return flag;
    }

    private void limpiarCampos()
    {
        this.nroDNI = "";
        this.lblApellidos.Text = "";
        this.lblDNI.Text = "";
        this.lblEmpresa.Text = "";
        this.lblNombres.Text = "";
        this.lblTipoPersonal.Text = "";
        this.pbxImagen.Image = SICOS_CONTROL_2014.My.Resources.Resources.man;
        this.txtBuscar.Text = "";
        this.txtBuscar.Focus();
    }

    [DllImport("FSBIO_SDK.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    public static extern int mergeTemplates(byte[] template1, int template1Size, byte[] template2, int template1Size);
    private void rbApellidos_CheckedChanged(object sender, EventArgs e)
    {
        this.txtBuscar.Focus();
    }

    private void rbDNI_CheckedChanged(object sender, EventArgs e)
    {
        this.txtBuscar.Focus();
    }

    private void renombrarSalidas(int muestra, int generarBmp, int generarWsq, int generarIso, int generarAnsi)
    {
        if (generarBmp == 1)
        {
            try
            {
            }
            catch (Exception exception1)
            {
                Exception ex = exception1;
                ProjectData.SetProjectError(ex);
                Exception exception = ex;
                ProjectData.ClearProjectError();
            }
            try
            {
                FileSystem.MoveFile(modulo_general.globalBioCarpeta + this.nroDNI + ".bmp", Conversions.ToString(true));
                FileSystem.DeleteFile(modulo_general.globalBioCarpeta + "huella.bmp");
            }
            catch (Exception exception8)
            {
                Exception ex = exception8;
                ProjectData.SetProjectError(ex);
                Exception exception2 = ex;
                ProjectData.ClearProjectError();
            }
        }
        if (generarWsq == 1)
        {
            try
            {
                FileSystem.MoveFile(modulo_general.globalBioCarpeta + "huella.wsq", modulo_general.globalBioCarpeta + this.nroDNI + ".wsq", true);
            }
            catch (Exception exception9)
            {
                Exception ex = exception9;
                ProjectData.SetProjectError(ex);
                Exception exception3 = ex;
                MessageBox.Show((("Fuente: " + exception3.Source.ToString()) + "\r\nMensaje de Excepci\x00f3n: " + exception3.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception3.TargetSite.Name, "SICOS CONTROL - renombrarSalidas", MessageBoxButtons.OK);
                ProjectData.ClearProjectError();
            }
        }
        if (generarIso == 1)
        {
            try
            {
            }
            catch (Exception exception10)
            {
                Exception ex = exception10;
                ProjectData.SetProjectError(ex);
                Exception exception4 = ex;
                ProjectData.ClearProjectError();
            }
            try
            {
                FileSystem.MoveFile(modulo_general.globalBioCarpeta + "template.iso", modulo_general.globalBioCarpeta + this.nroDNI + ".iso", true);
            }
            catch (Exception exception11)
            {
                Exception ex = exception11;
                ProjectData.SetProjectError(ex);
                Exception exception5 = ex;
                ProjectData.ClearProjectError();
            }
        }
        if (generarAnsi == 1)
        {
            try
            {
            }
            catch (Exception exception12)
            {
                Exception ex = exception12;
                ProjectData.SetProjectError(ex);
                Exception exception6 = ex;
                ProjectData.ClearProjectError();
            }
            try
            {
                FileSystem.MoveFile(modulo_general.globalBioCarpeta + this.nroDNI + ".ansi", Conversions.ToString(true));
                FileSystem.DeleteFile(modulo_general.globalBioCarpeta + "template.ansi");
            }
            catch (Exception exception13)
            {
                Exception ex = exception13;
                ProjectData.SetProjectError(ex);
                Exception exception7 = ex;
                ProjectData.ClearProjectError();
            }
        }
    }

    private void toolbt_Limpiar_Click(object sender, EventArgs e)
    {
        try
        {
            this.limpiarCampos();
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-toolbt_Limpiar_Click", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    private void toolbt_listaNegra_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.dg_empleados.Rows.Count == 0)
            {
                Interaction.MsgBox("No hay datos en la Lista para Seleccionar.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else if (this.dg_empleados.SelectedRows.Count == 0)
            {
                Interaction.MsgBox("Debe seleccionar un fila dentro de la Lista para proceder a registrar.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else if (this.lblDNI.Text.Trim() == "")
            {
                Interaction.MsgBox("Sellecionar una fila y dar doble clic para realizar el registro.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else
            {
                byte[] buffer = Convert.FromBase64String("0xC9");
                switch (this.gestorMovimientos.insertarBioIdentidad(this.lblDNI.Text.Trim(), "", "", "", buffer, 0))
                {
                    case 0:
                    {
                        this.nroDNI = "";
                        int calidad = 2;
                        string bioNombres = "";
                        bioNombres = this.lblNombres.Text.Trim();
                        int generarAnsi = 0;
                        int generarIso = 1;
                        int generarBmp = 0;
                        int generarWsq = 1;
                        this.nroDNI = this.lblDNI.Text.Trim();
                        frmBioMensaje mensaje = new frmBioMensaje {
                            propiedadNombreVentana = "REGISTRO DE HUELLA",
                            propiedadBioImagen = this.bioFoto,
                            propiedadBioDNI = this.lblDNI.Text.Trim(),
                            propiedadBioNombres = this.lblNombres.Text.Trim(),
                            propiedadBioApellidos = this.lblApellidos.Text.Trim(),
                            propiedadBioEmpresa = this.lblEmpresa.Text.Trim()
                        };
                        mensaje.Show();
                        int num13 = capturar(ref calidad, generarBmp, generarWsq, generarIso, generarAnsi, 0, 0, 2, 1, 0, GetForegroundWindow());
                        mensaje.Close();
                        this.renombrarSalidas(1, generarBmp, generarWsq, generarIso, generarAnsi);
                        switch (this.gestorMovimientos.insertarBioIdentidad(this.nroDNI, bioNombres, this.lblApellidos.Text.Trim(), Convert.ToBase64String(File.ReadAllBytes(this.nroDNI + ".Iso")), File.ReadAllBytes(this.nroDNI + ".Iso"), 1))
                        {
                            case -1:
                                Interaction.MsgBox("Error BBDD. Vuelva a intetarlo por favor.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                                break;

                            case 0:
                                Interaction.MsgBox("Error Aplicaci\x00f3n. Por favor vuelva a intentarlo.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                                break;

                            case 1:
                                Interaction.MsgBox("Huella registrada con \x00e9xito...!!!", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                                break;

                            case 2:
                                Interaction.MsgBox("La huella de persona ya existe. No se puede registrar nuevamente, comuniquese con su jefe inmediato.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                                break;

                            default:
                                break;
                        }
                        break;
                    }
                    case 2:
                        Interaction.MsgBox("Ya existe una Huella registrada para esta persona.No puede Registrarlo. Comuniquese con su Jefe Inmediato.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                        break;

                    default:
                        break;
                }
            }
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-toolbt_listaNegra_Click", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    private void toolbtVerificar_Click(object sender, EventArgs e)
    {
        try
        {
            if (this.dg_empleados.Rows.Count == 0)
            {
                Interaction.MsgBox("No hay datos en la Lista para Seleccionar.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else if (this.dg_empleados.SelectedRows.Count == 0)
            {
                Interaction.MsgBox("Debe seleccionar un fila dentro de la Lista para proceder a verificar.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else if (this.lblDNI.Text.Trim() == "")
            {
                Interaction.MsgBox("Seleccionar una fila y dar doble clic para realizar la verificaci\x00f3n.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
            }
            else
            {
                byte[] buffer = Convert.FromBase64String("0xC9");
                switch (this.gestorMovimientos.insertarBioIdentidad(this.lblDNI.Text.Trim(), "", "", "", buffer, 0))
                {
                    case 0:
                        Interaction.MsgBox("No existe una huella registrada para esta persona. Proceda a registrar la huella y luego verifique.", MsgBoxStyle.Information, "MENSAJE AL USUARIO");
                        break;

                    case 2:
                    {
                        byte[] buffer2;
                        int calidad = 2;
                        long foregroundWindow = GetForegroundWindow();
                        int generarAnsi = 1;
                        int generarIso = 1;
                        int generarBmp = 1;
                        int generarWsq = 1;
                        int autoClose = 0;
                        int habilitarRepetir = 1;
                        int lfdEnable = 0;
                        int lfdStrength = 2;
                        if (!this.leerDatos(ref buffer2))
                        {
                            MessageBox.Show("No ha cargado el template");
                        }
                        else
                        {
                            int num14;
                            frmBioMensaje mensaje = new frmBioMensaje {
                                propiedadNombreVentana = "VERIFICACION DE HUELLA",
                                propiedadBioImagen = this.bioFoto,
                                propiedadBioDNI = this.lblDNI.Text.Trim(),
                                propiedadBioNombres = this.lblNombres.Text.Trim(),
                                propiedadBioApellidos = this.lblApellidos.Text.Trim(),
                                propiedadBioEmpresa = this.lblEmpresa.Text.Trim()
                            };
                            mensaje.Show();
                            int num13 = verificar(ref calidad, 4, 0, buffer2, buffer2.Length, ref num14, generarBmp, generarWsq, generarIso, generarAnsi, 0, lfdEnable, lfdStrength, habilitarRepetir, autoClose, foregroundWindow);
                            mensaje.Close();
                            if ((num13 == 0) && (num14 == 1))
                            {
                            }
                        }
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-toolbtVerificar_Click", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    private void txtBuscar_KeyPress(object sender, KeyPressEventArgs e)
    {
        DataTable expression = new DataTable();
        string nombres = "";
        string str = "";
        int num = -1;
        try
        {
            if (e.KeyChar == '\r')
            {
                if (this.dg_empleados.RowCount > 0)
                {
                    this.dg_empleados.Rows.Clear();
                }
                if (!this.rbApellidos.Checked)
                {
                    str = this.txtBuscar.Text.Trim();
                    num = 2;
                }
                else
                {
                    num = 1;
                    str = "-1";
                    nombres = this.txtBuscar.Text.Trim();
                }
                expression = this.gestor_personal.ListarDatosPersonasBiometrico(nombres, str, num);
                if (!Information.IsNothing(expression) && (expression.Rows.Count > 0))
                {
                    int num3 = expression.Rows.Count - 1;
                    int num2 = 0;
                    while (true)
                    {
                        int num4 = num3;
                        if (num2 > num4)
                        {
                            break;
                        }
                        DataGridViewRow dataGridViewRow = new DataGridViewRow();
                        dataGridViewRow.CreateCells(this.dg_empleados);
                        dataGridViewRow.Cells[0].Value = expression.Rows[num2][0];
                        dataGridViewRow.Cells[1].Value = num2 + 1;
                        dataGridViewRow.Cells[2].Value = expression.Rows[num2][1];
                        dataGridViewRow.Cells[3].Value = expression.Rows[num2][2];
                        dataGridViewRow.Cells[4].Value = expression.Rows[num2][3];
                        dataGridViewRow.Cells[5].Value = 1;
                        this.dg_empleados.Rows.Add(dataGridViewRow);
                        num2++;
                    }
                }
                if (this.dg_empleados.RowCount > 0)
                {
                    this.dg_empleados.ClearSelection();
                }
            }
        }
        catch (Exception exception1)
        {
            Exception ex = exception1;
            ProjectData.SetProjectError(ex);
            Exception exception = ex;
            MessageBox.Show((("Fuente: " + exception.Source.ToString()) + "\r\nMensaje de excepcion: " + exception.Message + "\r\n") + "Metodo donde Ocurrio el Error: " + exception.TargetSite.Name, "frmBiometrico-txtBuscar_KeyPress", MessageBoxButtons.OK, MessageBoxIcon.Hand);
            ProjectData.ClearProjectError();
        }
    }

    [DllImport("FSBIO_SDK.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    public static extern int verificar(ref int calidad, int nivelSeguridad, int tipoTemplate, byte[] templateBase, int templateSize, ref int verificacion, int generarBmp, int generarWsq, int generarIso, int generarAnsi, int generarFtr, int lfdEnable, int lfdStrength, int habilitarRepetir, int autoClose, long handle);
    [DllImport("FSBIO_SDK.dll", CharSet=CharSet.Ansi, SetLastError=true, ExactSpelling=true)]
    public static extern int verificarx2(ref int calidad, int nivelSeguridad, int tipoTemplate, byte[] templateBase1, int templateSize1, byte[] templateBase2, int templateSize2, ref int verificacion, int generarBmp, int generarWsq, int generarIso, int generarAnsi, int generarFtr, int lfdEnable, int lfdStrength, int habilitarRepetir, int autoClose, long handle);

    // Properties
    internal virtual DataGridView dg_empleados
    {
        [DebuggerNonUserCode]
        get => 
            this._dg_empleados;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            DataGridViewCellEventHandler handler = new DataGridViewCellEventHandler(this.dg_empleados_CellDoubleClick);
            if (!ReferenceEquals(this._dg_empleados, null))
            {
                this._dg_empleados.CellDoubleClick -= handler;
            }
            this._dg_empleados = value;
            if (!ReferenceEquals(this._dg_empleados, null))
            {
                this._dg_empleados.CellDoubleClick += handler;
            }
        }
    }

    internal virtual DataGridViewTextBoxColumn col_dg_clientes_codigo
    {
        [DebuggerNonUserCode]
        get => 
            this._col_dg_clientes_codigo;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._col_dg_clientes_codigo = value);
    }

    internal virtual DataGridViewTextBoxColumn ColItem
    {
        [DebuggerNonUserCode]
        get => 
            this._ColItem;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ColItem = value);
    }

    internal virtual DataGridViewTextBoxColumn col_dg_clientes_ruc
    {
        [DebuggerNonUserCode]
        get => 
            this._col_dg_clientes_ruc;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._col_dg_clientes_ruc = value);
    }

    internal virtual DataGridViewTextBoxColumn col_dg_clientes_nombres
    {
        [DebuggerNonUserCode]
        get => 
            this._col_dg_clientes_nombres;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._col_dg_clientes_nombres = value);
    }

    internal virtual DataGridViewTextBoxColumn ColEmpresa
    {
        [DebuggerNonUserCode]
        get => 
            this._ColEmpresa;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ColEmpresa = value);
    }

    internal virtual DataGridViewTextBoxColumn col_dg_clientes_estado
    {
        [DebuggerNonUserCode]
        get => 
            this._col_dg_clientes_estado;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._col_dg_clientes_estado = value);
    }

    internal virtual ToolStrip ToolStrip1
    {
        [DebuggerNonUserCode]
        get => 
            this._ToolStrip1;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ToolStrip1 = value);
    }

    internal virtual ToolStripButton toolbt_listaNegra
    {
        [DebuggerNonUserCode]
        get => 
            this._toolbt_listaNegra;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            EventHandler handler = new EventHandler(this.toolbt_listaNegra_Click);
            if (!ReferenceEquals(this._toolbt_listaNegra, null))
            {
                this._toolbt_listaNegra.Click -= handler;
            }
            this._toolbt_listaNegra = value;
            if (!ReferenceEquals(this._toolbt_listaNegra, null))
            {
                this._toolbt_listaNegra.Click += handler;
            }
        }
    }

    internal virtual ToolStripSeparator ToolStripSeparator1
    {
        [DebuggerNonUserCode]
        get => 
            this._ToolStripSeparator1;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ToolStripSeparator1 = value);
    }

    internal virtual ToolStripButton toolbt_Limpiar
    {
        [DebuggerNonUserCode]
        get => 
            this._toolbt_Limpiar;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            EventHandler handler = new EventHandler(this.toolbt_Limpiar_Click);
            if (!ReferenceEquals(this._toolbt_Limpiar, null))
            {
                this._toolbt_Limpiar.Click -= handler;
            }
            this._toolbt_Limpiar = value;
            if (!ReferenceEquals(this._toolbt_Limpiar, null))
            {
                this._toolbt_Limpiar.Click += handler;
            }
        }
    }

    internal virtual ToolStripSeparator ToolStripSeparator2
    {
        [DebuggerNonUserCode]
        get => 
            this._ToolStripSeparator2;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ToolStripSeparator2 = value);
    }

    internal virtual ToolStripButton toolbtVerificar
    {
        [DebuggerNonUserCode]
        get => 
            this._toolbtVerificar;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            EventHandler handler = new EventHandler(this.toolbtVerificar_Click);
            if (!ReferenceEquals(this._toolbtVerificar, null))
            {
                this._toolbtVerificar.Click -= handler;
            }
            this._toolbtVerificar = value;
            if (!ReferenceEquals(this._toolbtVerificar, null))
            {
                this._toolbtVerificar.Click += handler;
            }
        }
    }

    internal virtual ToolStripSeparator ToolStripSeparator3
    {
        [DebuggerNonUserCode]
        get => 
            this._ToolStripSeparator3;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._ToolStripSeparator3 = value);
    }

    internal virtual GroupBox GroupBox4
    {
        [DebuggerNonUserCode]
        get => 
            this._GroupBox4;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._GroupBox4 = value);
    }

    internal virtual TextBox txtBuscar
    {
        [DebuggerNonUserCode]
        get => 
            this._txtBuscar;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            KeyPressEventHandler handler = new KeyPressEventHandler(this.txtBuscar_KeyPress);
            if (!ReferenceEquals(this._txtBuscar, null))
            {
                this._txtBuscar.KeyPress -= handler;
            }
            this._txtBuscar = value;
            if (!ReferenceEquals(this._txtBuscar, null))
            {
                this._txtBuscar.KeyPress += handler;
            }
        }
    }

    internal virtual RadioButton rbApellidos
    {
        [DebuggerNonUserCode]
        get => 
            this._rbApellidos;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            EventHandler handler = new EventHandler(this.rbApellidos_CheckedChanged);
            if (!ReferenceEquals(this._rbApellidos, null))
            {
                this._rbApellidos.CheckedChanged -= handler;
            }
            this._rbApellidos = value;
            if (!ReferenceEquals(this._rbApellidos, null))
            {
                this._rbApellidos.CheckedChanged += handler;
            }
        }
    }

    internal virtual RadioButton rbDNI
    {
        [DebuggerNonUserCode]
        get => 
            this._rbDNI;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set
        {
            EventHandler handler = new EventHandler(this.rbDNI_CheckedChanged);
            if (!ReferenceEquals(this._rbDNI, null))
            {
                this._rbDNI.CheckedChanged -= handler;
            }
            this._rbDNI = value;
            if (!ReferenceEquals(this._rbDNI, null))
            {
                this._rbDNI.CheckedChanged += handler;
            }
        }
    }

    internal virtual GroupBox GroupBox1
    {
        [DebuggerNonUserCode]
        get => 
            this._GroupBox1;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._GroupBox1 = value);
    }

    internal virtual GroupBox GroupBox2
    {
        [DebuggerNonUserCode]
        get => 
            this._GroupBox2;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._GroupBox2 = value);
    }

    internal virtual Label lblEmpresa
    {
        [DebuggerNonUserCode]
        get => 
            this._lblEmpresa;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._lblEmpresa = value);
    }

    internal virtual Label lblApellidos
    {
        [DebuggerNonUserCode]
        get => 
            this._lblApellidos;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._lblApellidos = value);
    }

    internal virtual Label lblNombres
    {
        [DebuggerNonUserCode]
        get => 
            this._lblNombres;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._lblNombres = value);
    }

    internal virtual Label lblDNI
    {
        [DebuggerNonUserCode]
        get => 
            this._lblDNI;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._lblDNI = value);
    }

    internal virtual Label lblTipoPersonal
    {
        [DebuggerNonUserCode]
        get => 
            this._lblTipoPersonal;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._lblTipoPersonal = value);
    }

    internal virtual Label Label7
    {
        [DebuggerNonUserCode]
        get => 
            this._Label7;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._Label7 = value);
    }

    internal virtual Label Label6
    {
        [DebuggerNonUserCode]
        get => 
            this._Label6;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._Label6 = value);
    }

    internal virtual Label Label9
    {
        [DebuggerNonUserCode]
        get => 
            this._Label9;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._Label9 = value);
    }

    internal virtual Label Label3
    {
        [DebuggerNonUserCode]
        get => 
            this._Label3;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._Label3 = value);
    }

    internal virtual Label Label2
    {
        [DebuggerNonUserCode]
        get => 
            this._Label2;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._Label2 = value);
    }

    internal virtual PictureBox pbxImagen
    {
        [DebuggerNonUserCode]
        get => 
            this._pbxImagen;
        [MethodImpl(MethodImplOptions.Synchronized), DebuggerNonUserCode]
        set => 
            (this._pbxImagen = value);
    }
}

