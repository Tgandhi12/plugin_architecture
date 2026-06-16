package com.example.host;

public class HostApplication {

 public static void main(String[] args) {

  System.out.println(
          "================================="
  );

  System.out.println(
          "PLUGIN HOST STARTED"
  );

  System.out.println(
          "================================="
  );

  new ConsumerService()
          .consume("Oracle");

  System.out.println(
          "================================="
  );

  System.out.println(
          "PLUGIN HOST FINISHED"
  );

  System.out.println(
          "================================="
  );
 }
}