Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82848C43217
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiKIXvp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiKIXvo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:51:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EB720F72
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC7B61D29
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A03AC43145;
        Wed,  9 Nov 2022 23:51:41 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1osurg-009C6a-1B;
        Wed, 09 Nov 2022 18:52:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 7/8] libtracefs: Add man pages for tracefs_cpu_alloc_fd() and tracefs_cpu_free_fd()
Date:   Wed,  9 Nov 2022 18:52:13 -0500
Message-Id: <20221109235214.2191393-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221109235214.2191393-1-rostedt@goodmis.org>
References: <20221109235214.2191393-1-rostedt@goodmis.org>
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

