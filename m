Return-Path: <SRS0=k4No=JM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33489 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935339AbeFZO3N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Jun 2018 10:29:13 -0400
Received: by mail-wr0-f195.google.com with SMTP id k16-v6so17505113wro.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Jun 2018 07:29:13 -0700 (PDT)
Subject: Re: [PATCH 2/7] kernel-shark-qt: Automatic generation of doxygen
 documentation
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180625150121.14291-1-y.karadz@gmail.com>
 <20180625150121.14291-3-y.karadz@gmail.com>
 <20180625120926.073a8579@gandalf.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <f37a58e2-486b-7d93-9527-bc97ca4db920@gmail.com>
Date: Tue, 26 Jun 2018 17:29:09 +0300
MIME-Version: 1.0
In-Reply-To: <20180625120926.073a8579@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 25.06.2018 19:09, Steven Rostedt wrote:
> On Mon, 25 Jun 2018 18:01:16 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> A possibility for automatic generation of doxygen documentation
>> of the KernelShark code is added to the CMake build system.
>> In order to generate such a documentation use the "_DOXYGEN_DOC"
>> CMake Command-Line option.
>>
>> example:
>>    cd build/
>>    cmake -D_DOXYGEN_DOC=1 ../
>>    make
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   kernel-shark-qt/CMakeLists.txt       |   17 +
>>   kernel-shark-qt/build/cmake_clean.sh |    2 +
>>   kernel-shark-qt/doc/dox_config       | 2291 ++++++++++++++++++++++++++
>>   3 files changed, 2310 insertions(+)
>>   create mode 100644 kernel-shark-qt/doc/dox_config
>>
>> diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.txt
>> index 56fca44..9929937 100644
>> --- a/kernel-shark-qt/CMakeLists.txt
>> +++ b/kernel-shark-qt/CMakeLists.txt
>> @@ -14,6 +14,8 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
>>   
>>   include(${KS_DIR}/build/FindTraceCmd.cmake)
>>   
>> +find_package(Doxygen)
>> +
>>   set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>>   set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>>   
>> @@ -32,4 +34,19 @@ message(STATUS "Linker flags : " ${CMAKE_EXE_LINKER_FLAGS})
>>   
>>   add_subdirectory(${KS_DIR}/src)
>>   
>> +if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
>> +
>> +    message("\n doxygen documentation ...")
>> +    add_custom_target(doc ALL)
>> +    add_custom_command(TARGET doc
>> +                       COMMAND doxygen dox_config > dox_build.log
>> +                       WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/doc)
>> +
>> +    set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
>> +                                          "${KS_DIR}/doc/dox_build.log"
>> +                                          "${KS_DIR}/doc/html"
>> +                                          "${KS_DIR}/doc/latex")
>> +
>> +endif ()
>> +
>>   message("")
>> diff --git a/kernel-shark-qt/build/cmake_clean.sh b/kernel-shark-qt/build/cmake_clean.sh
>> index ee0abbb..57c40a4 100755
>> --- a/kernel-shark-qt/build/cmake_clean.sh
>> +++ b/kernel-shark-qt/build/cmake_clean.sh
>> @@ -6,3 +6,5 @@ rm -rf CMakeFiles/
>>   rm -rf src/
>>   rm -f ../lib/*
>>   rm -f ../src/KsDeff.h
>> +rm -f CMakeDoxyfile.in
>> +rm -f CMakeDoxygenDefaults.cmake
>> diff --git a/kernel-shark-qt/doc/dox_config b/kernel-shark-qt/doc/dox_config
>> new file mode 100644
>> index 0000000..68d9ca0
>> --- /dev/null
>> +++ b/kernel-shark-qt/doc/dox_config
>> @@ -0,0 +1,2291 @@
>> +# Doxyfile 1.8.6
>> +
>> +# This file describes the settings to be used by the documentation system
>> +# doxygen (www.doxygen.org) for a project.
>> +#
>> +# All text after a double hash (##) is considered a comment and is placed in
>> +# front of the TAG it is preceding.
>> +#
>> +# All text after a single hash (#) is considered a comment and will be ignored.
>> +# The format is:
>> +# TAG = value [value, ...]
>> +# For lists, items can also be appended using:
>> +# TAG += value [value, ...]
>> +# Values that contain spaces should be placed between quotes (\" \").
>> +
> 
> All this text and below, was it copied from somewhere? What's the
> license, and we should document where it came from.
> 

A template Config file for Doxygen, like the one added in this patch, 
can be generated automatically (doxygen -g <Config File Name>).

However you are right that, adding to the project this huge file may 
cause confusion. Maybe it will be better if we use a simple file 
containing only the parameters, having non-default values and a link to 
the official Doxigen documentation page.

What do you think?

Thanks!
Yordan

> -- Steve
> 
> 
>> +#---------------------------------------------------------------------------
>> +# Project related configuration options
>> +#---------------------------------------------------------------------------
>> +
>> +# This tag specifies the encoding used for all characters in the config file
>> +# that follow. The default is UTF-8 which is also the encoding used for all text
>> +# before the first occurrence of this tag. Doxygen uses libiconv (or the iconv
>> +# built into libc) for the transcoding. See http://www.gnu.org/software/libiconv
>> +# for the list of possible encodings.
>> +# The default value is: UTF-8.
>> +
>> +DOXYFILE_ENCODING      = UTF-8
>> +
>> +# The PROJECT_NAME tag is a single word (or a sequence of words surrounded by
>> +# double-quotes, unless you are using Doxywizard) that should identify the
>> +# project for which the documentation is generated. This name is used in the
>> +# title of most generated pages and in a few other places.
>> +# The default value is: My Project.
>> +
>> +PROJECT_NAME           = "kernel-shark-qt"
> 
> [..]
> 
