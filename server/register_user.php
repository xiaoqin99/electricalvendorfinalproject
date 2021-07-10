<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/javathre/public_html/s270088/electricalvendor/php/PHPMailer/Exception.php';
require '/home8/javathre/public_html/s270088/electricalvendor/php/PHPMailer/PHPMailer.php';
require '/home8/javathre/public_html/s270088/electricalvendor/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$rating = "0";
$credit = "0";
$status = "active";

$sqlregister = "INSERT INTO tbl_user(user_email,password,otp,rating,credit,status) VALUES ('$email','$passha1','$otp','$rating','$credit','$status')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$email);
}else{
    echo "failed";
}

function sendEmail($otp,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.javathree99.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'electricalvendor@javathree99.com';                  //SMTP username
    $mail->Password   = 'TANxiaoqin991101';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "electricalvendor@javathree99.com";
    $to = $email;
    $subject = "From ElectricalVendor. Please Verify your account";
    $message = "<p>Click the following link to verify your account<br><br><a href='https://javathree99.com/s270088/electricalvendor/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here</a>";
    
    $mail->setFrom($from,"ElectricalVendor");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}
?>