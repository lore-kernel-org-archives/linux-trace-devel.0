Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B31C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbjADRbI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbjADRbE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:31:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2831463C1
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BF161745
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA9C433EF
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:31:01 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:31:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add check for duplicate functions in man pages
Message-ID: <20230104123100.63349d71@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the check-manpages.sh script to make sure that there are no
functions that are described in more than one man page.

Link: https://lore.kernel.org/linux-trace-devel/20230104172655.145516-2-rostedt@goodmis.org/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/check-manpages.sh b/check-manpages.sh
index d3ec6af65c50..776365c53403 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -15,12 +15,19 @@ cd $1
 MAIN=libtracefs
 MAIN_FILE=${MAIN}.txt
 
+PROCESSED=""
+
 # Ignore man pages that do not contain functions
 IGNORE="libtracefs-options.txt"
 
 for man in ${MAIN}-*.txt; do
 
-	sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man | while read a; do
+	for a in `sed -ne '/^NAME/,/^SYNOP/{/^[a-z]/{s/, *$//;s/,/\n/g;s/ //g;s/-.*$/-/;/-/{s/-//p;q};p}}' $man`; do
+		if [ "${PROCESSED/:${a} /}" != "${PROCESSED}" ]; then
+			P="${PROCESSED/:${a} */}"
+			echo "Found ${a} in ${man} and in ${P/* /}"
+		fi
+		PROCESSED="${man}:${a} ${PROCESSED}"
 		if [ "${IGNORE/$man/}" != "${IGNORE}" ]; then
 			continue
 		fi
-- 
2.35.1

