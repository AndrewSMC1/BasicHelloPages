using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Hosting.Server;
using System;

namespace WebApplication1.Pages
{
	public class IndexModel : PageModel
	{

        public string databasetableCol;
        public string databasetableRow;

        private readonly ILogger<IndexModel> _logger;

		public IndexModel(ILogger<IndexModel> logger)
		{
			_logger = logger;
		}

		public void OnGet()
		{
            // connection string
            // string connectionString = "Data Source=(localdb)\\ProjectModels;Initial Catalog=prods;Integrated Security=True;Connect Timeout=30;Encrypt=False;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False";
            //string connectionString = "Server=tcp:prodsdbserver.database.windows.net,1433;Initial Catalog=prods;Persist Security Info=False;User ID=cs190admin;Password=########;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30";
            string connectionString = "Data Source=prodsdbserver.database.windows.net;Initial Catalog=prods;User ID=cs190admin;Password=#########;Connect Timeout=30;Encrypt=True;Trust Server Certificate=False;Application Intent=ReadWrite;Multi Subnet Failover=False";
            // Connect to a PostgreSQL database
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();

            // Define a query returning a single row result set
            /*
             Change the table which the data is pulled from the first one for question 7 
             Second one for question 20
             */

            //Question 7
            SqlCommand command = new SqlCommand("SELECT * FROM product", conn); //grabs the data from the SQL DB

            //Question 20
            SqlCommand command_20 = new SqlCommand("SELECT * FROM customer", conn);


            //NpgsqlCommand quantity_command = new NpgsqlCommand("SELECT prod_id, prod_desc, prod_quantity from product WHERE prod_quantity <=30 and prod_quantity >= 12", conn);
            //NpgsqlCommand repids_command = new NpgsqlCommand("SELECT rep_id, SUM(cust_balance) AS rep_total_bal FROM customer GROUP BY rep_id", conn);

            SqlDataReader reader = command.ExecuteReader(); //reads the db data into a variable called "reader"


            DataTable dt = new DataTable(); //creates a new datatable called dt
            dt.Load(reader); //loads the new DT with the data from the reader
            reader.Close(); //closes the reader allowing for a new NpgSql reader to load the second data table

            SqlDataReader reader2 = command_20.ExecuteReader();
            DataTable dt2 = new DataTable();
            dt2.Load(reader2);
            reader2.Close();

            //Prints the whole data table
            //print_results(dt);

            //Question 7
            //Console.WriteLine("Question 7 Product quantities");
            //PrintSeven(dt);

            //Question 20
            Console.WriteLine("Question 20 Total balance");
            //printreps(dt2);
            print_results(dt2);
            conn.Close();
        }

        void PrintSeven(DataTable data) //question 7

        {
            DataTable sorted_data = new DataTable();
            foreach (DataColumn col in data.Columns)
            {
                //adds the columns to the new data table and the data type
                if (col.ColumnName.Contains("prod_id") || col.ColumnName.Contains("prod_desc") || col.ColumnName.Contains("prod_quantity"))
                {
                    sorted_data.Columns.Add(col.ColumnName, col.DataType);

                }
            }

            foreach (DataRow row in data.Rows)
            {
                //turns the quanity into ints to compare if it is between 12 or 30
                int rowdata = Convert.ToInt32(row["prod_quantity"]);
                if (rowdata >= 12 && rowdata <= 30)
                {
                    DataRow sorted_row = sorted_data.NewRow();
                    foreach (DataColumn col in sorted_data.Columns)
                    {

                        sorted_row[col.ColumnName] = row[col.ColumnName];
                    }
                    sorted_data.Rows.Add(sorted_row);
                };

            }

            // display using print results function
            print_results(sorted_data);

        }

        void printreps(DataTable data) //question 20
        {
            //creates a new datatable
            DataTable sorted_data = new DataTable();

            //creates the columns for the information the new table holds
            sorted_data.Columns.Add("rep_id", typeof(string));
            sorted_data.Columns.Add("total_bal", typeof(double));

            foreach (DataRow row in data.Rows)
            {
                string repIdValue = row["rep_id"].ToString();
                //does a comparison between the repid values in sorteddata table and the repids from the main table

                DataRow[] matchingRows = sorted_data.Select("rep_id = '" + repIdValue + "'"); //matchingrows references the data in a single row of sorteddata


                if (matchingRows.Length == 0) // if the row in complete data is not found in the sorted data table rows then it would return a variable
                                              //of lenth zero meaning it needs to be added to the sorted table
                {

                    DataRow newRow = sorted_data.NewRow(); // Create a new row object that copys the schema of sorted data rows 
                    newRow["rep_id"] = row["rep_id"]; // sets the data in newrow object in column repid to the original data in the main table

                    //add the inital balance to the rep row
                    newRow["total_bal"] = row["cust_balance"];

                    // Add the newrow object to sorted_data table
                    sorted_data.Rows.Add(newRow);


                }
                else
                {
                    //converts the object data to doubles so they can be added
                    double value_to_add = Convert.ToDouble(row["cust_balance"]);
                    double current_total = Convert.ToDouble(matchingRows[0]["total_bal"]);

                    // motifies the matchingrows object that references a row in sorteddata by adding the prevous total with the new cust bal
                    matchingRows[0]["total_bal"] = current_total + value_to_add;

                }
            }

            DataRow[] rowstoremove = sorted_data.Select("total_bal < '12000'");// filters the data from the table that fits the argument
                                                                               //define the rows to remove outside of a loop otherwise it will raise and exception if data is removed mid loop
                                                                               //removes rep ids that do not fit the required balance
            foreach (DataRow row in rowstoremove)
            {
                sorted_data.Rows.Remove(row);
            }


            // display using print results function
            print_results(sorted_data);

        }
        void print_results(DataTable data)
        {
            //Console.WriteLine();
            databasetableCol = " ";
            Dictionary<string, int> colWidths = new Dictionary<string, int>();

            foreach (DataColumn col in data.Columns)
            {
                //Console.Write(col.ColumnName);
                databasetableCol = databasetableCol + col.ColumnName;
                var maxLabelSize = data.Rows.OfType<DataRow>()
                        .Select(m => (m.Field<object>(col.ColumnName)?.ToString() ?? "").Length)
                        .OrderByDescending(m => m).FirstOrDefault();

                colWidths.Add(col.ColumnName, maxLabelSize);
                for (int i = 0; i < maxLabelSize - col.ColumnName.Length + 14; i++) Console.Write(" ");
                databasetableRow = databasetableRow + " ";
            }

            //Console.WriteLine();
            

            foreach (DataRow dataRow in data.Rows)
            {
                for (int j = 0; j < dataRow.ItemArray.Length; j++)
                {
                    //Console.Write(dataRow.ItemArray[j]);
                    databasetableRow = databasetableRow + dataRow.ItemArray[j];

                    for (int i = 0; i < colWidths[data.Columns[j].ColumnName] - dataRow.ItemArray[j].ToString().Length + 14; i++) Console.Write(" ");
                }
                //Console.WriteLine();
                databasetableRow = databasetableRow + "\t";
            }

        }
    }
	
}