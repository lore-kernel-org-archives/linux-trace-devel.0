Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D649C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 00:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345622AbiAKARL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 19:17:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40426 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345849AbiAKARK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 19:17:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A8BB81856
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 00:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8D0C36AE9;
        Tue, 11 Jan 2022 00:17:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1n74qZ-002uDp-0W;
        Mon, 10 Jan 2022 19:17:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 2/2] libtraceevent: Allow ipsa arg to use dynamic arrays
Date:   Mon, 10 Jan 2022 19:17:05 -0500
Message-Id: <20220111001705.692692-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220111001705.692692-1-rostedt@goodmis.org>
References: <20220111001705.692692-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As the print format of %pIS can handle different types of sockets that may
be of different sizes, a dynamic array may be used to save the socket
instead of a static field.

Allow %pIS to be used against a dynamic array.

Link: https://lore.kernel.org/all/164182978641.8391.8277203495236105391.stgit@bazille.1015granger.net/

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/event-parse.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 5f3e2d8a6421..d3e43e5c11f8 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -5139,6 +5139,8 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 	unsigned char *buf;
 	struct sockaddr_storage *sa;
 	bool reverse = false;
+	unsigned int offset;
+	unsigned int len;
 	int rc = 0;
 	int ret;
 
@@ -5168,27 +5170,38 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 	while (arg->type == TEP_PRINT_TYPE)
 		arg = arg->typecast.item;
 
-	if (arg->type != TEP_PRINT_FIELD) {
-		trace_seq_printf(s, "ARG TYPE NOT FIELD BUT %d", arg->type);
-		return rc;
-	}
+	if (arg->type == TEP_PRINT_FIELD) {
 
-	if (!arg->field.field) {
-		arg->field.field =
-			tep_find_any_field(event, arg->field.name);
 		if (!arg->field.field) {
-			do_warning("%s: field %s not found",
-				   __func__, arg->field.name);
-			return rc;
+			arg->field.field =
+				tep_find_any_field(event, arg->field.name);
+			if (!arg->field.field) {
+				do_warning("%s: field %s not found",
+					   __func__, arg->field.name);
+				return rc;
+			}
 		}
+
+		offset = arg->field.field->offset;
+		len = arg->field.field->size;
+
+	} else if (arg->type == TEP_PRINT_DYNAMIC_ARRAY) {
+
+		dynamic_offset_field(event->tep, arg->dynarray.field, data,
+				     size, &offset, &len);
+
+	} else {
+		trace_seq_printf(s, "ARG NOT FIELD NOR DYNAMIC ARRAY BUT TYPE %d",
+				 arg->type);
+		return rc;
 	}
 
-	sa = (struct sockaddr_storage *) (data + arg->field.field->offset);
+	sa = (struct sockaddr_storage *)(data + offset);
 
 	if (sa->ss_family == AF_INET) {
 		struct sockaddr_in *sa4 = (struct sockaddr_in *) sa;
 
-		if (arg->field.field->size < sizeof(struct sockaddr_in)) {
+		if (len < sizeof(struct sockaddr_in)) {
 			trace_seq_printf(s, "INVALIDIPv4");
 			return rc;
 		}
@@ -5201,7 +5214,7 @@ static int print_ipsa_arg(struct trace_seq *s, const char *ptr, char i,
 	} else if (sa->ss_family == AF_INET6) {
 		struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) sa;
 
-		if (arg->field.field->size < sizeof(struct sockaddr_in6)) {
+		if (len < sizeof(struct sockaddr_in6)) {
 			trace_seq_printf(s, "INVALIDIPv6");
 			return rc;
 		}
-- 
2.33.0

