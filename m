Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F510C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3351764F65
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Feb 2021 22:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbhBCWaN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 17:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:56764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229897AbhBCWaH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 17:30:07 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F9D64F65
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Feb 2021 22:29:27 +0000 (UTC)
Date:   Wed, 3 Feb 2021 17:29:25 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Use instance->name for guests and not tracefs instance name
Message-ID: <20210203172925.25cb42e2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Recording a guest does not use tracefs, revert part of a7f44264f
("trace-cmd: New libtracefs APIs for ftrace instances") that mistakenly
switched the guest set up from instance->name to
tracefs_instance_get_name().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3bcb2403..a1c4e919 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3658,11 +3658,9 @@ static void connect_to_agent(struct buffer_instance *instance)
 	unsigned int *ports;
 	int i, *fds = NULL;
 	bool use_fifos = false;
-	const char *name;
 
-	name = tracefs_instance_get_name(instance->tracefs);
 	if (!no_fifos) {
-		nr_fifos = open_guest_fifos(name, &fds);
+		nr_fifos = open_guest_fifos(instance->name, &fds);
 		use_fifos = nr_fifos > 0;
 	}
 
@@ -3703,7 +3701,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 			instance->tsync.proto_name = strdup(tsync_protos_reply);
 			printf("Negotiated %s time sync protocol with guest %s\n",
 				instance->tsync.proto_name,
-				tracefs_instance_get_name(instance->tracefs));
+				instance->name);
 			tracecmd_host_tsync(instance, tsync_port);
 		} else
 			warning("Failed to negotiate timestamps synchronization with the guest");
@@ -3714,7 +3712,7 @@ static void connect_to_agent(struct buffer_instance *instance)
 		if (nr_cpus != nr_fifos) {
 			warning("number of FIFOs (%d) for guest %s differs "
 				"from number of virtual CPUs (%d)",
-				nr_fifos, name, nr_cpus);
+				nr_fifos, instance->name, nr_cpus);
 			nr_cpus = nr_cpus < nr_fifos ? nr_cpus : nr_fifos;
 		}
 		free(ports);
@@ -3747,8 +3745,7 @@ static void setup_guest(struct buffer_instance *instance)
 	int fd;
 
 	/* Create a place to store the guest meta data */
-	file = trace_get_guest_file(output_file,
-				    tracefs_instance_get_name(instance->tracefs));
+	file = trace_get_guest_file(output_file, instance->name);
 	if (!file)
 		die("Failed to allocate memory");
 
@@ -5771,6 +5768,7 @@ static void parse_record_options(int argc,
 			ctx->instance->flags |= BUFFER_FL_GUEST;
 			ctx->instance->cid = cid;
 			ctx->instance->port = port;
+			ctx->instance->name = name;
 			add_instance(ctx->instance, 0);
 			break;
 		}
-- 
2.25.4

