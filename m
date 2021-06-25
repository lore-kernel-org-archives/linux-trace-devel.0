Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96208C49EAF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AAED61952
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhFYWUH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:20:07 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:26953 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhFYWUH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 18:20:07 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 15:17:41 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 4CA2920327;
        Fri, 25 Jun 2021 15:17:45 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeross1994@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4/4] libtracefs: Add documentation for tracefs_tracer_set/clear()
Date:   Fri, 25 Jun 2021 18:17:39 -0400
Message-ID: <20210625221739.1215557-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625221739.1215557-1-rostedt@goodmis.org>
References: <20210625221739.1215557-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the man page for tracefs_tracer_set() and tracefs_tracer_clear().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-tracer.txt | 221 ++++++++++++++++++++++++++++
 1 file changed, 221 insertions(+)
 create mode 100644 Documentation/libtracefs-tracer.txt

diff --git a/Documentation/libtracefs-tracer.txt b/Documentation/libtracefs-tracer.txt
new file mode 100644
index 0000000..64d99c7
--- /dev/null
+++ b/Documentation/libtracefs-tracer.txt
@@ -0,0 +1,221 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_tracer_set, tracefs_tracer_clear - Enable or disable a tracer in an instance or the top level
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_);
+int *tracefs_tracer_set*(struct tracefs_instance pass:[*]_instance_, enum tracefs_tracers _tracer_, const char pass:[*]_name_);
+int *tracefs_tracer_clear*(struct tracefs_instance pass:[*]_instance_);
+--
+
+DESCRIPTION
+-----------
+*tracefs_tracer_set* enables a tracer in the given instance, defined by the
+_instance_ parameter. If _instance_ is NULL, then the top level instance is
+changed. If _tracer_ is set to _TRACFES_TRACER_CUSTOM_ then a const char pass[*]
+string must be passed in as the third parameter, and that is written into the
+instance to enable the tracer with that name. This is useful for newer or
+custom kernels that contain tracers that are not yet identified by the
+tracefs_tracers enum.
+
+*tracefs_tracer_clear* disables the tracer for the given instance defined by
+the _instance_ variable, or the top level instance if it is NULL.
+This is the same as calling *tracefs_tracer_set* with TRACEFS_TRACER_NOP as
+the _tracer_ parameter.
+
+TRACEFS_TRACER ENUMS
+--------------------
+
+The currently defined enums that are accepted are:
+
+*TRACEFS_TRACER_NOP* :
+This is the idle tracer, which does nothing and is used to clear any
+active tarcer.
+
+*TRACEFS_TRACER_FUNCTION* :
+Enables most functions in the kernel to be traced.
+
+*TRACEFS_TRACER_FUNCTION_GRAPH* :
+Enables most functions in the kernel to be traced as well as the return
+of the function.
+
+*TRACEFS_TRACER_IRQSOFF* :
+Tracers the latency of interrupts disabled.
+
+*TRACEFS_TRACER_PREEMPTOFF* :
+Tracers the latency of preemption disabled (the time in the kernel that
+tasks can not be scheduled from the CPU).
+
+*TRACEFS_TRACER_PREEMPTIRQSOFF* :
+Traces the combined total latency of when interrupts are disabled as well as when
+preemption is disabled.
+
+*TRACEFS_TRACER_WAKEUP* :
+Traces the latency of when the highest priority task takes to wake up.
+
+*TRACEFS_TRACER_WAKEUP_RT* :
+Traces the latency of when the highest priority real-time task takes to wake up.
+All other tasks are ignored.
+
+*TRACEFS_TRACER_WAKEUP_DL* :
+Traces the latency of when the highest priority DEADLINE task takes to wake up.
+All other tasks are ignored.
+
+*TRACEFS_TRACER_MMIOTRACE* :
+Traces the interaction of devices with the kernel.
+
+*TRACEFS_TRACER_HWLAT* :
+Detects latency caused by the hardware that is outside the scope of the kernel.
+
+*TRACEFS_TRACER_BRANCH* :
+Traces when likely or unlikely branches are taken.
+
+*TRACEFS_TRACER_BLOCK* :
+Special tracer for the block devices.
+
+Note that the above tracers may not be available in the kernel and
+*tracefs_tracer_set()* will return an error with errno set to ENODEV,
+if the kernel does not support the _tracer_ option, or the custom one
+if TRACEFS_TRACER_CUSTOM is used.
+
+RETURN VALUE
+------------
+Returns 0 on success, or -1 on error.
+
+ERRORS
+------
+
+*tracefs_tracer_set*() can fail with the following errors:
+
+*EINVAL* The _tracer_ parameter is outside the scope of what is defined.
+
+*ENOMEM* Memory allocation error.
+
+*ENOENT* Tracers are not supported on the running kernel.
+
+*ENODEV* The specified tracer is not supported on the running kernel.
+
+Other errors may also happen caused by internal system calls.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <stdio.h>
+#include <getopt.h>
+#include <errno.h>
+#include <tracefs.h>
+
+int main(int argc, char *argv[])
+{
+	struct tracefs_instance *inst = NULL;
+	enum tracefs_tracers t = TRACEFS_TRACER_NOP;
+	const char *buf = NULL;
+	const char *cust;
+	int ret;
+	int ch;
+
+	while ((ch = getopt(argc, argv, "nfgiwdc:B:")) > 0) {
+		switch (ch) {
+		case 'f': t = TRACEFS_TRACER_FUNCTION; break;
+		case 'g': t = TRACEFS_TRACER_FUNCTION_GRAPH; break;
+		case 'i': t = TRACEFS_TRACER_PREEMPTIRQSOFF; break;
+		case 'w': t = TRACEFS_TRACER_WAKEUP_RT; break;
+		case 'd': t = TRACEFS_TRACER_WAKEUP_DL; break;
+		case 'c':
+			t = TRACEFS_TRACER_CUSTOM;
+			cust = optarg;
+			break;
+		case 'B':
+			buf = optarg;
+			break;
+		case 'n':
+			/* nop */
+			break;
+		default:
+			printf("Unknow arg %c\n", ch);
+			exit(-1);
+		}
+	}
+
+	if (buf) {
+		inst = tracefs_instance_create(buf);
+		if (!inst) {
+			printf("failed to create instance\n");
+			exit(-1);
+		}
+	}
+
+	if (t == TRACEFS_TRACER_CUSTOM)
+		ret = tracefs_tracer_set(inst, t, cust);
+	else
+		ret = tracefs_tracer_set(inst, t);
+
+	if (ret < 0) {
+		if (inst) {
+			tracefs_instance_destroy(inst);
+			tracefs_instance_free(inst);
+		}
+		if (errno == ENODEV)
+			printf("Tracer not supported by kernel\n");
+		else
+			perror("Error");
+		exit(-1);
+	}
+
+	if (inst)
+		tracefs_instance_free(inst);
+
+	exit(0);
+}
+--
+
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
+*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
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
+
+COPYING
+-------
+Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
-- 
2.30.2

