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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE56AC2BBD5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855FD233FB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgLQJrT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgLQJrT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D62FC0611CD
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:38 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q18so18390373wrn.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UGI7x9XGf8QdyR8SMGBQIxUmxZG5OF3RDAyFwTys9vM=;
        b=JKIaFu3PtjFrkBYYVpx6sGadJy887v3SCDsm9y366ar6v1KxGPeFzo6kj8wj8piO4A
         3r3dulTWEG/dCKanqyugqnLHMV5oefijNDn5gOrhMgcthf/6gHEN1JgbqdWR0enHnIgc
         kXx1V0r0KE+E838knc0zVDZnemcyX0TIea/PQyDvMMEWM7pG10RnlpOClETKmvZ7bWko
         TaQwnLpl5GwM0XOnPxhNZTcZ2NznD1urXaS6YIFuYX5MoHyyllvEtnUeEWAgPmfTL6h1
         DrWYboxIrdHb3lgoBu68667TrrfeOGhpgFJcQW/XvCuOjgINz5b/tVAVljU+UK401qDs
         cO9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UGI7x9XGf8QdyR8SMGBQIxUmxZG5OF3RDAyFwTys9vM=;
        b=AsWWpogkCoMmzvZVLARU5Cch4a5mTKoa47a5Re7ym8VaIbCwWFI46B49FWbIBWYHrr
         MILzeZDa6s6OhvfXGo5ZTl743kfsqp910g8IPUbWtzYJxTxYvKhm8qSlhhtB+VC/Dnmx
         97+afpW0Dbms0DwJH87cxZ0sOExSAz3jqT7iEKhFCVSkfBWrTv/KlFyiSvyq9zp47NwU
         E/CeAeF5VghzTqfXMttIoF2gkK77CUKup0mETKI9qL5JtFsAzRCXFfnSLcWwo4ulvbi7
         LA4gdIA3rAPh20IOUlTZP8YcQ04Qkib9FLlJ343eUs5AkPOcyK7VidE1z2tpPKzuq0dF
         TZhA==
X-Gm-Message-State: AOAM533IkwV2CkrRuJmnE9lxFJdmyNJpn+1qlg4EUfW+1ri2v4h/Mg3z
        i0KuQsxpDWS8rwhixeTpm/E=
X-Google-Smtp-Source: ABdhPJxKzeTN9DI2MLWkEVQEMFlXfybMMk5FWMdSj2ONy7ybaysko4M9VeRRsIdBdh3fIwUEcOQ4jQ==
X-Received: by 2002:adf:ec8c:: with SMTP id z12mr31111712wrn.208.1608198397367;
        Thu, 17 Dec 2020 01:46:37 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 8/9] libtracefs man pages: APIs for initializing a tep handler with trace events from the local system.
Date:   Thu, 17 Dec 2020 11:46:25 +0200
Message-Id: <20201217094626.1402191-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_local_events()
tracefs_local_events_system()
tracefs_fill_local_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events-tep.txt | 131 ++++++++++++++++++++++++
 1 file changed, 131 insertions(+)
 create mode 100644 Documentation/libtracefs-events-tep.txt

diff --git a/Documentation/libtracefs-events-tep.txt b/Documentation/libtracefs-events-tep.txt
new file mode 100644
index 0000000..a01ce0e
--- /dev/null
+++ b/Documentation/libtracefs-events-tep.txt
@@ -0,0 +1,131 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_local_events, tracefs_local_events_system, tracefs_fill_local_events -
+Initialize a tep handler with trace events from the local system.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+*#include <event-parse.h>*
+
+struct tep_handle pass:[*]*tracefs_local_events*(const char pass:[*]_tracing_dir_);
+struct tep_handle pass:[*]*tracefs_local_events_system*(const char pass:[*]_tracing_dir_, const char pass:[*] const pass:[*]_sys_names_);
+int *tracefs_fill_local_events*(const char pass:[*]_tracing_dir_, struct tep_handle pass:[*]_tep_, int pass:[*]_parsing_failures_);
+
+--
+
+DESCRIPTION
+-----------
+Functions for initializing a tep handler with trace events from the local system.
+
+The _tracefs_local_events()_ function allocates a new _tep_ handler and
+initializes it with events from all trace systems, located in the given
+_tracing_dir_ directory. This could be NULL or tracefs mount point, for
+trace events in top instance, or full path to a trace instance, for trace
+events in that instance.
+
+The _tracefs_local_events_system()_ function allocates a new _tep_ handler
+and initializes it with events from specified trace systems _sys_names_,
+located in the given _tracing_dir_ directory. This could be NULL or tracefs
+mount point, for trace events in top instance, or full path to a trace instance,
+for trace events in that instance. The _sys_names_ argument is an array of
+trace system names, that will be used for _tep_ handler initialization.
+The last element in that array must be a NULL pointer.
+
+The _tracefs_fill_local_events()_ function initializes already allocated _tep_
+handler with events from all trace systems, located in the given _tracing_dir_
+directory. This could be NULL or tracefs mount point, for trace events in
+the top instance, or full path to a trace instance, for trace events in that
+instance. The _tep_ argument must be a pointer to already allocated tep
+handler, that is going to be initialized. The _parsing_failures_ argument
+could be NULL or a pointer to an integer, where the number of failures while
+parsing the event files are returned.
+
+RETURN VALUE
+------------
+The _tracefs_local_events()_ and _tracefs_local_events_system()_ functions
+return pointer to allocated and initialized _tep_ handler, or NULL in
+case of an error. The returned _tep_ handler must be freed with _tep_free()_.
+
+The _tracefs_fill_local_events()_ function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+#include <event-parse.h>
+
+struct tep_event *tep;
+...
+	tep = tracefs_local_events(NULL);
+	if (!tep) {
+		/* Failed to initialise tep handler with local events from top instance */
+		...
+	}
+...
+	tep_free(tep);
+...
+	const char *systems[] = {"ftrace", "irq", NULL};
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep) {
+		/* Failed to initialise tep handler with local events from
+		 * ftrace and irq systems in top instance.
+		 */
+		...
+	}
+...
+	tep_free(tep);
+...
+	int parsing_failures;
+	tep = tep_alloc();
+	if (!tep) {
+		/* Failed to allocate a tep handler */
+		...
+	}
+	if (tracefs_fill_local_events(NULL, tep, &parsing_failures) < 0) {
+		/* Failed to initialise tep handler with local events from top instance */
+	}
+...
+	tep_free(tep);
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
\ No newline at end of file
-- 
2.28.0

