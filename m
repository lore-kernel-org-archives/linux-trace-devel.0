Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DCAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Nov 2022 23:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKIXcL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 18:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiKIXcL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 18:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1E9E012
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 15:32:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F0BBB81F30
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA1EC433D6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Nov 2022 23:32:07 +0000 (UTC)
Date:   Wed, 9 Nov 2022 18:32:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Quiet gcc warning of snprintf truncation
Message-ID: <20221109183204.33ae109d@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add 256 to the size of cmd[] and xml[] to quiet the warnings:

trace-setup-guest.c: In function ‘attach_guest_fifos’:
trace-setup-guest.c:247:1: warning: ‘%s’ directive output may be truncated writing up to 4095 bytes into a region of size 4058 [-Wformat-truncation=]
  134 |                 snprintf(xml, sizeof(xml), xml_fmt, path, GUEST_PIPE_NAME, i);
      |                                                     ~~~~
......
  247 | }
      | ^
trace-setup-guest.c:247:1: note: directive argument in the range [0, 2147483646]
trace-setup-guest.c:134:17: note: ‘snprintf’ output between 102 and 4206 bytes into a destination of size 4096
  134 |                 snprintf(xml, sizeof(xml), xml_fmt, path, GUEST_PIPE_NAME, i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trace-setup-guest.c:247:1: warning: ‘%s’ directive output may be truncated writing up to 4095 bytes into a region of size 4063 [-Wformat-truncation=]
  137 |                 snprintf(cmd, sizeof(cmd), cmd_fmt, guest, tmp_path);
      |                                                            ~~~~~~~~
......
  247 | }
      | ^
trace-setup-guest.c:137:17: note: ‘snprintf’ output 58 or more bytes (assuming 4153) into a destination of size 4096
  137 |                 snprintf(cmd, sizeof(cmd), cmd_fmt, guest, tmp_path);

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-setup-guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index 899848cb254a..6b0a9fe8a5bc 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -121,7 +121,7 @@ static int attach_guest_fifos(const char *guest, int nr_cpus)
 		"  <target type='virtio' name='%s%d'/>\n"
 		"</channel>";
 	char tmp_path[PATH_MAX], path[PATH_MAX];
-	char cmd[PATH_MAX], xml[PATH_MAX];
+	char cmd[PATH_MAX + 256], xml[PATH_MAX + 256];
 	int i, fd, ret = 0;
 
 	strcpy(tmp_path, "/tmp/pipexmlXXXXXX");
-- 
2.35.1

