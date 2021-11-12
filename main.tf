provider "google" {
  project = "caplab"
  credentials = "caplab-a765dc74b76e.json"
}


resource "google_bigquery_table" "dest-table-v1" {
  deletion_protection = false
  dataset_id = "confdiff"
  table_id   = "sample_wtext_v1_loaded_test1"

  schema = <<EOF
[
  {
    "name": "Authority_Name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Fiscal_Year_End_Date",
    "type": "DATE",
    "mode": "NULLABLE"
  },
  {
    "name": "Has_Outstanding_Debt",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "Type_Of_Debt",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Debt_Program",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Begin_Amount_Total",
    "type": "BIGNUMERIC",
    "mode": "NULLABLE"
  },
  {
    "name": "New_Debt_Issuance",
    "type": "BIGDECIMAL",
    "mode": "NULLABLE"
  },
  {
    "name": "Amount_Retired",
    "type": "BIGDECIMAL",
    "mode": "NULLABLE"
  },
  {
    "name": "End_Amount_Total",
    "type": "BIGNUMERIC",
    "mode": "NULLABLE"
  },
  {
    "name": "Text_Test_Field",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "Other_Total",
    "type": "BIGDECIMAL",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_job" "extract-jobv2" {
  job_id     = "job_extract__v2"

  extract {
    destination_uris = [
      "gs://caplabbucket-test05/extractv2.csv"
    ]

    source_table {
      project_id = "caplab"
      dataset_id = "confdiff"
      table_id   = "sample_wtext_v1"
    }

    destination_format = "CSV"
  }
}


resource "google_bigquery_job" "load-jobv5" {
  job_id     = "job_load__v5"

  load {
    source_uris = [
      "gs://caplabbucket-test05/extractv2.csv",
    ]

    destination_table {
      project_id = "caplab"
      dataset_id = "confdiff"
      table_id = "sample_wtext_v1_loaded_test3"
    }
    autodetect = true
    write_disposition = "WRITE_APPEND"
    allow_quoted_newlines = true
  }
}

