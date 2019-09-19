Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D26C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AF19218AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 21:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390595AbfISVZn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390275AbfISVZn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 17:25:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FCC72196F;
        Thu, 19 Sep 2019 21:25:42 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1iB3vp-0008TG-QI; Thu, 19 Sep 2019 17:25:41 -0400
Message-Id: <20190919212541.697034573@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 19 Sep 2019 17:23:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 2/6] tools/lib/traceevent: Man pages fix, rename tep_ref_get() to
 tep_get_ref()
References: <20190919212335.400961206@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

The tep_ref_get() was renamed to tep_get_ref(), to be more consistent with
the other tep_ref_* APIs. However, in the man pages the API is still with
the old name. The documentation is fixed to reflect the actual name of the API.

Link: http://lore.kernel.org/linux-trace-devel/20190808113636.13299-2-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../lib/traceevent/Documentation/libtraceevent-handle.txt | 8 ++++----
 tools/lib/traceevent/Documentation/libtraceevent.txt      | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
index 8d568316847d..45b20172e262 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-handle.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_alloc, tep_free,tep_ref, tep_unref,tep_ref_get - Create, destroy, manage
+tep_alloc, tep_free,tep_ref, tep_unref,tep_get_ref - Create, destroy, manage
 references of trace event parser context.
 
 SYNOPSIS
@@ -16,7 +16,7 @@ struct tep_handle pass:[*]*tep_alloc*(void);
 void *tep_free*(struct tep_handle pass:[*]_tep_);
 void *tep_ref*(struct tep_handle pass:[*]_tep_);
 void *tep_unref*(struct tep_handle pass:[*]_tep_);
-int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+int *tep_get_ref*(struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -57,9 +57,9 @@ EXAMPLE
 ...
 struct tep_handle *tep = tep_alloc();
 ...
-int ref = tep_ref_get(tep);
+int ref = tep_get_ref(tep);
 tep_ref(tep);
-if ( (ref+1) != tep_ref_get(tep)) {
+if ( (ref+1) != tep_get_ref(tep)) {
 	/* Something wrong happened, the counter is not incremented by 1 */
 }
 tep_unref(tep);
diff --git a/tools/lib/traceevent/Documentation/libtraceevent.txt b/tools/lib/traceevent/Documentation/libtraceevent.txt
index fbd977b47de1..00519503c8de 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent.txt
@@ -16,7 +16,7 @@ Management of tep handler data structure and access of its members:
 	void *tep_free*(struct tep_handle pass:[*]_tep_);
 	void *tep_ref*(struct tep_handle pass:[*]_tep_);
 	void *tep_unref*(struct tep_handle pass:[*]_tep_);
-	int *tep_ref_get*(struct tep_handle pass:[*]_tep_);
+	int *tep_get_ref*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
 	void *tep_clear_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flag_);
 	bool *tep_test_flag*(struct tep_handle pass:[*]_tep_, enum tep_flag _flags_);
-- 
2.20.1


