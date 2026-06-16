package com.example.host;

import com.example.api.*;

import java.util.ServiceLoader;

public class ConsumerService {

    public void consume(String input) {

        ServiceLoader.load(Task.class)
                .forEach(Task::execute);

        ServiceLoader.load(Validator.class)
                .forEach(v ->
                        System.out.println(
                                v.validate(input)
                        ));

        ServiceLoader.load(Transformer.class)
                .forEach(t ->
                        System.out.println(
                                t.transform(input)
                        ));
    }
}