Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F69C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 28 Mar 2022 09:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiC1JFg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 05:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiC1JFe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 05:05:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099016353
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:54 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bq8so13252740ejb.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 28 Mar 2022 02:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/W6b4CszSD1CvgOsspLEaJRiT44hTPeugvoHnhQJiI=;
        b=B/+lOV8CGGaKfrjWsLt+hYYst/Ej5BsOecYZB2jPv5bgn7GbHY1xS69kRKP7/LzBds
         W3oz6MlFqRJIqOHYa+TTRPBqZ4KkR5M8yKIf/WUDkNaRsIoYvZnYZUvepFhg6KTW3O1m
         PjwZA4ek2HtBFSaj9/JqXZwRAwHTi7SAfS6HC577z6qm5aRCrZI1dbY8jLeVc0TWzgu8
         KnH44zGEAgIbA0yFHpi935lzXRuRFUMNdwTVRBX+nXFr/6x9laMJvHfcSWUm4CIOuEYz
         ULx0q8ocotQBw61osva8jAMyfe0N3E4ndbN7RTt5w9nh9/ozapvtbFfsY731xCS1J+c3
         wTDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/W6b4CszSD1CvgOsspLEaJRiT44hTPeugvoHnhQJiI=;
        b=FNB6k93VpadxfKCD5tC7lHtZ2WMF4s4aAW1uiVHV5STzG3yL8VCgcCSo2R75Ukm+/t
         hvHzMG/SG97/bT3KJbnrzYxbPZUDhIdhg+Hro1wGw0XjYZR0C0iVaYIUAzPWnGGwE9gn
         2KP5F0xok+EBYFtwAnBcLh67/gqMa3hcV4Wnvk7v3adheiUsl3mY5yAZ/gvy/vRzT/BO
         5tTjAT/UtVn+br7+SrpjeagnVHGiVrIkjLkJPTqX4q6vrzQfk8V7353LnapoBjqAMZZ4
         iOYrh1vSBs7EljSQ1czSE7eIzvVCm0RssiX0UooWUkSrUvzi/3U3zzUkxai9+uzrtSxR
         D8IA==
X-Gm-Message-State: AOAM532KXSX42MnoNTO06BysF+p19R9yx+4Ld/pl677gMY978LBqyYts
        lw23bKT6yDhp7qoi9PC69jzSTXfsZ1E=
X-Google-Smtp-Source: ABdhPJzz2ZB3df0LwbH6EnrmZl/C/9AfTAa4cJ3uNbEexa4xbhjwKfTv6Ab5tYd+bdFnWZ3LpIGQxg==
X-Received: by 2002:a17:907:8687:b0:6d7:8f6a:3c0e with SMTP id qa7-20020a170907868700b006d78f6a3c0emr26303138ejc.500.1648458232555;
        Mon, 28 Mar 2022 02:03:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dm11-20020a170907948b00b006cf488e72e3sm5647973ejc.25.2022.03.28.02.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 02:03:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] libtracefs: Document uprobes APIs
Date:   Mon, 28 Mar 2022 12:03:46 +0300
Message-Id: <20220328090347.107849-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328090347.107849-1-tz.stoyanov@gmail.com>
References: <20220328090347.107849-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly introduced uprobe APIs should be described in a man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-uprobes.txt | 188 +++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 Documentation/libtracefs-uprobes.txt

diff --git a/Documentation/libtracefs-uprobes.txt b/Documentation/libtracefs-uprobes.txt
new file mode 100644
index 0000000..dae0fc9
--- /dev/null
+++ b/Documentation/libtracefs-uprobes.txt
@@ -0,0 +1,188 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_uprobe_alloc,tracefs_uretprobe_alloc - Allocate new user (return) probe
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_dynevent pass:[*]
+*tracefs_uprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_)
+struct tracefs_dynevent pass:[*]
+*tracefs_uretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		     const char pass:[*]_file_, unsigned long long _offset_, const char pass:[*]_fetchargs_)
+--
+
+DESCRIPTION
+-----------
+*tracefs_uprobe_alloc*() allocates a new uprobe context. It will be in the _system_ group
+(or uprobes if _system_ is NULL) and with _event_ name. The uprobe will be attached to _offset_
+within the _file_. The list of arguments, described in _fetchargs_, will be fetched  with the uprobe.
+The returned pointer to the user probe context must be freed with *tracefs_dynevent_free*().
+The ubrobe is not configured in the system, tracefs_dynevent_* set of APIs can be used to configure
+it.
+
+The *tracefs_uretprobe_alloc*() behaves the same as *tracefs_uprobe_alloc*(), the only difference is
+that it allocates context to user return probe (uretprobe).
+
+RETURN VALUE
+------------
+The *tracefs_uprobe_alloc*() and *tracefs_uretprobe_alloc*() APIs return a pointer to an allocated
+tracefs_dynevent structure, describing the user probe. This pointer must be freed with
+*tracefs_dynevent_free*(3). Note, this only allocates a descriptor representing the uprobe. It does
+not modify the running system. On error NULL is returned.
+
+EXAMPLE
+-------
+[source,c]
+--
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/wait.h>
+
+#include <tracefs.h>
+
+static int callback(struct tep_event *event, struct tep_record *record,
+		    int cpu, void *data)
+{
+	struct trace_seq seq;
+
+	trace_seq_init(&seq);
+	tep_print_event(event->tep, &seq, record, "%d-%s: %s",
+			TEP_PRINT_PID, TEP_PRINT_COMM, TEP_PRINT_NAME);
+	trace_seq_puts(&seq, "'\n");
+
+	trace_seq_terminate(&seq);
+	trace_seq_do_printf(&seq);
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
+const char *myprobe = "my_urobes";
+
+int main (int argc, char **argv, char **env)
+{
+	struct tracefs_dynevent *uprobe, *uretprobe;
+	struct tep_handle *tep;
+	struct tracefs_instance *instance;
+	const char *sysnames[] = { myprobe, NULL };
+	long addr;
+	pid_t pid;
+
+	if (argc < 3) {
+		printf("usage: %s file_offset command\n", argv[0]);
+		exit(-1);
+	}
+	addr = strtol(argv[1], NULL, 0);
+
+	instance = tracefs_instance_create("exec_open");
+	if (!instance) {
+		perror("creating instance");
+		exit(-1);
+	}
+
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_UPROBE|TRACEFS_DYNEVENT_URETPROBE, true);
+
+	uprobe = tracefs_uprobe_alloc(myprobe, "user_probe", argv[2], addr, NULL);
+	uretprobe = tracefs_uretprobe_alloc(myprobe, "user_retprobe", argv[2], addr, NULL);
+	if (!uprobe || !uretprobe) {
+		perror("allocating user probes");
+		exit(-1);
+	}
+
+	if (tracefs_dynevent_create(uprobe) ||
+	    tracefs_dynevent_create(uretprobe)) {
+		perror("creating user probes");
+		exit(-1);
+	}
+
+	tep = tracefs_local_events_system(NULL, sysnames);
+	if (!tep) {
+		perror("reading events");
+		exit(-1);
+	}
+
+	tracefs_event_enable(instance, myprobe, "user_probe");
+	tracefs_event_enable(instance, myprobe, "user_retprobe");
+
+	pid = run_exec(&argv[2], env);
+
+	/* Let the child start to run */
+	sched_yield();
+
+	do {
+		tracefs_load_cmdlines(NULL, tep);
+		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, NULL);
+	} while (waitpid(pid, NULL, WNOHANG) != pid);
+
+	/* disable and destroy the events */
+	tracefs_dynevent_destroy(uprobe, true);
+	tracefs_dynevent_destroy(uretprobe, true);
+	tracefs_dynevent_free(uprobe);
+	tracefs_dynevent_free(uretprobe);
+	tracefs_instance_destroy(instance);
+
+	return 0;
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
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
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
+Copyright \(C) 2022 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.35.1

