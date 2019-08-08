Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1D1C433FF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC0B216C8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 11:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dCFeKn+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfHHLgo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 07:36:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43777 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHHLgo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 07:36:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so19994866wru.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Aug 2019 04:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KkvZZy5tO7vCjrFbOhlHvCU9wUl90F3cOFKuCFd4cPw=;
        b=dCFeKn+DraQyKqzgbHKRglme0UJqj4ZDku4usntgdq9MFVDPRY0+tmXwwBoGdYfpy4
         IxgSsY4qVRVOpLfxjwNexIokh/zDuTon8c2cBgMu+QyTnD1uWbIJKrJTxlY4L7JB+b1g
         DTpAGrLsBZ6Twx9S3+GfRQOYQbZqxgJyJKwccub/D9vvXAuvOqlFOWBrEAK3LLYw0JYJ
         AVKoH22uaOPXptk7fuOXTzu5PXN+2LM8FC9HsH2VePlcBqa2a1EnSyWVSBMrWv9td2Wi
         mRKMjWFBA9ajUcNYxfZ8bMXkSbbR9FnbfsoUSJxzcFC5A5qG+vxm9HuLybP+s8yWjX7q
         4YXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KkvZZy5tO7vCjrFbOhlHvCU9wUl90F3cOFKuCFd4cPw=;
        b=D0lahCSbQqmRS8qhe8E2lMfW24Ah74kEnAOL3xhjHtW6VkdYWVjcC/ktdEOVPnwl/z
         W7LV3ye2lBz+r4XcAkkI65oWE7Wjw93kuApbOgm9zFCPUpNSRKafFJ4fPkNJfBpwBu0G
         dv5af+7r2LlTuOap1h/WBzzC9++MrJTTcBoXtWCB98T+KOG6YPY/DFsy4zCAOXjb33QN
         npcOT6oGj2eAaqWFKAYYTvku8a0GP0eUtbCvRrUwhrCPLkzxDlDppM9OmouYbeNs1Z/m
         7XPra12qnIjDFyqbOTTTG4sJnAx++TfrQc8LzznB1RJ7qx/R+n7boDni5I88myHjl6HB
         MKag==
X-Gm-Message-State: APjAAAVv8Mp+tES090zFV3WV1HIMCO+5pVb8MqIvcGp8XfbuWPiOYPYR
        zkmbyJc4s0m9ylBtenmm/Fc=
X-Google-Smtp-Source: APXvYqz/rml805Yh69vZIg2jwiMT3TkbO6pm7T6W+A/l5EGUogMJ/ZfGzDqYTxj9/KGicIKZAahc5g==
X-Received: by 2002:adf:8183:: with SMTP id 3mr16663688wra.181.1565264200882;
        Thu, 08 Aug 2019 04:36:40 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l16sm5127992wrt.31.2019.08.08.04.36.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 04:36:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] tools/lib/traceevent: Man pages fix, changes in event printing APIs
Date:   Thu,  8 Aug 2019 14:36:36 +0300
Message-Id: <20190808113636.13299-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808113636.13299-1-tz.stoyanov@gmail.com>
References: <20190808113636.13299-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

APIs for printing various trace event information were redesigned to
be more simple. However, the main libtraceevent man page was not updated
with those changes. The documentation is updated to describe the new
event print API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../libtraceevent-latency_format.txt          | 154 ------------------
 .../Documentation/libtraceevent.txt           |  13 +-
 2 files changed, 1 insertion(+), 166 deletions(-)
 delete mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
deleted file mode 100644
index 3a3c9e9866ec..000000000000
--- a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
+++ /dev/null
@@ -1,154 +0,0 @@
-libtraceevent(3)
-================
-
-NAME
-----
-tep_set_latency_format, tep_is_latency_format, tep_data_latency_format -
-"latency output" format APIs.
-
-SYNOPSIS
---------
-[verse]
---
-*#include <event-parse.h>*
-
-void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
-bool *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
-void *tep_data_latency_format*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
-
---
-
-DESCRIPTION
------------
-"Latency output" format prints information about interrupts being disabled,
-soft irq being disabled, the "need_resched" flag being set and preempt count.
-This information is recorded with every event, but by default is not printed.
-
-The _tep_set_latency_format()_ function enables the "latency output" printing.
-The _tep_ argument is trace event parser context. The _lat_ argument can be
-zero, for "latency output" disabled, or non zero for "latency output" enabled.
-Information is displayed with 6 characters. When a field is zero, or N/A,
-a pass:['.'] is printed. Example:
-[verse]
---
-  <idle>-0       0d.h1 106467.859747: function:    ktime_get <-- tick_check_idle
---
-The 0d.h1. denotes this information. The first character is never a pass:['.']
-and represents what CPU the trace was recorded on (CPU 0). The pass:['d']
-denotes that interrupts were disabled. The pass:['.'] is "need_resched" flag.
-If it is set, the character ['N'] would be displayed. The pass:['h'] means that
-this was called inside an interrupt handler. The pass:['1'] is the preemption
-disabled (preempt_count) was set to one. See 'LATENCY FORMAT' section.
-
-The _tep_is_latency_format()_ function gets if "latency output" is enabled.
-
-The _tep_data_latency_format()_ function parses out the latency format from
-_record_ and writes it into _s_. The _tep_ argument is the trace event parser
-context.
-
-This "Latency output" setting affects output of _tep_print_event_task()_
-and _tep_print_event_time()_ APIs.
-
-LATENCY FORMAT
---------------
-The latency format displays 5 or more fields:
-[verse]
---
-CPU #, interrupt state, scheduling state, current context, and preemption count.
-
-Field 1 is the CPU number (starting with zero).
-
-Field 2 is the interrupt enabled state:
-  d : Interrupts are disabled
-  . : Interrupts are enabled
-  X : The architecture does not support this information
-
-Field 3 is the "need resched" state.
-  N : The task is set to call the scheduler when possible, as another
-      higher priority task may need to be scheduled in.
-  . : The task is not set to call the scheduler.
-
-Field 4 is the context state.
-  . : Normal context
-  s : Soft interrupt context
-  h : Hard interrupt context
-  H : Hard interrupt context which triggered during soft interrupt context.
-  z : NMI context
-  Z : NMI context which triggered during hard interrupt context
-
-Field 5 is the preemption count.
-  . : The preempt count is zero.
-
-  On preemptible kernels (where the task can be scheduled out in
-  arbitrary locations while in kernel context), The preempt count,
-  when non zero, will prevent the kernel from scheduling out the
-  current task. The preempt count number is displayed when it is not
-  zero.
---
-Depending on the kernel, it may show other fields (lock depth,
-or migration disabled, which are unique to specialized kernels).
-
-RETURN VALUE
-------------
-
-The _tep_is_latency_format()_ function returns true if "latency output"
-is enabled, or false if it is disabled.
-
-EXAMPLE
--------
-[source,c]
---
-#include <event-parse.h>
-...
-struct tep_handle *tep = tep_alloc();
-struct trace_seq seq;
-trace_seq_init(&seq);
-...
-	tep_set_latency_format(tep, 1);
-...
-	if (tep_is_latency_format(tep)) {
-		/* latency output format is enabled */
-	} else {
-		/* latency output format is disabled */
-	}
-...
-void process_record(struct tep_record *record)
-{
-	/* Write latency information in seq */
-	tep_data_latency_format(tep, &seq, record);
-}
---
-
-FILES
------
-[verse]
---
-*event-parse.h*
-	Header file to include in order to have access to the library APIs.
-*-ltraceevent*
-	Linker switch to add when building a program that uses the library.
---
-
-SEE ALSO
---------
-_libtraceevent(3)_, _trace-cmd(1)_, tep_print_event_task(3),
-tep_print_event_time(3)
-
-AUTHOR
-------
-[verse]
---
-*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
-*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
---
-REPORTING BUGS
---------------
-Report bugs to  <linux-trace-devel@vger.kernel.org>
-
-LICENSE
--------
-libtraceevent is Free Software licensed under the GNU LGPL 2.1
-
-RESOURCES
----------
-https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/lib/traceevent/Documentation/libtraceevent.txt
index 7a3310168ef6..ad36939aef50 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -26,15 +26,12 @@ Management of tep handler data structure and access of its members:
 	void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
 	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
-	bool *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
-	void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
 	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
 	int *tep_strerror*(struct tep_handle pass:[*]_tep_, enum tep_errno _errnum_, char pass:[*]_buf_, size_t _buflen_);
 
 Register / unregister APIs:
-	int *tep_register_trace_clock*(struct tep_handle pass:[*]_tep_, const char pass:[*]_trace_clock_);
 	int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
 	int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
 	int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
@@ -57,14 +54,7 @@ Event related APIs:
 	int *tep_get_events_count*(struct tep_handle pass:[*]_tep_);
 	struct tep_event pass:[*]pass:[*]*tep_list_events*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
 	struct tep_event pass:[*]pass:[*]*tep_list_events_copy*(struct tep_handle pass:[*]_tep_, enum tep_event_sort_type _sort_type_);
-
-Event printing:
-	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, bool _use_trace_clock_);
-	void *tep_print_event_data*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_event_info*(struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_print_event_task*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]_record_);
-	void *tep_print_event_time*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_event pass:[*]_event_, struct tep_record pass:[*]record, bool _use_trace_clock_);
-	void *tep_set_print_raw*(struct tep_handle pass:[*]_tep_, int _print_raw_);
+	void *tep_print_event*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_, const char pass:[*]_fmt_, _..._);
 
 Event finding:
 	struct tep_event pass:[*]*tep_find_event*(struct tep_handle pass:[*]_tep_, int _id_);
@@ -116,7 +106,6 @@ Filter management:
 	int *tep_filter_compare*(struct tep_event_filter pass:[*]_filter1_, struct tep_event_filter pass:[*]_filter2_);
 
 Parsing various data from the records:
-	void *tep_data_latency_format*(struct tep_handle pass:[*]_tep_, struct trace_seq pass:[*]_s_, struct tep_record pass:[*]_record_);
 	int *tep_data_type*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
 	int *tep_data_pid*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
 	int *tep_data_preempt_count*(struct tep_handle pass:[*]_tep_, struct tep_record pass:[*]_rec_);
-- 
2.21.0

