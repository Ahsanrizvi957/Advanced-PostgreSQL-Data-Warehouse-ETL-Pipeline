-- Generating sequence number for batch id

CREATE SEQUENCE bronze.batch_id_seq
START WITH 1
INCREMENT BY 1;


DROP TABLE IF EXISTS bronze.batch_audit;
CREATE TABLE bronze.batch_audit(

	batch_id         BIGINT PRIMARY KEY,
	layer			 TEXT NOT NULL,
	batch_start_time TIMESTAMP,
	batch_end_time   TIMESTAMP,
	status           TEXT
);
