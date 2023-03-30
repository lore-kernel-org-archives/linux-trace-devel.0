Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C6DC761A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Mar 2023 18:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjC3Swo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 14:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjC3Swn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 14:52:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE7DFF3A
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Mar 2023 11:52:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 01C5E219E6;
        Thu, 30 Mar 2023 18:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680202343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Az2cNVIvgxzkStMlDWPi3f911ZMX3ggcRYCfYG8Fr34=;
        b=T0FRTpK3nND4223+lpPdRzQf17ea+1wFIYWl1pkdS6VGugIhAxoSl1Gyq0iZBdn+B/EeBd
        wA9eKCxIJJ9s9uCOv0Yu1OUkuyxp9VuOANUnfnfTM0KErJM3hv7QaognOEwkrvze+QZO96
        HMdUJfJ8XdLXBjLq+cIkuRLwFQ8glmE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680202343;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Az2cNVIvgxzkStMlDWPi3f911ZMX3ggcRYCfYG8Fr34=;
        b=gcOdQ9i0uemCLsSOUKW0VnQA8C0qKhykCHBCfz34IhoOoXTJXKYnOZnHGOREgfchJIdJFg
        VjD/AYR+0qdvcKBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 698AB133E0;
        Thu, 30 Mar 2023 18:52:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3oRQDGbaJWSvMgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 30 Mar 2023 18:52:22 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH trace-cmd v2 1/3] trace-cmd report: Ensure filter is applied to single input file
Date:   Thu, 30 Mar 2023 15:52:09 -0300
Message-Id: <20230330185211.5604-2-krisman@suse.de>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330185211.5604-1-krisman@suse.de>
References: <20230330185211.5604-1-krisman@suse.de>
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
Since v1:
  - use rev. xmas tree for variable declaration (steve)
---
 tracecmd/trace-read.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 52ba818..6a872d7 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -564,14 +564,15 @@ static void make_pid_filter(struct tracecmd_input *handle,
 
 static void process_filters(struct handle_list *handles)
 {
+	struct input_files *input_file = handles->input_file ?: last_input_file;
 	struct tracecmd_filter *trace_filter;
 	struct filter_str *filter;
 	int filters = 0;
 
-	make_pid_filter(handles->handle, handles->input_file);
+	make_pid_filter(handles->handle, input_file);
 
-	if (handles->input_file)
-		filter = handles->input_file->filter_str;
+	if (input_file)
+		filter = input_file->filter_str;
 	else
 		filter = filter_strings;
 
-- 
2.40.0

