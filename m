Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C83C001DE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Aug 2023 05:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjHKFjr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 01:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHKFjq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 01:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CADA910C7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Aug 2023 22:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E2A263FFA
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7573C433C9;
        Fri, 11 Aug 2023 05:39:44 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qUKsB-005uPh-2T;
        Fri, 11 Aug 2023 01:39:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 03/17] libtraceeval hist: Add pointer and const string types
Date:   Fri, 11 Aug 2023 01:39:26 -0400
Message-Id: <20230811053940.1408424-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230811053940.1408424-1-rostedt@goodmis.org>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
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

