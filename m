Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF89C4167E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241636AbhLPVkD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbhLPVkC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C5C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 13:40:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2EC5B82650
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1654C36AF1;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dr-V6;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 10/10] libtraceevent: Have print_field_raw() handle old data layout
Date:   Thu, 16 Dec 2021 16:39:56 -0500
Message-Id: <20211216213956.13934-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Old kernels would produce dynamic strings with only a two byte offset. The
length of the array was determined by the string length. When parsing, if
the field is dynamic with a size of 2, then it is the old dynamic string
layout. Set the field to both a string and an array.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/event-parse.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 40af92f4295f..9bd605d74b1f 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1828,6 +1828,16 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 		field->size = strtoul(token, NULL, 0);
 		free_token(token);
 
+		/*
+		 * The old data format before dynamic arrays had dynamic
+		 * strings defined with just a 2 byte offset (the length
+		 * is defined by the strlen() of the string. To process them
+		 * correctly, check if the field is dynamic and has a size of
+		 * 2 bytes. All current dynamic events have a size of 4.
+		 */
+		if ((field->flags & TEP_FIELD_IS_DYNAMIC) && field->size == 2)
+			field->flags |= TEP_FIELD_IS_STRING | TEP_FIELD_IS_ARRAY;
+
 		if (read_expected(TEP_EVENT_OP, ";") < 0)
 			goto fail_expect;
 
-- 
2.33.0

