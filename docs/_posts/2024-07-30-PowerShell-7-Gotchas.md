---
layout: post
title:  "PowerShell 7 gotchas"
description: A look at PowerShell 7 in particular into some gotchas that may trip up existing scripts, and linking to the official Microsoft release notes
date:   2024-07-30 06:15:53 +0100
category: on-premises
tags: powershell on-premises
comments_id: 6
---
<h1>{{ page.title }}</h1>

With the release of PowerShell 7, several improvements and changes were introduced to enhance performance, compatibility, and functionality. However, some of these changes may impact existing scripts if you're upgrading from PowerShell Core 6.x or earlier versions. In this post, we'll explore some more significant breaking changes and provide examples to help you understand how they might affect your scripts.  Microsoft have a document that lists more changes here [https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell](https://learn.microsoft.com/en-us/powershell/scripting/whats-new/differences-from-windows-powershell)

## 1. Changes in `.Split()` method behaviour with multiple characters

### Previous behaviour:
In PowerShell Core 6.x, when using the `.Split()` method with a string containing multiple characters, PowerShell would split the input string on each individual character found in the delimiter string.

**Example in PowerShell Core 6.x:**

```powershell
$value = "ab12cd34ef"  
$result = $value.Split("bde")  
$result  
```

**Output:**

```powershell
a  
12c  
34  
f  
```

Here, the string is split at every occurrence of 'b', 'd', and 'e', treating each character separately.

### PowerShell 7 behaviour:
In PowerShell 7, the `.Split()` method treats the entire delimiter string as a single unit. If you want to retain the previous behaviour and split on individual characters, you need to explicitly convert the delimiter string to a character array.

**Example in PowerShell 7:**

```powershell
$value = "ab12cd34ef"  
$result = $value.Split("bde")  
$result  
```
**Output:**

```powershell
ab12cd34ef  
```
In this case, the string "bde" is not found as a whole in the input, so no splitting occurs.

**To split on each character in PowerShell 7:**

```powershell
$value = "ab12cd34ef"  
$result = $value.Split([char[]]"bde")  
$result  
```
**Output:**

```powershell
a  
12c  
34  
f  
```
This behaviour mimics the splitting on each character as seen in PowerShell Core 6.x.

### Summary:
PowerShell 7's `.Split()` method now treats multi-character strings as single delimiters by default. If you need the old behaviour of splitting on each character, use `[char[]]` to explicitly convert the delimiter.

## 2. Changes in `ConvertFrom-Json` handling of single-item arrays

### Previous behaviour:
In PowerShell Core 6.x, when using `ConvertFrom-Json` to parse a JSON array with a single object, the result was treated as an array, even with only one item.

**Example in PowerShell Core 6.x:**

```powershell
$json = '[{"name": "John"}]'  
$object = $json | ConvertFrom-Json  
$object.GetType()  
```
**Output:**

```powershell
IsPublic IsSerial Name                                     BaseType  
-------- -------- ----                                     --------  
True     True     Object[]                                 System.Array  
```
In this example, the result is an array, despite containing a single item.

### PowerShell 7 behaviour:
In PowerShell 7, `ConvertFrom-Json` returns a `PSCustomObject` when the JSON array contains only a single item, rather than treating it as an array.

**Example in PowerShell 7:**

```powershell
$json = '[{"name": "John"}]'  
$object = $json | ConvertFrom-Json  
$object.GetType()  
```
**Output:**

```powershell
IsPublic IsSerial Name                                     BaseType  
-------- -------- ----                                     --------  
True     True     PSCustomObject                           System.Object  
```
In this case, the result is a `PSCustomObject`, simplifying scenarios where only one item is present.

### Summary:
This change in PowerShell 7 simplifies the handling of single-item JSON arrays, reducing unnecessary array handling and making it easier to work with such objects directly.

## 3. Introduction of `ForEach-Object -Parallel`

### Previous behaviour:
In PowerShell 5.x and PowerShell Core 6.x, the `ForEach-Object` cmdlet processed items sequentially. There was no built-in option to execute tasks in parallel within the pipeline.

**Example in PowerShell 5.x or PowerShell Core 6.x:**

```powershell
1..5 | ForEach-Object {  
    Start-Sleep -Seconds 1  
    "Processed $_"  
}  
```
**Output:**

```powershell
Processed 1  
Processed 2  
Processed 3  
Processed 4  
Processed 5  
```
The commands are executed one by one, resulting in a total sleep time of 5 seconds.

### PowerShell 7 behaviour:
PowerShell 7 introduces the `-Parallel` parameter for the `ForEach-Object` cmdlet, allowing you to process items in parallel, which can significantly speed up tasks.

**Example in PowerShell 7:**

```powershell
1..5 | ForEach-Object -Parallel {  
    Start-Sleep -Seconds 1  
    "Processed $_"  
}  
```
**Output:**

```powershell
Processed 1  
Processed 2  
Processed 3  
Processed 4  
Processed 5  
```
This time, all tasks are processed in parallel, reducing the overall sleep time to approximately 1 second.

### Summary:
The `ForEach-Object -Parallel` parameter in PowerShell 7 offers a powerful way to speed up processing by running tasks concurrently, a feature not available in previous versions.

## 4. Default UTF-8 encoding with BOM

### Previous behaviour:
In PowerShell 5.x and PowerShell Core 6.x, when you created a new file or redirected output to a file, the default encoding was often system-specific, typically ANSI or UTF-16 without a Byte Order Mark (BOM).

### PowerShell 7 behaviour:
PowerShell 7 changes the default encoding to UTF-8 with BOM for new files and output redirection. This ensures better cross-platform compatibility and consistency.

**Example in PowerShell 7:**

```powershell
"Hello, World!" > hello.txt  
```
This creates a `hello.txt` file encoded in UTF-8 with BOM by default.

### Summary:
PowerShell 7's shift to UTF-8 with BOM as the default encoding helps standardize file encoding, especially in cross-platform environments.

## 5. `Out-Null` in Pipeline Optimization

### Previous behaviour:
In PowerShell 5.x and PowerShell Core 6.x, using `Out-Null` in a pipeline simply discarded the output but did not offer any performance benefits.

### PowerShell 7 behaviour:
In PowerShell 7, the pipeline handling for `Out-Null` is optimized for performance. This means that when `Out-Null` is used, PowerShell skips generating the output altogether, leading to faster script execution.

**Example:**

```powershell
1..100000 | ForEach-Object { $_ } | Out-Null  
```
In PowerShell 7, this operation is optimized, resulting in faster execution compared to previous versions.

### Summary:
The optimization of `Out-Null` in PowerShell 7 can lead to performance improvements in scripts where unnecessary output is being discarded.

---

PowerShell 7 introduces several changes that improve functionality and performance, but it's important to be aware of these breaking changes to ensure your scripts run smoothly. By understanding and adapting to these differences, you can take full advantage of what PowerShell 7 has to offer.

---
