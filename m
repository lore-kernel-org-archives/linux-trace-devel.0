Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FCA1EB64DA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jul 2023 16:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjGJQuf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 12:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjGJQuf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 12:50:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66374F4
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jul 2023 09:50:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1BF561132
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jul 2023 16:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FF3C433C8;
        Mon, 10 Jul 2023 16:50:32 +0000 (UTC)
Date:   Mon, 10 Jul 2023 12:50:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Sharon Gabay <Sharon.Gabay@mobileye.com>
Subject: [PATCH] trace-cmd split: Fix creation of temp files to include
 output name
Message-ID: <20230710125031.0e140727@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The creation of the temp files for creating the split did the following:

	output = strdup(output_file);
	dir = dirname(output);
	base = basename(output);

The problem with the above is that dirname() modifies "output" to add a
'\0' after the directory name. That is, if we had output_file = '/tmp/test';
Then the following will happen:

	output = copy of "/tmp/test"
	dir = dirname(output);

This will set dir to "/tmp" and insert a '\0' into the second '/'. This
also has the side effect of changing output to "/tmp" as well.

Then to get the base name:

	base = basename(output);

base will end up as "tmp" and not as "test". The temp file will then be:

		ret = asprintf(&file, "%s/.tmp.%s.%d", dir, base, cpu);

	"/tmp/.tmp.tmp.1"

This is incorrect, as it should have been "/tmp/.tmp.test.1".

This can easily be fixed by swapping the assignment of dir and base:

	base = basename(output);
	dir = dirname(output);

As then, after the assignment of base, base would be "test" and output
would still be "/tmp/test", allowing for dir to get "/tmp".

Link: https://lore.kernel.org/linux-trace-users/VE1PR09MB3535122A0DA44242886307B9F233A@VE1PR09MB3535.eurprd09.prod.outlook.com/

Reported-by: Sharon Gabay <Sharon.Gabay@mobileye.com>
Fixes: d9b58d42c43c2 ("trace-cmd: Fix temp files in trace-cmd split to include directories")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 59df1d02b345..4fda781307e6 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -367,8 +367,9 @@ static double parse_file(struct tracecmd_input *handle,
 	int fd;
 
 	output = strdup(output_file);
-	dir = dirname(output);
+	/* Extract basename() first, as dirname() truncates output */
 	base = basename(output);
+	dir = dirname(output);
 
 	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES, 0, NULL);
 
-- 
2.39.2

