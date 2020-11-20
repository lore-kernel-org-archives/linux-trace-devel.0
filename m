Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680EDC63798
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 061DB222BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dzhmTcZ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgKTJnZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgKTJnZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC213C0617A7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id q3so8809456edr.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=dzhmTcZ4Whzb+mhOOOiVXH821UXQfbUbKZc/5sliYcNl1v8n0sRbEgl7c/sxpBCRpi
         HD8KqSj6GOtlyUEGY4a1Wernd6S7Ivy6iQhChY7wfFZNKWVrtSrbzwwJfLE9cVsh0LAe
         EwhWEZfyYRRl0NNlNxYBb01M7FkMWZu4hlbuMF2XaCQNtJRGYvyDrb/5SDSJjw+pnpt2
         igX6wjS9Foe6ZX/ZUMsxSIlRm8mtKhEH5jPJ+v64IUZNBHbG5g2wGLC22M25MECX1zdV
         iiqXToSKlFz3ofqKjhBGAgEhmgilaaErtGUZa9jIs3EApe4puBbuWOLF2u0N8RdEKfJR
         2NjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9O0IeQDBm05Vx1oL137gxy8HhEf9zbyDs7+3Vndszg=;
        b=tLlw4bc6wTMFGehpJTGKLq5o58lQxOFFepzB6s+4TR+8f3tdtoGZE/7Ih6g7/udQ0S
         86kbWCPA7WvGpw5/2s+TjQ7S5RZWgcBH3TCFrOSTA7O8uify0ZkNyXKyBqsgyZu7uQlc
         895ncyPoPFZ78yi37SNDTxkVDFhCSuN2IM8wPUiCk0Ettv47CnP4JZfx/Yx5G3dHpAFR
         ear2injw736SsbihmT9zKXPP14Sc5N4I5x0CB0QN7+mffImDo+EGm3EBexHwJHVjwhDC
         dL36eoju+yYpoNf+LDQ4QnmBx9SdqSOIkap2WUF1RaiQJndTpqAJ1ZBMhN1BmVPe6/Dm
         zajw==
X-Gm-Message-State: AOAM530fVMZav0TAIuspRXrrpllVYtWQ6K3lAHqlliYkmX3NpGd+Lzau
        6ETiSenf27X5dDFEDOuQmZG3YPo5ytE=
X-Google-Smtp-Source: ABdhPJzJXzBVFQ81ywvS404c6NGrD1U65d3mH4xRbjxZmFb5kTSVD+owYk4raZEjKj5oXs1eqCtomQ==
X-Received: by 2002:a05:6402:2da:: with SMTP id b26mr33728283edx.176.1605865403684;
        Fri, 20 Nov 2020 01:43:23 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 01/20] kernel-shark: Use only signed types in kshark_entry
Date:   Fri, 20 Nov 2020 11:42:45 +0200
Message-Id: <20201120094304.271502-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
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

