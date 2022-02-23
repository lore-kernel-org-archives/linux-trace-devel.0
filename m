Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9E4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiBWAal (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6D355BCF
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0133561299
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71055C340E8;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGD-E7;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 03/11] libtracefs: Have check-manpages.sh check tracefs.h as well
Date:   Tue, 22 Feb 2022 19:30:04 -0500
Message-Id: <20220223003012.1334741-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Test to make sure that all functions listed in tracefs.h are described in
libtracefs.txt man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/check-manpages.sh b/check-manpages.sh
index b455fecd124b..33419a92fd2f 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -36,3 +36,14 @@ for man in ${MAIN}-*.txt; do
 		fi
 	done
 done
+
+sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/tracefs.h | while read f; do
+	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
+		if [ "$last" == "" ]; then
+			echo
+			echo "Missing functions from $MAIN_FILE that are in tracefs.h"
+			last=$f
+		fi
+		echo "   ${f}"
+	fi
+done
-- 
2.34.1

