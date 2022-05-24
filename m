Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4433C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 May 2022 01:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiEXBui (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 May 2022 21:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbiEXBuf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 May 2022 21:50:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4B3737AB
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 18:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20C11B81729
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 01:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4FDC34117;
        Tue, 24 May 2022 01:50:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1ntJgr-0015iB-Ml;
        Mon, 23 May 2022 21:50:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd record: Set clock to TSC when connecting to a proxy with kvm
Date:   Mon, 23 May 2022 21:50:28 -0400
Message-Id: <20220524015028.260238-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524015028.260238-1-rostedt@goodmis.org>
References: <20220524015028.260238-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

If the time synchronization protocol for the recorder to a agent proxy is
KVM, then it means that the TSC clock must be used. Force it when this is
discovered.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ce20402af7c2..169836bd493c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3849,16 +3849,29 @@ static int open_guest_fifos(const char *guest, int **fds)
 	return i;
 }
 
+static bool clock_is_supported(struct tracefs_instance *instance, const char *clock);
+
 static int host_tsync(struct common_record_context *ctx,
 		      struct buffer_instance *instance,
 		      unsigned int tsync_port, char *proto)
 {
+	struct buffer_instance *iter_instance;
 	int guest_id = -1;
 	int fd;
 
 	if (!proto)
 		return -1;
 
+	/* If connecting to a proxy, the clock may still need to be set */
+	if (strcmp(proto, "kvm") == 0 &&
+	    clock_is_supported(NULL, TSC_CLOCK)) {
+		ctx->clock = TSC_CLOCK;
+		for_all_instances(iter_instance) {
+			iter_instance->clock = TSC_CLOCK;
+			set_clock(ctx, iter_instance);
+		}
+	}
+
 	if (is_network(instance)) {
 		fd = connect_port(instance->name, tsync_port,
 				  instance->port_type);
-- 
2.35.1

