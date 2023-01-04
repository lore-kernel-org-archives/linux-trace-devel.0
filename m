Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7EBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjADRho (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjADRh1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:37:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E900A39FB9
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:37:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82CD1617C9
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2127C433D2
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:37:25 +0000 (UTC)
Date:   Wed, 4 Jan 2023 12:37:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Add check for duplicate functions in man pages
Message-ID: <20230104123722.00887044@gandalf.local.home>
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
index 1166bbe82cad..f73a6c573f6c 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -15,12 +15,19 @@ cd $1
 MAIN=libtracecmd
 MAIN_FILE=${MAIN}.txt
 
+PROCESSED=""
+
 # Ignore man pages that do not contain functions
 IGNORE=""
 
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

