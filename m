Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E59C4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52AB723603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgLQJrB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbgLQJrA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A77EC0611CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t16so25891548wra.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HUU1Jh6FSWY9JTBNdVV/FN25lvc1+FDVD1OMUo4JEl8=;
        b=DDTW+gNKZ6cLBW38x8X7qZnr1H/cPB/IswsUOyFGtX0JVZA0+nRblP7dZQAiVRPA6h
         ahZl7NdBDESRmfkvW5oL1sNEVh96ITe66rkUMu/tmUlxwz8VupaUl1bp0i/oSEyVqvPT
         iY85UC7ofYb/P4JMbfTKcqEv6MwXYidH8U4FAp1ytcC0GUZM6tTed3j/l15NmxfTnGnB
         AYV1QQtCyzq9A4QuBk3mtcTLoean7iQ2xhaa1FTgWStE7g+LQ3JVdIAxVUyUL1WnucDK
         cCX+jdcX1WBHRnh8sWls6MFdJdbQFnTh9YXi26InDeLKMtDeDAG+/nfRdxU8wUAP6jT9
         M8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HUU1Jh6FSWY9JTBNdVV/FN25lvc1+FDVD1OMUo4JEl8=;
        b=WBFnjaOaeFl1uP7VXRXJHfKkeMH2QSOwOOvxwXu2PtpnBEJ/RS2vUumdAmy3uKPe89
         s26SfXS8WRmyi7HaP5LrL/z1z/N1eWyvRwMBgmoaUCoFuNmPKPrBC5FDQx8iloMcmaah
         FadVPUEQRAeG1Fv6eBx0r3meaFZq0aa47rkKsHRzSDAq+d5SUUtT8HW6irIHNptAzyQD
         a6ZdcYHGX+Jzcw9GI9wlJyTs2iNu9DUEDp4EjE4ha/NKTbNqzIZWWNydf0Ifdo5A3MJ5
         v/Zv9L+AAc0Gyso7Zpmxc9PLNGjFIfK33SX0CFJZrzahSJ2Uyoy3+SUNNIBVBFyIAsrX
         F4Cw==
X-Gm-Message-State: AOAM531IyKdJSGrBYyvUdpSNsaEiCkevmOjtLFCi3pK9zZcYeFDZcRTp
        4+1GC2jSctcrxEVP0XiS65zssMUnmfTCGQ==
X-Google-Smtp-Source: ABdhPJwbOps6UKkqjGLy4IUWvu52Z8P9UVKDzstWUkPimklCM8F2qU0bDQsLWATiKQHQvlvuNxJuMg==
X-Received: by 2002:adf:ba46:: with SMTP id t6mr43025395wrg.168.1608198398357;
        Thu, 17 Dec 2020 01:46:38 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 9/9] libtracefs man pages: helper APIs for working with trace file system.
Date:   Thu, 17 Dec 2020 11:46:26 +0200
Message-Id: <20201217094626.1402191-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
References: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented APIs:
tracefs_tracers()
tracefs_get_clock()
tracefs_list_free()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-utils.txt | 103 +++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)
 create mode 100644 Documentation/libtracefs-utils.txt

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
new file mode 100644
index 0000000..86dd754
--- /dev/null
+++ b/Documentation/libtracefs-utils.txt
@@ -0,0 +1,103 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_tracers, tracefs_get_clock, tracefs_list_free -
+Helper functions for working with trace file system.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
+char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
+void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+--
+
+DESCRIPTION
+-----------
+Various useful functions for working with trace file system.
+
+The _tracefs_tracers()_ function returns array of strings with the
+names of supported tracer plugins, located in the given _tracing_dir_ directory.
+This could be NULL or tracefs mount point, for trace systems in top instance,
+or full path to a trace instance, for trace systems in that instance.
+The last entry in the array as a NULL pointer. The array must
+be freed with _tracefs_list_free()_ API.
+
+The _tracefs_get_clock()_ function returns name of the current trace clock,
+used in the given _instance_. If _instance_ is NULL, the clock of the main
+trace instance is returned. The returned string must be freed with free().
+
+The _tracefs_list_free()_ function frees an array of strings, returned by
+_tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
+APIs.
+
+RETURN VALUE
+------------
+The _tracefs_tracers()_ returns array of strings. The last element in that
+array is a NULL pointer. The array must be freed with _tracefs_list_free()_ API.
+In case of an error, NULL is returned.
+
+The _tracefs_get_clock()_ returns string, that must be freed with free(), or NULL
+in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <tracefs.h>
+
+char **tracers = tracefs_tracers(NULL);
+
+	if (tracers) {
+		/* Got tracer plugins from the top trace instance */
+		...
+		tracefs_list_free(tracers);
+	}
+....
+char *clock = tracefs_get_clock(NULL);
+
+	if (clock) {
+		/* Got current trace clock of the top trace instance */
+		...
+		free(clock);
+	}
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

