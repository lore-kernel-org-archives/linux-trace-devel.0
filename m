Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476FEC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA4D64E45
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBRDje (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 22:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBRDjd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 22:39:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036BAC0613D6
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:53 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s11so1067349edd.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hOmzGVBgLLnUIZF5zHOb17utVXquWGard6EAWw7lmhw=;
        b=eSBf4YFS+4M4XXTJ97IW1elqaC+tBmo3J2ubzFaecZBnXClWtgpWkzhpL20G5Nb4ga
         +T6iVlVQIPNu8AabD05SsFPFJKD4AfEoKoNImxbTa9cjJGoPB61MC9vSg3j6rZHGHBu1
         N3p5gfI7MfcpayGQ//9/2Q1vhlPaWT1g1caQN0ryagM3FAyRcUOc+DLdgNN2XDQqYd4G
         rfdxQr/awK3MScCKHnunBNXICwE6/20TnOzJsSBlDES09sGSLly687oUQu3CXusUBqQE
         Bx57eUS2zgCEk+xkDRm6Qa0Ozg/UOFusbSebzhSSIPYmAf7pXvw11D2GQeULPeSzXmfN
         hZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hOmzGVBgLLnUIZF5zHOb17utVXquWGard6EAWw7lmhw=;
        b=d33VrQdedzgGRCgwuCnN3dVumW4Emljf/Nu3sTl7wkZ4zI9pqVcIkyrhGQWPCYY1Zr
         Su7Kisv/NLo5l4i6tS3R8/hW0qLgzwljL9IoHKh3gIEQhW9ksmJU8kmunlCaKysfp8aG
         rmElYZfUaxk8R2NYKUW6z6H7c92zR65+R+GjTrTlvEKCk2W3UvdIYc8RSNawV3nQRSYH
         VnZmAixqDHaeXLmaNmtvxyls3rUOX6Zt7DaQijtK/URBkGSeg1yuJAvd1/9Lq1InZWay
         KtOzHuzEsuJR6EPTK9Rkc2MVO2mAwwoMZA8gf8RsitHH3kGIERZlT8Bpa5IwbXCzUN/s
         J1kA==
X-Gm-Message-State: AOAM532QwfuKXa+lE/lPpbvyg3zQTBPomwtLz70BclsdHqZW0P3e52fz
        IWSTWLvWZNASzXZ2zRHOGKQ=
X-Google-Smtp-Source: ABdhPJwvgDuBWWHb6zAlqmtd7JQH/lFERnJ9m8UBFWkHz2deaG9tMKdJqBkyJRCxsD+7EMAb3NlxTw==
X-Received: by 2002:a05:6402:34d2:: with SMTP id w18mr2034638edc.102.1613619531548;
        Wed, 17 Feb 2021 19:38:51 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i4sm1796979eje.90.2021.02.17.19.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 19:38:50 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] libtracefs: Document APIs for trace options
Date:   Thu, 18 Feb 2021 05:38:46 +0200
Message-Id: <20210218033846.1891289-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210218033846.1891289-1-tz.stoyanov@gmail.com>
References: <20210218033846.1891289-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation for libtracefs APIs realated to ftrace options:
	enum tracefs_option - short description of each option

 	tracefs_option_set()
	tracefs_option_clear()
	qtracefs_option_is_set()

	tracefs_options_get_supported()
	tracefs_option_is_supported()
	tracefs_options_get_enabled()
	qtracefs_option_is_enabled()

	tracefs_option_enable()
	tracefs_option_diasble()
	tracefs_option_name()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-option-bits.txt |  90 +++++++++++++
 Documentation/libtracefs-option-get.txt  | 123 ++++++++++++++++++
 Documentation/libtracefs-option-misc.txt | 100 ++++++++++++++
 Documentation/libtracefs-options.txt     | 159 +++++++++++++++++++++++
 4 files changed, 472 insertions(+)
 create mode 100644 Documentation/libtracefs-option-bits.txt
 create mode 100644 Documentation/libtracefs-option-get.txt
 create mode 100644 Documentation/libtracefs-option-misc.txt
 create mode 100644 Documentation/libtracefs-options.txt

diff --git a/Documentation/libtracefs-option-bits.txt b/Documentation/libtracefs-option-bits.txt
new file mode 100644
index 0000000..d713a5e
--- /dev/null
+++ b/Documentation/libtracefs-option-bits.txt
@@ -0,0 +1,90 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_option_set, tracefs_option_clear, tracefs_option_is_set -
+Set, clear, check option in a bitmask.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+void *tracefs_option_set*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
+void *tracefs_option_clear*(struct tracefs_options_mask pass:[*]_options_, enum tracefs_option_id _id_);
+bool *tracefs_option_is_set*(struct tracefs_options_mask _options_, enum tracefs_option_id _id_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to manipulate a bitmask with option IDs.
+
+The _tracefs_option_set()_ function sets the bit, corresponding to the option with _id_ in the
+_options_ bitmask.
+
+The _tracefs_option_clear()_ function clears the bit, corresponding to the option with _id_ in the
+_options_ bitmask.
+
+The _tracefs_option_is_set()_ function checks if the bit, corresponding to the option with _id_ is
+set in the _options_ bitmask.
+
+RETURN VALUE
+------------
+The _tracefs_option_is_set()_ function returns true if the bit is set, false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+...
+struct tracefs_options_mask options;
+memset(&options, 0, sizeof(options));
+...
+tracefs_option_set(&options, TRACEFS_OPTION_EVENT_FORK | TRACEFS_OPTION_FUNCTION_FORK);
+...
+if (tracefs_option_is_set(options, TRACEFS_OPTION_EVENT_FORK))
+	tracefs_option_clear(&options, TRACEFS_OPTION_EVENT_FORK);
+...
+--
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
new file mode 100644
index 0000000..9b3cb56
--- /dev/null
+++ b/Documentation/libtracefs-option-get.txt
@@ -0,0 +1,123 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_options_get_supported, tracefs_option_is_supported,
+tracefs_options_get_enabled, tracefs_option_is_enabled - Get and check ftrace options.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_options_mask pass:[*]*tracefs_options_get_supported*(struct tracefs_instance pass:[*]_instance_);
+bool *tracefs_option_is_supported*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+struct tracefs_options_mask pass:[*]*tracefs_options_get_enabled*(struct tracefs_instance pass:[*]_instance_);
+bool *tracefs_option_is_enabled*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to get and check current ftrace options. Supported ftrace options may
+depend on the kernel version and the kernel configuration.
+
+The _tracefs_options_get_supported()_ function gets all ftrace options supported by the system in
+the given _instance_. If _instance_ is NULL, supported options of the top trace instance are
+returned. The set of supported options must be the same in all trace instances.
+
+The _tracefs_option_is_supported()_ function checks if the option with given _id_ is supported by
+the system in the given _instance_. If _instance_ is NULL, the top trace instance is used. If an
+option is supported at the top trace instance, it must be supported in all trace instances also.
+
+The _tracefs_options_get_enabled()_ function gets all ftrace options, currently enabled in
+the given _instance_. If _instance_ is NULL, enabled options of the top trace instance are returned.
+
+The _tracefs_option_is_enabled()_ function checks if the option with given _id_ is enabled in the
+given _instance_. If _instance_ is NULL, the top trace instance is used.
+
+RETURN VALUE
+------------
+The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions return pointer
+to allocated bitmask with trace options, or NULL in case of an error. The returned bitmask must be
+freed with free();
+
+The _tracefs_option_is_supported()_ and _tracefs_option_is_enabled()_ functions return true if the
+option in supported / enabled, or false otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+...
+struct tracefs_options_mask *options;
+...
+options = tracefs_options_get_supported(NULL);
+if (!options) {
+	/* Failed to get supported options */
+} else {
+	...
+	free(options);
+}
+...
+options = tracefs_options_get_enabled(NULL);
+if (!options) {
+	/* Failed to get options, enabled in the top instance */
+} else {
+	...
+	free(options);
+}
+...
+
+if (tracefs_option_is_supported(NULL, TRACEFS_OPTION_LATENCY_FORMAT)) {
+	/* Latency format option is supprted */
+}
+
+...
+
+if (tracefs_option_is_enabled(NULL, TRACEFS_OPTION_STACKTRACE)) {
+	/* Stacktrace option is enabled in the top instance */
+}
+
+--
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-option-misc.txt b/Documentation/libtracefs-option-misc.txt
new file mode 100644
index 0000000..1cd7c88
--- /dev/null
+++ b/Documentation/libtracefs-option-misc.txt
@@ -0,0 +1,100 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_option_enable, tracefs_option_diasble, tracefs_option_name -
+Various trace option functions.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_option_enable*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+int *tracefs_option_diasble*(struct tracefs_instance pass:[*]_instance_, enum tracefs_option_id _id_);
+const char pass:[*]*tracefs_option_name*(enum tracefs_option_id _id_);
+--
+
+DESCRIPTION
+-----------
+This set of APIs can be used to enable and disable ftrace options and to get the name of an option.
+
+The _tracefs_option_enable()_ function enables the option with _id_ in the given _instance_. If
+_instance_ is NULL, the option is enabled in the top trace instance.
+
+The _tracefs_option_diasble()_ function disables the option with _id_ in the given _instance_. If
+_instance_ is NULL, the option is disabled in the top trace instance.
+
+The _tracefs_option_name()_ function returns a string, representing the option with _id_. The string
+must *not* be freed.
+
+
+RETURN VALUE
+------------
+The _tracefs_option_enable()_ and _tracefs_option_diasble()_ functions return 0 if the state of the
+option is set successfully, or -1 in case of an error.
+
+The _tracefs_option_name()_ function returns string with option name, or "unknown" in case of an
+error. The returned string must *not* be freed.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+...
+if (tracefs_option_enable(NULL, TRACEFS_OPTION_ANNOTATE)) {
+	/* Failed to enable annotate option in top trace instance */
+}
+...
+if (tracefs_option_diasble(NULL, TRACEFS_OPTION_CONTEXT_INFO)) {
+	/* Failed to disable context info option in top trace instance */
+}
+...
+char *name = tracefs_option_name(TRACEFS_OPTION_FUNC_STACKTRACE);
+if (strcmp(name, "unknown")) {
+	/* Cannot get the name of the option */
+}
+
+--
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs-options.txt b/Documentation/libtracefs-options.txt
new file mode 100644
index 0000000..b8f0edf
--- /dev/null
+++ b/Documentation/libtracefs-options.txt
@@ -0,0 +1,159 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_options - ftrace options, that can be controlled using tracefs library.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+enum tracefs_option_id {
+	*TRACEFS_OPTION_INVALID*,
+	*TRACEFS_OPTION_ANNOTATE*,
+	*TRACEFS_OPTION_BIN*,
+	*TRACEFS_OPTION_BLK_CGNAME*,
+	*TRACEFS_OPTION_BLK_CGROUP*,
+	*TRACEFS_OPTION_BLK_CLASSIC*,
+	*TRACEFS_OPTION_BLOCK*,
+	*TRACEFS_OPTION_CONTEXT_INFO*,
+	*TRACEFS_OPTION_DISABLE_ON_FREE*,
+	*TRACEFS_OPTION_DISPLAY_GRAPH*,
+	*TRACEFS_OPTION_EVENT_FORK*,
+	*TRACEFS_OPTION_FGRAPH_ABSTIME*,
+	*TRACEFS_OPTION_FGRAPH_CPU*,
+	*TRACEFS_OPTION_FGRAPH_DURATION*,
+	*TRACEFS_OPTION_FGRAPH_IRQS*,
+	*TRACEFS_OPTION_FGRAPH_OVERHEAD*,
+	*TRACEFS_OPTION_FGRAPH_OVERRUN*,
+	*TRACEFS_OPTION_FGRAPH_PROC*,
+	*TRACEFS_OPTION_FGRAPH_TAIL*,
+	*TRACEFS_OPTION_FUNC_STACKTRACE*,
+	*TRACEFS_OPTION_FUNCTION_FORK*,
+	*TRACEFS_OPTION_FUNCTION_TRACE*,
+	*TRACEFS_OPTION_GRAPH_TIME*,
+	*TRACEFS_OPTION_HEX*,
+	*TRACEFS_OPTION_IRQ_INFO*,
+	*TRACEFS_OPTION_LATENCY_FORMAT*,
+	*TRACEFS_OPTION_MARKERS*,
+	*TRACEFS_OPTION_OVERWRITE*,
+	*TRACEFS_OPTION_PAUSE_ON_TRACE*,
+	*TRACEFS_OPTION_PRINTK_MSG_ONLY*,
+	*TRACEFS_OPTION_PRINT_PARENT*,
+	*TRACEFS_OPTION_RAW*,
+	*TRACEFS_OPTION_RECORD_CMD*,
+	*TRACEFS_OPTION_RECORD_TGID*,
+	*TRACEFS_OPTION_SLEEP_TIME*,
+	*TRACEFS_OPTION_STACKTRACE*,
+	*TRACEFS_OPTION_SYM_ADDR*,
+	*TRACEFS_OPTION_SYM_OFFSET*,
+	*TRACEFS_OPTION_SYM_USEROBJ*,
+	*TRACEFS_OPTION_TRACE_PRINTK*,
+	*TRACEFS_OPTION_USERSTACKTRACE*,
+	*TRACEFS_OPTION_VERBOSE*,
+};
+--
+
+DESCRIPTION
+-----------
+This enum contains all ftrace options, that can be manipulated using tracefs library. More detailed
+information about each option is available in Documentation/trace/ftrace.rst from the Linux
+kernel tree, in the trace_options section. Note that some ftrace options cannot be manipulated by
+this library, as they are intended for internal, debug purposes. These options control the tracers
+or the trace output. All options have two states - on and off, the default state is different for
+each of them.
+[verse]
+--
+Common options for all tracers:
+	*TRACEFS_OPTION_INVALID* Not a valid ftrace option, used by the API to indicate an error.
+	*TRACEFS_OPTION_ANNOTATE* Display when a new CPU buffer started.
+	*TRACEFS_OPTION_BIN* Display the formats in raw binary.
+	*TRACEFS_OPTION_CONTEXT_INFO* Show only the event data. Hides the comm, PID, timestamp, CPU, and other useful data.
+	*TRACEFS_OPTION_BLOCK* When set, reading trace_pipe will not block when polled.
+	*TRACEFS_OPTION_DISABLE_ON_FREE* When the free_buffer is closed, tracing will stop.
+	*TRACEFS_OPTION_DISPLAY_GRAPH* When set, the latency tracers will use function graph tracing instead of function tracing.
+	*TRACEFS_OPTION_EVENT_FORK* When set, tasks with PIDs listed in set_event_pid will have the PIDs of their children added to set_event_pid when those tasks fork.
+	*TRACEFS_OPTION_FUNCTION_FORK* When set, tasks with PIDs listed in set_ftrace_pid will have the PIDs of their children added to set_ftrace_pid when those tasks fork.
+	*TRACEFS_OPTION_FUNCTION_TRACE* When enabled, the latency tracers will trace functions.
+	*TRACEFS_OPTION_HEX* Display numbers in a hexadecimal format.
+	*TRACEFS_OPTION_IRQ_INFO* Display the interrupt, preempt count, need resched data.
+	*TRACEFS_OPTION_LATENCY_FORMAT* Display additional information about the latency.
+	*TRACEFS_OPTION_MARKERS* When set, the trace_marker is enabled - writable (only by root).
+	*TRACEFS_OPTION_OVERWRITE* Controls what happens when the trace buffer is full. If set, the oldest events are discarded and overwritten. If disabled, then the newest events are discarded.
+	*TRACEFS_OPTION_PAUSE_ON_TRACE* When set, opening the trace file for read, will pause writing to the ring buffer. When the file is closed, tracing will be enabled again.
+	*TRACEFS_OPTION_PRINTK_MSG_ONLY* When set, trace_printk()s will only show the format and not their parameters.
+	*TRACEFS_OPTION_PRINT_PARENT* On function traces, display the calling (parent) function as well as the function being traced.
+	*TRACEFS_OPTION_RAW* Display raw numbers.
+	*TRACEFS_OPTION_RECORD_CMD* Save a mapping with a pid and corresponding command.
+	*TRACEFS_OPTION_RECORD_TGID* Save a mapping with a pid and corresponding Thread Group IDs.
+	*TRACEFS_OPTION_STACKTRACE* Record a stack trace after any trace event.
+	*TRACEFS_OPTION_SYM_ADDR* Display the function address as well as the function name.
+	*TRACEFS_OPTION_SYM_OFFSET* Display not only the function name, but also the offset in the function.
+	*TRACEFS_OPTION_SYM_USEROBJ* When *TRACEFS_OPTION_USERSTACKTRACE* is set, look up which object the address belongs to, and print the object and a relative address.
+	*TRACEFS_OPTION_TRACE_PRINTK* Disable trace_printk() from writing into the buffer.
+	*TRACEFS_OPTION_USERSTACKTRACE* Records a stack trace of the current user space thread after each trace event.
+	*TRACEFS_OPTION_VERBOSE* When *TRACEFS_OPTION_LATENCY_FORMAT* is enabled, print more detailed information.
+
+Options, specific to function tracer:
+	*TRACEFS_OPTION_FUNC_STACKTRACE* Record a stack trace after every function.
+
+Options, specific to function_graph tracer:
+	*TRACEFS_OPTION_FGRAPH_ABSTIME* Display the timestamp at each line.
+	*TRACEFS_OPTION_FGRAPH_CPU* Display the CPU number of the CPU where the trace occurred.
+	*TRACEFS_OPTION_FGRAPH_DURATION* Display the duration of the amount of time at the end of each function, in microseconds.
+	*TRACEFS_OPTION_FGRAPH_IRQS* Trace functions that happen inside an interrupt.
+	*TRACEFS_OPTION_FGRAPH_OVERHEAD* Display a marker if a function takes longer than a certain amount of time.
+	*TRACEFS_OPTION_FGRAPH_OVERRUN* Display "overrun" of the call graph, in the case of functions missed due to big callstack.
+	*TRACEFS_OPTION_FGRAPH_PROC* Display the command of each process at every line.
+	*TRACEFS_OPTION_FGRAPH_TAIL* Display the function name on its return.
+	*TRACEFS_OPTION_SLEEP_TIME* Account time the task has been scheduled out as part of the function call.
+	*TRACEFS_OPTION_GRAPH_TIME* Display the time to call nested functions, if function profiler is enabled.
+
+Options, specific to blk tracer:
+	*TRACEFS_OPTION_BLK_CGNAME*
+	*TRACEFS_OPTION_BLK_CGROUP*
+	*TRACEFS_OPTION_BLK_CLASSIC* Display a more minimalistic output.
+--
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
+_libtracefs(3)_,
+_libtraceevent(3)_,
+_trace-cmd(1)_,
+_Documentation/trace/ftrace.rst_ from the Linux kernel tree.
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
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
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.29.2

