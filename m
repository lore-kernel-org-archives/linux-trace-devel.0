Return-Path: <SRS0=Ara6=2J=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B20FC3F68F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2CEE24679
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Dec 2019 21:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfLSVs7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 16:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfLSVs7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 16:48:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2068224679
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Dec 2019 21:48:59 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92.3)
        (envelope-from <rostedt@goodmis.org>)
        id 1ii3fG-000UqF-8f
        for linux-trace-devel@vger.kernel.org; Thu, 19 Dec 2019 16:48:58 -0500
Message-Id: <20191219214858.137902679@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Dec 2019 16:48:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Duplicate trace_clock in tracecmd_input handle
References: <20191219214805.821145530@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The following crashes:

 # trace-cmd record -C local -e sched -B foo -e irq sleep 1
 # trace-cmd report

The issue is that new instances are copied from the top instance descriptor
and their values are set. This means that the trace_clock field is also
copied which is a pointer to a string.

On freeing of the tracecmd_input handlers, the trace_clock is freed. This
is an issue if the trace_clock was added as an option, because the instance
just has a copy of the top instance, and when the instance descriptor is
freed, it will free the same pointer that was already freed by the
descruction of the top instance descriptor and we have a double free.

Have the creation of the instance tracecmd_input handler descriptor perform
a strdup() and have its own copy of the trace_clock.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 3b187e3f135b..5688610fe082 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3398,6 +3398,13 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->ref = 1;
+	if (handle->trace_clock) {
+		new_handle->trace_clock = strdup(handle->trace_clock);
+		if (!new_handle->trace_clock) {
+			free(new_handle);
+			return NULL;
+		}
+	}
 	new_handle->parent = handle;
 	new_handle->cpustats = NULL;
 	new_handle->hooks = NULL;
-- 
2.24.0


