Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B78C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiBWAam (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A88255BE7
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C216130C
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD4FC340F0;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGA-DK;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 02/11] libtracefs: Do not check libtracefs-options.txt man page
Date:   Tue, 22 Feb 2022 19:30:03 -0500
Message-Id: <20220223003012.1334741-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The trace_options man page is there to list options and does not contain
any functions. It should be ignored from the check as it does not have
functions.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/check-manpages.sh b/check-manpages.sh
index a52281198f6e..b455fecd124b 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -15,9 +15,15 @@ cd $1
 MAIN=libtracefs
 MAIN_FILE=${MAIN}.txt
 
+# Ignore man pages that do not contain functions
+IGNORE="libtracefs-options.txt"
+
 for man in ${MAIN}-*.txt; do
 
 	sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man | while read a; do
+		if [ "${IGNORE/$man/}" != "${IGNORE}" ]; then
+			continue
+		fi
 		if ! grep -q '\*'${a}'\*' $MAIN_FILE; then
 			if [ "$last" == "" ]; then
 				echo
-- 
2.34.1

