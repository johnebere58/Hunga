package com.hunga;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.opay.account.core.LoginTask;
import com.opay.account.core.PayTask;
import com.opay.account.iinterface.LoginResultCallback;
import com.opay.account.iinterface.PayResultCallback;
import com.opay.account.iinterface.ResultStatus;
import com.opay.account.model.LoginResult;
import com.opay.account.model.OrderInfo;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "channel.john";
    private MethodChannel.Result pendingResult;
    String publicKey = "256620112218046";
    String merchantId = "OPAYPUB16060395869560.5467954372775526";
    String aesKey = "djkNXpcMU1HcbIOz";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            pendingResult = result;
                            // Your existing code
                            if(call.method.equals("login")){
                                opayLogin();
                            }
                            if(call.method.equals("pay")){
//                                val text = call.argument<String>("text")
                                double amount = (double)call.argument("amount");
                                String id = (String)call.argument("id");
                                opay(amount,id);
                            }

                        });
    }



    public void opayLogin(){

        new LoginTask(publicKey,merchantId,aesKey)
                .login(MainActivity.this,
                        loginResult -> {
                            if(loginResult.status == ResultStatus.SUCCESS){
                              pendingResult.success(true);
                            }else{
                              pendingResult.success(false);
                            }
                        });
    }

     public void opay(double amount,String paymentId){

         OrderInfo info = new OrderInfo();
         info.setAmount(amount);
         info.setCurrency("NG");
         info.setMerchantName("Hunga");
         info.setMerchantUserId(merchantId);
         info.setReference(paymentId);
         info.setPublicKey(publicKey);
         info.setDescription("Payment for food");
         new PayTask(info)
                 .pay( MainActivity.this,
                         status -> {
                             if(status==ResultStatus.SUCCESS) {
                                 pendingResult.success(true);
                             }else{
                                 pendingResult.error(String.valueOf(status.code),
                                         status.msg,"Failed");
                             }
                             //doSomething
                         });
    }





    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

}
