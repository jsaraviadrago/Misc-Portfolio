import pandas as pd
import s3fs

# Your S3 credentials. Ideally, these should not be hardcoded but fetched from a secure environment.
#aws_access_key_id = 'YOUR_ACCESS_KEY'
#aws_secret_access_key = 'YOUR_SECRET_KEY'
#bucket_name = 'your-bucket-name'
#file_path = 'path/to/your/file.parquet'

# Creating an S3 filesystem object
#fs = s3fs.S3FileSystem(key=aws_access_key_id, secret=aws_secret_access_key)

# Reading the file
#with fs.open(f's3://{bucket_name}/{file_path}') as f:
#    df = pd.read_parquet(f)

#print(df)


# s3_uri=s3://ng-data-science-interviews/clickstream2
# s3_region= us-east-2
#s3_access_key_id=AKIASQRQO2RJDCVD7SAA
# s3_secret_access_key=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