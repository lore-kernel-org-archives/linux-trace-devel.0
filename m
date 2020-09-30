Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9CBC4727E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF0920659
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvLdxP7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgI3LUj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 07:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgI3LUj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 07:20:39 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E1FC061755;
        Wed, 30 Sep 2020 04:20:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so1364916wrm.2;
        Wed, 30 Sep 2020 04:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWakhOKPKz2znU9O5s7AkKsRQAEAed3GLRNCcxW+1kw=;
        b=MvLdxP7qR07tHcwn/U9tovrPst13k0lc4hWyk0Zadwzu11NUatr5+T2KdXMqg66zsF
         2Ob9GvxRo2dUuGEnoOQVAzgRaHP6OJCAOaZGFwzgT1h2dEzonad/ac7MwuR8n8Xp16v3
         DAcPiZn+RxTfwG/4llBL5s8Mk/M5Ttzp9UYdzTYVPtGHPsGdRwOKYRHrMCFF0L6M5Y8U
         D6YSXAcRi7IF6Y/5J8MGe6PE9Fy7vo9S4Gm1GCf3r7U6nt/Y9V6rzvAsxX9yxAyuZZR8
         rV/P9tB5iGhndalpDI8lp1jmDWgrfoP6nE93Egf8mePpqilJI0X51NtvWg6ktbI8RhRh
         7ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aWakhOKPKz2znU9O5s7AkKsRQAEAed3GLRNCcxW+1kw=;
        b=XnSlKl/nbc+TRvcKA/jGkepTkHHOW1QUkArETzW1EG5b1VImo7bB+2qtBcXq5IjCE9
         zK7WBucrA8x4zoqioKkpNxR090zKC1387In84CygRTENs7Xtdy5gjK+fyRB5I1fnJ4lj
         QXjh98sdEKuUByCuJHsOzzQBKinaR00kEkLdi/BG1QbieOijFBU5xYxI6UzdL07NRYTe
         W4047iCMtJACyGcUAtJaiJjuCj/iAJrMX4JZt4Gyi4WvwbRhWKpFCRhXK6vFnCfJ3I4P
         Hcv9/rz7DvFeEKuN+ZEY3TcV/QU3e4sAik+J0XQsg8WZ6+VFKqlruEY9Iel1uGiyDZPq
         8JYg==
X-Gm-Message-State: AOAM530BgD9zSD8bJwHKlotTZnSH6SbwZ+ZdiNQFzgCiVKGbGBjZgmnB
        IrkGN3pUezNszgCOhDviq/g=
X-Google-Smtp-Source: ABdhPJxWbuEkKLpDBnEhzMLnI+C16F+pwjR4st/g8a0IWVUiWgawaAI/yqL9f57WMcejjFi/kFzqtg==
X-Received: by 2002:a5d:40c4:: with SMTP id b4mr2583546wrq.151.1601464837599;
        Wed, 30 Sep 2020 04:20:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k6sm2195594wmf.30.2020.09.30.04.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 04:20:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     arnaldo.melo@gmail.com
Cc:     rostedt@goodmis.org, mtk.manpages@gmail.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] tools lib traceevent: Man page libtraceevent debug APIs
Date:   Wed, 30 Sep 2020 14:20:35 +0300
Message-Id: <20200930112035.282039-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add a new libtraceevent man page with documentation of these debug APIs:
 	 tep_print_printk
 	 tep_print_funcs
	 tep_set_test_filters
	 tep_plugin_print_options

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Removed an extra interval from the example's code.

 .../Documentation/libtraceevent-debug.txt     | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-debug.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-debug.txt b/tools/lib/traceevent/Documentation/libtraceevent-debug.txt
new file mode 100644
index 000000000000..a0be84fe8990
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-debug.txt
@@ -0,0 +1,95 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_print_printk, tep_print_funcs, tep_set_test_filters, tep_plugin_print_options -
+Print libtraceevent internal information.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+*#include <trace-seq.h>*
+
+void *tep_print_printk*(struct tep_handle pass:[*]tep);
+void *tep_print_funcs*(struct tep_handle pass:[*]tep);
+void *tep_set_test_filters*(struct tep_handle pass:[*]tep, int test_filters);
+void *tep_plugin_print_options*(struct trace_seq pass:[*]s);
+--
+
+DESCRIPTION
+-----------
+The _tep_print_printk()_ function prints the printk string formats that were
+stored for this tracing session. The _tep_ argument is trace event parser context.
+
+The _tep_print_funcs()_ function prints the stored function name to address mapping
+for this tracing session. The _tep_ argument is trace event parser context.
+
+The _tep_set_test_filters()_ function sets a flag to test a filter string. If this
+flag is set, when _tep_filter_add_filter_str()_ API as called, it will print the filter
+string instead of adding it. The _tep_ argument is trace event parser context.
+The _test_filters_ argument is the test flag that will be set.
+
+The _tep_plugin_print_options()_ function writes a list of the registered plugin options
+into _s_.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+#include <trace-seq.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_print_printk(tep);
+...
+	tep_print_funcs(tep);
+...
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+	tep_set_test_filters(tep, 1);
+	tep_filter_add_filter_str(filter, "sched/sched_wakeup:target_cpu==1");
+	tep_set_test_filters(tep, 0);
+	tep_filter_free(filter);
+...
+struct trace_seq seq;
+trace_seq_init(&seq);
+
+	tep_plugin_print_options(&s);
+...
+--
+
+FILES
+-----
+[verse]
+--
+*event-parse.h*
+	Header file to include in order to have access to the library APIs.
+*-ltraceevent*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+_libtraceevent(3)_, _trace-cmd(1)_
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtraceevent is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.26.2

