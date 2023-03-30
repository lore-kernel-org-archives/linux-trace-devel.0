Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10556C761A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Mar 2023 18:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjC3Swv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 14:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjC3Swu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 14:52:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23224EC7C
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Mar 2023 11:52:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 91BBC1F85D;
        Thu, 30 Mar 2023 18:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680202346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jZutCq9+0TxYs9yO+EsXc7MsuG/N5ce7rR6afByPjx4=;
        b=srZk09M3x2nL0IFoodN8dPiSAYTVNiMCH5jcUtab7GluCrGDRKb+8dN1xRrz84c67i2j40
        zvqv62GBqAkhbzwZEPIAPTDQz7/5jXx5Un4QazRccvVjEeHb0eA/J8bCnE7Y4jsCCHFQtn
        xIXkpIW0q9nFACW2FtIp6ml+LJB6nCU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680202346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jZutCq9+0TxYs9yO+EsXc7MsuG/N5ce7rR6afByPjx4=;
        b=I+a5IXfuIthsz3ChlYaQ1gkJc3VlE/j4mvY7qSvd1GjaIcyk+WYUWjC/s0e0Gwklm3Ab23
        gadejatgREZ+XODg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E321133E0;
        Thu, 30 Mar 2023 18:52:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ChJwL2naJWS9MgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 30 Mar 2023 18:52:25 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH trace-cmd v2 2/3] trace-cmd-report: Support global filters
Date:   Thu, 30 Mar 2023 15:52:10 -0300
Message-Id: <20230330185211.5604-3-krisman@suse.de>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330185211.5604-1-krisman@suse.de>
References: <20230330185211.5604-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a filter is provided before an input file, consider it globally
applying to all traces:

i.e., the following will trace kernel_stack out of both traces instead
of only the first:

  $ trace-cmd report -v -F kernel_stack -i trace1.dat -i trace2.dat

Filter order matters due to the order of processing. Always process
global filters first, which are likely more generic.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 tracecmd/trace-read.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6a872d7..f645c05 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -562,30 +562,40 @@ static void make_pid_filter(struct tracecmd_input *handle,
 	}
 }
 
+static int __process_filters(struct tracecmd_input *handle,
+			     struct filter_str *filters)
+{
+	struct tracecmd_filter *trace_filter;
+
+	for (; filters; filters = filters->next) {
+		trace_filter = tracecmd_filter_add(handle,
+						   filters->filter,
+						   filters->neg);
+		if (!trace_filter)
+			die("Failed to create event filter: %s",
+			    filters->filter);
+	}
+
+	return !!filters;
+}
+
 static void process_filters(struct handle_list *handles)
 {
 	struct input_files *input_file = handles->input_file ?: last_input_file;
-	struct tracecmd_filter *trace_filter;
-	struct filter_str *filter;
-	int filters = 0;
+	int added = 0;
 
 	make_pid_filter(handles->handle, input_file);
 
+	/*
+	 * Order of filter processing matters. Apply the global filters
+	 * before file-specific ones.
+	 */
+	added += __process_filters(handles->handle, filter_strings);
 	if (input_file)
-		filter = input_file->filter_str;
-	else
-		filter = filter_strings;
-
-	for (; filter; filter = filter->next) {
-		trace_filter = tracecmd_filter_add(handles->handle,
-						   filter->filter,
-						   filter->neg);
-		if (!trace_filter)
-			die("Failed to create event filter: %s", filter->filter);
+		added += __process_filters(handles->handle,
+					   input_file->filter_str);
 
-		filters++;
-	}
-	if (filters && test_filters_mode)
+	if (added && test_filters_mode)
 		exit(0);
 }
 
-- 
2.40.0

