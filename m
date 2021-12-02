Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB02C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346969AbhLBMei (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbhLBMeh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:34:37 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D85BC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:31:14 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x15so115207394edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M5yBpPx3JVqQrDPoDufs5gbmJO8fVroIyK/1pvMnHUg=;
        b=TN95nYQfWZdaxVNh919dkOJV6th+2YkYzF4ZR+IkOM4iv4i7ij88vLIlSvwgSOVjln
         Jq4D2MDnPajhqLjA1D8+SQCgOlc3IYwTgBh6jvbapgPoppu6hZSq+zG4enykI+PIlZ9f
         hfd2wa+8JdIm1H7F4tEYl1PHRk2jmvcVOFIs5bdUYtFDaxUDA07MyRGT3hJqk3x4AhHX
         Jh+jN4l/YkX6JapQeLhajwla+8IAPr6qa0NUPQIF7xAeC6AhjhGFHWwS2uu02mgM4vpD
         u2RGn3AOLLBv81QcVOyrMiPaqqlCiHwk/s1xsHwSZUnJErwMg8ljl1QIbLWBYCYZz0aH
         B4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M5yBpPx3JVqQrDPoDufs5gbmJO8fVroIyK/1pvMnHUg=;
        b=nnLQpPZoQq2NHwJY8de4XVU8CN4Df0MjwObBcx16mbLoIIjbYRVRbIAHxQbX+EOPVB
         J7+iDMBOEym7n9E5VPSfFwjXkfPujEbeswpywvcenL2X3zSMV2qH/lUG6JC8mEheduVh
         JFDoM7wgkdCmZ5ZJd3mRwKRwP/BXDKqI4Ar+MDI9X+VADRau39Ib6pXjDdKJ+5qcP/r0
         +ih+l+tYRwXxoWf0nT54I5H2iZJHaYlmjjd9lhv/5jzRUs3owTBOUrsHOGMWWbH6UhmS
         +H8IfS788h9UYLXk4NAd0JKGZANdE1qpSkc4oq2JGq3rS/EJkoCCU1QxlI3g+P9yao8y
         CWhA==
X-Gm-Message-State: AOAM532tpo4gSOrmsjiqFHDmTXwJBaBjV+ZyX5gGSnufvmNhWQkN7sp3
        jP5OJzJ8tRwCFeIJV3NgJtiQu1Xn286EYA==
X-Google-Smtp-Source: ABdhPJzeWC6/tOHNh4hdUPI4qre7EaqwjocJZ+oNEfqTuw4khM1AIrDKHLWRfuvgZSRAcQD5ZonF3A==
X-Received: by 2002:a05:6402:4312:: with SMTP id m18mr16978959edc.273.1638448272593;
        Thu, 02 Dec 2021 04:31:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b14sm2120394edw.6.2021.12.02.04.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:31:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 4/4] trace-cmd: Document trace file version 7
Date:   Thu,  2 Dec 2021 14:31:06 +0200
Message-Id: <20211202123106.44245-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202123106.44245-1-tz.stoyanov@gmail.com>
References: <20211202123106.44245-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file versions 6 and 7 have a lot of differences. Added new man
page describing the version 7 and renamed the existing trace-cmd.dat
page for version 6 only.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   9 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 442 ++++++++++++++++++
 2 files changed, 446 insertions(+), 5 deletions(-)
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

diff --git a/Documentation/trace-cmd/trace-cmd.dat.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v6.5.txt
similarity index 98%
rename from Documentation/trace-cmd/trace-cmd.dat.5.txt
rename to Documentation/trace-cmd/trace-cmd.dat.v6.5.txt
index 8d285353..8437b363 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.v6.5.txt
@@ -1,9 +1,9 @@
-TRACE-CMD.DAT(5)
-================
+TRACE-CMD.DAT.v6(5)
+===================
 
 NAME
 ----
-trace-cmd.dat - trace-cmd file format
+trace-cmd.dat.v6 - trace-cmd version 6 file format
 
 SYNOPSIS
 --------
@@ -30,7 +30,7 @@ INITIAL FORMAT
      "tracing"
 
   The next set of characters contain a null '\0' terminated string
-  that contains the version of the file (for example):
+  that contains the version of the file:
 
      "6\0"
 
@@ -264,4 +264,3 @@ COPYING
 -------
 Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
 the terms of the GNU Public License (GPL).
-
diff --git a/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
new file mode 100644
index 00000000..36dae643
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd.dat.v7.5.txt
@@ -0,0 +1,442 @@
+TRACE-CMD.DAT.v7(5)
+===================
+
+NAME
+----
+trace-cmd.dat.v7 - trace-cmd version 7 file format
+
+SYNOPSIS
+--------
+*trace-cmd.dat* ignore
+
+DESCRIPTION
+-----------
+The trace-cmd(1) utility produces a "trace.dat" file. The file may also
+be named anything depending if the user specifies a different output name,
+but it must have a certain binary format. The file is used
+by trace-cmd to save kernel traces into it and be able to extract
+the trace from it at a later point (see *trace-cmd-report(1)*).
+
+
+INITIAL FORMAT
+--------------
+
+  The first three bytes contain the magic value:
+
+     0x17 0x08  0x44
+
+  The next 7 bytes contain the characters:
+
+     "tracing"
+
+  The next set of characters contain a null '\0' terminated string
+  that contains the version of the file:
+
+     "7\0"
+
+  The next 1 byte contains the flags for the file endianess:
+
+     0 = little endian
+     1 = big endian
+
+  The next byte contains the number of bytes per "long" value:
+
+     4 - 32-bit long values
+     8 - 64-bit long values
+
+  Note: This is the long size of the target's userspace. Not the
+  kernel space size.
+
+  [ Now all numbers are written in file defined endianess. ]
+
+  The next 4 bytes are a 32-bit word that defines what the traced
+  host machine page size was.
+
+  The compression algorithm header is written next:
+     "name\0version\0"
+  where "name" and "version" are strings, name and version of the
+  compression algorithm used to compress the trace file. If the name
+  is "none", the data in the file is not compressed.
+
+ The next 8 bytes are 64-bit integer, the offset within the file where
+ the first OPTIONS section is located.
+
+ The rest of the file consists of different sections. The only mandatory
+ is the first OPTIONS section, all others are optional. The location and
+ the order of the sections is not strict. Each section starts with a header:
+
+FORMAT OF THE SECTION HEADER
+----------------------------
+  <2 bytes> unsigned short integer, ID of the section.
+  <string> a null terminated ASCII string, description of the section.
+  <2 bytes> unsigned short integer, section flags:
+    1 = the section is compressed.
+  <4 bytes> unsigned integer, size of the section in the file.
+
+  If the section is compressed, the above is the compressed size.
+  The section must be uncompressed on reading. The described format of
+  the sections refers to the uncompressed data.
+
+COMPRESSION FORMAT OF THE FILE SECTIONS
+---------------------------------------
+
+  Some of the sections in the file may be compressed with the compression algorithm,
+  specified in the compression algorithm header. Compressed sections have a compression
+  header, written after the section header and right before the compressed data:
+    <4 bytes> unsigned int, size of compressed data in this section.
+    <4 bytes> unsigned int, size of uncompressed data.
+    <data> binary compressed data, with the specified size.
+
+COMPRESSION FORMAT OF THE TRACE DATA
+------------------------------------
+
+  There are two special sections, BUFFER FLYRECORD and BUFFER LATENCY, containing
+  trace data. These sections may be compressed with the compression algorithm, specified
+  in the compression header. Usually the size of these sections is huge, that's why its
+  compression format is different from the other sections. The trace data is compressed
+  in chunks The size of one chunk is specified in the file creation time. The format
+  of compressed trace data is:
+     <4 bytes> unsigned int, count of chunks.
+     Follows the compressed chunks of given count. For each chunk:
+        <4 bytes> unsigned int, size of compressed data in this chunk.
+        <4 bytes> unsigned int, size of uncompressed data, aligned with the trace page size.
+        <data> binary compressed data, with the specified size.
+  These chunks must be uncompressed on reading. The described format of
+  trace data refers to the uncompressed data.
+
+OPTIONS SECTION
+---------------
+
+  Section ID: 0
+
+  This is the the only mandatory section in the file. There can be multiple
+  options sections, the first one is located at the offset specified right
+  after the compression algorithm header. The section consists of multiple
+  trace options, each option has the following format:
+    <2 bytes> unsigned short integer, ID of the option.
+    <4 bytes> unsigned integer, size of the option's data.
+    <binary data> bytes of the size specified above, data of the option.
+
+
+  Options, supported by the trace file version 7:
+
+  DONE: id 0, size 8
+    This option indicates the end of the options section, it is written
+    always as last option. The DONE option data is:
+       <8 bytes> long long unsigned integer, offset in the trace file where
+       the next options section is located. If this offset is 0, then there
+       are no more options sections.
+
+  DATE: id 1, size vary
+    The DATE option data is a null terminated ASCII string, which represents
+    the time difference between trace events timestamps and the Generic Time
+    of Day of the system.
+
+  CPUSTAT: id 2, size vary
+    The CPUSTAT option data is a null terminated ASCII string, the content of the
+    "per_cpu/cpu<id>/stats" file from the trace directory. There is a CPUSTAT option
+    for each CPU.
+
+  BUFFER: id 3, size vary
+    The BUFFER option describes the flyrecord trace data saved in the file, collected
+    from one trace instance. There is BUFFER option for each trace instance. The format
+    of the BUFFER data is:
+      <8 bytes> long long unsigned integer, offset in the trace file where the
+      BUFFER FLYRECORD section is located, containing flyrecord trace data.
+      <string> a null terminated ASCII string, name of the trace instance. Empty string ""
+      is saved as name of the top instance.
+      <string> a null terminated ASCII string, trace clock used for events timestamps in
+      this trace instance.
+      <4 bytes> unsigned integer, count of the CPUs with trace data.
+      For each CPU of the above count:
+         <4 bytes> unsigned integer, ID of the CPU.
+         <8 bytes> long long unsigned integer, offset in the trace file where the trace data
+         for this CPU is located.
+         <8 bytes> long long unsigned integer, size of the trace data for this CPU.
+
+  TRACECLOCK: id 4, size vary
+    The TRACECLOCK option data is a null terminated ASCII string, the content of the
+    "trace_clock" file from the trace directory.
+
+  UNAME: id 5, size vary
+    The UNAME option data is a null terminated ASCII string, identifying the system where
+    the trace data is collected. The string is retrieved by the uname() system call.
+
+  HOOK: id 6, size vary
+    The HOOK option data is a null terminated ASCII string, describing event hooks: custom
+    event matching to connect any two events together.
+
+  OFFSET: id 7, size vary
+    The OFFSET option data is a null terminated ASCII string, representing a fixed time that
+    is added to each event timestamp on reading.
+
+  CPUCOUNT: id 8, size 4
+    The CPUCOUNT option data is:
+      <4 bytes> unsigned integer, number of CPUs in the system.
+
+  VERSION: id 9, size vary
+    The VERSION option data is a null terminated ASCII string, representing the version of
+    the trace-cmd application, used to collect these trace logs.
+
+  PROCMAPS: id 10, size vary
+    The PROCMAPS option data is a null terminated ASCII string, representing the memory map
+    of each traced filtered process. The format of the string is, for each filtered process:
+      <procss ID> <libraries count> <process command> \n
+        <memory start address> <memory end address> <full path of the mapped library file> \n
+        ...
+         separate line for each library, used by this process
+        ...
+      ...
+
+  TRACEID: id 11, size 8
+    The TRACEID option data is a unique identifier of this tracing session:
+      <8 bytes> long long unsigned integer, trace session identifier.
+
+  TIME_SHIFT: id 12, size vary
+    The TIME_SHIFT option stores time synchronization information, collected during host and guest
+    tracing session. Usually it is saved in the guest trace file. This information is used to
+    synchronize guest with host events timestamps, when displaying all files from this tracing
+    session. The format of the TIME_SHIFT option data is:
+      <8 bytes> long long unsigned integer, trace identifier of the peer (usually the host).
+      <4 bytes> unsigned integer, flags specific to the time synchronization protocol, used in this
+      trace session.
+      <4 bytes> unsigned integer, number of traced CPUs. For each CPU, timestamps corrections
+      are recorded:
+         <4 bytes> unsigned integer, count of the recorded timestamps corrections for this CPU.
+         <array of unsigned long long integers of the above count>, times when the corrections are calculated
+         <array of unsigned long long integers of the above count>, corrections offsets
+         <array of unsigned long long integers of the above count>, corrections scaling ratio
+
+  GUEST: id 13, size vary
+    The GUEST option stores information about traced guests in this tracing session. Usually it is
+    saved in the host trace file. There is a separate GUEST option for each traced guest.
+    The information is used when displaying all files from this tracing session. The format of
+    the GUEST option data is:
+       <string> a null terminated ASCII string, name of the guest.
+       <8 bytes> long long unsigned integer, trace identifier of the guest for this session.
+       <4 bytes> unsigned integer, number of guest's CPUs. For each CPU:
+          <4 bytes> unsigned integer, ID of the CPU.
+          <4 bytes> unsigned integer, PID of the host task, emulating this guest CPU.
+
+  TSC2NSEC: id 14, size 16
+    The TSC2NSEC option stores information, used to convert TSC events timestamps to nanoseconds.
+    The format of the TSC2NSEC option data is:
+       <4 bytes> unsigned integer, time multiplier.
+       <4 bytes> unsigned integer, time shift.
+       <8 bytes> unsigned long long integer, time offset.
+
+  BUFFER_LAT: id 15, size
+    The BUFFER_LAT option describes the latency trace data saved in the file. The format
+    of the BUFFER_LAT data is:
+      <8 bytes> long long unsigned integer, offset in the trace file where the
+      BUFFER LATENCY section is located, containing latency trace data.
+      <string> a null terminated ASCII string, name of the trace instance. Empty string ""
+      is saved as name of the top instance.
+      <string> a null terminated ASCII string, trace clock used for events timestamps in
+      this trace instance.
+
+  HEADER_INFO: id 15, size 8
+    The HEADER_INFO option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the HEADER INFO
+      section is located
+
+  FTRACE_EVENTS: id 16, size 8
+    The FTRACE_EVENTS option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the
+      FTRACE EVENT FORMATS section is located.
+
+  EVENT_FORMATS: id 17, size 8
+    The EVENT_FORMATS option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the EVENT FORMATS
+      section is located.
+
+  KALLSYMS: id 18, size 8
+    The KALLSYMS option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the KALLSYMS
+      section is located.
+
+  PRINTK: id 19, size 8
+    The PRINTK option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the TRACE_PRINTK
+      section is located.
+
+  CMDLINES: id 20, size 8
+    The CMDLINES option data is:
+      <8 bytes> long long unsigned integer, offset into the trace file where the
+      SAVED COMMAND LINES section is located.
+
+HEADER INFO SECTION
+-------------------
+
+  Section ID: 16
+
+  The first 12 bytes of the section, after the section header, contain the string:
+
+    "header_page\0"
+
+  The next 8 bytes are a 64-bit word containing the size of the
+  page header information stored next.
+
+  The next set of data is of the size read from the previous 8 bytes,
+  and contains the data retrieved from debugfs/tracing/events/header_page.
+
+  Note: The size of the second field \fBcommit\fR contains the target
+  kernel long size. For example:
+
+  field: local_t commit;	offset:8;	\fBsize:8;\fR	signed:1;
+
+  shows the kernel has a 64-bit long.
+
+  The next 13 bytes contain the string:
+
+  "header_event\0"
+
+  The next 8 bytes are a 64-bit word containing the size of the
+  event header information stored next.
+
+  The next set of data is of the size read from the previous 8 bytes
+  and contains the data retrieved from debugfs/tracing/events/header_event.
+
+  This data allows the trace-cmd tool to know if the ring buffer format
+  of the kernel made any changes.
+
+FTRACE EVENT FORMATS SECTION
+----------------------------
+
+  Section ID: 17
+
+  Directly after the section header comes the information about
+  the Ftrace specific events. These are the events used by the Ftrace plugins
+  and are not enabled by the event tracing.
+
+  The next 4 bytes contain a 32-bit word of the number of Ftrace event
+  format files that are stored in the file.
+
+  For the number of times defined by the previous 4 bytes is the
+  following:
+
+  8 bytes for the size of the Ftrace event format file.
+
+  The Ftrace event format file copied from the target machine:
+  debugfs/tracing/events/ftrace/<event>/format
+
+EVENT FORMATS SECTION
+---------------------
+
+  Section ID: 18
+
+  Directly after the section header comes the information about
+  the event layout.
+
+  The next 4 bytes are a 32-bit word containing the number of
+  event systems that are stored in the file. These are the
+  directories in debugfs/tracing/events excluding the \fBftrace\fR
+  directory.
+
+  For the number of times defined by the previous 4 bytes is the
+  following:
+
+  A null-terminated string containing the system name.
+
+  4 bytes containing a 32-bit word containing the number
+  of events within the system.
+
+  For the number of times defined in the previous 4 bytes is the
+  following:
+
+  8 bytes for the size of the event format file.
+
+  The event format file copied from the target machine:
+  debugfs/tracing/events/<system>/<event>/format
+
+KALLSYMS SECTION
+----------------
+
+  Section ID: 19
+
+  Directly after the section header comes the information of the mapping
+  of function addresses to the function names.
+
+  The next 4 bytes are a 32-bit word containing the size of the
+  data holding the function mappings.
+
+  The next set of data is of the size defined by the previous 4 bytes
+  and contains the information from the target machine's file:
+  /proc/kallsyms
+
+
+TRACE_PRINTK SECTION
+--------------------
+
+  Section ID: 20
+
+  If a developer used trace_printk() within the kernel, it may
+  store the format string outside the ring buffer.
+  This information can be found in:
+  debugfs/tracing/printk_formats
+
+  The next 4 bytes are a 32-bit word containing the size of the
+  data holding the printk formats.
+
+  The next set of data is of the size defined by the previous 4 bytes
+  and contains the information from debugfs/tracing/printk_formats.
+
+
+SAVED COMMAND LINES SECTION
+---------------------------
+
+  Section ID: 21
+
+  Directly after the section header comes the information mapping
+  a PID to a process name.
+
+  The next 8 bytes contain a 64-bit word that holds the size of the
+  data mapping the PID to a process name.
+
+  The next set of data is of the size defined by the previous 8 bytes
+  and contains the information from debugfs/tracing/saved_cmdlines.
+
+
+BUFFER FLYRECORD SECTION
+------------------------
+
+  This section contains flyrecord tracing data, collected in one trace instance.
+  The data is saved per CPU. Each BUFFER FLYRECORD section has a corresponding BUFFER
+  option, containing information about saved CPU's trace data. Padding is placed between
+  the section header and the CPU data, placing the CPU data at a page aligned (target page)
+  position in the file.
+
+  This data is copied directly from the Ftrace ring buffer and is of the
+  same format as the ring buffer specified by the event header files
+  loaded in the header format file.
+
+  The trace-cmd tool will try to \fBmmap(2)\fR the data page by page with the
+  target's page size if possible. If it fails to mmap, it will just read the
+  data instead.
+
+BUFFER LATENCY SECTION
+------------------------
+
+  This section contains latency tracing data, ASCII text taken from the
+  target's debugfs/tracing/trace file.
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
+trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
+trace-cmd-split(1), trace-cmd-list(1), trace-cmd-listen(1),
+trace-cmd.dat(5)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
-- 
2.33.1

