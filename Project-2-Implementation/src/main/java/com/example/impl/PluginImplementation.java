package com.example.impl;

import com.example.api.*;

public class PluginImplementation
        implements Task,
        Validator,
        Transformer {

 @Override
 public void execute() {
  System.out.println("Task Executed");
 }

 @Override
 public boolean validate(String value) {
  return value != null;
 }

 @Override
 public String transform(String value) {
  return value.toUpperCase();
 }
}