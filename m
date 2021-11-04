Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66D2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3331611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhKDLNj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhKDLNj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260F0C061205
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:11:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i5so8018397wrb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eXgvizcGUEJqWhSKgbu8OJDQmrpnajMbTV1ezXJn5nc=;
        b=BxoJgM8vXhs+W6MqvLoR8b41VNqHrmGA8siJyNIecV+Jvnrq/c6juPdDci6YXeAwfa
         9EsioLF0Nrqh107lq1jFT/V+YJbFJODz23stY0Wk1EhsWWsaqkCJAnK3aIAr/Xi7BkxA
         KOC3xPt6o75AemuCbV/hSeEH2WBloqJHXTkoAEaMNC44w7LLlQ32H/jWEjzifT5qPY71
         NuMh4NFDlSH40cBYIiCt+l003LtDl/BMLbF4PfzGpb/fNuVQmteGveJhkvUg/DVQgtmB
         +7dIvilvoZCcMSAnJf+J2QQ9ojDtrxvwYAJMelWdlBMh4vpDN8y+GGqsKVNRGmHzhq6A
         UEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eXgvizcGUEJqWhSKgbu8OJDQmrpnajMbTV1ezXJn5nc=;
        b=ARd3ewF3srarWJbR912G0JBMx3mUngf/h1AnipWlKPxE9m9AKYiZR9doyfPpIoGWFA
         SMOtPVw8ub3I6Lthnff85wHrHVi+BiZTMgHQAEMB/+LnRZtgGVbJtMlMYz3WSUSOhx2D
         W3LiVLBokN7aGSsLFNhDZCjEjcdk6x4wIB+O/JhqmPg/6eYOJMPGaPNgoSmPNzXy2kTt
         mqRBduBaLfPx6+TzO/OEWdhxQgJDvlqAj2SVYAPdzkO2lJRfCPqHbL5jnw1WfpilxEuJ
         afNTNXPwCApqwnAsHmBBy4KoKEWCmquSc+mz1vvS2zCy7+EjKQZvJujl1k2hsfGQ7d26
         4kUw==
X-Gm-Message-State: AOAM532mIoT0wtcjlC7zZ5bc0Wq7XxUQOzwctL4XdXpi7l7baqyWVkkN
        mUAhiY0ThqhdY80x+M5w0h4A5BZvX14jsA==
X-Google-Smtp-Source: ABdhPJzJoDEPdd6SEB9EjP2C0dJU3Rpd/5oCcke2twkFnY9avLB+kc9wofTnLDbLA8LWAAyC7D0aLA==
X-Received: by 2002:adf:f9d2:: with SMTP id w18mr31243333wrr.303.1636024259729;
        Thu, 04 Nov 2021 04:10:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/10] libtracefs: Document dynamic events APIs
Date:   Thu,  4 Nov 2021 13:10:47 +0200
Message-Id: <20211104111047.302660-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As a new set of APIs for ftrace dynamic events were added recently,
they must be documented. A new man page is added, describing these
APIs:
  tracefs_dynevent_create();
  tracefs_dynevent_destroy();
  tracefs_dynevent_destroy_all();
  tracefs_dynevent_free();
  tracefs_dynevent_list_free();
  tracefs_dynevent_get_all();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-dynevents.txt | 251 +++++++++++++++++++++++++
 Documentation/libtracefs.txt           |  10 +
 2 files changed, 261 insertions(+)
 create mode 100644 Documentation/libtracefs-dynevents.txt

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
new file mode 100644
index 0000000..d3b4830
--- /dev/null
+++ b/Documentation/libtracefs-dynevents.txt
@@ -0,0 +1,251 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_dynevent_create, tracefs_dynevent_destroy, tracefs_dynevent_destroy_all,
+tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all -
+Create, destroy, free and get dynamic events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct *tracefs_dynevent*;
+enum *tracefs_dynevent_type*;
+int *tracefs_dynevent_create*(struct tracefs_dynevent pass:[*]_devent_);
+int *tracefs_dynevent_destroy*(struct tracefs_dynevent pass:[*]_devent_, bool _force_);
+int *tracefs_dynevent_destroy_all*(enum tracefs_dynevent_type _types_, bool _force_);
+void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(enum tracefs_dynevent_type _types_, const char pass:[*]_system_);
+--
+
+DESCRIPTION
+-----------
+
+The *tracefs_dynevent_create*() function creates dynamic event _devent_ in the system.
+
+The *tracefs_dynevent_destroy*() function removes dynamic event _devent_ from the system. If _force_
+is true, the function will attempt to disable all events in all trace instances, before removing
+the dynamic event. The _devent_ context is not freed, use *tracefs_dynevent_free*() to free it.
+
+The *tracefs_dynevent_destroy_all*() function removes all dynamic events of given types from the
+system. The _types_ parameter is a type of specific dynamic event, or a bitmask of dynamic events
+types *tracefs_dynevent_type*, that will be removed. If _types_ is 0, dynamic events from all types
+will be removed.  If _force_ is true, the function will attempt to disable all events in all trace
+instances, before removing the dynamic events.
+
+The *tracefs_dynevent_get_all*() function allocates and returns an array of pointers to dynamic
+events of given types that exist in the system. The last element of the array is a NULL pointer.
+The array must be freed with *tracefs_dynevent_list_free*(). If there are no events a NULL pointer is
+returned. The _types_ parameter is a type of specific dynamic event, or a bitmask of dynamic events
+types *tracefs_dynevent_type*, that will be retrieved. If _types_ is 0, dynamic events from all
+types will be retrieved.
+
+The *tracefs_dynevent_free*() function frees a dynamic event context _devent_.
+
+The *tracefs_dynevent_list_free*() function frees an array of pointers to dynamic event, returned
+by *tracefs_dynevent_get_all()* API.
+
+RETURN VALUE
+------------
+
+*tracefs_dynevent_create*() returns 0 on success, or -1 on error. If a parsing error occurs then
+*tracefs_error_last*(3) may be used to retrieve the error message explaining the parsing issue.
+
+*tracefs_dynevent_destroy*() and *tracefs_dynevent_destroy_all*() return 0 on success, or -1 on
+error. If _force_ is enabled, the functions may fail on disabling the events.
+
+*tracefs_dynevent_get_all*() function returns allocated array of pointers to dynamic events, or NULL
+in case of an error or in case there are no events in the system. That array must be freed by
+*tracefs_dynevent_list_free*().
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EPERM* Not run as root user
+
+*ENODEV* dynamic events of requested type are not configured for the running kernel.
+
+*ENOMEM* Memory allocation error.
+
+*tracefs_dynevent_create*() can fail with the following errors:
+
+*EINVAL*  Most likely a parsing error occurred (use *tracefs_error_last*(3) to possibly
+          see what that error was).
+
+Other errors may also happen caused by internal system calls.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/wait.h>
+
+#include <tracefs/tracefs.h>
+
+static struct tep_event *open_event;
+static struct tep_format_field *file_field;
+
+static struct tep_event *openret_event;
+static struct tep_format_field *ret_field;
+
+static int callback(struct tep_event *event, struct tep_record *record,
+		    int cpu, void *data)
+{
+	struct trace_seq seq;
+
+	trace_seq_init(&seq);
+	tep_print_event(event->tep, &seq, record, "%d-%s: ", TEP_PRINT_PID, TEP_PRINT_COMM);
+
+	if (event->id == open_event->id) {
+		trace_seq_puts(&seq, "open file='");
+		tep_print_field(&seq, record->data, file_field);
+		trace_seq_puts(&seq, "'\n");
+	} else if (event->id == openret_event->id) {
+		unsigned long long ret;
+		tep_read_number_field(ret_field, record->data, &ret);
+		trace_seq_printf(&seq, "open ret=%lld\n", ret);
+	} else {
+		goto out;
+	}
+
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
+out:
+	trace_seq_destroy(&seq);
+
+	return 0;
+}
+
+static pid_t run_exec(char **argv, char **env)
+{
+	pid_t pid;
+
+	pid = fork();
+	if (pid)
+		return pid;
+
+	execve(argv[0], argv, env);
+	perror("exec");
+	exit(-1);
+}
+
+const char *mykprobe = "my_kprobes";
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_dynevent *kprobe, *kretprobe;
+	const char *sysnames[] = { mykprobe, NULL };
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	pid_t pid;
+
+	if (argc < 2) {
+		printf("usage: %s command\n", argv[0]);
+		exit(-1);
+	}
+
+	instance = tracefs_instance_create("exec_open");
+	if (!instance) {
+		perror("creating instance");
+		exit(-1);
+	}
+
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
+
+	kprobe = tracefs_kprobe_alloc(mykprobe, "open", "do_sys_openat2",
+				      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
+	kretprobe = tracefs_kretprobe_alloc(mykprobe, "openret", "do_sys_openat2", "ret=%ax", 0);
+	if (!kprobe || !kretprobe) {
+		perror("allocating dynamic events");
+		exit(-1);
+	}
+
+	if (tracefs_dynevent_create(kprobe) || tracefs_dynevent_create(kretprobe)){
+		err = tracefs_error_last(NULL);
+		perror("Failed to create kprobes:");
+		if (err && strlen(err))
+			fprintf(stderr, "%s\n", err);
+		exit(-1);
+	}
+
+	tep = tracefs_local_events_system(NULL, sysnames);
+	if (!tep) {
+		perror("reading events");
+		exit(-1);
+	}
+	open_event = tep_find_event_by_name(tep, mykprobe, "open");
+	file_field = tep_find_field(open_event, "file");
+
+	openret_event = tep_find_event_by_name(tep, mykprobe, "openret");
+	ret_field = tep_find_field(openret_event, "ret");
+
+	tracefs_event_enable(instance, mykprobe, NULL);
+	pid = run_exec(&argv[1], env);
+
+	/* Let the child start to run */
+	sched_yield();
+
+	do {
+		tracefs_load_cmdlines(NULL, tep);
+		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, NULL);
+	} while (waitpid(pid, NULL, WNOHANG) != pid);
+
+	/* Will disable the events */
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
+	tracefs_dynevent_free(kprobe);
+	tracefs_dynevent_free(kretprobe);
+	tracefs_instance_destroy(instance);
+	tep_free(tep);
+
+	return 0;
+}
+--
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
+*Yordan Karadzhov* <y.karadz@gmail.com>
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
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index f679002..9ffb6ab 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -64,6 +64,16 @@ Writing data in the trace buffer:
 Control library logs:
 	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
 
+Dynamic event generic APIs:
+	struct *tracefs_dynevent*;
+	enum *tracefs_dynevent_type*;
+	int *tracefs_dynevent_create*(struct tracefs_dynevent pass:[*]_devent_);
+	int *tracefs_dynevent_destroy*(struct tracefs_dynevent pass:[*]_devent_, bool _force_);
+	int *tracefs_dynevent_destroy_all*(enum tracefs_dynevent_type _types_, bool _force_);
+	void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(enum tracefs_dynevent_type _types_, const char pass:[*]_system_);
+
 Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
-- 
2.31.1

