Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83B6C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 03:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344107AbiBPDOE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:14:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344110AbiBPDOC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 22:14:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C99D10BC
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 19:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE8EBB81DCC
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 03:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7D8C340F6;
        Wed, 16 Feb 2022 03:13:47 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1nKAlG-00481h-G9;
        Tue, 15 Feb 2022 22:13:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtraceevent: Add API tep_get_function_count()
Date:   Tue, 15 Feb 2022 22:13:44 -0500
Message-Id: <20220216031345.984113-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216031345.984113-1-rostedt@goodmis.org>
References: <20220216031345.984113-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a way to get the number of registered functions in a tep handler.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-func_apis.txt |  5 ++++-
 include/traceevent/event-parse.h          |  2 ++
 src/event-parse-api.c                     | 14 ++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-func_apis.txt b/Documentation/libtraceevent-func_apis.txt
index 89e307afe63f..1fe450023772 100644
--- a/Documentation/libtraceevent-func_apis.txt
+++ b/Documentation/libtraceevent-func_apis.txt
@@ -4,7 +4,8 @@ libtraceevent(3)
 NAME
 ----
 tep_find_function, tep_find_function_address, tep_set_function_resolver,
-tep_reset_function_resolver, tep_register_function, tep_register_print_string -
+tep_reset_function_resolver, tep_register_function, tep_register_print_string,
+tep_get_function_count - 
 function related tep APIs
 
 SYNOPSIS
@@ -20,6 +21,7 @@ const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned
 unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
 int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
 int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
+int *tep_get_function_count*(struct tep_handle *_tep_)
 --
 
 DESCRIPTION
@@ -75,6 +77,7 @@ addresses and those strings. The _tep_ argument is the trace event parser
 context. The _fmt_ is the string to register, it is copied internally.
 The _addr_ is the address the string was located at.
 
+*tep_get_function_count*() returns the number of registered functions in a tep handler.
 
 RETURN VALUE
 ------------
diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 68b2f4383b42..0b911e1caa7c 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -566,6 +566,8 @@ struct tep_event **tep_list_events_copy(struct tep_handle *tep,
 struct tep_format_field **tep_event_common_fields(struct tep_event *event);
 struct tep_format_field **tep_event_fields(struct tep_event *event);
 
+int tep_get_function_count(struct tep_handle *tep);
+
 enum tep_endian {
         TEP_LITTLE_ENDIAN = 0,
         TEP_BIG_ENDIAN
diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index a765a683f05d..268a58609419 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -50,6 +50,20 @@ int tep_get_events_count(struct tep_handle *tep)
 	return 0;
 }
 
+/**
+ * tep_get_events_count - get the number of defined events
+ * @tep: a handle to the tep_handle
+ *
+ * This returns number of elements in event array
+ * If @tep is NULL, 0 is returned.
+ */
+int tep_get_function_count(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->func_count;
+	return 0;
+}
+
 /**
  * tep_set_flag - set event parser flag
  * @tep: a handle to the tep_handle
-- 
2.34.1

