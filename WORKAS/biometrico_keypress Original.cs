private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            int li_existencias = 0;
            if (e.KeyChar == (char)Keys.Enter)
            {
                limpia_campos();
                if (textBox1.Text.Trim().Length == 8)
                    {
                       // MessageBox.Show("DNI");
                        li_existencias  = busca_dni(textBox1.Text.Trim());
                    }
                else
                    {
                        //MessageBox.Show("fotocheck");
                        busca_fotocheck(busca_cod_per(textBox1.Text.Trim()));

                    }

                Color_campos_ln("NEGRO");
                if (li_existencias  > 0)
                {
                    busca_listanegra(lbl_codpers.Text.Trim());
                }
                
            }
        }