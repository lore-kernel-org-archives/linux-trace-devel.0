Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3981C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2E86023E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCPrU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhKCPrJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:09 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADF8C061203
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:32 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d5so4270005wrc.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mV1kSFuvRGQt5pE2neYmRbtlaO0+g5jmzYMKSeowzlU=;
        b=cNZBfDyXIfnPsE8B0jD4CTfviZBwN8gmLKycpO7xS/E2f/zU81daCmzYMR84AubpYu
         ltA3pQQbvOFY3vnoHevqLcNbkw4qMGmct6qQeLwwYrG19Nd7eImeIP8iJZy0zRDSKl3b
         ygNtxfxYBPkw4y7gP31P/z6iMgBxYViCkB8k1fMMzamSaiGTofCDmfgu75VRKmS1owIC
         /JsWKRHTftub5E2ltfbk5izI9/hveAvEz8ZwYoEFO84W8cUsuCXjhW7iZ/Gc8DMxM64y
         1vR/kbvakT+SzdAMC0A01asj91QTf5n4ViR60lYSPqUQ5uEtxqwdTqC2zXEHugm+/OJP
         4uvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mV1kSFuvRGQt5pE2neYmRbtlaO0+g5jmzYMKSeowzlU=;
        b=mDBaLNzmGlVKlRRMRwWmnyCgUzkg1WEiKElghsONSw1rN342xQK8Oid7z3lFrsGZAv
         Zi/Yd4/saeqf7KX0a/X01izk7u4S7sYlahHhs5uKxHcVV2lHUzJ72QdebTLNFc4oMor3
         e9CldlZDKKHQrx9IYcdQ3nojQ5tGn6MocEVwtqETQpaa6PTcOqJLQklVfX86psS5jnku
         UPkF+2+p1WRup5vbC2SvGJLBtjbv+pfjstcwJmiO8RCJuu5nfG9ivmrl4GZwuaF/T7M2
         oIWnI1/qjzj2UZtIk4/slGaxUbuJGuwcXWSfWhIWlrV/N5RIQKGXiQLDxZBRHZq7nsDC
         2/9g==
X-Gm-Message-State: AOAM530A5RkcWkx3SiZYRJaE+BmbHHImwCp7khVwv/z2AoOFo4WEBPtr
        PHKHtUdarWEjzdsa0B97JRg=
X-Google-Smtp-Source: ABdhPJzyyPgb/bbGZ8stacb5NuFfbCs5zmopRS66tbCUpr+XYFt1jIcYYahY9ZO+ZQbc13jQ5hG/aQ==
X-Received: by 2002:a5d:518d:: with SMTP id k13mr53188349wrv.120.1635954271314;
        Wed, 03 Nov 2021 08:44:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 11/11] libtracefs: Document dynamic events APIs
Date:   Wed,  3 Nov 2021 17:44:17 +0200
Message-Id: <20211103154417.246999-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As a new set of APIs for ftrace dynamic events were added recently,
they must be documented. A new man page is added, describing these
APIs:
	int tracefs_dynevent_create(struct tracefs_dynevent *devent);
	int tracefs_dynevent_destroy(struct tracefs_dynevent *devent, bool force);
	int tracefs_dynevent_destroy_all(unsigned long type_mask, bool force);
	void tracefs_dynevent_free(struct tracefs_dynevent *devent);
	void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
	struct tracefs_dynevent **tracefs_dynevent_get_all(unsigned long type_mask, const char *system);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-dynevents.txt | 257 +++++++++++++++++++++++++
 Documentation/libtracefs.txt           |  10 +
 2 files changed, 267 insertions(+)
 create mode 100644 Documentation/libtracefs-dynevents.txt

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
new file mode 100644
index 0000000..1f28d77
--- /dev/null
+++ b/Documentation/libtracefs-dynevents.txt
@@ -0,0 +1,257 @@
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
+int *tracefs_dynevent_destroy_all*(unsigned long _type_mask_, bool _force_);
+void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned long _type_mask_, const char pass:[*]_system_);
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
+system. The _type_mask_ parameter is a bitmask with dynamic events types *tracefs_dynevent_type*,
+that will be removed. The *TRACEFS_BIT_SET* macro can be used to set desired types in the bitmask.
+If _type_mask_ is 0, dynamic events from all types will be removed.  If _force_ is true, the
+function will attempt to disable all events in all trace instances, before removing the dynamic
+events.
+
+The *tracefs_dynevent_get_all*() function allocates and returns an array of pointers to dynamic
+events of given types that exist in the system. The last element of the array is a NULL pointer.
+The array must be freed with *tracefs_dynevent_list_free*(). If there are no events a NULL pointer is
+returned. The _type_mask_ parameter is a bitmask with dynamic events types *tracefs_dynevent_type*,
+that will be retrieved. The *TRACEFS_BIT_SET* macro can be used to set desired types in the bitmask.
+If _type_mask_ is 0, dynamic events from all types will be retrieved.
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
+
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_dynevent *kprobe, *kretprobe;
+	const char *sysnames[] = { mykprobe, NULL };
+	struct tracefs_instance *instance;
+	unsigned long kmask = 0;
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
+	TRACEFS_BIT_SET(kmask, TRACEFS_DYNEVENT_KPROBE);
+	TRACEFS_BIT_SET(kmask, TRACEFS_DYNEVENT_KRETPROBE);
+	tracefs_dynevent_destroy_all(kmask, true);
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
+	tracefs_dynevent_destroy_all(kmask, true);
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
index f679002..12c2e97 100644
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
+	int *tracefs_dynevent_destroy_all*(unsigned long _type_mask_, bool _force_);
+	void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
+	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
+	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned long _type_mask_, const char pass:[*]_system_);
+
 Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
-- 
2.31.1

