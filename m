Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1383C7EE29
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jun 2023 08:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbjFBIKF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 04:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjFBIKB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 04:10:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C41A7
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 01:10:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015F664AE1
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 08:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F58C433D2;
        Fri,  2 Jun 2023 08:09:58 +0000 (UTC)
Date:   Fri, 2 Jun 2023 04:09:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Alexander Aring <aahringo@redhat.com>
Subject: [PATCH] trace-cmd agent: Add "IP" to -N argument in help message
Message-ID: <20230602040955.6195a184@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The trace-cmd agent -h message does not specify that an IP needs to be
given as an argument. Update the help message to reflect that.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216291
Reported-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 42a8e7d1107d..4fbbc545a5ef 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -334,7 +334,7 @@ static struct usage_help usage_help[] = {
 	{
 		"agent",
 		"listen on a vsocket for trace clients",
-		" %s agent -p port[-D][-N][-P cid]\n"
+		" %s agent -p port[-D][-N IP][-P cid]\n"
 		"          Creates a vsocket to listen for clients.\n"
 		"          -N Connect to IP via TCP instead of vsockets\n"
 		"             *** Insecure setting, only use on a trusted network ***\n"
-- 
2.39.2

