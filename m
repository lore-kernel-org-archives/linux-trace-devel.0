Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B3DC43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839C8630EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbhKOKtr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhKOKtN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:13 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02FC061746
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:18 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so9897295edd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ah69xG5P4nVicL7GuHLsqd5IvrMQ6gBCU1n2d4zFeYg=;
        b=Du4pjyqG1zr/inhqjTGyomBxTIO4CUziuY9pfZpHzT1OxV913N4wMvf/GNddPLmM5q
         TbQxiGMXEK8ZZeb2PrxwvDhUrqmgfGcu1wNv74eAgh3HqUHLP2RQ3UQ18oqZoeDyKUTK
         Ph7dT/CU6uZA42ORhrN7PcZ/hhCaJus3qDzdvJehe+J83AgYfUIRhvygTAOaN6P0EXoA
         XH9KqhlYg8RXCtNhHFDj42D4N6bg5dtHVw7Wm4F0W+jDUr58B9cai8yf3AZNktSbbJvF
         NmguN9oJMyFuD8sw5w56DwucoC/uuOWLKqsSzz5mwV8HmQfJwA85et7c0QTicwZg6xvd
         kl5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ah69xG5P4nVicL7GuHLsqd5IvrMQ6gBCU1n2d4zFeYg=;
        b=424kl1pDlLIcCl9myqKAlySCB0M3KciPHTiQcaABUEnlYECxobQ7t1U7C9L9hW8m+8
         B6m9KvjM6DX9eGksSa6BniFWurgLGS2wqpsPnEJ8TGWDwcLdbVhy5zET973Y8DYlbf75
         UsnNT+gsp54jwkG/7Cz8I6M2ySOJmQ04VrjsTKZ8C2bAKhIzaaiD2MUIpg/F5Zaft90k
         18IerRwa5jqJsnu3mFbFO/VAIn19kscNM0KRusbt1y5l9jBfx0jF9aLE/j/FG4yMBGar
         N8FTSMx/9gPOtSGdJeUsFu1z1rYyqqZ2m9+toLCg7U6JkXyy78dHc1jGLGSlOlttyVJR
         Au7g==
X-Gm-Message-State: AOAM533cO4uO2vc9PVotACNDIkpafcSnj9/C4Vos/2ACG9cLg8MuDxMC
        Pws1BGsGi0heBEJiuZgZnk/nXt+VlcFIrQ==
X-Google-Smtp-Source: ABdhPJytrDo5qDOSYJzqQyAc87zFlE544kuk6hKuDlsmwX9bZ2MgeIhsdJnSzHsqp7Bc43ddefAXMQ==
X-Received: by 2002:aa7:c406:: with SMTP id j6mr34052352edq.76.1636973176820;
        Mon, 15 Nov 2021 02:46:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 15/15] libtracefs: Document eprobe API
Date:   Mon, 15 Nov 2021 12:45:56 +0200
Message-Id: <20211115104556.121359-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As a new API for ftrace event probes wasadded recently, it must be
documented. A new man page is added, describing the API:
 tracefs_eprobe_alloc()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-eprobes.txt | 189 +++++++++++++++++++++++++++
 Documentation/libtracefs.txt         |   3 +
 2 files changed, 192 insertions(+)
 create mode 100644 Documentation/libtracefs-eprobes.txt

diff --git a/Documentation/libtracefs-eprobes.txt b/Documentation/libtracefs-eprobes.txt
new file mode 100644
index 0000000..3baaea3
--- /dev/null
+++ b/Documentation/libtracefs-eprobes.txt
@@ -0,0 +1,189 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_eprobe_alloc - Allocate new event probe (eprobe)
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_dynevent pass:[*]
+*tracefs_eprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		       const char pass:[*]_target_system_, const char pass:[*]_target_event_,
+		       const char pass:[*]_fetchargs_);
+--
+
+DESCRIPTION
+-----------
+*tracefs_eprobe_alloc*() allocates a new eprobe context. The ebrobe is not configured in the system.
+The new eprobe will be in the _system_ group (or eprobes if _system_ is NULL) and have the name of
+_event_. The eprobe will be attached to _target_event_, located in _target_system_. The list of
+arguments, described in _fetchargs_, will be fetched from _target_event_. The returned pointer to
+the event probe must be freed with *tracefs_dynevent_free*().
+
+
+RETURN VALUE
+------------
+The *tracefs_eprobe_alloc*() API returns a pointer to an allocated tracefs_dynevent structure,
+describing the event probe. This pointer must be freed by *tracefs_dynevent_free*(3). Note, this
+only allocates a descriptor representing the eprobe. It does not modify the running system. On error
+NULL is returned.
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
+	}
+
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
+
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
+const char *myprobe = "my_eprobes";
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_dynevent *eprobe;
+	struct tracefs_instance *instance;
+	struct tep_handle *tep;
+	const char *sysnames[] = { mykprobe, NULL };
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
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
+
+	eprobe = tracefs_eprobe_alloc(myprobe, "sopen", "syscalls", "sys_enter_openat2",
+				      "file=+0($filename):ustring");
+	if (!eprobe) {
+		perror("allocating event probe");
+		exit(-1);
+	}
+
+	if (tracefs_dynevent_create(eprobe)) {
+		perror("creating event probe");
+		exit(-1);
+	}
+
+	tep = tracefs_local_events_system(NULL, sysnames);
+	if (!tep) {
+		perror("reading events");
+		exit(-1);
+	}
+
+	open_event = tep_find_event_by_name(tep, myprobe, "sopen");
+	file_field = tep_find_field(open_event, "file");
+
+	tracefs_event_enable(instance, myprobe, "sopen");
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
+	tracefs_dynevent_destroy(eprobe, true);
+	tracefs_dynevent_free(eprobe);
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
+--
+
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
index 6850860..39cf027 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -75,6 +75,9 @@ Dynamic event generic APIs:
 	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
 	enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
 
+Even probes (eprobes):
+	struct tracefs_dynevent pass:[*] *tracefs_eprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_target_system_, const char pass:[*]_target_event_, const char pass:[*]_fetchargs_);
+
 Kprobes and Kretprobes:
 	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
-- 
2.33.1

