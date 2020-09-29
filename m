Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2938C4741F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A65C208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ugk4JzML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgI2Nly (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgI2Nlx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:41:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20460C0613D0
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:52 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k18so4854706wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=Ugk4JzMLQwFp/Mi69XU3kgxVVPWSrOe2rGP4sJmn14GDTfdZIOto0G23um0Tp/rJ//
         AW7kjDeM713Fls2NfPdT0r0nLaZx3aa4pNTGfT2B6ISbhtIzh1Snpg5UV5zzrGXzPZDm
         JMV1wNZ2xPDba8hGkmUrmzuTrWZ5P0aA7HlWB6MMXNXQDIvgERqqBz/kteQzg4RPxQ5X
         QVGsz5QxQSrIzJE55gHkRFmu+TQTxIYAmFj2eMgrHOIQ5FFe1Iy0IauyX//AnZAq+JBS
         hDy34/byz9Z1+nadCPQ9+H8gVSPi/0LVzlcuUIVKdMTDSPf9P7AaA1ldOruAMkk1YWzH
         z/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUrqS/GpSejn2uuqZhUncbHZ8n9JUDOzQHUiRMQRzu4=;
        b=YprXoJfaLJp9vEb+592mu14r8vDhDtG9Bs5ndcmschR2Y3duEQZ7kJwaITlTreGp8q
         QUc8y3V5nW/ZzdiJsMSeFg1huDhE6une2i723TNm79GjGV+wUbafidVvq7L/rHmOyUR9
         k/fJ8OM2d+DqGIXsZYLwTCER9+M7UysW0e1lqjXDFmvKQV6d7Npm52nktyPSF+XAo3Ei
         1MztaN/BkgBl5XyUXtLabpA1siqsPJUS5EEj7QFBl+W8Uex74Uvrp9MguVhlQRvnp6/o
         ZPhvJ7UJzv/qZ30Jx3Ft+kHsmHVD0AZBXNhRbtAUf+0bsTCGfl+1bgCArl8xoT44xYwX
         ypbg==
X-Gm-Message-State: AOAM530o/xKVGtIg35hhYvedhAib/yukssJzfV7jGb8E70xppYiSh9Kp
        ImaoIRBDVlu9Ml8Z7X7IpqI=
X-Google-Smtp-Source: ABdhPJz4Ov4xWF1tFVjIEfi6SrztOGxxUVvEEvSVlWxJsO6mSpghZkXbTdkPIytvWlVJ4VcEjCYuSQ==
X-Received: by 2002:a1c:2e08:: with SMTP id u8mr4941497wmu.156.1601386910793;
        Tue, 29 Sep 2020 06:41:50 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:41:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 04/15] kernel-shark: Use only signed types in kshark_entry
Date:   Tue, 29 Sep 2020 16:41:12 +0300
Message-Id: <20200929134123.178688-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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
index 0d6c50d..9eecc2d 100644
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

