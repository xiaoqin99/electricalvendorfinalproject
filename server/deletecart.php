<?php

include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];


if (isset($_POST['prid'])){
    $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$email' AND prid='$prid'";
}else{
    $sqldelete = "DELETE FROM tbl_cart WHERE user_email = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>