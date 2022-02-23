Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B427C43219
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 00:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiBWAao (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 19:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiBWAan (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 19:30:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743155BEF
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 16:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0F5661330
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1BAC340FA;
        Wed, 23 Feb 2022 00:30:14 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nMfXp-005bGk-KZ;
        Tue, 22 Feb 2022 19:30:13 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 10/11] libtracefs: Do not check for deprecated functions
Date:   Tue, 22 Feb 2022 19:30:11 -0500
Message-Id: <20220223003012.1334741-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223003012.1334741-1-rostedt@goodmis.org>
References: <20220223003012.1334741-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

tracefs_event_append_filter() and tracefs_event_verify_filter() are
deprecated, where tracefs_filter_string_append() and
tracefs_filter_string_verify() should be used instead. They are purposely
not in the man pages. Do not have the checker warn about them.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/check-manpages.sh b/check-manpages.sh
index 33419a92fd2f..d3ec6af65c50 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -37,8 +37,13 @@ for man in ${MAIN}-*.txt; do
 	done
 done
 
+DEPRECATED="*tracefs_event_append_filter* *tracefs_event_verify_filter*"
+
 sed -ne 's/^[a-z].*[ \*]\([a-z_][a-z_]*\)(.*/\1/p' -e 's/^\([a-z_][a-z_]*\)(.*/\1/p' ../include/tracefs.h | while read f; do
 	if ! grep -q '\*'${f}'\*' $MAIN_FILE; then
+		if [ "${DEPRECATED/\*$f\*/}" != "${DEPRECATED}" ]; then
+			continue;
+		fi
 		if [ "$last" == "" ]; then
 			echo
 			echo "Missing functions from $MAIN_FILE that are in tracefs.h"
-- 
2.34.1

