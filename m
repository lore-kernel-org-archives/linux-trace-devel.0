Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62261C00140
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Aug 2022 18:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiHHSDy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Aug 2022 14:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbiHHSDx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Aug 2022 14:03:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3C517077
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Aug 2022 11:03:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C6FA433963;
        Mon,  8 Aug 2022 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659981826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=lgIoSZ0i75Dg7dJZ8fBFibtvvAs8wVrZje6zNb0AFyE=;
        b=jIgv4aqJMem/OwCFNd1vQCZnepCwyqE4IMCxTo+4Ay3q3owTT4BfuW9dokk8JKfb7raLpo
        u16CICk3kmF30f+seiJuzDElfVtXqcekmr0wJ7nSjd+vB09EdQm8xAebaMPrdwO8OvgmJH
        nYUS5+8aCB0yuRkatPmypnjtyyfFYBk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A8EAB13AB3;
        Mon,  8 Aug 2022 18:03:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Q2QRKAJQ8WLPYgAAMHmgww
        (envelope-from <alexandre.vicenzi@suse.com>); Mon, 08 Aug 2022 18:03:46 +0000
From:   Alexandre Vicenzi <alexandre.vicenzi@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     bristot@kernel.org, rostedt@goodmis.org,
        Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Subject: [PATCH] rtla: fix tracer name
Date:   Mon,  8 Aug 2022 20:03:43 +0200
Message-Id: <20220808180343.22262-1-alexandre.vicenzi@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The correct tracer name is timerlat and not timelat.

Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
---
 Documentation/tools/rtla/rtla-timerlat-hist.rst | 2 +-
 tools/tracing/rtla/src/timerlat_hist.c          | 2 +-
 tools/tracing/rtla/src/timerlat_top.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/tools/rtla/rtla-timerlat-hist.rst b/Documentation/tools/rtla/rtla-timerlat-hist.rst
index e12eae1f3301..6bf7f0ca4556 100644
--- a/Documentation/tools/rtla/rtla-timerlat-hist.rst
+++ b/Documentation/tools/rtla/rtla-timerlat-hist.rst
@@ -33,7 +33,7 @@ EXAMPLE
 =======
 In the example below, **rtla timerlat hist** is set to run for *10* minutes,
 in the cpus *0-4*, *skipping zero* only lines. Moreover, **rtla timerlat
-hist** will change the priority of the *timelat* threads to run under
+hist** will change the priority of the *timerlat* threads to run under
 *SCHED_DEADLINE* priority, with a *10us* runtime every *1ms* period. The
 *1ms* period is also passed to the *timerlat* tracer::
 
diff --git a/tools/tracing/rtla/src/timerlat_hist.c b/tools/tracing/rtla/src/timerlat_hist.c
index f3ec628f5e51..4b48af8a8309 100644
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -892,7 +892,7 @@ int timerlat_hist_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&tool->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 35452a1d45e9..334271935222 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -687,7 +687,7 @@ int timerlat_top_main(int argc, char *argv[])
 	return_value = 0;
 
 	if (trace_is_off(&top->trace, &record->trace)) {
-		printf("rtla timelat hit stop tracing\n");
+		printf("rtla timerlat hit stop tracing\n");
 		if (params->trace_output) {
 			printf("  Saving trace to %s\n", params->trace_output);
 			save_trace_to_file(record->trace.inst, params->trace_output);
-- 
2.34.1

