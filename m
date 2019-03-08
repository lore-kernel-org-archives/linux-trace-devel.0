Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD2BC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A15C2087C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfCHNhJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:37:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53910 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfCHNhJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:37:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id e74so12566363wmg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:37:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+1D0rjAi1cZiOqo1mIduUIu3Cyi19E08jFbilxQE2w=;
        b=hfkF/Cjc9Bs6li8jSCIODJazAESY8WRXUz0vSq+g+vucnH6m1SeTlJNmSugV3N8be8
         qXK35N9YarMpWJBFmUQYif5KUwdO6sQ+H6BntXzrQqBgbfSP1pr2DTX9dYWnZGJOlWHL
         WMy/ZYhLzuETZmIkec7Kqlk3FuLziuxvSaAaJW+/lvLlX1xHjujri99f3h+8vpfkgL6v
         2hhGNdBAeHN4U929fUzTtbQj/dvHjEi6a3yHyW1bBIBlkuCtKes7bwy7le68RCWHAljv
         zoGaqtTS5lN05RsvG9DDxqCQ10bdsJu4gfuzdjWS/u/EoOmdnd8wU+odFz4t+I4ZGUb3
         BE6A==
X-Gm-Message-State: APjAAAVfDY3ymO1t9I6+XpmUWTvoghP0yWfg5DZXw96HYJtNoxA1AHlk
        K4+FnvBRAAutGmro9z0+U1o=
X-Google-Smtp-Source: APXvYqxj7SARtIhxgn4jL8AV/yPQgnm4xwcfdQMshoUV87FTJnoSXT0PDmrbNkIJCSVdbL5T3TQWhg==
X-Received: by 2002:a1c:5f86:: with SMTP id t128mr9075252wmb.87.1552052227038;
        Fri, 08 Mar 2019 05:37:07 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 132sm19625364wmd.27.2019.03.08.05.37.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:37:06 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 10/46] tools/lib/traceevent: Man page for tep_is_latency_format() and tep_set_latency_format()
Date:   Fri,  8 Mar 2019 15:36:18 +0200
Message-Id: <20190308133654.21264-11-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308133654.21264-1-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Create man pages for tep_is_latency_format() and tep_set_latency_format()
as part of the libtraceevent APIs.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 .../libtraceevent-latency_format.txt          | 140 ++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
new file mode 100644
index 000000000000..ea82cbda7b7c
--- /dev/null
+++ b/tools/lib/traceevent/Documentation/libtraceevent-latency_format.txt
@@ -0,0 +1,140 @@
+libtraceevent(3)
+================
+
+NAME
+----
+tep_set_latency_format,tep_is_latency_format - Get / set "latency output" format.
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <event-parse.h>*
+
+void *tep_set_latency_format*(struct tep_handle pass:[*]_tep_, int _lat_);
+int *tep_is_latency_format*(struct tep_handle pass:[*]_tep_);
+
+--
+
+DESCRIPTION
+-----------
+"Latency output" format prints information about interrupts being disabled,
+soft irq being disabled, the "need_resched" flag being set and preempt count.
+This information is recorded with every event, but by default is not printed.
+
+The _tep_set_latency_format()_ function enables the "latency output" printing.
+The _tep_ argument is trace event parser context. The _lat_ argument can be zero,
+for "latency output" disabled, or non zero for "latency output" enabled.
+Information is displayed with 6 characters. When a field is zero, or N/A, a pass:['.']
+is printed. Example:
+[verse]
+--
+  <idle>-0       0d.h1. 106467.859747: function:             ktime_get <-- tick_check_idle
+--
+The 0d.h1. denotes this information. The first character is never a pass:['.']
+and represents what CPU the trace was recorded on (CPU 0). The pass:['d'] denotes
+that interrupts were disabled. The pass:['h'] means that this was called inside
+an interrupt handler. The pass:['1'] is the preemption disabled (preempt_count)
+was set to one.  The two pass:['.']s are "need_resched" flag and kernel lock
+counter. If the "need_resched" flag is set, then that character would be a pass:['N'].
+See 'LATENCY FORMAT' section.
+
+The _tep_is_latency_format()_ function returns if "latency output" is enabled.
+
+This "Latency output" setting affects output of _tep_print_event_task()_
+and _tep_print_event_time()_ APIs.
+
+LATENCY FORMAT
+--------------
+The latency format displays 5 or more fields:
+[verse]
+--
+ CPU #, interrupt state, scheduling state, current context, and preemption count.
+
+ Field 1 is the CPU number (starting with zero).
+
+ Field 2 is the interrupt enabled state:
+   d : Interrupts are disabled
+   . : Interrupts are enabled
+   X : The architecture does not support this information
+
+ Field 3 is the "need resched" state.
+   N : The task is set to call the scheduler when possible, as another
+       higher priority task may need to be scheduled in.
+   . : The task is not set to call the scheduler.
+
+ Field 4 is the context state.
+   . : Normal context
+   s : Soft interrupt context
+   h : Hard interrupt context
+   H : Hard interrupt context which triggered during soft interrupt context.
+   z : NMI context
+   Z : NMI context which triggered during hard interrupt context
+
+ Field 5 is the preemption count.
+   . : The preempt count is zero.
+
+   On preemptible kernels (where the task can be scheduled out in
+   arbitrary locations while in kernel context), The preempt count,
+   when non zero, will prevent the kernel from scheduling out the
+   current task. The preempt count number is displayed when it is not
+   zero.
+--
+Depending on the kernel, it may show other fields (lock depth,
+or migration disabled, which are unique to specialized kernels).
+
+RETURN VALUE
+------------
+
+The _tep_is_latency_format()_ function returns non zero if "latency output"
+is enabled, or zero if it is disabled.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <event-parse.h>
+...
+struct tep_handle *tep = tep_alloc();
+...
+	tep_set_latency_format(tep, 1);
+...
+	if (tep_is_latency_format(tep)) {
+		/* latency output format is enabled */
+	} else {
+		/* latency output format is disabled */
+	}
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
+_libtraceevent(3)_, _trace-cmd(1)_, tep_print_event_task(3), tep_print_event_time(3)
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

