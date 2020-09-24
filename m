Return-Path: <SRS0=Qydk=DB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DB7C4346E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 08:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F862376F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 08:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vRiU3Ixv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgIXI5j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Sep 2020 04:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIXI5j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Sep 2020 04:57:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B907BC0613CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 01:57:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so2729684wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 01:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w90kD4riP0Fuf2IH9074v4Qu8q9n8nKw3Ed4EsETaIs=;
        b=vRiU3IxvOYPVGh3eAEc8CkT8i3+FX96uMAO6Qp5cKQo9O1JhEk1lU2uwa3Qb29ft9B
         j6XGY8rPwBhJ8TcHOCmigIqIP4crkBGpwNC+hGJGwejqMnLmxTOFUb0/GmPURe4EpnwS
         Fssanq5wcEVS07q+KFmC0KGOjfsFOweK8pu3LBLj5nVTJbpg5uu4bZMPPrhsRTx+WoaY
         +qopfORnRbGR1bh472ALQl+Mbvf6BPwlIwYrryumGMrJzF61S15P1d/Wx65DcuGG5lcK
         RSXM5zOKtw0ri8lmrzqD4ODQwijjKSNe4x4quFhPZy68Jpvcj25s/9NrjykFOwf9yMUO
         T7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w90kD4riP0Fuf2IH9074v4Qu8q9n8nKw3Ed4EsETaIs=;
        b=q2CpK7NfHrORvfzNe7SEmeYk1DjhiTQ2AUCOL226t1eLCP+i9bJ1OoSTDyMpVMxXYd
         ipMMwdiN/kP0JkeX5z18sdV/pEZsyaQ6AUE3m9EQS4xplvBx0EHPZS9+Q/xaBnrZpC2Y
         eo0h0AN+cAoq9Ao7FSCJzSrbauoxYZhsghvKCE7FsJmB3xNteE9u6emtClPjtxSr6iS9
         7RGL52BpRCF3JlcaeQ345QttbKTs1DmiI7WJD4vWC4hnnSW7QSHZ/lLyACjTB6ip2hEj
         iIbM0CuEuNenNNM1wkCPhBxzcMk34Li3WmIAe4YfXjv26A2QEuQ30e7AzwZJWjBGvpuj
         juMg==
X-Gm-Message-State: AOAM531rbccU26xOpJja7xDiNly5euhzDrsZzyDM6hCrynSGDSlfCA70
        Gq8RYYbcZn3u3WGKulwWL0d8sPsA553dWw==
X-Google-Smtp-Source: ABdhPJy132A+psIOBImOiVVR8BgtNNGxqsdSK3t+s6xO6fSkFKHuVjk6dnPzcj6coaThf6VEbeS/cg==
X-Received: by 2002:a1c:3d06:: with SMTP id k6mr3578744wma.27.1600937857382;
        Thu, 24 Sep 2020 01:57:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y5sm2762030wrh.6.2020.09.24.01.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 01:57:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] tools lib traceevent: Man page libtraceevent debug APIs
Date:   Thu, 24 Sep 2020 11:57:35 +0300
Message-Id: <20200924085735.112822-1-tz.stoyanov@gmail.com>
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

