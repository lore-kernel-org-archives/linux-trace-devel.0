Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3699DC48BC2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111306162E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhFYWUF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:20:05 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:26949 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhFYWUF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 18:20:05 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 15:17:39 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id BA12A20328;
        Fri, 25 Jun 2021 15:17:42 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeross1994@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtracefs: Add custom tracer to tracefs_tracer_set()
Date:   Fri, 25 Jun 2021 18:17:36 -0400
Message-ID: <20210625221739.1215557-2-rostedt@goodmis.org>
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

Allow the user to enter their own string to define a tracer using
TRACEFS_TRACER_CUSTOM. This way if there's a tracer that is not yet
supported by libtracefs, the user could still enable the tracer with the
tracefs_tracer_set() functionality, as well as use the enums to set
tracers.

 For example:

   tracefs_tracer_set(NULL, TRACEFS_TRACER_CUSTOM, "osnoise");

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |  3 ++-
 src/tracefs-tools.c | 28 +++++++++++++++++++++++-----
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 50873f3..75905ec 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -186,6 +186,7 @@ void tracefs_set_loglevel(enum tep_loglevel level);
 
 enum tracefs_tracers {
 	TRACEFS_TRACER_NOP = 0,
+	TRACEFS_TRACER_CUSTOM,
 	TRACEFS_TRACER_FUNCTION,
 	TRACEFS_TRACER_FUNCTION_GRAPH,
 	TRACEFS_TRACER_IRQSOFF,
@@ -200,7 +201,7 @@ enum tracefs_tracers {
 	TRACEFS_TRACER_BLOCK,
 };
 
-int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer);
+int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer, ...);
 
 int tracefs_tracer_clear(struct tracefs_instance *instance);
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 21efa6e..fb243d8 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -7,6 +7,7 @@
  *
  */
 #include <stdlib.h>
+#include <stdarg.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/types.h>
@@ -29,6 +30,7 @@ __hidden pthread_mutex_t toplevel_lock = PTHREAD_MUTEX_INITIALIZER;
 
 #define TRACERS \
 	C(NOP,                  "nop"),			\
+	C(CUSTOM,		"CUSTOM"),		\
 	C(FUNCTION,             "function"),            \
 	C(FUNCTION_GRAPH,       "function_graph"),      \
 	C(IRQSOFF,              "irqsoff"),             \
@@ -950,11 +952,20 @@ int write_tracer(int fd, const char *tracer)
 /**
  * tracefs_set_tracer - function to set the tracer
  * @instance: ftrace instance, can be NULL for top tracing instance
- * @tracer: Tracer that has to be set, which can be integer from 0 - 12
- * or enum value
+ * @tracer: The tracer enum that defines the tracer to be set
+ * @t: A tracer name if TRACEFS_TRACER_CUSTOM is passed in for @tracer
+ *
+ * Set the tracer for the instance based on the tracefs_tracer enums.
+ * If the user wishes to enable a tracer that is not defined by
+ * the enum (new or custom kernel), the tracer can be set to
+ * TRACEFS_TRACER_CUSTOM, and pass in a const char * name for
+ * the tracer to set.
+ *
+ * Returns 0 on succes, negative on error.
  */
 
-int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers tracer)
+int tracefs_tracer_set(struct tracefs_instance *instance,
+		       enum tracefs_tracers tracer, ...)
 {
 	char *tracer_path = NULL;
 	const char *t = NULL;
@@ -976,9 +987,16 @@ int tracefs_tracer_set(struct tracefs_instance *instance, enum tracefs_tracers t
 		errno = -ENODEV;
 		goto out;
 	}
-	if (tracer == tracer_enums[tracer])
+
+	if (tracer == TRACEFS_TRACER_CUSTOM) {
+		va_list ap;
+
+		va_start(ap, tracer);
+		t = va_arg(ap, const char *);
+		va_end(ap);
+	} else if (tracer == tracer_enums[tracer]) {
 		t = tracers[tracer];
-	else {
+	} else {
 		for (i = 0; i < ARRAY_SIZE(tracer_enums); i++) {
 			if (tracer == tracer_enums[i]) {
 				t = tracers[i];
-- 
2.30.2

