
CREATE SEQUENCE etl.batch_id_seq
START WITH 1
INCREMENT BY 1;


DROP TABLE IF EXISTS etl.batch_audit;
CREATE TABLE etl.batch_audit(

	batch_id         BIGINT PRIMARY KEY,
	layer			 TEXT NOT NULL,
	batch_start_time TIMESTAMP,
	batch_end_time   TIMESTAMP,
	status           TEXT
);
