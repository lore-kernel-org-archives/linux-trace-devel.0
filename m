Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A7BC6369E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAC2246AA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oh4AGdP3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgKROu1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbgKROu1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:27 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1347C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:26 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id o15so2480866wru.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=oh4AGdP3S/MS0MGcCqpIvX60hHRcHuKdovVTUnPK6s/zKkH+m9iFYHQJiNnpAC7RFB
         cAuhSFzWh/OLb87+fVvI8NaVLdV53DeIumaUfO+bJDE0cfvsLJXj24ovKsgkVeMLhkAk
         kvaj92ubaDS2N5HGxjPBmomzoALiKBP3pwMBwPtvRkge5fNhgKbZZZbqNzCpqCFVKw8Z
         KKG/ZdnrT9Bh/To32ct4ww/s5ectAIsz+6eov0N6vMmWpxLltH8+yraZVCXiQXpnrAYW
         CceKPacBRg8biIVTOsyNLe0X1jBUVmjl2gJ9GmZOs+eqbPCaZEUS6lKRrVmx93890Q/4
         x2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=bEJuZP2QXNrDNnjBwKBY/vKNglyNEuBlww2lNHH+MyJgM1bkz2IZxCIZA0/24g09X6
         q8qgaHmHWIaodwV/CfWlxV0aJ/OxGJK1tmczWTBoXsdvAmMAMdraUQUzO2T2OIvS44pO
         ncuccm9XV262siWekQ0NOgd3iNy6sR8SAzE8zetmelunmFRXHozCz79yrLhZ6DOx1amF
         y0gZvb21NTBk72QuWReRtkSdPCefGTLCjkcDozaVQ8SY68/Nb/CZalSiR6EPz4a+nYlB
         zDK9j6ksVgODJiiCGawsBf2IqqE+zoNGYJgb+9K6z9zpBbsBpNECg6PCQ+rYDX3Zh269
         96MA==
X-Gm-Message-State: AOAM532AwCNj3IP5adT8J3ha44l4sAp9VEI/xf5Se8/ZhuSRuveGX+j0
        PxPb4KIpNzgsq/k1Qn6VPeemt65X8SU=
X-Google-Smtp-Source: ABdhPJzYt8ht+27ri3UGVlGdX4qFoxE84Hv/L7MhNunnyAA7h/GshFeMhCQ8vAsw4DoqRxgrSVUbkw==
X-Received: by 2002:adf:f783:: with SMTP id q3mr4994918wrp.88.1605711025393;
        Wed, 18 Nov 2020 06:50:25 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 01/20] kernel-shark: Use only signed types in kshark_entry
Date:   Wed, 18 Nov 2020 16:49:44 +0200
Message-Id: <20201118145003.156542-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using uint64_t for the value of the offset was just wrong. According
to the POSIX standard off_t is a signed integer type with unspecified
size. Here we stick to a 64 bit integer, because this size guaranties
optimal packing of the kshark_entry structure.

Using unsigned values for the timestamps is also a source of problems
and has been a reason for the introduction of multiple bugs in the past.
In principal the value of the timestamps cannot be negative. However,
this value must have the same type as the values used to define the
state of the visualization model, like the range of the model or the
size of the bin. The model state definitions should not take negative
values as well, however their values are recalculated automatically when
the user browses the data and those calculations may result in negative
values in some corner cases. Because of this it is better to use a
signed integer type and treat the negative values as an indicator
of an error rather than have the negative result of the calculations
casted into unsigned type which results into unpredictable behavior of
the model.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libkshark.h b/src/libkshark.h
index 0d6c50d1..9eecc2d0 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -61,7 +61,7 @@ struct kshark_entry {
 	int32_t		event_id;
 
 	/** The offset into the trace file, used to find the record. */
-	uint64_t	offset;
+	int64_t		offset;
 
 	/**
 	 * The time of the record in nano seconds. The value is taken from
@@ -69,7 +69,7 @@ struct kshark_entry {
 	 * dependent. The time usually is the timestamp from when the system
 	 * started.
 	 */
-	uint64_t	ts;
+	int64_t		ts;
 };
 
 /** Size of the task's hash table. */
-- 
2.25.1

