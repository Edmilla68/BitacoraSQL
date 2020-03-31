 public void busca_listanegra(string ar_codper)
        {
            //string ls_cmdlocal = ls_cmd001 + ls_whr001 + ar_dni + ls_fin001;

            string ls_cmd_ln = "select  TMLN.tipo_motivo, LN.observacion, LN.indefinido, LN.fechaInicio, LN.fechaFinal  " +
                                "from LISTA_NEGRA_PERSONAL_2014 LN  " +
                                "INNER JOIN TIPOS_MOTIVOS_LISTA_NEGRA_2014 TMLN ON TMLN.codigo_tipo_motivo = LN.codigo_tipo_motivo  ";

            string ls_whe_ln = "where LN.habilitado = 1 and codigo_personal =  " + ar_codper + "  ";
            string ls_cmd_com = ls_cmd_ln + ls_whe_ln;

            using (SqlConnection cn = new SqlConnection(Globals.cadcnx_principal))
            {
                cn.Open();

                SqlCommand cmd = new SqlCommand(ls_cmd_com, cn);
                SqlDataReader dr = cmd.ExecuteReader();
                int conta1 = 0;

                //label21

                if (dr.Read())
                {

                    lbl_motivo.Text = Convert.ToString(dr[0]);
                    lbl_observ.Text = Convert.ToString(dr[1]);
                    //label2.Text = Convert.ToString(dr[2]);
                    //label3.Text = Convert.ToString(dr[3]);
                    //label4.Text = Convert.ToString(dr[4]);

                    //lbl_codpers.Text = Convert.ToString(dr[6]);
                    conta1 = conta1 + 1;

                }

                if (conta1 > 0)
                {
                    label21.Text = "EN LISTA NEGRA...";
                    Color_campos_ln("ROJO");

                }

                cn.Close();
            }

        }