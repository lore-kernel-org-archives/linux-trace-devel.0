Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A771C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Mar 2022 02:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbiC3C1E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 22:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240933AbiC3C1D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 22:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5C6427ED;
        Tue, 29 Mar 2022 19:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4184B819F4;
        Wed, 30 Mar 2022 02:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A90BC2BBE4;
        Wed, 30 Mar 2022 02:25:16 +0000 (UTC)
Date:   Tue, 29 Mar 2022 22:25:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] tracing: Set user_events to BROKEN
Message-ID: <20220329222514.51af6c07@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

After being merged, user_events become more visible to a wider audience
that have concerns with the current API. It is too late to fix this for
this release, but instead of a full revert, just mark it as BROKEN (which
prevents it from being selected in make config). Then we can work finding
a better API. If that fails, then it will need to be completely reverted.

Link: https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 kernel/trace/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 16a52a71732d..edc8159f63ef 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -741,6 +741,7 @@ config USER_EVENTS
 	bool "User trace events"
 	select TRACING
 	select DYNAMIC_EVENTS
+	depends on BROKEN # API needs to be straighten out
 	help
 	  User trace events are user-defined trace events that
 	  can be used like an existing kernel trace event.  User trace
-- 
2.35.1

