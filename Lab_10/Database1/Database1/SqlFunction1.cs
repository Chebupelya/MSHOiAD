using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read)]
    public static double CalculateAverageWithoutx(SqlString values)
    {
        if (values.IsNull || values.Value.Length < 3)
            return 0;

        string[] stringValues = values.Value.Split(',');

        double sum = 0;
        int count = 0;

        double min = Convert.ToDouble(stringValues[0]);
        foreach (string stringValue in stringValues)
        {
            if (double.TryParse(stringValue, out double currentValue))
            {
                if (currentValue <= min)
                {
                    min = currentValue;
                }
            }
        }
        double max = Convert.ToDouble(stringValues[0]);
        foreach (string stringValue in stringValues)
        {
            if (double.TryParse(stringValue, out double currentValue))
            {
                if (currentValue >= max)
                {
                    max = currentValue;
                }
            }
        }

        foreach (string stringValue in stringValues)
        {

            if (double.TryParse(stringValue, out double currentValue))
            {
                if (currentValue != min && currentValue != max)
                {
                    sum += currentValue;
                    count++;
                }
            }
        }
        return sum / count;
    }
}
