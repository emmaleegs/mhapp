<?php
    //$secret = $_POST["secretWord"];
    //if ("44fdcv8jf3" != $secret) exit; // note the same secret as the app - could be let out if this check is not required. secretWord is not entered by the user and is used to prevent unauthorized access to the database
    
    $id = $_POST['id'];
    $survey = $_POST['survey'];
    
    // POST items should be checked for bad information before being added to the database.
    
    // Create connection
    $db_host = 'localhost';
    $db_user = 'root';
    $db_password = 'root';
    $db_db = 'appDB';
    $db_port = 3306;
    $db_socket = '/Applications/MAMP/tmp/mysql/mysql.sock';
    
    $mysqli = @new mysqli($db_host, $db_user, $db_password, $db_db, $db_port, $db_socket);
    
    if ($mysqli->connect_error) {
        echo 'Errno: '.$mysqli->connect_errno;
        echo '<br>';
        echo 'Error: '.$mysqli->connect_error;
        exit();
    }
    
    echo 'Success: A proper connection to MySQL was made.';
    echo '<br>';
    echo 'Host information: '.$mysqli->host_info;
    echo '<br>';
    echo 'Protocol version: '.$mysqli->protocol_version;
    
    // Import Data
    $query = "insert into 'survey_data' (id, survey) value ('".$id."','".$survey."')";
    $result = mysqli_query($mysqli,$query);
    
    echo $result; // sends 1 if insert worked
    
    $mysqli->close();
