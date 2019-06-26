Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E243C4646B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 06:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCC2D20B7C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 06:01:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YLMk7yKd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFZGBP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 02:01:15 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:42696 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfFZGBP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 02:01:15 -0400
Received: by mail-pf1-f202.google.com with SMTP id y7so1032963pfy.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jun 2019 23:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6O4YttaDDRls66Ulc4bNEM+n50yUvG5+2fOz4v3tN1w=;
        b=YLMk7yKdsrmecoesBxA/Te/wcQXYh/8NJlPDZK+S8M8SfVo5B2FLv7qA7PVWKdNmg3
         Tfo3ZB8hgdT4PPBKJsKDWoQtZOZBH4hof84+Q58DZ940ZeLdW7Utj4LQh0xg5nnuf3Xm
         vMik4c0AYe22brOJCC7XlnmM7D08uW8SMR9r9zvnAPOb04+XU/nkJGyOewywylH7T2o3
         DxTF+JEb5sl5+YeQdj+RssnMf0v5iz3Os3q9zuXKx+GCWM1cOulwtS0ZkgOIgVaQTgin
         ecx0rA5XvET6vKVh8zp/hFzK4awstm5TJNp+z6Xqe6g7roRQ4ffz/e3N5aMxgRls9O9e
         XH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6O4YttaDDRls66Ulc4bNEM+n50yUvG5+2fOz4v3tN1w=;
        b=CHvFdJrxlDaI/zsBM829Bgz+5PPxMfpBGHLfoVOkjxaIFkvRJIQqnktWGgxrjMRtkf
         KYD3q0A/24wu4+CxhnV8Cd/M7DkqNR9+YeRJF9uRMXwX+h28hTIL/1fY/4kY6YXYvR+G
         qnZV9MuSZpgx3OVJY+WsXRHW681mxNqD6pboEiY1PcAJGWpvJbt3ECaaTqpc+VrUEox7
         abFTHqr4XEPt4kNAhhEx3ZIbT6YEi/UCVf2laHBh0qnTOw4r+8UWd1CA/gkqmSZAG6l9
         0zFwlqtsEdp+u5ceApLPTpJqgMZl3IDYNKiuAmjYpr4A3zTjSLXpdcRLGn1x5QyuC5xo
         c8UA==
X-Gm-Message-State: APjAAAUFFxL3n6WLqY6BqFjuMhkJ3wzXBxHM4hy4TON0CGHOw9ltySIL
        hOXsSNjA9zozjljVTalT8klwkV/i1f28
X-Google-Smtp-Source: APXvYqwPy8AhxFCHRidcqCmJ4jpcLZXeIS8L8fYko6r+BgJy4NypsFmNfSbsVbGORGuB26Bm+iZ0KEKuri5S
X-Received: by 2002:a65:5c0a:: with SMTP id u10mr1194707pgr.412.1561528874123;
 Tue, 25 Jun 2019 23:01:14 -0700 (PDT)
Date:   Tue, 25 Jun 2019 23:01:01 -0700
Message-Id: <20190626060101.220607-1-gthelen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] trace-cmd: remove ununsed knuth_hash*() routines
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Neither knuth_hash16() nor knuth_hash() are used.
Delete them.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 lib/trace-cmd/trace-filter-hash.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
index 39b28790e0bc..c56628f69ff0 100644
--- a/lib/trace-cmd/trace-filter-hash.c
+++ b/lib/trace-cmd/trace-filter-hash.c
@@ -29,26 +29,6 @@ static inline uint8_t knuth_hash8(uint32_t val)
 	return UINT8_C(val) * UINT8_C(157);
 }
 
-static inline uint16_t knuth_hash16(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^16.
-	 */
-	return UINT16_C(val) * UINT16_C(40507);
-}
-
-static inline uint32_t knuth_hash(uint32_t val)
-{
-	/*
-	 * Multiplicative hashing function.
-	 * Multiplication by the Prime number, closest to the golden
-	 * ratio of 2^32.
-	 */
-	return val * UINT32_C(2654435761);
-}
-
 struct tracecmd_filter_id_item *
 tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
 {
-- 
2.22.0.410.gd8fdbe21b5-goog

