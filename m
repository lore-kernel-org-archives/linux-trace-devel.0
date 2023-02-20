Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1798CC05027
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Feb 2023 17:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjBTRy1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Feb 2023 12:54:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjBTRy0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Feb 2023 12:54:26 -0500
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A74F1F912
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Feb 2023 09:54:23 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ayaya.dev; s=key1;
        t=1676915660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D3vg956ibmEfoN1H8Ior4y1Ghi8CWPBWxQbZqbt7fco=;
        b=UKdMShPvIYcuuGSXtHtov+7HqBU62VWqWzAw4y/py4DqQToN8lgXfw2xMCOaM2/9LZywag
        gH0uZJkmoVr+u6rOOLqzRzFp2D1X7hdR7ymSlD6hPVxA9Sk3an0jV7I2m5leUh0qHLZUMa
        xWf1Iv6+A4gXZlFrHgcjJPvb7RBgZ+8=
From:   psykose <alice@ayaya.dev>
To:     linux-trace-devel@vger.kernel.org
Cc:     psykose <alice@ayaya.dev>
Subject: [PATCH] libtraceevent: fix some missing commas in big endian blocks
Date:   Mon, 20 Feb 2023 18:52:41 +0100
Message-Id: <20230220175241.15424-1-alice@ayaya.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

the lack of a trailing comma makes the array definition invalid, since elements
must be comma delimited in the initialiser. so, add one in the big endian case
too.

Signed-off-by: psykose <alice@ayaya.dev>
---
 utest/traceevent-utest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
index ebd5eb9..041843e 100644
--- a/utest/traceevent-utest.c
+++ b/utest/traceevent-utest.c
@@ -45,7 +45,7 @@ static char dyn_str_data[] = {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	/* common type */		1, 0x00,
 #else
-	/* common type */		0x00, 1
+	/* common type */		0x00, 1,
 #endif
 	/* common flags */		0x00,
 	/* common_preempt_count */	0x00,
@@ -82,7 +82,7 @@ static char dyn_str_old_data[] = {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	/* common type */		2, 0x00,
 #else
-	/* common type */		0x00, 2
+	/* common type */		0x00, 2,
 #endif
 	/* common flags */		0x00,
 	/* common_preempt_count */	0x00,
@@ -166,7 +166,7 @@ static char sizeof_data[] = {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	/* common type */		23, 0x00,
 #else
-	/* common type */		0x00, 23
+	/* common type */		0x00, 23,
 #endif
 	/* common flags */		0x00,
 	/* common_preempt_count */	0x00,
-- 
2.39.2

