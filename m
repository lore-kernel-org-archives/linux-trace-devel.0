Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA3BC7EE2F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jun 2023 08:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbjFBIBa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 04:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjFBIB3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 04:01:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539EE195
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 01:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC9416466E
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 08:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C083CC433EF;
        Fri,  2 Jun 2023 08:01:26 +0000 (UTC)
Date:   Fri, 2 Jun 2023 04:01:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] trace-cmd record: Remove redundant check of instance in 
 allocate_instance()
Message-ID: <20230602040123.3ce83b19@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The error path only happens after the instance has been allocated. No need
to check if it exists again.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217127
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b094f0699a43..41d765b593b7 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -387,11 +387,9 @@ struct buffer_instance *allocate_instance(const char *name)
 	return instance;
 
 error:
-	if (instance) {
-		free(instance->name);
-		tracefs_instance_free(instance->tracefs);
-		free(instance);
-	}
+	free(instance->name);
+	tracefs_instance_free(instance->tracefs);
+	free(instance);
 	return NULL;
 }
 
-- 
2.39.2

