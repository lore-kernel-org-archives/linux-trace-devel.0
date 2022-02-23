Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED26CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 23 Feb 2022 02:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiBWCxF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbiBWCw7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 21:52:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2842506CE
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 18:52:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BDBA6130F
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 02:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710E9C340E8
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Feb 2022 02:52:31 +0000 (UTC)
Date:   Tue, 22 Feb 2022 21:52:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Fix the ftrace filter function man pages
Message-ID: <20220222215229.3805b46e@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The ftrace filter function man page had a title for each function at the
beginning. The beginning of the file is to list the functions that are
explained in the man page with a single description of the man page.
Having one for each of the three functions breaks the creation of the man
page and two of the three functions did not have their man pages created
for them.

Fixes: 7c9565e6ba2d7 ("libtracefs: Add tracefs_function_notrace() API")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs-function-filter.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
index d12f61406448..2a141fd00db2 100644
--- a/Documentation/libtracefs-function-filter.txt
+++ b/Documentation/libtracefs-function-filter.txt
@@ -3,9 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_function_filter - Function to limit kernel functions that are traced
-tracefs_function_notrace - Function to filter kernel functions that not to be traced
-tracefs_filter_functions - Function to list the functions that are available for filtering
+tracefs_function_filter, tracefs_function_notrace, tracefs_filter_functions
+- Functions to modify the the function trace filters
 
 SYNOPSIS
 --------
-- 
2.34.1

