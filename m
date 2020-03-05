Return-Path: <SRS0=o+Or=4W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48687C3F2D1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 18:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 204AB207FD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 18:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgCESoV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 13:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgCESoU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 13:44:20 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C75E2072D;
        Thu,  5 Mar 2020 18:44:20 +0000 (UTC)
Date:   Thu, 5 Mar 2020 13:44:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Make name and cpu_pid into const pointers to
 tracecmd_get_guest_cpumap()
Message-ID: <20200305134418.4ca07214@gandalf.local.home>
In-Reply-To: <20200304091220.30936-9-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
        <20200304091220.30936-9-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

As both the name and cpu_pid return pointers to the actual data of the
tracecmd_handle, they should be constant to make sure that the callers do
not try to modify them.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h | 4 ++--
 lib/trace-cmd/trace-input.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 0375f500..2643b889 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -157,8 +157,8 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle);
 int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      unsigned long long trace_id,
-			      char **name,
-			      int *vcpu_count, int **cpu_pid);
+			      const char **name,
+			      int *vcpu_count, const int **cpu_pid);
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index faf6a795..c1531410 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3695,8 +3695,8 @@ unsigned long long tracecmd_get_traceid(struct tracecmd_input *handle)
  */
 int tracecmd_get_guest_cpumap(struct tracecmd_input *handle,
 			      unsigned long long trace_id,
-			      char **name,
-			      int *vcpu_count, int **cpu_pid)
+			      const char **name,
+			      int *vcpu_count, const int **cpu_pid)
 {
 	struct guest_trace_info	*guest = handle->guest;
 
-- 
2.20.1

