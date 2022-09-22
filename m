Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FDBC6FA92
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbiIVPYQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiIVPYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B49F8C37
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC016361F
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057F6C43140;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzl4-2M;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 8/9] libtraceevent: Add man page documentation of tep_get_sub_buffer_size()
Date:   Thu, 22 Sep 2022 11:25:09 -0400
Message-Id: <20220922152510.3335601-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page for tep_get_sub_buffer_size() is missing, add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-page_size.txt | 10 +++++++++-
 Documentation/libtraceevent.txt           |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-page_size.txt b/Documentation/libtraceevent-page_size.txt
index 7ffeb790002a..6d0dd36e3d68 100644
--- a/Documentation/libtraceevent-page_size.txt
+++ b/Documentation/libtraceevent-page_size.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_get_page_size, tep_set_page_size - Get / set the size of a memory page on
+tep_get_page_size, tep_set_page_size, tep_get_sub_buffer_size - Get / set the size of a memory page on
 the machine, where the trace is generated
 
 SYNOPSIS
@@ -14,6 +14,7 @@ SYNOPSIS
 
 int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
 --
 
 DESCRIPTION
@@ -27,10 +28,17 @@ memory page on the machine, where the trace is generated.
 The _tep_ argument is trace event parser context.
 The _page_size_ argument is the size of a memory page, in bytes.
 
+The *tep_get_sub_buffer_size()* returns the size of each "sub buffer" of the
+ring buffer. The Linux kernel ring buffer is broken up into sections called
+sub buffers. This returns the size of those buffers.
+
 RETURN VALUE
 ------------
 The *tep_get_page_size()* function returns size of the memory page, in bytes.
 
+The *tep_get_sub_buffer_size()* function returns the number of bytes each sub
+buffer is made up of.
+
 EXAMPLE
 -------
 [source,c]
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 045437cb2282..0d0795e79b53 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -26,6 +26,7 @@ Management of tep handler data structure and access of its members:
 	void *tep_set_long_size*(struct tep_handle pass:[*]_tep_, int _long_size_);
 	int *tep_get_page_size*(struct tep_handle pass:[*]_tep_);
 	void *tep_set_page_size*(struct tep_handle pass:[*]_tep_, int _page_size_);
+	int *tep_get_sub_buffer_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_page_size*(struct tep_handle pass:[*]_tep_);
 	int *tep_get_header_timestamp_size*(struct tep_handle pass:[*]_tep_);
 	bool *tep_is_old_format*(struct tep_handle pass:[*]_tep_);
-- 
2.35.1

