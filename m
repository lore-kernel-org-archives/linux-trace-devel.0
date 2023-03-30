Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F9CC761A6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Mar 2023 18:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjC3Sw5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjC3Sw4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 14:52:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A35E38D
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Mar 2023 11:52:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2EF5B219E1;
        Thu, 30 Mar 2023 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680202350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9/LX+/x0zQKBc/HM3MPlOiF5a3jsDjP4p7tApoRAXuQ=;
        b=HvgHFhfnfr8qdvI8J//nm0F8YKj5uKBH2IpmwHr2cP7E7UqYEvRy8PaYZMAoEr5kuQutVO
        5WIHVhAHNkCEtkLgPZD+X+zJThB+HtuaeIp2IYOvzIBkTDOuNeJvLTaFAhs/qW2W01hvyh
        ezWA5Kp2Fmb7i9h2VVKvIPnrvRtH1iE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680202350;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9/LX+/x0zQKBc/HM3MPlOiF5a3jsDjP4p7tApoRAXuQ=;
        b=0fVzk5go5qZEPI3mKDQrxnB6YeZ25UIHHYL9bb3dXKkpO362biFZCfHV+PqLK5jv1isycE
        xsPhIVYgv21+mjAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9BC68133E0;
        Thu, 30 Mar 2023 18:52:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nHpzFm3aJWTFMgAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 30 Mar 2023 18:52:29 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH trace-cmd v2 3/3] documentation: trace-cmd-report: Document filter scope
Date:   Thu, 30 Mar 2023 15:52:11 -0300
Message-Id: <20230330185211.5604-4-krisman@suse.de>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230330185211.5604-1-krisman@suse.de>
References: <20230330185211.5604-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Document how filters provided before any input files are global while
filters coming after a -i only apply to that filter.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 Documentation/trace-cmd/trace-cmd-report.1.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-report.1.txt b/Documentation/trace-cmd/trace-cmd-report.1.txt
index 71df9a8..ddbde81 100644
--- a/Documentation/trace-cmd/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-report.1.txt
@@ -69,8 +69,12 @@ OPTIONS
     is only to the microsecond. To see the full timestamp, add the *-t* option.
 
 *-F* 'filter'::
-    Add a filter to limit what events are displayed. The format of the filter
-    is:
+    Add a filter to limit what events are displayed.  Filters defined
+    after an input file (specified with *-i*) only apply to that
+    input file. Filters provided before any input file is given are
+    considered global and apply to all input files.
+
+    The format of the filter is:
 
 [source,bison]
 ----
-- 
2.40.0

