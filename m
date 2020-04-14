Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0B7C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000EF206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 01:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403849AbgDNBqN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403848AbgDNBqM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 21:46:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E34D20768
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 01:46:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jOAeR-004H4a-DM
        for linux-trace-devel@vger.kernel.org; Mon, 13 Apr 2020 21:46:11 -0400
Message-Id: <20200414014611.295310002@goodmis.org>
User-Agent: quilt/0.65
Date:   Mon, 13 Apr 2020 21:44:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Optimize check_file_exists()
References: <20200414014403.968063641@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

       if (dir && !S_ISDIR(st.st_mode))
               return false;
       if (!dir && S_ISDIR(st.st_mode))
               return false;
       return true;

Is the same as:

       return !dir == !S_ISDIR(st.st_mode);

Micro-optimize the logic!

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/tracefs/tracefs-instance.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index a8729406b9fc..012a867038b7 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -263,12 +263,7 @@ static bool check_file_exists(struct tracefs_instance *instance,
 	if (ret < 0)
 		return false;
 
-	if (dir && !S_ISDIR(st.st_mode))
-		return false;
-	if (!dir && S_ISDIR(st.st_mode))
-		return false;
-
-	return true;
+	return !dir == !S_ISDIR(st.st_mode);
 }
 
 /**
-- 
2.25.1


