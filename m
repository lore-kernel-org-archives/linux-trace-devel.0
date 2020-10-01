Return-Path: <SRS0=JSNI=DI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A8CC4727C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Oct 2020 08:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B9420BED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  1 Oct 2020 08:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731365AbgJAI7g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 04:59:36 -0400
Received: from foss.arm.com ([217.140.110.172]:56428 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgJAI7g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 04:59:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91FE4D6E;
        Thu,  1 Oct 2020 01:59:35 -0700 (PDT)
Received: from e120877-lin.cambridge.arm.com (e120877-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ED9F43F70D;
        Thu,  1 Oct 2020 01:59:34 -0700 (PDT)
From:   vincent.donnefort@arm.com
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH v2] trace-cmd: Fix "trace-cmd extract" temp files path
Date:   Thu,  1 Oct 2020 09:59:29 +0100
Message-Id: <1601542769-443324-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

During the introduction of instance's output_file copy:

  3a206ca ("trace-cmd: Have instances include a copy of its output file")

The extract path has been omitted, causing the temp files created to be
written in the same directory using the null "output_file" of the
instance, to create "(null).cpuX" files. If this is executed in a
directory that is not writable (like /sys/kernel/tracing) or does not
have enough space to hold the temp files, then it will fail to write.

Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bd00457..72a5c8c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6622,6 +6622,9 @@ void trace_extract(int argc, char **argv)
 
 	/* Save the state of tracing_on before starting */
 	for_all_instances(instance) {
+		instance->output_file = strdup(ctx.output);
+		if (!instance->output_file)
+			die("Failed to allocate output file name for instance");
 
 		if (!ctx.manual && instance->flags & BUFFER_FL_PROFILE)
 			enable_profile(ctx.instance);
-- 
2.7.4

