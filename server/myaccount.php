<?php

include_once("dbconnect.php");

$name = $_POST['name'];
$phoneNo = $_POST['phoneNo'];
$email = $_POST['email'];

$sql = "SELECT * FROM tbl_user WHERE user_email = '$email'";
   $result = $conn->query($sql);
   if($result->num_rows > 0){
      $sqlaccount = "UPDATE tbl_user SET name = '$name', phoneNo = '$phoneNo' WHERE user_email = '$email'";
      if ($conn->query($sqlaccount) === TRUE){
          echo 'success';
      }else{
          echo 'failed';
      }
}
else{
    echo 'failed';
}

?>