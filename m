Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFAEC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 22:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 747D36121E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Apr 2021 22:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhDLWkh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238901AbhDLWkh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 18:40:37 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A38061246
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Apr 2021 22:40:16 +0000 (UTC)
Date:   Mon, 12 Apr 2021 18:40:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] libtracefs: Have tracefs_instance_destroy() match the
 man page
Message-ID: <20210412184014.000a315e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

According to the man page of tracefs_instance_destroy():

 "The tracefs_instance_destroy() frees the instance structure, and will also
  remove the trace instance from the system."

Which is wrong, and trace-cmd actually depends on this function not
freeing the structure. Update the documentation to reflect this.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:

  - Found that trace-cmd depends on this not freeing it, so
    change the documentation to match the code, instead of the
    code to match the documentation.

 Documentation/libtracefs-instances-manage.txt | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index e7dc393..2ba48c4 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -35,8 +35,9 @@ then the new tracefs_instance structure is initialised for the top instance.
 Note that the top instance cannot be created in the system, if it does not
 exist.
 
-The _tracefs_instance_destroy()_ frees the _instance_ structure, and will
-also remove the trace instance from the system.
+The _tracefs_instance_destroy()_ removes the instance from the system, but
+does not free the structure. _tracefs_instance_free()__ must still be called
+on _instance_.
 
 The _tracefs_instance_alloc()_ function allocates a new tracefs_instance structure
 for existing trace instance. If the instance does not exist in the system, the function
@@ -55,11 +56,11 @@ before that.
 RETURN VALUE
 ------------
 The _tracefs_instance_create()_ and _tracefs_instance_alloc()_ functions return a pointer to
-a newly allocated tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
-_tracefs_instance_free()_.
+a newly allocated tracefs_instance structure. It must be freed with _tracefs_instance_free()_.
 
-The _tracefs_instance_destroy()_ function returns -1 in case of an error,
-or 0 otherwise.
+The _tracefs_instance_destroy()_ function returns 0 if it succeeds to remove
+the instance, otherwise it returns -1 if the instance does not exist or it
+fails to remove it.
 
 The _tracefs_instance_is_new()_ function returns true if the
 _tracefs_instance_create()_ that allocated _instance_ also created the
@@ -83,8 +84,7 @@ struct tracefs_instance *inst = tracefs_instance_create("foo");
 
 	if (tracefs_instance_is_new(inst))
 		tracefs_instance_destroy(inst);
-	else
-		tracefs_instance_free(inst);
+	tracefs_instance_free(inst);
 ...
 
 struct tracefs_instance *inst = tracefs_instance_alloc(NULL, "bar");
-- 
2.29.2

