package com.example.host;

import java.util.*;

public class PluginRegistry {

    private final Map<Class<?>, List<Object>> registry =
            new HashMap<>();

    public <T> void register(
            Class<T> type,
            Object implementation
    ) {

        registry
                .computeIfAbsent(
                        type,
                        k -> new ArrayList<>()
                )
                .add(implementation);
    }

    @SuppressWarnings("unchecked")
    public <T> List<T> get(Class<T> type) {

        return (List<T>) registry.getOrDefault(
                type,
                Collections.emptyList()
        );
    }

    public void printContents() {

        registry.forEach(
                (type, implementations) ->
                        System.out.println(
                                type.getName()
                                        + " -> "
                                        + implementations.size()
                        )
        );
    }
}