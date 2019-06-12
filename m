Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE672C31E48
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11FC21743
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfFLSUU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfFLSUU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:20:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1010215EA;
        Wed, 12 Jun 2019 18:20:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hb7r9-000587-46; Wed, 12 Jun 2019 14:20:19 -0400
Message-Id: <20190612182019.007518394@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 12 Jun 2019 14:19:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Have --max-graph-depth only be part of instance
References: <20190612181927.608151291@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

New kernels will allow function graph tracer to be used in an instance,
which means that the max_graph_depth file will be per instance and not just
the top level file. Make the max_graph_depth associated to the instance and
not part of the trace record context.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h |  2 ++
 tracecmd/trace-record.c        | 27 +++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index a1a06e9196b4..1cad3ccc4de7 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -183,6 +183,8 @@ struct buffer_instance {
 	struct tracecmd_msg_handle *msg_handle;
 	struct tracecmd_output *network_handle;
 
+	char			*max_graph_depth;
+
 	int			flags;
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ee35ada10d6e..2d716a81acbf 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -207,7 +207,6 @@ struct common_record_context {
 	struct buffer_instance *instance;
 	const char *output;
 	char *date2ts;
-	char *max_graph_depth;
 	int data_flags;
 
 	int record_all;
@@ -4892,9 +4891,9 @@ static void parse_record_options(int argc,
 			ctx->data_flags |= DATA_FL_OFFSET;
 			break;
 		case OPT_max_graph_depth:
-			free(ctx->max_graph_depth);
-			ctx->max_graph_depth = strdup(optarg);
-			if (!ctx->max_graph_depth)
+			free(ctx->instance->max_graph_depth);
+			ctx->instance->max_graph_depth = strdup(optarg);
+			if (!ctx->instance->max_graph_depth)
 				die("Could not allocate option");
 			break;
 		case OPT_no_filter:
@@ -5056,10 +5055,12 @@ static void record_trace(int argc, char **argv,
 	update_plugins(type);
 	set_options();
 
-	if (ctx->max_graph_depth) {
-		for_all_instances(instance)
-			set_max_graph_depth(instance, ctx->max_graph_depth);
-		free(ctx->max_graph_depth);
+	for_all_instances(instance) {
+		if (instance->max_graph_depth) {
+			set_max_graph_depth(instance, instance->max_graph_depth);
+			free(instance->max_graph_depth);
+			instance->max_graph_depth = NULL;
+		}
 	}
 
 	allocate_seq();
@@ -5155,10 +5156,12 @@ void trace_extract(int argc, char **argv)
 	update_plugins(type);
 	set_options();
 
-	if (ctx.max_graph_depth) {
-		for_all_instances(instance)
-			set_max_graph_depth(instance, ctx.max_graph_depth);
-		free(ctx.max_graph_depth);
+	for_all_instances(instance) {
+		if (instance->max_graph_depth) {
+			set_max_graph_depth(instance, instance->max_graph_depth);
+			free(instance->max_graph_depth);
+			instance->max_graph_depth = NULL;
+		}
 	}
 
 	allocate_seq();
-- 
2.20.1


