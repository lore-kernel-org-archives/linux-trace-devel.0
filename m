Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9EAC46477
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2015A2173C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 18:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFLSUU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 14:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfFLSUU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 14:20:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2109921721;
        Wed, 12 Jun 2019 18:20:20 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hb7r9-00058c-9O; Wed, 12 Jun 2019 14:20:19 -0400
Message-Id: <20190612182019.169932649@goodmis.org>
User-Agent: quilt/0.65
Date:   Wed, 12 Jun 2019 14:19:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: Check the return of get_file_content() before calling
 add_reset_file()
References: <20190612181927.608151291@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If get_file_content() returns NULL, because the file does not exist or for
any other reason, it will cause add_reset_file() to trigger a SEGSEGV due to
using a NULL pointer. Only call add_reset_file() if get_file_content()
actually returns something.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2d716a81acbf..5dc6f17aa743 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -270,8 +270,10 @@ static void reset_save_file(const char *file, int prio)
 	char *content;
 
 	content = get_file_content(file);
-	add_reset_file(file, content, prio);
-	free(content);
+	if (content) {
+		add_reset_file(file, content, prio);
+		free(content);
+	}
 }
 
 /*
-- 
2.20.1


