Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27558C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A4BA63221
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhKOKte (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhKOKtK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:10 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3257FC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:14 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so9896369edd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ob06WUv+izI4Jezu4mHKXc4ZrigJqrvIZBxSR1gu7c8=;
        b=WtRuY8UeboJt0d7kWMrcVxUB3T28shmzYB0E26sHDA5sgbJ3C8BcAGtrst/68JGnWl
         HjY38AJHY7OQjft/BgtsG60IuUcwduKoQqWLdAHfMZiQDGOB8Dh+oGo9Ux3jJPvhJwV7
         YturP6F9PUer8Ie7fK3DMh89r8eJZhcK/Ga2vkNJFXjjJ4uojEQm6Nj1hGnAHt/hgnFy
         rsapmMAhciV/8mmmCQQPL1xO+n985w2UdjdhIEXo2sgxZQM/pPDHjjTqZkoQsUO9tnnY
         6Gxi6lvlfhco9nkNT2pHP/Suk4IC5ZIX2kaz7H2s32HXfyBjUAHBC8CI7T3TUII+ymBm
         XLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ob06WUv+izI4Jezu4mHKXc4ZrigJqrvIZBxSR1gu7c8=;
        b=7mk20P9eMYlQMKZ3yZmY7+qcvzGUGbt7CLIikyHqBwM65WKnrfvkotttUL5zLZTVc+
         XXwRESFzTaRZDCBeB+wrtYMjaxVl7wd9ZuPJhHO/raokSTb3hnIbF4BwZ9j1bjFKHDFb
         /Fo9qYUgX6zM+ES2vHv2apNwn38+ipmcsAybZ/oCVtBaeQ6suiL9JLQMf5p8bpCxVaEJ
         hd4GY74XG0SciiHvE3RUnkYpQtNqCNPHoNJtcXoZHtPS1dFx36ZF/0zkX324QN8O/nUu
         fMbzB3c2VmVqy+iINoLiJrG64aEjMYOhhLs99OLWRgnN1LAeZuUcBLvU7oYX3Mka5IIi
         0Wsg==
X-Gm-Message-State: AOAM532Hb6S6YdxqT1VHWv83zLY+b+zGHXLAROOk32DBbbu/8cI3oxPu
        brLOu6ozk/gu3K0lEoyo+Fw=
X-Google-Smtp-Source: ABdhPJyZT12KL+iplXOMJany3X049xRHMG3MIoS6qj9qmOlnyaqJstQiYT3DDyfcLcdbEujRwU5gMA==
X-Received: by 2002:a50:da06:: with SMTP id z6mr53600642edj.355.1636973172669;
        Mon, 15 Nov 2021 02:46:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 11/15] libtracefs: Document dynamic events APIs
Date:   Mon, 15 Nov 2021 12:45:52 +0200
Message-Id: <20211115104556.121359-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
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
  tracefs_dynevent_info();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-dynevents.txt | 264 +++++++++++++++++++++++++
 Documentation/libtracefs.txt           |  11 ++
 2 files changed, 275 insertions(+)
 create mode 100644 Documentation/libtracefs-dynevents.txt

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
new file mode 100644
index 0000000..25172c3
--- /dev/null
+++ b/Documentation/libtracefs-dynevents.txt
@@ -0,0 +1,264 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_dynevent_create, tracefs_dynevent_destroy, tracefs_dynevent_destroy_all,
+tracefs_dynevent_free, tracefs_dynevent_list_free, tracefs_dynevent_get_all, tracefs_dynevent_info -
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
+int *tracefs_dynevent_destroy_all*(unsigned int _types_, bool _force_);
+void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
+enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
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
+The *tracefs_dynevent_info*() function returns the type and information of a given dynamic event
+_dynevent_. If any of the _system_, _event_, _prefix_, _addr_ or _format_ arguments are not NULL,
+then strings are allocated and returned back via these arguments. The _system_ and _event_ holds the
+system and the name of the dynamic event. If _prefix_ is non NULL, then it will hold an allocated
+string that holds the prefix portion of the dynamic event (the content up to the ":", exluding it).
+If _addr_ is non NULL, it will hold the address or function that the dynamic event is attached to,
+if relevant for this event type. If _format_ is non NULL, it will hold the format string of the
+dynamic event. Note, that the content in _group_, _event_, _prefix_, _addr_, and _format_ must be
+freed with free(3) if they are set.
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
+*tracefs_dynevent_info*() returns the type of the given dynamic event  or TRACEFS_DYNEVENT_UNKNOWN
+on error. If _system_, _event_, _prefix_, _addr_, or _format_ are non NULL, they will contain
+allocated strings that must be freed by free(3).
+
+ERRORS
+------
+The following errors are for all the above calls:
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
index 430d02e..6850860 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -64,6 +64,17 @@ Writing data in the trace buffer:
 Control library logs:
 	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
 
+Dynamic event generic APIs:
+	struct *tracefs_dynevent*;
+	enum *tracefs_dynevent_type*;
+	int *tracefs_dynevent_create*(struct tracefs_dynevent pass:[*]_devent_);
+	int *tracefs_dynevent_destroy*(struct tracefs_dynevent pass:[*]_devent_, bool _force_);
+	int *tracefs_dynevent_destroy_all*(unsigned int _types_, bool _force_);
+	void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
+	enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
+
 Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
-- 
2.33.1

