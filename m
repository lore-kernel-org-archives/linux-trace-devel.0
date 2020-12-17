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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD4DC3526E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE446238D6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgLQJqu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgLQJqt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:46:49 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23AA6C0611CA
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:34 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id r7so25908499wrc.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qk53r8eZIG9FM0whVuWdypgVu0JQXb37mXTB0DUalUI=;
        b=B+VmNv/ts9LBPVm4PS+olXyFXYKHJgVn5bxQVra/rSzQZkcy8+aiutZNshFHdWBkjh
         vzlIzD6yeoHL4bWZLyAu2pgI0veaaZRiL2JvtezoZkqS7IV67BeX4KgJlI02L6/Qf0se
         bAPM3zLWaa+p2tsmK4xexY41iTiX40x2SrShwsXepuKHA3seMXvLaFxd0UPjnDg1lB87
         kTdbgDuFYDdCl8DmKnpV2zTngRhoXBbdWWfwbBCHVvSgQr63V6Gtnwa9Z7F/yhEu+bod
         1O6fiJLbMLWgsMbQBeL84P2BcMz4THGVuwYfTq6zlH7JBh0mjT7IH9h4yskJ/FxksbDF
         n3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qk53r8eZIG9FM0whVuWdypgVu0JQXb37mXTB0DUalUI=;
        b=gHjmiN79srwj8BVYpg/tfdr35JuUVFxxz9hQhJlUR3TklxMZ5lAO9C1jYCGmBGcxMH
         6cxaEsksQdudvNUTUX40X+eNpIt7a1D+w5Y3XI2GHYrd3dtS19ERPfl2+klDEgJZmmaV
         fp7tXkRnWknfhygyRm6nfMF8GC3la/vNeB6/DuK/0u6+7QweuuX4XDwSmlPmQgpsdrF5
         ybHeIt7WcvAUfAriF/mJdhRi9MiQkPO4wDjVtyj6SvzQnAS7ZnD4WA0n2Bw0tFmugzVJ
         RUPN85Xep5FoptD6UTXXcZjfdeFOGV9bFnIZ62A+M/d5UuFhJhfERWJYuj3AguLhSrW2
         wAGQ==
X-Gm-Message-State: AOAM533P3cr8c1/yNyAQLv2PZdeVyHQNgrRgirSHhniZpqO5XBkzxp4j
        oKcOKtY1B7Xsd9THIJgjF3c=
X-Google-Smtp-Source: ABdhPJzhANg7jLOy4KPxm8prbqIKo50Tjqlaku+8Sc52EIdVBlLwNVNercC+nD9rsJ8pla2dijnC2Q==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr11392455wru.84.1608198392925;
        Thu, 17 Dec 2020 01:46:32 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/9] libtracefs man pages: APIs for working with trace systems and events.
Date:   Thu, 17 Dec 2020 11:46:21 +0200
Message-Id: <20201217094626.1402191-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_event_systems()
tracefs_system_events()
tracefs_iterate_raw_events()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events.txt | 140 ++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100644 Documentation/libtracefs-events.txt

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
new file mode 100644
index 0000000..1fa4674
--- /dev/null
+++ b/Documentation/libtracefs-events.txt
@@ -0,0 +1,140 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_event_systems, tracefs_system_events, tracefs_iterate_raw_events -
+Work with trace systems and events.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+*#include <event-parse.h>*
+
+char pass:[*]pass:[*]*tracefs_event_systems*(const char pass:[*]_tracing_dir_);
+char pass:[*]pass:[*]*tracefs_system_events*(const char pass:[*]_tracing_dir_, const char pass:[*]_system_);
+int *tracefs_iterate_raw_events*(struct tep_handle pass:[*]_tep_, struct tracefs_instance pass:[*]_instance_, cpu_set_t pass:[*]_cpus_, int _cpu_size_, int (pass:[*]_callback_)(struct tep_event pass:[*], struct tep_record pass:[*], int, void pass:[*]), void pass:[*]_callback_context_);
+
+--
+
+DESCRIPTION
+-----------
+Trace systems and events related APIs.
+
+The _tracefs_event_systems()_ function returns array of strings with the
+names of all registered trace systems, located in the given _tracing_dir_
+directory. This could be NULL or tracefs mount point, for trace systems in
+top instance, or full path to a trace instance, for trace systems in that
+instance. The last entry in the array is a NULL pointer. The array must
+be freed with _tracefs_list_free()_ API.
+
+The _tracefs_system_events()_ function returns array of strings with the
+names all registered trace events for given trace system, located in the
+given _tracing_dir_ directory. This could be NULL or tracefs mount point,
+for trace events in top instance, or full path to a trace instance, for
+trace events in that instance. The last entry in the array as a NULL
+pointer. The array must be freed with _tracefs_list_free()_ API.
+
+The _tracefs_iterate_raw_events()_ function iterates through all recorded
+events in the raw trace ring buffer. It requires an initialized _tep_
+handler. The ring buffer being iterated is in the given _instance_, or
+in the top instance if _instance_ is NULL. It can filter events
+for given _cpus_ only, a CPU mask of _cpu_size_ size, or walk through all
+recorded events, if _cpus_ is a NULL pointer. The _callback_ is called for
+every recorded event from the ring buffer. The _callback_context_ parameter
+is passed to the _callback_. Parameters of the _callback_ are _tep_ event
+handler; a pointer to recorded event, _struct tep_record_; the _cpu_ on
+which the event had been happened and the user specified _callback_context_.
+If the _callback_ returns non-zero, the iteration stops.
+
+RETURN VALUE
+------------
+The _tracefs_event_systems()_ and __tracefs_system_events()_ functions return
+an array of strings. The last element in that array is a NULL pointer. The array
+must be freed with _tracefs_list_free()_ API. In case of an error, NULL is returned.
+
+The _tracefs_iterate_raw_events()_ function returns -1 in case of an error or
+0 otherwise.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+#include <event-parse.h>
+
+char **systems = tracefs_event_systems(NULL);
+
+	if (systems) {
+		int i = 0;
+		/* Got registered trace systems from the top trace instance */
+		while (systems[i]) {
+			char **events = tracefs_system_events(NULL, systems[i]);
+			if (events) {
+				/* Got registered events in system[i] from the top trace instance */
+				int j = 0;
+
+				while (events[j]) {
+					/* Got event[j] in system[i] from the top trace instance */
+					j++;
+				}
+				tracefs_list_free(events);
+			}
+			i++;
+		}
+		tracefs_list_free(systems);
+	}
+....
+static int records_walk(struct tep_event *tep, struct tep_record *record, int cpu, void *context)
+{
+	/* Got recorded event on cpu */
+	return 0;
+}
+...
+struct tep_event *tep = tracefs_local_events(NULL);
+
+	if (!tep) {
+		/* Failed to initialise tep handler with local events */
+		...
+	}
+	if (tracefs_iterate_raw_events(tep, NULL, NULL, 0, records_walk, NULL) < 0) {
+		/* Error walking through the recorded raw events */
+	}
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

