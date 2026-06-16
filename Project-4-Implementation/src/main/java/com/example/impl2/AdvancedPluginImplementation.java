package com.example.impl2;

import com.example.api.*;

public class AdvancedPluginImplementation
        implements Task,
        Validator,
        Transformer {

    @Override
    public void execute() {
        System.out.println("Advanced Task Executed");
    }

    @Override
    public boolean validate(String value) {
        return value != null && !value.isBlank();
    }

    @Override
    public String transform(String value) {
        return new StringBuilder(value)
                .reverse()
                .toString();
    }
}