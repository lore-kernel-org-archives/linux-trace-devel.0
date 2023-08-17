Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C03C2FC20
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 01:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347536AbjHQBdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 21:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347547AbjHQBdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 21:33:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE802723
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Aug 2023 18:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A478163D8D
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9DAC433CA;
        Thu, 17 Aug 2023 01:33:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWRst-000N3k-1a;
        Wed, 16 Aug 2023 21:33:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 03/18] libtraceeval hist: Add pointer and const string types
Date:   Wed, 16 Aug 2023 21:32:55 -0400
Message-Id: <20230817013310.88582-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817013310.88582-1-rostedt@goodmis.org>
References: <20230817013310.88582-1-rostedt@goodmis.org>
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
index 08e0696f2d83..f6c4e8efb2be 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -25,6 +25,7 @@ enum traceeval_data_type {
 	TRACEEVAL_TYPE_NUMBER_32,
 	TRACEEVAL_TYPE_NUMBER_64,
 	TRACEEVAL_TYPE_NUMBER,
+	TRACEEVAL_TYPE_POINTER,
 	TRACEEVAL_TYPE_STRING,
 	TRACEEVAL_TYPE_DYNAMIC
 };
@@ -52,6 +53,8 @@ struct traceeval_dynamic {
 union traceeval_data {
 	struct traceeval_dynamic	dyn_data;
 	char				*string;
+	const char			*cstring;
+	void				*pointer;
 	unsigned long			number;
 	unsigned long long		number_64;
 	unsigned int			number_32;
-- 
2.40.1

