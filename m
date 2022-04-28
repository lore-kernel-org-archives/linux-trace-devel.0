Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD95C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344429AbiD1PJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 11:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiD1PJ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 11:09:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D3A29803
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 08:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8450ECE2B5A
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Apr 2022 15:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9729CC385A9;
        Thu, 28 Apr 2022 15:06:37 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nk5j2-003JH9-9P;
        Thu, 28 Apr 2022 11:06:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd: Simplify add_guest()
Date:   Thu, 28 Apr 2022 11:06:33 -0400
Message-Id: <20220428150635.789051-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428150635.789051-1-rostedt@goodmis.org>
References: <20220428150635.789051-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Simplify the function add_guest by using a local variable to point to the
array element instead of dereferencing the array every time.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vm.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 281843b223f6..f0513950aa26 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -56,18 +56,22 @@ bool trace_have_guests_pid(void)
 
 static struct trace_guest *add_guest(unsigned int cid, const char *name)
 {
+	struct trace_guest *guest;
+
 	guests = realloc(guests, (guests_len + 1) * sizeof(*guests));
 	if (!guests)
 		die("allocating new guest");
-	memset(&guests[guests_len], 0, sizeof(struct trace_guest));
-	guests[guests_len].name = strdup(name);
-	if (!guests[guests_len].name)
+
+	guest = &guests[guests_len++];
+
+	memset(guest, 0, sizeof(*guest));
+	guest->name = strdup(name);
+	if (!guest->name)
 		die("allocating guest name");
-	guests[guests_len].cid = cid;
-	guests[guests_len].pid = -1;
-	guests_len++;
+	guest->cid = cid;
+	guest->pid = -1;
 
-	return &guests[guests_len - 1];
+	return guest;
 }
 
 static struct tracefs_instance *start_trace_connect(void)
-- 
2.35.1

