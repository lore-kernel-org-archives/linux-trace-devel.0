Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDCFC32771
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIVAWw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiIVAWv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:22:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F949F772
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:22:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2799632FE
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B0AC433D6;
        Thu, 22 Sep 2022 00:22:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA0M-00Dr3L-2d;
        Wed, 21 Sep 2022 20:23:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd: Do not return zero length name for guest by name
Date:   Wed, 21 Sep 2022 20:23:48 -0400
Message-Id: <20220922002348.3302169-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002348.3302169-1-rostedt@goodmis.org>
References: <20220922002348.3302169-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function trace_get_guest() will first look for a guest by name, and
if it finds one, it will return it. But if the guest added did not have
a name (but had an empty string), it would return any guest that also
did not have a name (but just an empty string). If two guests did not
have a name, and the CID was used, then the first guest would be
returned for the second guest, breaking the creating of two guests where
both were without names.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-vm.c b/tracecmd/trace-vm.c
index 09bd60259258..f78f1d83386b 100644
--- a/tracecmd/trace-vm.c
+++ b/tracecmd/trace-vm.c
@@ -35,7 +35,7 @@ static struct trace_guest *get_guest_by_name(const char *name)
 {
 	int i;
 
-	if (!guests)
+	if (!guests || !strlen(name))
 		return NULL;
 
 	for (i = 0; i < guests_len; i++)
-- 
2.35.1

