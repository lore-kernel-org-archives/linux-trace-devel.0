Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CD4FA3743
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Oct 2022 00:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiJ1A1u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 20:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiJ1A1t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 20:27:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE693A232A
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Oct 2022 17:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A01C9B82840
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Oct 2022 00:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF64C43470;
        Fri, 28 Oct 2022 00:27:45 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ooDE9-00DoYt-05;
        Thu, 27 Oct 2022 20:28:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Add man pages for tracefs_cpu_alloc_fd() and tracefs_cpu_free_fd()
Date:   Thu, 27 Oct 2022 20:27:57 -0400
Message-Id: <20221028002758.3285764-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221028002758.3285764-1-rostedt@goodmis.org>
References: <20221028002758.3285764-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the man pages to describe the tracefs_cpu_alloc_fd() and
tracefs_cpu_free_fd().

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-cpu-open.txt | 24 +++++++++++++++++++++++-
 Documentation/libtracefs.txt          |  2 ++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-cpu-open.txt b/Documentation/libtracefs-cpu-open.txt
index 58dde508290d..c5a900a06e8e 100644
--- a/Documentation/libtracefs-cpu-open.txt
+++ b/Documentation/libtracefs-cpu-open.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_cpu_open, tracefs_cpu_close - Opening trace_pipe_raw data for reading
+tracefs_cpu_open, tracefs_cpu_close, tracefs_cpu_alloc_fd, tracefs_cpu_free_fd - Opening trace_pipe_raw data for reading
 
 SYNOPSIS
 --------
@@ -14,6 +14,9 @@ SYNOPSIS
 struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
 				     int _cpu_, bool _nonblock_);
 void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
+
+struct tracefs_cpu pass:[*]*tracefs_cpu_alloc_fd*(int _fd_, int _subbuf_size_, bool _nonblock_);
+void *tracefs_cpu_free_fd*(struct tracefs_cpu pass:[*]_tcpu_);
 --
 
 DESCRIPTION
@@ -29,11 +32,30 @@ NULL than the toplevel trace_pipe_raw file is used.
 The *tracefs_cpu_close()* closes all the file descriptors associated to the trace_pipe_raw
 opened by *tracefs_cpu_open()*.
 
+The *tracefs_cpu_alloc_fd()* will create a tracefs_cpu descriptor from an existing
+file descriptor _fd_. This is useful to use when connecting to a socket or pipe where
+the other end is feeding raw tracing data in the same format as the trace_pipe_raw
+file would (like in guest to host tracing). The caller is responsible for determining
+the _subbuf_size_ that will be used to break up the sub-buffers being read by the
+file descriptor. The _nonblock_ is treated the same as the same parameter in
+*tracefs_cpu_open()*.
+
+The *tracefs_cpu_free_fd()* is used to free the descriptor returned by *tracefs_cpu_alloc_fd()*.
+It does all the clean up that *tracefs_cpu_close()* performs, and that could also be
+used to free up the descriptor created by *tracefs_cpu_alloc_fd()* but will also close
+the file descriptor passed in. Note that *tracefs_cpu_free_fd()* should not be used
+on the descriptor returned by *tracefs_cpu_open()* as it will not close the file descriptor
+created by it.
+
 RETURN VALUE
 ------------
 The *tracefs_cpu_open()* returns a struct tracefs_cpu descriptor that can be
 used by the other functions or NULL on error.
 
+The *tracefs_cpu_alloc_fd()* returns a struct tracefs_cpu descriptor that can
+be used by the *tracefs_cpu_read*(3) related functions, where the descriptor
+will be reading the passed in _fd_ file descriptor.
+
 EXAMPLE
 -------
 See *tracefs_cpu_read*(3) for an example.
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index d41c7ab382ee..50af23e33026 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -270,7 +270,9 @@ Histograms:
 Recording of trace_pipe_raw files:
 	struct tracefs_cpu pass:[*]*tracefs_cpu_open*(struct tracefs_instance pass:[*]_instance_,
 					     int _cpu_, bool _nonblock_);
+	struct tracefs_cpu pass:[*]*tracefs_cpu_alloc_fd*(int _fd_, int _subbuf_size_, bool _nonblock_);
 	void *tracefs_cpu_close*(struct tracefs_cpu pass:[*]_tcpu_);
+	void *tracefs_cpu_free_fd*(struct tracefs_cpu pass:[*]_tcpu_);
 	int *tracefs_cpu_read_size*(struct tracefs_cpu pass:[*]_tcpu_);
 	int *tracefs_cpu_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
 	int *tracefs_cpu_buffered_read*(struct tracefs_cpu pass:[*]_tcpu_, void pass:[*]_buffer_, bool _nonblock_);
-- 
2.35.1

