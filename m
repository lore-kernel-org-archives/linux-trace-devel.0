Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C00AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 02:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiBVCd4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:33:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiBVCdz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 21:33:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB6C25C5E
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Feb 2022 18:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DCAB811BB
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01631C340E9
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 02:33:27 +0000 (UTC)
Date:   Mon, 21 Feb 2022 21:33:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix regression of not reading older data files
Message-ID: <20220221213314.18516bf0@yoga.local.home>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

I have some old trace.dat files that for some reason have the version
missing from its file, causing it to flag a "version 0". Because there's
now a check for reading a minimum version, it fails to read these files
when it use to read them just fine. If there's no version number in the
file or the minimum is below what it thinks it is, then just read it.

Fixes: 6482f99a47ac ("trace-cmd library: Define trace file version 7")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index f5c77e9154c1..2cf8974ef4ee 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -630,7 +630,7 @@ int tracecmd_default_file_version(void)
 
 bool tracecmd_is_version_supported(unsigned int version)
 {
-	if (version >= FILE_VERSION_MIN && version <= FILE_VERSION_MAX)
+	if (version <= FILE_VERSION_MAX)
 		return true;
 	return false;
 }
-- 
2.34.1

