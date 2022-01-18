Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890A7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347227AbiARDNQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:13:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54342 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352552AbiARDAI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 22:00:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF2CB6137D
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 03:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621B4C36AEB;
        Tue, 18 Jan 2022 03:00:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n9ej8-006jG1-Ct;
        Mon, 17 Jan 2022 22:00:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/2] libtracefs: Fix libtracefs-instance-affinity example
Date:   Mon, 17 Jan 2022 22:00:05 -0500
Message-Id: <20220118030005.1603821-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220118030005.1603821-1-rostedt@goodmis.org>
References: <20220118030005.1603821-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The example in the libtracefs-instance-affinity man page had a bug where
it was taking argv[0] as one of the parameters for the CPUs to set. The
first parameter is the executable name, which isn't what we want.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/libtracefs-instances-affinity.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 22994f877e30..0f3093d62035 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -146,8 +146,8 @@ int main (int argc, char **argv)
 	}
 
 	trace_seq_init(&seq);
-	for (i = 0; i < argc; i++) {
-		if (i)
+	for (i = 1; i < argc; i++) {
+		if (i > 1)
 			trace_seq_putc(&seq, ',');
 		trace_seq_puts(&seq, argv[i]);
 	}
-- 
2.33.0

