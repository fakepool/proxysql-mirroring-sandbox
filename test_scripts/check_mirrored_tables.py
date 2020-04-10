import pymysql
import pymysql.cursors
import sys, os, getopt


countOfTables = -1

try:
    opts, args = getopt.getopt(sys.argv[1:],"t:",["tables="])
except getopt.GetoptError:
    sys.exit(1)

for opt, arg in opts:
    if opt in ("-t", "--tables"):
        try:
            countOfTables = int(arg)
        except:
            print("error: invalid 'tables' argument:", arg)
            os._exit(1)

if countOfTables == -1:
    print("error: count of table argument is required")
    os._exit(1)
 
masterConnection = pymysql.connect(host='localhost', port=3306,
        user='root',
        password='password',
        db='test',
        charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

mirrorConnection = pymysql.connect(host='localhost', port=3307,
        user='root',
        password='password',
        db='test',
        charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

masterCursor = masterConnection.cursor()
mirrorCursor = mirrorConnection.cursor()

for i in range(1, countOfTables+1):
    print("comparing checksum of table sbtest"+str(i), end=': ')
    masterCursor.execute("CHECKSUM TABLE sbtest"+str(i))
    masterAnswer = masterCursor.fetchone()

    mirrorCursor.execute("CHECKSUM TABLE sbtest"+str(i))
    mirrorAnswer = mirrorCursor.fetchone()

    if masterAnswer['Checksum'] != mirrorAnswer['Checksum']:
        print("checksums are not equal")
        os._exit(1)
    print('ok')

masterConnection.close()
mirrorConnection.close()

print("all tables from master and mirror are equal")