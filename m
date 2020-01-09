Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BD0C33CA2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2F7A2077C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p7X/skZ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41469 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730340AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: by mail-lj1-f193.google.com with SMTP id h23so6978837ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 04:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qh5OJ58j/xGpt4o52/IIucscDGfISOxmHiEJhmuRDJg=;
        b=p7X/skZ+2jImK29lSzJikAZANCeWayq74EHm8RyNBwUpDse+PvKWYGVkldwb2ExxfK
         L2PAeGsRsX0WtocKs8kbH5HBcmK0bHsOH9zldBh0004kfp1J03bSSWVcrhxOPZYjZrSn
         LVCrNZOajTDazmjRM69mQUHyV4zi2oNnRewfafMNeIDazoyGuSmXBLweZqFDYpXBGW39
         weDtbgLulBZeJ5yMYyPNhxEuSKaoiT72QtDwP9h4on+MJ3IbjJLDU3mxXqk6rGO0NiIu
         SpSEHiWc2fGeA4Ocz2uBziAEDB7H91Hs2TQDmVDsCdRHeDEOq9XO91+3ab1ht1vm7u1j
         PHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qh5OJ58j/xGpt4o52/IIucscDGfISOxmHiEJhmuRDJg=;
        b=Y54qhPx96RtB/6HQ9R7Dn+FEktP/44BB3ERgFOj0SruAnKiXmczqQEAqYAKrVkwH3F
         PGMqdTcdlwIdxqNQ43Y3RI1Mu9P1Msgkd3reR/AtX/BlwcZukGWxuuY/OdaqKS+zILvv
         fcGL0/OZu5hgfBTWQYGuI8ugPuVemCbY7mexBmIpXusR1Q1Clq8vCQBzLb78QPzLSk2x
         5X9ty0hziUBrO4ajgapLBw+qqE5QkAX0vzhPPbkBF+fGFHy71ZwpOvmDhRm0uDaSE3Hd
         6xf2NQjFYO6KytYAC3GVDcEbZufI8UMyCo/OgfYaSQULwNHcgTlbX5A81MsrSs9jbv6B
         pnEg==
X-Gm-Message-State: APjAAAX4t70teHQf0u230BqDHFzPrIyXE+1BXYj8mPgxUbyeSnSIWpyB
        sY02hOUq2MewL1bllch6P2U0A+Fvalg=
X-Google-Smtp-Source: APXvYqxguUhjsupOl8rN8Kzqx3+RByGLh2InnV9kzwe90k9St5cIQiJnofN8GmA/99ew9X/JwaF5ZA==
X-Received: by 2002:a2e:814e:: with SMTP id t14mr6060301ljg.149.1578572461289;
        Thu, 09 Jan 2020 04:21:01 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f16sm2877251ljn.17.2020.01.09.04.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:21:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Man page of "trace-cmd dump" sub-command
Date:   Thu,  9 Jan 2020 14:20:54 +0200
Message-Id: <20200109122055.286290-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109122055.286290-1-tz.stoyanov@gmail.com>
References: <20200109122055.286290-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The man page describes all options and use cases of
"trace-cmd dump" sub-command

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-dump.1.txt | 132 +++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)
 create mode 100644 Documentation/trace-cmd-dump.1.txt

diff --git a/Documentation/trace-cmd-dump.1.txt b/Documentation/trace-cmd-dump.1.txt
new file mode 100644
index 0000000..9c36779
--- /dev/null
+++ b/Documentation/trace-cmd-dump.1.txt
@@ -0,0 +1,132 @@
+TRACE-CMD-DUMP(1)
+===================
+
+NAME
+----
+trace-cmd-dump - show a meta data from a trace file, created by trace-cmd record
+
+SYNOPSIS
+--------
+*trace-cmd dump* ['OPTIONS'] ['input-file']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) dump command will display the meta data from a trace file
+created by trace-cmd record.
+
+OPTIONS
+-------
+*-i* 'input-file'::
+    By default, trace-cmd dump will read the file 'trace.dat'. But the *-i*
+    option open up the given 'input-file' instead. Note, the input file may
+    also be specified as the last item on the command line.
+*-v*, *--validate*::
+    Check if the input file is a valid trace file, created by trace-cmd.
+*--summary*::
+    Print a meta data summary - initial format and a short description of each
+    file section. This is the default action, if no arguments are specified.
+*--head-page*::
+    Print the header page information, stored in the file.
+*--head-event*::
+    Print the event header information, stored in the file.
+*--ftrace-events*::
+    Print formats of ftrace specific events.
+*--systems*::
+    Print information of event systems, stored in the file - name and number of
+    events for each system.
+*--events*::
+    Print formats of all events, stored in the file.
+*--kallsyms*::
+    Print information of the mapping of function addresses to the function names.
+*--printk*::
+    Print trace_printk() format strings, stored in the file.
+*--cmd-lines*::
+    Print mapping a PID to a process name.
+*--options*::
+    Print all options, stored in the file.
+*--flyrecord*::
+    Print the offset and the size of tracing data per each CPU.
+*--all*::
+    Print all meta data from the file.
+*--help*::
+    Print usage information.
+
+EXAMPLES
+--------
+
+# trace-cmd dump --summary -i trace.dat
+
+ Tracing meta data in file trace.dat:
+	[Initial format]
+		6	[Version]
+		0	[Little endian]
+		8	[Bytes in a long]
+		4096	[Page size, bytes]
+	[Header info, 205 bytes]
+	[Header event, 205 bytes]
+	[Ftrace format, 15 events]
+	[Events format, 2 systems]
+	[Kallsyms, 7144493 bytes]
+	[Trace printk, 2131 bytes]
+	[Saved command lines, 117 bytes]
+	8 [CPUs with tracing data]
+	[12 options]
+	[Flyrecord tracing data]
+------------------------------------------
+
+# trace-cmd dump --flyrecord -i trace.dat
+	[Flyrecord tracing data]
+		 7176192 0	[offset, size of cpu 0]
+		 7176192 0	[offset, size of cpu 1]
+		 7176192 0	[offset, size of cpu 2]
+		 7176192 4096	[offset, size of cpu 3]
+		 7180288 4096	[offset, size of cpu 4]
+		 7184384 0	[offset, size of cpu 5]
+		 7184384 0	[offset, size of cpu 6]
+		 7184384 0	[offset, size of cpu 7]
+------------------------------------------
+
+# trace-cmd dump --summary --systems -i trace.dat
+
+ Tracing meta data in file trace.dat:
+	[Initial format]
+		6	[Version]
+		0	[Little endian]
+		8	[Bytes in a long]
+		4096	[Page size, bytes]
+	[Header info, 205 bytes]
+	[Header event, 205 bytes]
+	[Ftrace format, 15 events]
+	[Events format, 3 systems]
+		sched 23 [system, events]
+		irq 5 [system, events]
+		kvm 70 [system, events]
+	[Kallsyms, 7144493 bytes]
+	[Trace printk, 2131 bytes]
+	[Saved command lines, 157 bytes]
+	8 [CPUs with tracing data]
+	[11 options]
+	[Flyrecord tracing data]
+------------------------------------------
+
+# trace-cmd dump --summary --systems -i trace.dat
+File trace.dat is a valid trace-cmd file
+------------------------------------------
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd.dat(1)
+
+AUTHOR
+------
+*Steven Rostedt* <rostedt@goodmis.org>, author of *trace-cmd*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+
+RESOURCES
+---------
+git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
-- 
2.24.1

