Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9272FA373D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 00:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiJ1A1r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbiJ1A1r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 20:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B1BA232A
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Oct 2022 17:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6B116257C
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 00:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499E8C433D7;
        Fri, 28 Oct 2022 00:27:45 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ooDE9-00DoZ2-0B;
        Thu, 27 Oct 2022 20:28:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs: Add man pages for tracefs_cpu_pipe()
Date:   Thu, 27 Oct 2022 20:27:58 -0400
Message-Id: <20221028002758.3285764-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221028002758.3285764-1-rostedt@goodmis.org>
References: <20221028002758.3285764-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the man pages to describe the tracefs_cpu_pipe() function.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu.txt | 12 +++++++++++-
 Documentation/libtracefs.txt     |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-cpu.txt b/Documentation/libtracefs-cpu.txt
index 8975e6ec5a0b..d6215d9912c0 100644
--- a/Documentation/libtracefs-cpu.txt
+++ b/Documentation/libtracefs-cpu.txt
@@ -4,7 +4,8 @@ libtracefs(3)
 NAME
 ----
 tracefs_cpu_read_size, tracefs_cpu_read, tracefs_cpu_buffered_read, tracefs_cpu_write,
-tracefs_cpu_stop, tracefs_cpu_flush, tracefs_cpu_flush_write - Reading trace_pipe_raw data
+tracefs_cpu_stop, tracefs_cpu_flush, tracefs_cpu_flush_write, tracefs_cpu_pipe
+- Reading trace_pipe_raw data
 
 SYNOPSIS
 --------
@@ -19,6 +20,7 @@ int *tracefs_cpu_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonb
 int *tracefs_cpu_stop*(struct tracefs_cpu pass:[*]_tcpu_);
 int *tracefs_cpu_flush*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_);
 int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
+int *tracefs_cpu_pipe*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
 --
 
 DESCRIPTION
@@ -66,6 +68,14 @@ trace_pipe_raw into non-blocking mode.
 The *tracefs_cpu_flush_write()* same as *trace_cpu_flush()* except it takes a file
 descriptor _wfd_ to flush the data into.
 
+The *tracefs_cpu_pipe()* is similar to *tracefs_cpu_write()* but the _wfd_ file descriptor
+must be a pipe. This call is an optimization of *tracefs_cpu_write()* that uses two calls
+to *splice*(2) in order to connect the trace_pipe_raw file descriptor with the write file
+descriptor. *splice*(2) requires that one of the passed in file descriptors is a pipe.
+If the application wants to pass the data to an existing pipe, there's no reason for
+there to be two *splice*(2) system calls and *tracefs_cpu_pipe()* can simply use a single
+call to _wfd_.
+
 RETURN VALUE
 ------------
 The *tracefs_cpu_open()* returns a struct tracefs_cpu descriptor that can be
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 50af23e33026..0081210f8951 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -280,6 +280,7 @@ Recording of trace_pipe_raw files:
 	int *tracefs_cpu_stop*(struct tracefs_cpu pass:[*]_tcpu_);
 	int *tracefs_cpu_flush*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_);
 	int *tracefs_cpu_flush_write*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_);
+	int *tracefs_cpu_pipe*(struct tracefs_cpu pass:[*]_tcpu_, int _wfd_, bool _nonblock_);
 
 --
 
-- 
2.35.1

