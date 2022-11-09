Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A805BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiKIXvr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiKIXvo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D722714088
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94499B82052
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3776DC43143;
        Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1osurg-009C6W-17;
        Wed, 09 Nov 2022 18:52:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 6/8] libtracefs: Move tracefs_cpu_open/close into its own man page
Date:   Wed,  9 Nov 2022 18:52:12 -0500
Message-Id: <20221109235214.2191393-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221109235214.2191393-1-rostedt@goodmis.org>
References: <20221109235214.2191393-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Man pages only allow at most 9 functions to be described in a single man
page. The libtracefs-cpu man page is already at that limit. In order to
add more tracefs_cpu_* functions, this needs to be split up.

Move the tracefs_cpu_open() and tracefs_cpu_close() functions out into its
own man page, to allow more to be added to both.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-open.txt | 78 +++++++++++++++++++++++++++
 Documentation/libtracefs-cpu.txt      | 17 ++----
 2 files changed, 82 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/libtracefs-cpu-open.txt

diff --git a/Documentation/libtracefs-cpu-open.txt b/Documentation/libtracefs-cpu-open.txt
new file mode 100644
index 000000000000..58dde508290d
--- /dev/null
+++ b/Documentation/libtracefs-cpu-open.txt
@@ -0,0 +1,78 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_cpu_open, tracefs_cpu_close - Opening trace_pipe_raw data for reading
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
+				     int _cpu_, bool _nonblock_);
+void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to open the raw data from the trace_pipe_raw
+files in the tracefs file system in oder to read them with the *tracefs_cpu_read*(3)
+functions.
+
+The *tracefs_cpu_open()* creates a descriptor that can read the tracefs
+trace_pipe_raw file for a given _cpu_ in a given _instance_. If _instance_ is
+NULL than the toplevel trace_pipe_raw file is used.
+
+The *tracefs_cpu_close()* closes all the file descriptors associated to the trace_pipe_raw
+opened by *tracefs_cpu_open()*.
+
+RETURN VALUE
+------------
+The *tracefs_cpu_open()* returns a struct tracefs_cpu descriptor that can be
+used by the other functions or NULL on error.
+
+EXAMPLE
+-------
+See *tracefs_cpu_read*(3) for an example.
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-cpu.txt b/Documentation/libtracefs-cpu.txt
index d664ebb3082f..8975e6ec5a0b 100644
--- a/Documentation/libtracefs-cpu.txt
+++ b/Documentation/libtracefs-cpu.txt
@@ -3,9 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_cpu_open, tracefs_cpu_close, tracefs_cpu_read_size, tracefs_cpu_read,
-tracefs_cpu_buffered_read, tracefs_cpu_write, tracefs_cpu_stop, tracefs_cpu_flush,
-tracefs_cpu_flush_write - Reading trace_pipe_raw data
+tracefs_cpu_read_size, tracefs_cpu_read, tracefs_cpu_buffered_read, tracefs_cpu_write,
+tracefs_cpu_stop, tracefs_cpu_flush, tracefs_cpu_flush_write - Reading trace_pipe_raw data
 
 SYNOPSIS
 --------
@@ -13,9 +12,6 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
-				     int _cpu_, bool _nonblock_);
-void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
 int *tracefs_cpu_read_size*(struct tracefs_cpu pass:[*]_tcpu_);
 int *tracefs_cpu_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
 int *tracefs_cpu_buffered_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
@@ -30,13 +26,6 @@ DESCRIPTION
 This set of APIs can be used to read the raw data from the trace_pipe_raw
 files in the tracefs file system.
 
-The *tracefs_cpu_open()* creates a descriptor that can read the tracefs
-trace_pipe_raw file for a given _cpu_ in a given _instance_. If _instance_ is
-NULL than the toplevel trace_pipe_raw file is used.
-
-The *tracefs_cpu_close()* closes all the file descriptors associated to the trace_pipe_raw
-opened by *tracefs_cpu_open()*.
-
 The *tracefs_cpu_read_size()* returns the subbuffer size of the trace_pipe_raw. This
 returns the minimum size of the buffer that is passed to the below functions.
 
@@ -211,6 +200,8 @@ FILES
 
 SEE ALSO
 --------
+*tracefs_cpu_open*(3)
+*tracefs_cpu_close*(3)
 *libtracefs*(3),
 *libtraceevent*(3),
 *trace-cmd*(1)
-- 
2.35.1

