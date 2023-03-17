Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F0E5C7618B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Mar 2023 21:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjCQVZm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 17:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCQVZl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 17:25:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EF122A06
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Mar 2023 14:25:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 86A3E1FE2C;
        Fri, 17 Mar 2023 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679088278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4OhquL+OIBkfaZXBnuxR9upCt+XJNFVGOuv5eJIMr2s=;
        b=z1CR10c2uqW6o2jUuqjD79bDCNFDSQc9FLh7SlsKfdQzM5ePUAoe401XdyTT98mxm40nZ4
        CdjWud7OP9o6uhX09cmjz/6yjpQQlbWUajEG3d/FBk0+y1G8i1Fz5K5yihoYYsC0uip6FJ
        3BXG5msaS9kUMCSuDwes43kZWBJ8bQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679088278;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=4OhquL+OIBkfaZXBnuxR9upCt+XJNFVGOuv5eJIMr2s=;
        b=SvptRRKIlLlxL9LyKmUlrop80FSBh0sn9h+Q9dHwLoY2Fchm8dCde3p9CESGwei/cnLfLP
        EfzIl1FYQVhph+Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BD8C1346F;
        Fri, 17 Mar 2023 21:24:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6LKjMJXaFGS8NwAAMHmgww
        (envelope-from <krisman@suse.de>); Fri, 17 Mar 2023 21:24:37 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH trace-cmd] trace-cmd report: Ensure filter is applied to single input file
Date:   Fri, 17 Mar 2023 18:24:30 -0300
Message-Id: <20230317212430.12675-1-krisman@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since 955d05fc7aee ("trace-cmd report: Make filter arguments match their
files"), the -F filtering is silently ignored when a trace file is
provided with -i and the filter comes after -i .  The reason is that the
filter is now associated with input_files and not saved to the global
list only in this case, but process_filters still only checks the global
list when handles->input_file is not set.

Avoid this by checking last_input_file first, which always contains a
pointer to the correct filter in this case.

This was only lightly tested, using a single trace file.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217038
Fixes: 955d05fc7aee ("trace-cmd report: Make filter arguments match their files")
Signed-off-by: Gabriel krisman Bertazi <krisman@suse.de>
---
 tracecmd/trace-read.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 52ba818..dbbd124 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -567,11 +567,15 @@ static void process_filters(struct handle_list *handles)
 	struct tracecmd_filter *trace_filter;
 	struct filter_str *filter;
 	int filters = 0;
+	struct input_files *input_file = handles->input_file;
 
-	make_pid_filter(handles->handle, handles->input_file);
+	if (!input_file)
+		input_file = last_input_file;
 
-	if (handles->input_file)
-		filter = handles->input_file->filter_str;
+	make_pid_filter(handles->handle, input_file);
+
+	if (input_file)
+		filter = input_file->filter_str;
 	else
 		filter = filter_strings;
 
-- 
2.35.3

