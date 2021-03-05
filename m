Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1D8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2750A650A9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhCEW7u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhCEW7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 574676509B
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQC-0020Bv-DR
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:48 -0500
Message-ID: <20210305225948.293719864@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/9 v2] trace-cmd: Have tracecmd_get_file_state() return the enum
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of returning an unsigned long for tracecmd_get_file_state(), have it
return the enum, now that it is a required API.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 +-
 lib/trace-cmd/trace-input.c                       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ad863df8954f..bd14caff93ac 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -163,7 +163,7 @@ int tracecmd_copy_headers(struct tracecmd_input *handle, int fd);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
-unsigned long tracecmd_get_file_state(struct tracecmd_input *handle);
+enum tracecmd_file_states tracecmd_get_file_state(struct tracecmd_input *handle);
 unsigned long long tracecmd_get_tsync_peer(struct tracecmd_input *handle);
 int tracecmd_enable_tsync(struct tracecmd_input *handle, bool enable);
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1dcefc61bcbb..b4d18209fe2d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -162,7 +162,7 @@ unsigned long tracecmd_get_flags(struct tracecmd_input *handle)
 	return handle->flags;
 }
 
-unsigned long tracecmd_get_file_state(struct tracecmd_input *handle)
+enum tracecmd_file_states tracecmd_get_file_state(struct tracecmd_input *handle)
 {
 	return handle->file_state;
 }
-- 
2.30.0


