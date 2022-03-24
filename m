Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946A3C4167B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347922AbiCXC7H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347913AbiCXC7D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:59:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A089939E9;
        Wed, 23 Mar 2022 19:57:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF083B82229;
        Thu, 24 Mar 2022 02:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384B6C340FA;
        Thu, 24 Mar 2022 02:57:28 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nXDfD-007FLe-8M;
        Wed, 23 Mar 2022 22:57:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     williskung@google.com, kaleshsingh@google.com,
        linux-rt-users@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 12/12] trace-cmd analyze: Add documentation
Date:   Wed, 23 Mar 2022 22:57:26 -0400
Message-Id: <20220324025726.1727204-13-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324025726.1727204-1-rostedt@goodmis.org>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the help messages and the man page for trace-cmd analyze.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../trace-cmd/trace-cmd-analyze.1.txt         | 290 ++++++++++++++++++
 tracecmd/trace-usage.c                        |   7 +
 2 files changed, 297 insertions(+)
 create mode 100644 Documentation/trace-cmd/trace-cmd-analyze.1.txt

diff --git a/Documentation/trace-cmd/trace-cmd-analyze.1.txt b/Documentation/trace-cmd/trace-cmd-analyze.1.txt
new file mode 100644
index 000000000000..17c0f7029215
--- /dev/null
+++ b/Documentation/trace-cmd/trace-cmd-analyze.1.txt
@@ -0,0 +1,290 @@
+TRACE-CMD-ANALYZE(1)
+====================
+
+NAME
+----
+trace-cmd-analyze - Report useful information from data in a trace.dat file
+
+SYNOPSIS
+--------
+*trace-cmd analyze ['OPTIONS']* [input-file]
+
+DESCRIPTION
+-----------
+The trace-cmd(1) analyze will read a trace.dat file created by *trace-cmd-record*(1)
+and report statistical information out of it. Such as, how much the CPUs were
+idle, what tasks ran most on each CPU, the timings of tasks such as wake up to
+scheduling, how long they were preempted, blocked, sleeping.
+
+The timings are reported in microseconds (assuming the trace.dat file was recorded
+using a nanosecond clock), unless the *-t* option is used.
+
+OPTIONS
+-------
+*-i* 'file'::
+    Input file to read from. Otherwise it uses the first file passed in to it.
+
+*-t*::
+    Show timings in nanoseconds instead of microseconds.
+
+EXAMPLES
+--------
+
+.....
+# trace-cmd record -e sched_switch -e sched_waking -e page_fault_user -e timer -e irq -e irq_vectors sleep 1
+# trace-cmd analyze
+version = 6
+
+Total time:      1.015_180
+
+ Idle CPU	     Run time
+ --------	     --------
+CPU 0 idle:	     1.011_667 (%99)
+CPU 1 idle:	     1.015_180 (%100)
+
+    Task name        PID 	     Run time
+    ---------        --- 	     --------
+       trace-cmd     1116	     0.002_285 (%0)
+       trace-cmd     1115	     0.000_395 (%0)
+       trace-cmd     1114	     0.000_382 (%0)
+  NetworkManager      580	     0.000_181 (%0)
+    rtkit-daemon      618	     0.000_088 (%0)
+       rcu_sched       12	     0.000_045 (%0)
+ runaway-killer-      635	     0.000_043 (%0)
+    kworker/u4:1       56	     0.000_025 (%0)
+    rtkit-daemon      619	     0.000_020 (%0)
+      kcompactd0       29	     0.000_020 (%0)
+     kworker/0:4      408	     0.000_015 (%0)
+     migration/0       13	     0.000_009 (%0)
+       trace-cmd     1113	     0.000_000 (%0)
+
+
+CPU 0
+-------
+idle:	     1.011_667 (%99)
+Idleness             Total    (cnt)       Avg              Longest       Where
+--------             -----    -----       ---              -------       -----
+		     1.011667 (6252)      0.000161         0.001021       184.420132
+    Task name        PID 	     Run time
+    ---------        --- 	     --------
+       trace-cmd     1116	     0.002_285 (%0)
+       trace-cmd     1115	     0.000_395 (%0)
+       trace-cmd     1114	     0.000_382 (%0)
+  NetworkManager      580	     0.000_181 (%0)
+    rtkit-daemon      618	     0.000_088 (%0)
+       rcu_sched       12	     0.000_045 (%0)
+ runaway-killer-      635	     0.000_043 (%0)
+    kworker/u4:1       56	     0.000_025 (%0)
+    rtkit-daemon      619	     0.000_020 (%0)
+      kcompactd0       29	     0.000_020 (%0)
+     kworker/0:4      408	     0.000_015 (%0)
+     migration/0       13	     0.000_009 (%0)
+       trace-cmd     1113	     0.000_000 (%0)
+
+CPU 1
+-------
+idle:	     1.015_180 (%100)
+Idleness             Total    (cnt)       Avg              Longest       Where
+--------             -----    -----       ---              -------       -----
+		     1.015180 (62)        0.016373         0.443041       183.979216
+
+
+Task: 12 : rcu_sched:
+Runtime:         0.000_045
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000043 (5)         0.000008         0.000009       183.976142
+Preempted:           0.016962 (4)         0.004240         0.004973       183.984156
+
+Task: 13 : migration/0:
+Runtime:         0.000_009
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000028 (1)         0.000028         0.000028       184.047119
+
+Task: 29 : kcompactd0:
+Runtime:         0.000_020
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000022 (2)         0.000011         0.000012       184.542135
+Sleeping:            0.503988 (1)         0.503988         0.503988       184.038158
+
+Task: 56 : kworker/u4:1:
+Runtime:         0.000_025
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000018 (2)         0.000009         0.000009       184.398136
+Preempted:           0.191983 (1)         0.191983         0.191983       184.206162
+
+Task: 408 : kworker/0:4:
+Runtime:         0.000_015
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000010 (1)         0.000010         0.000010       184.654135
+
+Task: 580 : NetworkManager:
+Runtime:         0.000_181
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000024 (1)         0.000024         0.000024       184.886115
+
+Task: 618 : rtkit-daemon:
+Runtime:         0.000_088
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000025 (1)         0.000025         0.000025       184.565118
+Preempted:           0.000020 (1)         0.000020         0.000020       184.565222
+
+Task: 619 : rtkit-daemon:
+Runtime:         0.000_020
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000056 (1)         0.000056         0.000056       184.565166
+
+Task: 635 : runaway-killer-:
+Runtime:         0.000_043
+Faulted:         2
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000025 (1)         0.000025         0.000025       184.891113
+
+Task: 1113 : trace-cmd:
+Runtime:         0.000_000
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000008 (1)         0.000008         0.000008       184.989274
+
+Task: 1114 : trace-cmd:
+Runtime:         0.000_382
+Faulted:        37
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+
+Task: 1115 : trace-cmd:
+Runtime:         0.000_395
+Faulted:        37
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+
+Task: 1116 : trace-cmd:
+Runtime:         0.002_285
+Faulted:        52
+Type                 Total    (cnt)       Avg              Longest       Where
+----                 -----    -----       ---              -------       -----
+Wakeup:              0.000090 (3)         0.000030         0.000056       184.989032
+Blocked:             0.012737 (2)         0.006368         0.012149       183.974451
+Sleeping:            1.000157 (1)         1.000157         1.000157       183.988932
+.....
+
+Breaking down the above:
+.....
+Total time:      1.015_180
+.....
+
+The total run time in seconds.
+
+.....
+ Idle CPU	     Run time
+ --------	     --------
+CPU 0 idle:	     1.011_667 (%99)
+CPU 1 idle:	     1.015_180 (%100)
+.....
+
+How long each CPU was idle for.
+
+.....
+
+    Task name        PID 	     Run time
+    ---------        --- 	     --------
+       trace-cmd     1116	     0.002_285 (%0)
+       trace-cmd     1115	     0.000_395 (%0)
+       trace-cmd     1114	     0.000_382 (%0)
+  NetworkManager      580	     0.000_181 (%0)
+    rtkit-daemon      618	     0.000_088 (%0)
+       rcu_sched       12	     0.000_045 (%0)
+ runaway-killer-      635	     0.000_043 (%0)
+    kworker/u4:1       56	     0.000_025 (%0)
+    rtkit-daemon      619	     0.000_020 (%0)
+      kcompactd0       29	     0.000_020 (%0)
+     kworker/0:4      408	     0.000_015 (%0)
+     migration/0       13	     0.000_009 (%0)
+       trace-cmd     1113	     0.000_000 (%0)
+.....
+
+A list of all tasks in the trace and their run times along with the percentage of time they
+were running with respect to the total time.
+
+
+.....
+CPU 0
+-------
+idle:	     1.011_667 (%99)
+Idleness             Total    (cnt)       Avg              Longest       Where
+--------             -----    -----       ---              -------       -----
+		     1.011667 (6252)      0.000161         0.001021       184.420132
+    Task name        PID 	     Run time
+    ---------        --- 	     --------
+       trace-cmd     1116	     0.002_285 (%0)
+       trace-cmd     1115	     0.000_395 (%0)
+       trace-cmd     1114	     0.000_382 (%0)
+  NetworkManager      580	     0.000_181 (%0)
+    rtkit-daemon      618	     0.000_088 (%0)
+       rcu_sched       12	     0.000_045 (%0)
+ runaway-killer-      635	     0.000_043 (%0)
+    kworker/u4:1       56	     0.000_025 (%0)
+    rtkit-daemon      619	     0.000_020 (%0)
+      kcompactd0       29	     0.000_020 (%0)
+     kworker/0:4      408	     0.000_015 (%0)
+     migration/0       13	     0.000_009 (%0)
+       trace-cmd     1113	     0.000_000 (%0)
+.....
+
+Each CPU is show, again showing its total time (which could be different than the total
+time of the system, if events were dropped before the first event on the CPU).
+
+The "Idleness" is the time between events for the CPU's idle task. This is useful for knowing
+if the CPU can make it into deep sleep if interrupts are being traced as well. Note, currently
+it does not remove the time of an interrupt entering to when it leaves, but that may change in the
+future.
+
+.....
+Task: 1116 : trace-cmd:
+Runtime:         0.002_285
+Faulted:        52
+Type                 Total    (cnt)       Avg              Longest        Where
+----                 -----    -----       ---              -------        -----
+Wakeup:              0.000090 (3)         0.000030         0.000056       184.989032
+Blocked:             0.012737 (2)         0.006368         0.012149       183.974451
+Sleeping:            1.000157 (1)         1.000157         1.000157       183.988932
+.....
+
+Each task is traced. It will show the total run time of the task, the number of times
+tha task migrated (not shown if the task never migrated during the trace). The wake up
+latency (total time it was in waiting to be woken up), the number of times it was woken up (cnt),
+the adverage time it took to wake it up, the longest time it took to wake up, along with the
+time stamp in the report of where it woke up with that longest time.
+
+Then the same timings for how long the task was preempted (scheduled out in the running
+state), blocked (scheduled out in an uninterruptible state), sleeping (scheduled out
+in an interruptible state), and "other" for all other states the task was in when
+scheduling out.
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
+trace-cmd-stop(1), trace-cmd-reset(1), trace-cmd-split(1),
+trace-cmd-list(1), trace-cmd-listen(1)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/
+
+COPYING
+-------
+Copyright \(C) 2022 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 20995fabed73..53d3159f0903 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -274,6 +274,13 @@ static struct usage_help usage_help[] = {
 		"          -H Allows users to hook two events together for timings\n"
 		"          --verbose 'level' Set the desired log level\n"
 	},
+	{
+		"analyze",
+		"Analyze a trace file and extract various information about it",
+		" %s analyze [-i input][-t]\n"
+		"    -i Specify the input file to read, otherwise read the first non option\n"
+		"    -t Show time stamps in nanoseconds instead of microseconds\n"
+	},
 	{
 		"hist",
 		"show a histogram of the trace.dat information",
-- 
2.35.1

