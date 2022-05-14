Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4868C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 14 May 2022 02:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiENCzW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 May 2022 22:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiENCzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 May 2022 22:55:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73E734A029
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 May 2022 19:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D614FB83257
        for <linux-trace-devel@vger.kernel.org>; Sat, 14 May 2022 02:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B27C34118;
        Sat, 14 May 2022 02:47:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nphoz-005XM8-BE;
        Fri, 13 May 2022 22:47:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 04/26] trace-cmd: Move find_pid_by_cid() into add_guest()
Date:   Fri, 13 May 2022 22:47:34 -0400
Message-Id: <20220514024756.1319681-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220514024756.1319681-1-rostedt@goodmis.org>
References: <20220514024756.1319681-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

To simplify the code even more, move the find_pid_by_cid() into
add_guest() to map the main pid process to the cid.

Link: https://lore.kernel.org/linux-trace-devel/20220428150635.789051-5-rostedt@goodmis.org

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vm.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 7a91038d75dc..4b4e039bd2cb 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -54,6 +54,8 @@ bool trace_have_guests_pid(void)
 	return true;
 }
 
+static void find_pid_by_cid(struct trace_guest *guest);
+
 static struct trace_guest *add_guest(unsigned int cid, const char *name)
 {
 	struct trace_guest *guest;
@@ -71,6 +73,8 @@ static struct trace_guest *add_guest(unsigned int cid, const char *name)
 	guest->cid = cid;
 	guest->pid = -1;
 
+	find_pid_by_cid(guest);
+
 	return guest;
 }
 
@@ -307,11 +311,8 @@ struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
 
 	if (cid > 0) {
 		guest = get_guest_by_cid(cid);
-		if (!guest && name) {
+		if (!guest && name)
 			guest = add_guest(cid, name);
-			if (guest)
-				find_pid_by_cid(guest);
-		}
 	}
 	return guest;
 }
@@ -321,7 +322,6 @@ struct trace_guest *trace_get_guest(unsigned int cid, const char *name)
 #define VM_CID_ID	"address='"
 static void read_guest_cid(char *name)
 {
-	struct trace_guest *guest;
 	char *cmd = NULL;
 	char line[512];
 	char *cid;
@@ -343,9 +343,7 @@ static void read_guest_cid(char *name)
 		cid_id = strtol(cid + strlen(VM_CID_ID), NULL, 10);
 		if ((cid_id == INT_MIN || cid_id == INT_MAX) && errno == ERANGE)
 			continue;
-		guest = add_guest(cid_id, name);
-		if (guest)
-			find_pid_by_cid(guest);
+		add_guest(cid_id, name);
 		break;
 	}
 
-- 
2.35.1

