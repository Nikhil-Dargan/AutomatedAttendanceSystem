function f = mysql(func, stu_id, feature_arr);
    init();
    %create_db();
    switch(func)
        case 'create_db'
            f = create_db();
        case 'create_features'
            create_features(stu_id,feature_arr);
        otherwise
            error(['Unknown function ', func]);
    end
    global dbConn
    %close(dbConn);
end
function f = init();
       host = 'localhost:3306';
       user = 'root';
        password = '12345';
        dbName = 'attentec';
        jdbcString = sprintf('jdbc:mysql://%s/%s', host, dbName);
        jdbcDriver = 'com.mysql.jdbc.Driver';
        global dbConn
        dbConn = database(dbName, user , password, jdbcDriver, jdbcString);
        if isconnection(dbConn)
            disp('succes');
        else
            disp('error in connection');
        end
end
function f = create_db();
        global dbConn
        result = get(fetch(exec(dbConn, 'create table StuDetails (sid int primary key, sname varchar(20), dob date, attendance int, Maxclasses int)')), 'Data');
        result = get(fetch(exec(dbConn, 'create table StuFacialFeatures (sid int,facial_val double, foreign key(sid) references StuDetails(sid))')), 'Data');    
        colnames = {'sid' 'sname' 'attendance' 'Maxclasses'};
        for i=1:20
            id = i; 
            name = i*i;
            exdata = {id,'name', 0,0};
            %exdata_table = cell2mat(exdata);
            fastinsert(dbConn,'StuDetails',colnames,exdata);
        end 
        result = get(fetch(exec(dbConn, 'select * from StuDetails')), 'Data');
end
function f = create_features(stu_id,feature_arr);    
        global dbConn;   
        colnames= {'sid' 'facial_val'};
        for i=1:size(feature_arr,2)
            facial_val = feature_arr(i);
            sqlquery=sprintf('insert into StuFacialFeatures values(%s, %s)',stu_id,facial_val);
            result = exec(dbConn,sqlquery);
        end
        result = get(fetch(exec(dbConn, 'select * from StuFacialFeatures')), 'Data');
        disp(result);
end
