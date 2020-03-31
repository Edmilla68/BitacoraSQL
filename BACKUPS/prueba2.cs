
        private bool leerControlBiometrico()
        {
           // byte huella = 000;
            string CommandText = "USP_ListarBioIdentidadDatos_S";
            SqlConnection con = new SqlConnection("Data Source=calw12monitor;Initial Catalog=SICOS_CONTROL;Persist Security Info=True;User ID=sa;Password=N3ptunia");
            SqlCommand cmd = new SqlCommand(CommandText,con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@bioDni", SqlDbType.Char);
            param[0].Value = "08681564";

            cmd.Parameters.AddRange(param);

            con.Open();
            cmd.Connection = con;
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                //templateEntrada = Convert.ToByte(rdr[2]);
            }

            return true;


        }


        private byte[] leerControlBiometrico_2()
        {
            byte[] huella = null;
            string CommandText = "USP_ListarBioIdentidadDatos_S";
            SqlConnection con = new SqlConnection("Data Source=calw12monitor;Initial Catalog=SICOS_CONTROL;Persist Security Info=True;User ID=sa;Password=N3ptunia");
            SqlCommand cmd = new SqlCommand(CommandText, con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter[] param = new SqlParameter[1];
            param[0] = new SqlParameter("@bioDni", SqlDbType.Char);
            param[0].Value = "08681564";

            cmd.Parameters.AddRange(param);

            con.Open();
            cmd.Connection = con;
            SqlDataReader rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                huella = (byte[])rdr[2];
                    //BitConverter.GetBytes(rdr[2]);

                //numArray = (byte[])dataTable2.Rows[0][2];
                    //Convert.ToByte(rdr[2]);
               
            }

            return huella;


        }
