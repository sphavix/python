DROP TABLE IF EXISTS [dbo].[py_rental_predictions];
GO

CREATE TABLE [dbo].[py_rental_predictions](
 [RentalCount_Predicted] [int] NULL,
 [RentalCount_Actual] [int] NULL,
 [Month] [int] NULL,
 [Day] [int] NULL,
 [WeekDay] [int] NULL,
 [Snow] [int] NULL,
 [Holiday] [int] NULL,
 [Year] [int] NULL
) ON [PRIMARY]
GO


--Insert the results of the predictions for test set into a table
INSERT INTO py_rental_predictions
EXEC py_predict_rentalcount 'linear_model';

-- Select contents of the table
SELECT * FROM py_rental_predictions;