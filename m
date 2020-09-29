Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690A7C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B99207F7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgI2Rtf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:49:35 -0400
Received: from foss.arm.com ([217.140.110.172]:48918 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728198AbgI2Rtf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 13:49:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9836B31B;
        Tue, 29 Sep 2020 10:49:34 -0700 (PDT)
Received: from e120877-lin.cambridge.arm.com (e120877-lin.cambridge.arm.com [10.1.194.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1FA2F3F70D;
        Tue, 29 Sep 2020 10:49:34 -0700 (PDT)
From:   vincent.donnefort@arm.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Vincent Donnefort <vincent.donnefort@arm.com>
Subject: [PATCH] trace-cmd: fix extract output option
Date:   Tue, 29 Sep 2020 18:49:26 +0100
Message-Id: <1601401766-54400-1-git-send-email-vincent.donnefort@arm.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Vincent Donnefort <vincent.donnefort@arm.com>

During the introduction of instance's output_file copy:

  3a206ca ("trace-cmd: Have instances include a copy of its output file")

The extract path has been omitted, leading to a broken output option:

  $ trace-cmd extract -o /foo/bar.dat # Will fallback to ./trace.dat

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

