Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AFEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Dec 2022 20:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLJUhC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 15:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLJUhB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 15:37:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA40F1402E
        for <linux-trace-devel@vger.kernel.org>; Sat, 10 Dec 2022 12:37:00 -0800 (PST)
Received: from bigeasy by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <sebastian@breakpoint.cc>)
        id 1p46ag-0000Tz-Rh
        for linux-trace-devel@vger.kernel.org; Sat, 10 Dec 2022 21:36:58 +0100
Date:   Sat, 10 Dec 2022 21:36:58 +0100
From:   Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Let subcommand "convert" automatically if
 possible.
Message-ID: <Y5Tt6p0ONpuDVIS2@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Let the convert subcommand compress automatically if the file format
allows it and the user did not specify it.
This already the case the record command.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc
---
 Documentation/trace-cmd/trace-cmd-convert.1.txt | 3 ++-
 tracecmd/trace-convert.c                        | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-convert.1.txt b/Documentation/trace-cmd/trace-cmd-convert.1.txt
index 7c13cf3dcd625..21f580d6e1b6c 100644
--- a/Documentation/trace-cmd/trace-cmd-convert.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-convert.1.txt
@@ -13,7 +13,8 @@ DESCRIPTION
 -----------
 The trace-cmd(1) convert command converts trace file. It reads the input file and copies the data
 into an output file. The output file may be in different format, depending on the command line
-arguments.
+arguments. The default output is in version 7 and compressed (if
+compiled with compression support).
 
 OPTIONS
 -------
diff --git a/tracecmd/trace-convert.c b/tracecmd/trace-convert.c
index 88935dc7b0a4c..e72a352685f42 100644
--- a/tracecmd/trace-convert.c
+++ b/tracecmd/trace-convert.c
@@ -104,6 +104,8 @@ void trace_convert(int argc, char **argv)
 		input_file = DEFAULT_INPUT_FILE;
 	if (!output_file)
 		usage(argv);
+	if (file_version >= FILE_VERSION_COMPRESSION && !compression)
+		compression = "any";
 
 	convert_file(input_file, output_file, file_version, compression);
 }
-- 
2.38.1

