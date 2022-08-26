Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED814ECAAD4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Aug 2022 14:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiHZOZN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHZOZM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 10:25:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F202119001
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Aug 2022 07:25:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0E0211F8B5;
        Fri, 26 Aug 2022 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661523908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IThnrQ7mfTnbfggKZYVWN0O4JfyccYqDP0aYwh8k4Xw=;
        b=FUW3xfHgo6GjKYiwxsv0cmBSZxvd1mHxHuOHB+JGry5j7096XSMCQrfv4dN4x+GBv4mAOl
        4UFuk6lKoMEOtOG1xzidEjpoY4/tgs5JpXKrU+iTFdphewdVxwGXBEB8QD3kjz+/w5/RQe
        8ItduYqzXUrye4JVqdD449fxcbjqYdA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DFFAD13421;
        Fri, 26 Aug 2022 14:25:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2MWkNcPXCGOnQwAAMHmgww
        (envelope-from <alexandre.vicenzi@suse.com>); Fri, 26 Aug 2022 14:25:07 +0000
From:   Alexandre Vicenzi <alexandre.vicenzi@suse.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Subject: [PATCH 2/3] libtracefs: Fix test suite typo
Date:   Fri, 26 Aug 2022 16:24:19 +0200
Message-Id: <20220826142420.29911-2-alexandre.vicenzi@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
References: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The correct suite name should be "tracefs library".

Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 1ab43d2..cda131e 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -17,7 +17,7 @@
 
 #include "tracefs.h"
 
-#define TRACEFS_SUITE		"trasefs library"
+#define TRACEFS_SUITE		"tracefs library"
 #define TEST_INSTANCE_NAME	"cunit_test_iter"
 #define TEST_TRACE_DIR		"/tmp/trace_utest.XXXXXX"
 #define TEST_ARRAY_SIZE		5000
-- 
2.34.1

