import pymysql
import pymysql.cursors

proxySqlConnection = pymysql.connect(host='localhost', port=6032,
                                   user='radmin',
                                   password='radmin',
                                   db='test',
                                   charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

proxySqlCursor = proxySqlConnection.cursor()

proxySqlCursor.execute("select Queries from stats_mysql_connection_pool where srv_host='master'")
proxySqlAnswer = proxySqlCursor.fetchone()

print(proxySqlAnswer['Queries'])