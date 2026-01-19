-- Azure Data Factory Learning Project
-- SQL Database Schema

-- Create Sales Table
CREATE TABLE [dbo].[sales] (
    [sales_id] INT NOT NULL,
    [product] NVARCHAR(100),
    [amount] DECIMAL(10, 2),
    [date] DATE,
    [country] NVARCHAR(50),
    [amount_category] NVARCHAR(50)
);

-- Add Primary Key
ALTER TABLE [dbo].[sales]
ADD CONSTRAINT PK_sales PRIMARY KEY (sales_id);

-- Create Index for better performance
CREATE NONCLUSTERED INDEX IX_amount ON [dbo].[sales]([amount]);
CREATE NONCLUSTERED INDEX IX_country ON [dbo].[sales]([country]);

-- Verify table creation
SELECT * FROM [dbo].[sales];
