Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7267C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F364208B8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lamdBrN+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgI2Rgt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Rgt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 13:36:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E56C061755;
        Tue, 29 Sep 2020 10:36:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so6335069wrm.9;
        Tue, 29 Sep 2020 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w90kD4riP0Fuf2IH9074v4Qu8q9n8nKw3Ed4EsETaIs=;
        b=lamdBrN+/ud0H6jv/YrRe61BDdQrbbbu5KF25h4zCNY6Qcopz/vs1rEHFawcceNf2D
         7oXW3oD76OLS9F2TGNMjEp60ZC+cfhiW6+aR0stjkyb7NTsz1/wH+yNr7mXZ11sk/++I
         O1PfRRQhlBm9iPx7kydLwLsHSbvDA7VJmQ8e5JQmoZu3kCoV8kfo0YHy2QjxluxUrVhK
         OptKczWQKzELCMFsqMmdASOXmUOWp6O8IpnEw3CwqyI8w4aX8R2uzldxJAqEsinq1ynU
         kAU9RltA1J33mZhyRB5aCSF2HkXsfUX4fyF4UlqYFc8AadXCjL5OH8kndJs9OS4m+pK8
         Mcjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w90kD4riP0Fuf2IH9074v4Qu8q9n8nKw3Ed4EsETaIs=;
        b=UUnUXIz4dAwfu2oFbTv/vlA48ZftrXUmIOJ9J1i3VYB1FiYTgOQpTv55Ke5VoKi/JH
         jakuWa1xNltX/RaPnoH46YGgW60kAwKJARXHQZHkAkiiM7nPagPaWc/EFUu0IqkVgbw+
         EIKV/pyy+JCTMqFG1yi3q6fTzjVU+UMpB7Vbm0QpFBe6JAldLFTX2ci9oSJ02/fNWG1P
         88M0trRxZqY3bkGHVCu3GiHGZHPAjz96WJ5Pf6s4kN8U2LSBaMDR8A11qgqwtTrS+pja
         5/PW3Wz0B7vIv+TW03ME98W4ICpdhw0I/UxIgPjQ9m6/YRSvzz/O1DyA9KbdPxlxQdJF
         XjvA==
X-Gm-Message-State: AOAM532lXUamS6xokLW5zMvpDUYttbAUIBLWwDqabhAHjjmPf5ocHtGz
        ITtkOZXkA66vuSLlnahMAu6XeIn3bGHw6unB
X-Google-Smtp-Source: ABdhPJxMFj1e/9H64nWtgJoqJN+fK8Ka4MfP3dN+OO0impoEun9+Y76Dtd6SU7Ad+q6BO/31lSUzZw==
X-Received: by 2002:adf:f6c2:: with SMTP id y2mr5489885wrp.79.1601401007937;
        Tue, 29 Sep 2020 10:36:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x16sm7070548wrq.62.2020.09.29.10.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:36:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     arnaldo.melo@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tools lib traceevent: Man page libtraceevent debug APIs
Date:   Tue, 29 Sep 2020 20:36:46 +0300
Message-Id: <20200929173646.252163-1-tz.stoyanov@gmail.com>
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
 .../Documentation/libtraceevent-debug.txt     | 95 +++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-debug.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-debug.txt b/tools/lib/traceevent/Documentation/libtraceevent-debug.txt
new file mode 100644
index 000000000000..9a2d1ffa2d72
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
+	tep_filter_add_filter_str(filter, "sche	d/sched_wakeup:target_cpu==1");
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

