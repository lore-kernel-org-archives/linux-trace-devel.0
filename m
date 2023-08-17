Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849DBC64ECC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355021AbjHQUp6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 16:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354990AbjHQUp0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 16:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6AE30D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 13:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4767D63ED5
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 20:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB9DC433CA;
        Thu, 17 Aug 2023 20:45:22 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWjs1-000Tp3-0R;
        Thu, 17 Aug 2023 16:45:29 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v4 01/20] libtraceeval histograms: Fix traceeval_results_release() error message
Date:   Thu, 17 Aug 2023 16:45:09 -0400
Message-Id: <20230817204528.114577-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817204528.114577-1-rostedt@goodmis.org>
References: <20230817204528.114577-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function traceeval_results_release() must have a teval if passed in to
free the accompanying results, but currently the error message is only
displayed if the results is NULL and teval exists. It should be the other
way around.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/histograms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/histograms.c b/src/histograms.c
index a159892e509b..d22d15238616 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -681,7 +681,7 @@ void traceeval_results_release(struct traceeval *teval,
 			       union traceeval_data *results)
 {
 	if (!teval || !results) {
-		if (!results)
+		if (!teval)
 			print_err("Results to be freed without accompanied traceeval instance!");
 		return;
 	}
-- 
2.40.1

