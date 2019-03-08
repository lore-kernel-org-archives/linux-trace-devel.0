Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E52C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FA002087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfCHNhZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45929 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfCHNhZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id o7so1293933wrp.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wh6TRkpAyO1kZo2dHBmbbrZh1XfT6EtR+AMfSgR1Vw8=;
        b=o7CTx1E9Boqbu35gcKy1RkgHYJJ4bHL5ywIjkx51f8T27XFVWAg81zC9/5lcLb08X/
         5uskZ1c39mA15qkdPXh+Kt7+jOJ8nt9bin55N7Ieh92D9mm2l9pb6lX28RvrMbU1YDDP
         sOq2fnnahx3bpIjJtwGkqC2oGKzelnVKCUkEztakF+iE3m+EoPSHEYaW1CNBftScRo+o
         Vxfqa0QTMLIJOo7tmaZ75SWogZWGjf90YBN+TAzM/fU+Egp4XyjnShR0n461kjLk9zN0
         eTdfFULJNx1TXY5LW5TjpMMhZ1ay39J2w5rFRdr5FDhcdipnqTKEDjdMKmpzQg8ziJMD
         NlAw==
X-Gm-Message-State: APjAAAWAxRT1YanMAp67oRTXpeugHL2CkzwKOmPWrr7e3ppZiN/r/0Ij
        hTAM6rt4SH6GshQYGfQsVw6A0pMy
X-Google-Smtp-Source: APXvYqxXe+7uUpcXIG+3Kd4HF1Hkwg+i9CAMC556/mmoY29eigA5XyOS+Sz5/iP1zT/HatvA5w72kw==
X-Received: by 2002:adf:f40d:: with SMTP id g13mr10948002wro.18.1552052243542;
        Fri, 08 Mar 2019 05:37:23 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:22 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 28/46] tools/lib/traceevent: Man page for tep_filter_add_filter_str()
Date:   Fri,  8 Mar 2019 15:36:36 +0200
Message-Id: <20190308133654.21264-29-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man page for tep_filter_add_filter_str()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-filter_add.txt              | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt b/tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt
new file mode 100644
index 000000000000..5b8f67e406b2
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-filter_add.txt
@@ -0,0 +1,78 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_filter_add_filter_str - Adds a new rule to a filter.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+enum tep_errno *tep_filter_add_filter_str*(struct tep_event_filter pass:[*]_filter_, const char pass:[*]_filter_str_);
+--
+
+DESCRIPTION
+-----------
+The _tep_filter_add_filter_str()_ function adds a new rule to the _filter_. The
+_filter_str_ argument is the filter string, that contains the rule.
+
+RETURN VALUE
+------------
+The _tep_filter_add_filter_str()_ function returns 0 if the rule was
+successfully added or a negative error code.  Use _tep_filter_strerror()_ to see
+actual error message in case of an error.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+struct tep_event_filter *filter = tep_filter_alloc(tep);
+...
+int ret;
+char errstr[200];
+ret = tep_filter_add_filter_str(filter, "sched/sched_wakeup:target_cpu==1");
+if(ret < 0) {
+	tep_filter_strerror(filter, ret, errstr, sizeof(errstr));
+	/* Failed to add a new rule to the filter, the error string is in errstr */
+}
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
+_libtraceevent(3)_, _trace-cmd(1)_, _tep_filter_strerror(3)_
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
2.20.1

