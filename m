Return-Path: <SRS0=C+o5=XV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A10C43630
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:38:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD6C621D6C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569458303;
	bh=yYb3OVLZ03u8iBtjzHpj5RH9u0fHI6Q24A8klTbA8P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=zv9GFQ0KQe/oNZxOpgdEhwAQ/WB2v/zRbYdRTofG9QKVOTus/gxZZN3eq6hUiWAUY
	 93ilboXfUMJEUwY1+3HIkbMZfxafUSYd1OwJKc7g10gg6zIetePjXJo/AAszYNAfMA
	 MFDDFC81apea6yFpHeOMbEf+6S1JhU3qlb5084qk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388070AbfIZAdk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 20:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfIZAdj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 20:33:39 -0400
Received: from quaco.localdomain (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A020221D7B;
        Thu, 26 Sep 2019 00:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569458017;
        bh=yYb3OVLZ03u8iBtjzHpj5RH9u0fHI6Q24A8klTbA8P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vm49aB/f2IeyvPoVdFwzV4qHcc7Qf7Fu4toXiYG2hBfMqDzryrbEQJ9D5KnOzv2M4
         p8Joq1RgBYZY9tTK+KPFTjH1F9oRWBoPzKdNQsM48J+ntNVKGZHnYTPA35PCYW5djJ
         qH0rdwDVokMicZ9Bkot6g54peMaEbh/5fKcpZW+c=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/66] libtraceevent: Man pages fix, rename tep_ref_get() to tep_get_ref()
Date:   Wed, 25 Sep 2019 21:31:47 -0300
Message-Id: <20190926003244.13962-10-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926003244.13962-1-acme@kernel.org>
References: <20190926003244.13962-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

The tep_ref_get() was renamed to tep_get_ref(), to be more consistent
with the other tep_ref_* APIs. However, in the man pages the API is
still with the old name. The documentation is fixed to reflect the
actual name of the API.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190808113636.13299-2-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190919212541.697034573@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
2.21.0

