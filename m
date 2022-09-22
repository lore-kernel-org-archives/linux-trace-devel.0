Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F64C6FA96
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiIVPYT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbiIVPYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD81F8F8B
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E96163623
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08083C43141;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzl7-2P;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 9/9] libtraceevent: Add tep_print_field() to check-manpages.sh deprecated
Date:   Thu, 22 Sep 2022 11:25:10 -0400
Message-Id: <20220922152510.3335601-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As tep_print_field() is deprecated, do not report it as missing from the
man pages.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check-manpages.sh b/check-manpages.sh
index a2f4f264b42b..06a94f154ff9 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -37,7 +37,7 @@ for man in ${MAIN}-*.txt; do
 	done
 done
 
-DEPRECATED=""
+DEPRECATED="*tep_print_field*"
 
 sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/traceevent/event-parse.h | while read f; do
 	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
-- 
2.35.1

