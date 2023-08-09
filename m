Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D046C41513
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 03:13:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjHIDNZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 23:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjHIDNT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 23:13:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A14B1FCE
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 20:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA57962EFC
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46915C433CB;
        Wed,  9 Aug 2023 03:13:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qTZdL-005Rvj-2r;
        Tue, 08 Aug 2023 23:13:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/6] libtraceeval hist: Add pointer and const string types
Date:   Tue,  8 Aug 2023 23:13:09 -0400
Message-Id: <20230809031313.1298605-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809031313.1298605-1-rostedt@goodmis.org>
References: <20230809031313.1298605-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a pointer type to traceeval_data, as this can be used as a generic
pointer type. This may even obsolete the dynamic type.

Also, add a const char * "cstring" type. There's times where the key and
value data needs to be assigned to a const char *string, and without
having an option of that type, the compiler complains about losing the
const.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index e713c70e3fa3..03e050cdbed4 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -25,6 +25,7 @@ enum traceeval_data_type {
 	TRACEEVAL_TYPE_NUMBER_16,
 	TRACEEVAL_TYPE_NUMBER_8,
 	TRACEEVAL_TYPE_NUMBER,
+	TRACEEVAL_TYPE_POINTER,
 	TRACEEVAL_TYPE_STRING,
 	TRACEEVAL_TYPE_DYNAMIC
 };
@@ -41,7 +42,9 @@ enum traceeval_flags {
  */
 union traceeval_data {
 	char				*string;
+	const char			*cstring;
 	struct traceeval_dynamic	*dyn_data;
+	void				*pointer;
 	unsigned long long		number_64;
 	unsigned long			number;
 	unsigned int			number_32;
-- 
2.40.1

