Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBE8C6FA8E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIVA2n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIVA2m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F13A9267
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65775B82856
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C8FC433B5;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr5E-0D;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/5] trace-cmd library: Make tracecmd_filter_match() local
Date:   Wed, 21 Sep 2022 20:29:37 -0400
Message-Id: <20220922002940.3302285-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002940.3302285-1-rostedt@goodmis.org>
References: <20220922002940.3302285-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracecmd_filter_match() is really an internal function. It
should not be exported for other applications (The trace-cmd core
functions do not use it). It should definitely not be in the public
headers.

Move the prototype so that it is only used internally within the
library.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace-cmd/trace-cmd.h           | 2 --
 lib/trace-cmd/include/trace-cmd-local.h | 3 +++
 lib/trace-cmd/trace-filter.c            | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 4963f45dfe12..331815b9edc2 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -76,7 +76,5 @@ enum tracecmd_filters {
 struct tracecmd_filter;
 struct tracecmd_filter *tracecmd_filter_add(struct tracecmd_input *handle,
 					    const char *filter_str, bool neg);
-enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
-					    struct tep_record *record);
 
 #endif /* _TRACE_CMD_H */
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 2a458133204b..c95ec6530fdd 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -49,6 +49,9 @@ struct data_file_write {
 	unsigned long long	file_data_offset;
 };
 
+enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
+					    struct tep_record *record);
+
 void tracecmd_compress_init(void);
 void tracecmd_compress_free(void);
 
diff --git a/lib/trace-cmd/trace-filter.c b/lib/trace-cmd/trace-filter.c
index f7eb46c762d6..1c8c07fcf0da 100644
--- a/lib/trace-cmd/trace-filter.c
+++ b/lib/trace-cmd/trace-filter.c
@@ -44,8 +44,8 @@ static bool test_stacktraces(struct tracecmd_filter *filter, struct tep_record *
 		test_stacktrace(filter, record, filter->user_stacktrace_id);
 }
 
-enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
-					    struct tep_record *record)
+__hidden enum tracecmd_filters tracecmd_filter_match(struct tracecmd_filter *filter,
+						     struct tep_record *record)
 {
 	bool found = false;
 	int ret;
-- 
2.35.1

