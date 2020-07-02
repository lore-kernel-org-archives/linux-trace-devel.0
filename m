Return-Path: <SRS0=hXpH=AN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29F7C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A09E121534
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jul 2020 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgGBRMH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jul 2020 13:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgGBRMC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jul 2020 13:12:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4F9D21473;
        Thu,  2 Jul 2020 17:12:00 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jr2kg-004Asp-C7; Thu, 02 Jul 2020 13:11:58 -0400
Message-ID: <20200702171158.240195038@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 02 Jul 2020 13:10:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 9/9] tools lib traceevent: Add more SVM exit reasons
References: <20200702171016.178196716@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Exceptions require individual decoding (only feasible intercepts
listed), XSETBV was missing and the AVIC brought in two new exit codes.

Link: http://lkml.kernel.org/r/5741D822.3030203@web.de
Link: http://lore.kernel.org/linux-trace-devel/20200625100516.365338-10-tz.stoyanov@gmail.com

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/plugins/plugin_kvm.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/plugins/plugin_kvm.c b/tools/lib/traceevent/plugins/plugin_kvm.c
index c8e623065a7e..768c658f5904 100644
--- a/tools/lib/traceevent/plugins/plugin_kvm.c
+++ b/tools/lib/traceevent/plugins/plugin_kvm.c
@@ -155,7 +155,23 @@ static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
 	_ER(EXIT_WRITE_DR5,	0x035)		\
 	_ER(EXIT_WRITE_DR6,	0x036)		\
 	_ER(EXIT_WRITE_DR7,	0x037)		\
-	_ER(EXIT_EXCP_BASE,     0x040)		\
+	_ER(EXIT_EXCP_DE,	0x040)		\
+	_ER(EXIT_EXCP_DB,	0x041)		\
+	_ER(EXIT_EXCP_BP,	0x043)		\
+	_ER(EXIT_EXCP_OF,	0x044)		\
+	_ER(EXIT_EXCP_BR,	0x045)		\
+	_ER(EXIT_EXCP_UD,	0x046)		\
+	_ER(EXIT_EXCP_NM,	0x047)		\
+	_ER(EXIT_EXCP_DF,	0x048)		\
+	_ER(EXIT_EXCP_TS,	0x04a)		\
+	_ER(EXIT_EXCP_NP,	0x04b)		\
+	_ER(EXIT_EXCP_SS,	0x04c)		\
+	_ER(EXIT_EXCP_GP,	0x04d)		\
+	_ER(EXIT_EXCP_PF,	0x04e)		\
+	_ER(EXIT_EXCP_MF,	0x050)		\
+	_ER(EXIT_EXCP_AC,	0x051)		\
+	_ER(EXIT_EXCP_MC,	0x052)		\
+	_ER(EXIT_EXCP_XF,	0x053)		\
 	_ER(EXIT_INTR,		0x060)		\
 	_ER(EXIT_NMI,		0x061)		\
 	_ER(EXIT_SMI,		0x062)		\
@@ -201,7 +217,10 @@ static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
 	_ER(EXIT_MONITOR,	0x08a)		\
 	_ER(EXIT_MWAIT,		0x08b)		\
 	_ER(EXIT_MWAIT_COND,	0x08c)		\
-	_ER(EXIT_NPF,		0x400)		\
+	_ER(EXIT_XSETBV,	0x08d)		\
+	_ER(EXIT_NPF, 		0x400)		\
+	_ER(EXIT_AVIC_INCOMPLETE_IPI,		0x401)	\
+	_ER(EXIT_AVIC_UNACCELERATED_ACCESS,	0x402)	\
 	_ER(EXIT_ERR,		-1)
 
 #define _ER(reason, val)	{ #reason, val },
-- 
2.26.2


