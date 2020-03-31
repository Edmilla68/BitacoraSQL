 public int buscaID_m_tptablas(int ar_id_tptabla, string ar_nom_tptabla)
        {
            SqlConnection conx_mon = new SqlConnection();
            conx_mon.ConnectionString = Globals.cadcnx_principal;
            conx_mon.Open();
            string sql_COMON = "buscaID_m_tptablas";
            SqlCommand command_mon = new SqlCommand(sql_COMON, conx_mon);
            command_mon.CommandType = System.Data.CommandType.StoredProcedure;

            SqlParameter PAR1 = new SqlParameter();
            PAR1.SqlDbType = System.Data.SqlDbType.Int;
            PAR1.ParameterName = "@id_tptabla";
            PAR1.Value = ar_id_tptabla;
            PAR1.Direction = System.Data.ParameterDirection.Output;

            SqlParameter PAR2 = new SqlParameter();
            PAR2.SqlDbType = System.Data.SqlDbType.VarChar;
            PAR2.ParameterName = "@nom_tptabla";
            PAR2.Size = 200;
            PAR2.Value = ar_nom_tptabla;
            PAR2.Direction = System.Data.ParameterDirection.Input;

            command_mon.Parameters.Add(PAR1);
            command_mon.Parameters.Add(PAR2);
            command_mon.ExecuteNonQuery();

            int outval = (int)command_mon.Parameters["@id_tptabla"].Value;
            //MessageBox.Show(outval.ToString());
            conx_mon.Close();
            return outval;
            //return 6;
        }