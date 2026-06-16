# Plugin Architecture using Java ServiceLoader and GraalVM Native Image

## Overview

This project demonstrates an extensible Plugin Architecture built using:

* Java 21
* Gradle
* Java SPI (Service Provider Interface)
* ServiceLoader
* META-INF/services
* Maven Local Repository
* GraalVM Native Image (AOT)
* JVM (JIT) Execution

The solution is designed to showcase how multiple plugin implementations can be discovered and executed without the Host application having any direct dependency on implementation classes.

The architecture supports both:

* JVM Execution (JIT Compilation)
* GraalVM Native Image Execution (AOT Compilation)

---

# Architecture Overview

The solution consists of four independent projects.

```text
Plugin Architecture
│
├── Project-1-API
│
├── Project-2-Implementation
│
├── Project-3-Host
│
├── Project-4-Implementation
│
└── README.md
```

---

# Project Responsibilities

## Project-1 : API Contracts

Contains the contracts shared between the Host and Plugin implementations.

Interfaces:

```java
Task
Validator
Transformer
```

Example:

```java
public interface Task {

    void execute();
}
```

Artifact:

```text
com.example:api-contracts:1.0.0
```

Purpose:

* Defines extension points
* Shared dependency for Host and Plugins
* Published to Maven Local

---

## Project-2 : Plugin Implementation V1

Provides the first implementation of:

```java
Task
Validator
Transformer
```

Example Output:

```text
Task Executed

true

ORACLE
```

Artifact:

```text
com.example:plugin-implementation-v1:1.0.0
```

---

## Project-4 : Plugin Implementation V2

Provides an alternative implementation of:

```java
Task
Validator
Transformer
```

Example Output:

```text
Advanced Task Executed

true

elcarO
```

Artifact:

```text
com.example:plugin-implementation-v2:1.0.0
```

---

## Project-3 : Host Application

Acts as the runtime container.

Responsibilities:

* Discover plugins
* Bind plugins
* Execute plugins

The Host never references implementation classes directly.

It only depends on:

```java
Task
Validator
Transformer
```

---

# ServiceLoader Based Plugin Discovery

The Host uses Java's built-in SPI mechanism.

Example:

```java
ServiceLoader.load(Task.class);
```

ServiceLoader automatically:

1. Scans all JARs on the classpath
2. Reads META-INF/services files
3. Discovers implementations
4. Creates instances
5. Makes them available to the Host

No custom reflection code is required.

---

# META-INF/services

Each implementation project contains:

```text
src/main/resources
└── META-INF
    └── services
```

Example:

```text
META-INF/services/com.example.api.Task
```

Contents:

```text
com.example.impl.PluginImplementation
```

This file registers the implementation with ServiceLoader.

Without this registration ServiceLoader cannot discover plugins.

---

# Plugin Discovery Flow

```text
Host Application
        │
        ▼
ServiceLoader.load(Task.class)
        │
        ▼
META-INF/services
        │
        ▼
Discover Implementations
        │
        ▼
Instantiate Plugins
        │
        ▼
ConsumerService
        │
        ▼
Execute Plugin Methods
```

---

# Maven Local Repository

All artifacts are published into Maven Local.

Location:

Windows:

```text
C:\Users\<username>\.m2\repository
```

Linux/macOS:

```text
~/.m2/repository
```

Published Artifacts:

```text
api-contracts

plugin-implementation-v1

plugin-implementation-v2
```

Project-3 consumes these artifacts as normal Maven dependencies.

---

# Build and Execution Flow

## Step 1 : Publish API Contracts

Navigate to Project-1.

```powershell
.\gradlew publishToMavenLocal
```

Result:

```text
api-contracts
```

is installed into Maven Local.

---

## Step 2 : Publish Plugin Implementation V1

Navigate to Project-2.

```powershell
.\gradlew publishToMavenLocal
```

Result:

```text
plugin-implementation-v1
```

is installed into Maven Local.

---

## Step 3 : Publish Plugin Implementation V2

Navigate to Project-4.

```powershell
.\gradlew publishToMavenLocal
```

Result:

```text
plugin-implementation-v2
```

is installed into Maven Local.

---

## Step 4 : Run Host Application

Navigate to Project-3.

JVM Execution:

```powershell
.\gradlew run
```

Expected Output:

```text
PLUGIN HOST STARTED

Task Executed

Advanced Task Executed

true

true

ORACLE

elcarO

PLUGIN HOST FINISHED
```

---

# GraalVM Native Image Support

The project supports Ahead-of-Time Compilation using GraalVM.

Benefits:

* Faster startup
* Lower memory footprint
* Single executable deployment
* No JVM required at runtime

---

# Native Image Build

From Project-3:

```powershell
.\gradlew nativeCompile
```

Generated Executable:

```text
build/native/nativeCompile/plugin-host.exe
```

---

# Native Image Execution

Using Gradle:

```powershell
.\gradlew runAot
```

Or execute directly:

```powershell
.\build\native\nativeCompile\plugin-host.exe
```

---

# How GraalVM Discovers Plugins

During:

```powershell
.\gradlew nativeCompile
```

Gradle places the following artifacts on the classpath:

```text
api-contracts.jar

plugin-implementation-v1.jar

plugin-implementation-v2.jar

project-3-host.jar
```

GraalVM then:

1. Analyzes ServiceLoader usage
2. Reads META-INF/services
3. Discovers plugin implementations
4. Includes them in the executable

Result:

```text
plugin-host.exe
```

contains:

```text
Task

Validator

Transformer

PluginImplementation

AdvancedPluginImplementation
```

No external plugin JARs are loaded at runtime.

---

# Prerequisites

## Java

Required:

```text
Java 21
```

Recommended:

```text
Oracle GraalVM JDK 21
```

Verify:

```powershell
java -version
```

---

## Gradle

Gradle Wrapper is included.

No manual installation required.

Verify:

```powershell
.\gradlew --version
```

---

## GraalVM Native Image

Required for AOT execution.

Verify:

```powershell
native-image --version
```

---

## Visual Studio Build Tools (Windows Only)

Required for GraalVM Native Image compilation.

Install:

```text
Visual Studio Build Tools
```

Workload:

```text
Desktop Development with C++
```

Required Components:

* MSVC Compiler
* Windows SDK
* vcvarsall.bat

Verify:

```powershell
where cl
```

---

# Cloning and Running on Another Machine

## Step 1

Clone repository:

```bash
git clone <repository-url>
```

---

## Step 2

Install:

* GraalVM JDK 21
* Native Image
* Visual Studio Build Tools (Windows)

---

## Step 3

Publish API Contracts

```powershell
cd Project-1-API

.\gradlew publishToMavenLocal
```

---

## Step 4

Publish Plugin Implementation V1

```powershell
cd Project-2-Implementation

.\gradlew publishToMavenLocal
```

---

## Step 5

Publish Plugin Implementation V2

```powershell
cd Project-4-Implementation

.\gradlew publishToMavenLocal
```

---

## Step 6

Run Host

JVM:

```powershell
cd Project-3-Host

.\gradlew run
```

AOT:

```powershell
.\gradlew runAot
```

---

# Adding a New Plugin

Create a new implementation project.

Example:

```text
Project-5-Implementation
```

Implement:

```java
Task

Validator

Transformer
```

Register using:

```text
META-INF/services
```

Publish:

```powershell
.\gradlew publishToMavenLocal
```

Add dependency in Project-3:

```groovy
implementation 'com.example:plugin-implementation-v3:1.0.0'
```

Rebuild:

```powershell
.\gradlew clean nativeCompile
```

The new plugin will now be available.

---

# Advantages

* Loose Coupling
* Standard Java SPI Mechanism
* Multiple Plugin Support
* GraalVM Compatible
* No Custom ClassLoader Required
* Easy to Extend
* Supports JVM and Native Execution
* Enterprise-Friendly Architecture

---

# Technologies Used

* Java 21
* Gradle 9
* ServiceLoader
* Java SPI
* META-INF/services
* Maven Local Repository
* GraalVM Native Image
* Visual Studio Build Tools

---

# Conclusion

This project demonstrates a production-style Plugin Architecture using Java ServiceLoader and META-INF/services. The Host application remains independent of plugin implementations while supporting automatic discovery, binding, and execution through Java SPI. The architecture supports both JVM execution and GraalVM Native Image execution, making it suitable for extensible enterprise applications requiring high performance and maintainability.
