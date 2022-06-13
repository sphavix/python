DROP PROCEDURE IF EXISTS py_predict_rentalcount;
GO

CREATE PROCEDURE py_predict_rentalcount(@model VARCHAR(100))
AS
BEGIN
    DECLARE @py_model VARBINARY(max) = (select model from rental_py_models where model_name = @model)

    EXECUTE sp_execute_external_script
            @language = N'Python',
            @script = N'
            # Import the scikit-learn function to compute error.
from sklearn.metrics import mean_squared_error
import pickle
import pandas

rental_model = pickle.loads(py_model)

df = rental_score_data

# Get all the columns from the dataframe.
columns = df.columns.tolist()

# Variable you will be predicting on.
target = "RentalCount"

# Generate the predictions for the test set.
lin_predictions = rental_model.predict(df[columns])
print(lin_predictions)

# Compute error between the test predictions and the actual values.
lin_mse = mean_squared_error(lin_predictions, df[target])
#print(lin_mse)

predictions_df = pandas.DataFrame(lin_predictions)

OutputDataSet = pandas.concat([predictions_df, df["RentalCount"], df["Month"], df["Day"], df["WeekDay"], df["Snow"], df["Holiday"], df["Year"]], axis=1)
'
, @input_data_1 = N'Select "RentalCount", "Year" ,"Month", "Day", "WeekDay", "Snow", "Holiday"  from rental_data where Year = 2015'
, @input_data_1_name = N'rental_score_data'
, @params = N'@py_model varbinary(max)'
, @py_model = @py_model
with result sets (("RentalCount_Predicted" float, "RentalCount" float, "Month" float,"Day" float,"WeekDay" float,"Snow" float,"Holiday" float, "Year" float));

END
GO