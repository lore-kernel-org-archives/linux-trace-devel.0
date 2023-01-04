Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36834C46467
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbjADR1D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240104AbjADR1A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:27:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018C8F00E
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF28EB81893
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 17:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CD0C433F1;
        Wed,  4 Jan 2023 17:26:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1pD7XU-000bsO-0e;
        Wed, 04 Jan 2023 12:26:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtraceevent: Add check for duplicate functions in man pages
Date:   Wed,  4 Jan 2023 12:26:54 -0500
Message-Id: <20230104172655.145516-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230104172655.145516-1-rostedt@goodmis.org>
References: <20230104172655.145516-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the check-manpages.sh script to make sure that there are no
functions that are described in more than one man page.

The output will look like this:

  Found tep_find_function in libtraceevent-func_find.txt and in libtraceevent-func_apis.txt
  Found tep_find_function_address in libtraceevent-func_find.txt and in libtraceevent-func_apis.txt

Link: https://lore.kernel.org/linux-trace-devel/20221224153225.ojre2c3fxktfxtj2@carbon.lan/

Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 check-manpages.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/check-manpages.sh b/check-manpages.sh
index 85b3b7406864..4e9850f18c3d 100755
--- a/check-manpages.sh
+++ b/check-manpages.sh
@@ -15,12 +15,19 @@ cd $1
 MAIN=libtraceevent
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

