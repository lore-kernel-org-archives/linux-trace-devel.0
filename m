Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A5BC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 532F4613D3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhFNHyT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:19 -0400
Received: from mail-ej1-f42.google.com ([209.85.218.42]:37520 "EHLO
        mail-ej1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbhFNHyR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:17 -0400
Received: by mail-ej1-f42.google.com with SMTP id ce15so15025882ejb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbCjSkYiTayTZj1R7pN7UweSLyf1bgnBl/z0BvUhG2o=;
        b=fV9xtVDsZ4wObptp2M7zGdLeGh4gVaBVeAprPEg1eOPfHpeI6kXhcIAAxdVxy2vcl6
         dU+a6BEzesIvqJarjzPZLmyAQDXYEaoIS1bdMPlSQOYsM8Y9zhccc7BmlPLYKqukfKUW
         98WXX6M5hgs6VMznelbKOUUr3xmbMSG/9b6e0wD/NbzTwOEtV4ukvxO+tX899MNS2KJP
         nhrDnGAByty8QpK5mJXL40Zlqrgxv9kgFdPSj1gsDIJTp3jJlK4oNEbtey1+fECBX3Dw
         V4GB1fGdkHC9xTOxoFcrp8Or9t743BFUj6nNyvmRds++WK5nSf1IPuG+bgT0sqRraDiS
         L6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbCjSkYiTayTZj1R7pN7UweSLyf1bgnBl/z0BvUhG2o=;
        b=KmO3SrT+ZajN0GHsqJwI0qXmx8F+djB+nbtrDsWANQKTCRDsJ5UV6M27dGzjmpDH1J
         JVfVpyGSmI1cXprKEnWRuJxkTyRW68a3ndN9M2DAD/4uhATq4evrKWzjx13L0wnLYiod
         oCsQYBsrJ+A0Zg2rToLSIjYmkYndEvLtb4SGIE6E2pgaTl3o70Yk/jopOvuL1Lims7TV
         9T1z7zq3ucztZsU8Z4f9MCrwsGnvIsIonmd7+3OdqzIJpi1vnDAV6mwpSpa872O4M2Hn
         NcswJrmYPmdP1fAC/Yt4PNu0pCq6JFNmkZUqoFewBBIBi9arRIe+VPlBj+UJNXwHgnA3
         WNjQ==
X-Gm-Message-State: AOAM530lRuGNq97yw96dEuZtwopQUffZMSaeiefilDOZQW63brhA51Om
        oF9S9xMbmW0Gbxv3cTR7xGI=
X-Google-Smtp-Source: ABdhPJyBBOMO3/EDeFe+T27UJD/XtF85O8B6VsoK4yPzUDX9tWnbfbqOXYWXRJrB1qx/ZNwAQuI8oQ==
X-Received: by 2002:a17:906:3888:: with SMTP id q8mr13970665ejd.15.1623657074508;
        Mon, 14 Jun 2021 00:51:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 45/45] trace-cmd: Update trace.dat man page
Date:   Mon, 14 Jun 2021 10:50:29 +0300
Message-Id: <20210614075029.598048-46-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the trace.dat man page with the changes related to file
version 7 and compression.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd.dat.5.txt | 56 ++++++++++++++++++---
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd.dat.5.txt b/Documentation/trace-cmd/trace-cmd.dat.5.txt
index 8d285353..e80d460e 100644
--- a/Documentation/trace-cmd/trace-cmd.dat.5.txt
+++ b/Documentation/trace-cmd/trace-cmd.dat.5.txt
@@ -52,6 +52,23 @@ INITIAL FORMAT
   The next 4 bytes are a 32-bit word that defines what the traced
   host machine page size was.
 
+  If the file version is 7 or greater, the compression header is
+  written next:
+     "name version\0"
+  where "name" and "version" are strings, name and version of the
+  compression algorithm used to compress the trace file.
+
+COMPRESSION FORMAT OF THE HEADER SECTIONS
+-----------------------------------------
+  If the file version is 7 or greater, some header sections are compressed
+  with the compression algorithm, specified in the compression header.
+  The format of these compressed sections is:
+     <4 bytes> unsigned int, size of compressed data in the next block.
+     <4 bytes> unsigned int, size of uncompressed data.
+     <data> binary compressed data, with the specified size.
+  These sections must be uncompressed on reading. The described format of
+  the sections refers to the uncomperssed data.
+
 HEADER INFO FORMAT
 ------------------
 
@@ -93,7 +110,8 @@ FTRACE EVENT FORMATS
 
   Directly after the header information comes the information about
   the Ftrace specific events. These are the events used by the Ftrace plugins
-  and are not enabled by the event tracing.
+  and are not enabled by the event tracing. If the file version is 7 or
+  greater, this section is compressed.
 
   The next 4 bytes contain a 32-bit word of the number of Ftrace event
   format files that are stored in the file.
@@ -110,7 +128,8 @@ EVENT FORMATS
 -------------
 
   Directly after the Ftrace formats comes the information about
-  the event layout.
+  the event layout. If the file version is 7 or greater, this section
+  is compressed.
 
   The next 4 bytes are a 32-bit word containing the number of
   event systems that are stored in the file. These are the
@@ -137,7 +156,8 @@ KALLSYMS INFORMATION
 --------------------
 
   Directly after the event formats comes the information of the mapping
-  of function addresses to the function names.
+  of function addresses to the function names. If the file version is 7
+  or greater, this section is compressed.
 
   The next 4 bytes are a 32-bit word containing the size of the
   data holding the function mappings.
@@ -154,6 +174,7 @@ TRACE_PRINTK INFORMATION
   store the format string outside the ring buffer.
   This information can be found in:
   debugfs/tracing/printk_formats
+  If the file version is 7 or greater, this section is compressed.
 
   The next 4 bytes are a 32-bit word containing the size of the
   data holding the printk formats.
@@ -166,7 +187,8 @@ PROCESS INFORMATION
 -------------------
 
   Directly after the trace_printk formats comes the information mapping
-  a PID to a process name.
+  a PID to a process name. If the file version is 7 or greater, this
+  section is compressed.
 
   The next 8 bytes contain a 64-bit word that holds the size of the
   data mapping the PID to a process name.
@@ -193,10 +215,11 @@ REST OF TRACE-CMD HEADER
 
     "flyrecord\0"
 
-  If it is "options  \0" then:
+  If it is "options  \0" then follows a section with trace options.
+  If the file version is 7 or greater, this section is compressed.
 
   The next 2 bytes are a 16-bit word defining the current option.
-  If the the value is zero then there are no more options.
+  If the value is zero then there are no more options.
 
   Otherwise, the next 4 bytes contain a 32-bit word containing the
   option size. If the reader does not know how to handle the option
@@ -206,6 +229,25 @@ REST OF TRACE-CMD HEADER
   The next option will be directly after the previous option, and
   the options ends with a zero in the option type field.
 
+COMPRESSION FORMAT OF THE TRACE DATA
+------------------------------------
+
+  If the file version is 7 or greater, the tarce data is compressed
+  with the compression algorithm, specified in the compression header.
+  The data is compressed in chunks. The size of one compression chunk
+  is defined when the file is written. The format of compressed trace
+  data is:
+     <4 bytes> unsigned int, count of chunks.
+     Follows the compressed chunks of givent count. For each chunk:
+        <4 bytes> unsigned int, size of compressed data in this chunk.
+        <4 bytes> unsigned int, size of uncompressed data.
+        <data> binary compressed data, with the specified size.
+  These chunks must be uncompressed on reading. The described format of
+  trace data refers to the uncomperssed data.
+
+TRACE DATA
+----------
+
   The next 10 bytes after the options are one of the following:
 
   "latency  \0"
@@ -217,6 +259,7 @@ REST OF TRACE-CMD HEADER
   If the value is "latency  \0", then the rest of the file is
   simply ASCII text that was taken from the target's:
   debugfs/tracing/trace
+  If the file version is 7 or greater, the latency data is compressed.
 
   If the value is "flyrecord\0", the following is present:
 
@@ -232,6 +275,7 @@ REST OF TRACE-CMD HEADER
 CPU DATA
 --------
 
+  If the file version is 7 or greater, the CPU data is compressed.
   The CPU data is located in the part of the file that is specified
   in the end of the header. Padding is placed between the header and
   the CPU data, placing the CPU data at a page aligned (target page) position
-- 
2.31.1

