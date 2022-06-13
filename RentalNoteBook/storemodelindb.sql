USE TutorialDB;

DROP TABLE IF EXISTS dbo.rental_py_models;
GO
CREATE TABLE dbo.rental_py_models(
    model_name VARCHAR(30) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
);
GO

DECLARE @model VARBINARY(MAX);
EXECUTE generate_rental_py_model @model OUTPUT;

INSERT INTO rental_py_models (model_name, model) VALUES('linear_model', @model);
