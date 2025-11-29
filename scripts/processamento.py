from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Configurações de conexão com o PostgreSQL
PG_URL = "jdbc:postgresql://postgres_erp:5432/northwind"
PG_PROPERTIES = {
    "user": "user",
    "password": "password",
    "driver": "org.postgresql.Driver"
}
PG_TABLE = "customers"

# Nome da tabela Iceberg
ICEBERG_TABLE = "iceberg_catalog.default.customers_iceberg"

def create_spark_session():
    """Cria e retorna a sessão Spark com as configurações necessárias."""
    # As configurações de catálogo e logs já estão em spark-defaults.conf
    # Apenas inicializamos a sessão
    spark = SparkSession.builder \
        .appName("IcebergETL") \
        .getOrCreate()
    
    # Define o nível de log para evitar poluição no console
    spark.sparkContext.setLogLevel("WARN")
    
    print("Sessão Spark criada com sucesso.")
    return spark

def read_from_postgres(spark):
    """Lê dados da tabela de clientes do PostgreSQL."""
    print(f"Lendo dados da tabela '{PG_TABLE}' do PostgreSQL...")
    df = spark.read.jdbc(url=PG_URL, table=PG_TABLE, properties=PG_PROPERTIES)
    print(f"Total de registros lidos: {df.count()}")
    df.printSchema()
    return df

def write_to_iceberg(df):
    """Escreve o DataFrame no formato Iceberg."""
    print(f"Escrevendo dados no formato Iceberg na tabela: {ICEBERG_TABLE}...")
    
    # Seleciona e renomeia colunas para um formato mais limpo
    df_clean = df.select(
        col("customer_id").alias("id"),
        col("company_name").alias("empresa"),
        col("contact_name").alias("contato"),
        col("country").alias("pais")
    )
    
    # Escreve a tabela Iceberg
    df_clean.writeTo(ICEBERG_TABLE) \
        .using("iceberg") \
        .createOrReplace()
        
    print(f"Tabela Iceberg '{ICEBERG_TABLE}' criada com sucesso.")

def read_from_iceberg(spark):
    """Lê dados da tabela Iceberg."""
    print(f"Lendo dados da tabela Iceberg: {ICEBERG_TABLE}...")
    df_iceberg = spark.table(ICEBERG_TABLE)
    print(f"Total de registros lidos do Iceberg: {df_iceberg.count()}")
    df_iceberg.show(5, truncate=False)
    df_iceberg.printSchema()

def main():
    spark = create_spark_session()
    
    # 1. Extração (PostgreSQL)
    df_postgres = read_from_postgres(spark)
    
    # 2. Transformação e Carga (Iceberg)
    write_to_iceberg(df_postgres)
    
    # 3. Verificação (Leitura do Iceberg)
    read_from_iceberg(spark)
    
    spark.stop()
    print("Processo ETL concluído.")

if __name__ == "__main__":
    main()
