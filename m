Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF42C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Jun 2023 12:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjFAM2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 08:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjFAM2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 08:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9C7129
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 05:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2B2660AFB
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 12:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6152C433D2
        for <linux-trace-devel@vger.kernel.org>; Thu,  1 Jun 2023 12:28:39 +0000 (UTC)
Date:   Thu, 1 Jun 2023 08:28:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record/extract: Do not destroy existing instances
Message-ID: <20230601082836.2fc2eb1b@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Do not destroy an instance that already exists when trace-cmd record or
extract is executed. There may be state that the user still would like to
know about the instance. When doing an extract, it should not delete the
instance when it is finished.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 32fbfef58c26..ded9ea1a04e2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5295,7 +5295,8 @@ void tracecmd_remove_instances(void)
 			close(instance->tracing_on_fd);
 			instance->tracing_on_fd = 0;
 		}
-		tracefs_instance_destroy(instance->tracefs);
+		if (tracefs_instance_is_new(instance->tracefs))
+			tracefs_instance_destroy(instance->tracefs);
 	}
 }
 
@@ -6055,7 +6056,8 @@ static inline void remove_instances(struct buffer_instance *instances)
 		del = instances;
 		instances = instances->next;
 		free(del->name);
-		tracefs_instance_destroy(del->tracefs);
+		if (tracefs_instance_is_new(del->tracefs))
+			tracefs_instance_destroy(del->tracefs);
 		tracefs_instance_free(del->tracefs);
 		free(del);
 	}
-- 
2.39.2

