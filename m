Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B775EC6FA82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiIVPYO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiIVPYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0B7F8F8C
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A72463619
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001FDC43470;
        Thu, 22 Sep 2022 15:24:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzkm-1z;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/9] libtraceevent: Update man page to reflect tep_is_pid_registered() rename
Date:   Thu, 22 Sep 2022 11:25:03 -0400
Message-Id: <20220922152510.3335601-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The commit that renamed tep_pid_is_registered to
tep_is_pid_registered() missed a location that had the old name.

Fixes: 241ac93c8527 ("tools tools, tools lib traceevent: Make traceevent APIs more consistent")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-commands.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-commands.txt b/Documentation/libtraceevent-commands.txt
index 185ff16a1352..cea3001df888 100644
--- a/Documentation/libtraceevent-commands.txt
+++ b/Documentation/libtraceevent-commands.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_register_comm, tep_override_comm, tep_pid_is_registered,
+tep_register_comm, tep_override_comm, tep_is_pid_registered,
 tep_data_comm_from_pid, tep_data_pid_from_comm, tep_cmdline_pid -
 Manage pid to process name mappings.
 
-- 
2.35.1

