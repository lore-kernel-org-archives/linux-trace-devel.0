Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C84C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0BB4613D1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhDVVIK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:08:10 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:20412 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236877AbhDVVIJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:08:09 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 22 Apr 2021 14:07:30 -0700
Received: from vypre.com (unknown [10.21.244.251])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 1AE9220472;
        Thu, 22 Apr 2021 14:07:33 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Nicolas Sterchele <nicolas@sterchelen.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] trace-cmd: Add printf format attribute to die() and warning()
Date:   Thu, 22 Apr 2021 17:07:29 -0400
Message-ID: <20210422210730.857958-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210422210730.857958-1-rostedt@goodmis.org>
References: <20210422210730.857958-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add the gcc printf format attribute to die(), __die() and warning() such
that any mistake in the formats of the output will be caught by the
compiler.

Link: https://lore.kernel.org/linux-trace-devel/20210422165148.6d0ea90e@gandalf.local.home/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/include/trace-local.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4235ae21..eadf103e 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -27,6 +27,9 @@ typedef unsigned long long u64;
 
 struct buffer_instance;
 
+#define __printf(a, b) __attribute__((format(printf,a,b)))
+
+__printf(1,2)
 void warning(const char *fmt, ...);
 
 /* for local shared information with trace-cmd executable */
@@ -331,8 +334,10 @@ int trace_open_vsock(unsigned int cid, unsigned int port);
 char *trace_get_guest_file(const char *file, const char *guest);
 
 /* No longer in event-utils.h */
+__printf(1,2)
 void __noreturn die(const char *fmt, ...); /* Can be overriden */
 void *malloc_or_die(unsigned int size); /* Can be overridden */
+__printf(1,2)
 void __noreturn __die(const char *fmt, ...);
 void __noreturn _vdie(const char *fmt, va_list ap);
 
-- 
2.29.2

