Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F31C48BDC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A5D821726
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 17:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF0RHf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbfF0RHf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 13:07:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FA85214DA;
        Thu, 27 Jun 2019 17:07:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hgXrx-0004Uz-7y; Thu, 27 Jun 2019 13:07:33 -0400
Message-Id: <20190627170733.133714152@goodmis.org>
User-Agent: quilt/0.65
Date:   Thu, 27 Jun 2019 13:05:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Troy Engel <troyengel@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: Have "make clean" run cmake-clean.sh
References: <20190627170553.050679238@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

A make clean should clean up the cmake files as well.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile            | 1 +
 kernel-shark/README | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 693f33b69b4e..c9679d42fdbd 100644
--- a/Makefile
+++ b/Makefile
@@ -357,6 +357,7 @@ clean:
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
+	cd $(kshark-dir)/build; ./cmake_clean.sh
 
 
 ##### PYTHON STUFF #####
diff --git a/kernel-shark/README b/kernel-shark/README
index 7155e13b17fc..b133f1848fd2 100644
--- a/kernel-shark/README
+++ b/kernel-shark/README
@@ -49,7 +49,7 @@ changed by passing in "prefix" to the build.
    make prefix=/usr gui
 
 2.1.1.2 Use "make clean" if you want to delete all already compiled objects.
-Note, this will not clean up the files created by cmake. See section 2.1.2.4
+This will also clean up all the files created by cmake.
 
 2.1.2 Option 2 (expert) : standalone build of KernelShark (for hackers only)
 
-- 
2.20.1


