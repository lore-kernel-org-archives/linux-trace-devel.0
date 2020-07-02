Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C7EC433DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D1032084C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 18:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgGBSKm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgGBSKl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 14:10:41 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71F32073E;
        Thu,  2 Jul 2020 18:10:40 +0000 (UTC)
Date:   Thu, 2 Jul 2020 14:10:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Add helper function to print content of
 a trace file
Message-ID: <20200702141039.09aa88e1@oasis.local.home>
In-Reply-To: <20200421104713.31762-2-tz.stoyanov@gmail.com>
References: <20200421104713.31762-1-tz.stoyanov@gmail.com>
        <20200421104713.31762-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 21 Apr 2020 13:47:12 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> trace-cmd stat command prints various information about the current
> ftrace configuration. Some of it is just a dump of a ftrace file.
> These functions from trace-stat.c have almost the same logic:
>  report_plugin()
>  report_latency()
>  report_errorlog()
> A helper function is added, implementing this common logic:
>  report_file()
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  tracecmd/trace-stat.c | 77 ++++++++++++-------------------------------
>  1 file changed, 21 insertions(+), 56 deletions(-)
> 

Hi Tzvetomir,

I didn't realize how old this patch was, just noticed it in patchwork :-p

Anyway, I applied it with the following update (the change log spacing,
and used "strncmp() != 0" instead of "strncmp()".

-- Steve

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Date: Tue, 21 Apr 2020 13:47:12 +0300
Subject: [PATCH] trace-cmd: Add helper function to print content of a trace
 file

trace-cmd stat command prints various information about the current
ftrace configuration. Some of it is just a dump of a ftrace file.
These functions from trace-stat.c have almost the same logic:

 report_plugin()
 report_latency()
 report_errorlog()

A helper function is added, implementing this common logic:

 report_file()

Link: https://lore.kernel.org/linux-trace-devel/20200421104713.31762-2-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
[ Use strcmp() != 0 instead of just strncmp() ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-stat.c | 77 ++++++++++++-------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index bd0e647a..8ab686da 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -122,6 +122,24 @@ static char *get_instance_file_content(struct buffer_instance *instance,
 	return str;
 }
 
+static void report_file(struct buffer_instance *instance,
+			char *name, char *def_value, char *description)
+{
+	char *str;
+	char *cont;
+
+	if (!tracefs_file_exists(instance->tracefs, name))
+		return;
+	str = get_instance_file_content(instance, name);
+	if (!str)
+		return;
+	cont = strstrip(str);
+	if (cont[0] && strcmp(cont, def_value) != 0)
+		printf("\n%s%s\n", description, cont);
+
+	free(str);
+}
+
 static void report_instances(void)
 {
 	struct dirent *dent;
@@ -166,26 +184,6 @@ out:
 	tracefs_put_tracing_file(path);
 }
 
-static void report_plugin(struct buffer_instance *instance)
-{
-	char *str;
-	char *cont;
-
-	str = get_instance_file_content(instance, "current_tracer");
-	if (!str)
-		return;
-
-	cont = strstrip(str);
-
-	/* We only care if the plugin is something other than nop */
-	if (strcmp(cont, "nop") == 0)
-		goto out;
-
-	printf("\nTracer: %s\n", cont);
- out:
-	free(str);
-}
-
 struct event_iter *trace_event_iter_alloc(const char *path)
 {
 	struct event_iter *iter;
@@ -817,23 +815,6 @@ static void report_cpumask(struct buffer_instance *instance)
 	free(str);
 }
 
-static void report_latency(struct buffer_instance *instance)
-{
-	char *str;
-	char *cont;
-
-	str = get_instance_file_content(instance, "tracing_max_latency");
-	if (!str)
-		return;
-
-	cont = strstrip(str);
-
-	if (strcmp(cont, "0") != 0)
-		printf("\nMax Latency: %s\n", cont);
-
-	free(str);
-}
-
 static void report_probes(struct buffer_instance *instance,
 			  const char *file, const char *string)
 {
@@ -897,22 +878,6 @@ static void report_traceon(struct buffer_instance *instance)
 	free(str);
 }
 
-static void report_errorlog(struct buffer_instance *instance)
-{
-	char *str;
-
-	if (!tracefs_file_exists(instance->tracefs, "error_log"))
-		return;
-	str = get_instance_file_content(instance, "error_log");
-	if (!str)
-		return;
-
-	if (str[0])
-		printf("\nError log:\n%s\n", str);
-
-	free(str);
-}
-
 static void stat_instance(struct buffer_instance *instance)
 {
 	if (instance != &top_instance) {
@@ -922,7 +887,7 @@ static void stat_instance(struct buffer_instance *instance)
 			tracefs_instance_get_name(instance->tracefs));
 	}
 
-	report_plugin(instance);
+	report_file(instance, "current_tracer", "nop", "Tracer: ");
 	report_events(instance);
 	report_event_filters(instance);
 	report_event_triggers(instance);
@@ -931,11 +896,11 @@ static void stat_instance(struct buffer_instance *instance)
 	report_buffers(instance);
 	report_clock(instance);
 	report_cpumask(instance);
-	report_latency(instance);
+	report_file(instance, "tracing_max_latency", "0", "Max Latency: ");
 	report_kprobes(instance);
 	report_uprobes(instance);
 	report_traceon(instance);
-	report_errorlog(instance);
+	report_file(instance, "error_log", "", "Error log:\n");
 	if (instance == &top_instance)
 		report_instances();
 }
-- 
2.25.4

