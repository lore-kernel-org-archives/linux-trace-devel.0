Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE4C7C10F12
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A313F20854
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 22:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="l13kvR76"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfDOWxE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 18:53:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34469 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbfDOWxD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 18:53:03 -0400
Received: by mail-io1-f67.google.com with SMTP id n11so16051991ioh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 15:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkjIrKEQNQ3G7xnk8XYGn5F/+Y0cS2ZRMu00W+VyZSE=;
        b=l13kvR7644rfoKoxzoMRYJT7KFRzjE9KRkKEasZ/Q6oOShdyjJ7qKNMxGtEzcSksRq
         YQvbn+2nZz0HuqwE93Cp9KX2smsWC7DZ/tLGshgVH6v2bznWULCWlGsHl0pPO5MpkCXK
         V8JnsYr1RxMliDlXnubPtBfg0w4ix9utPBJOE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkjIrKEQNQ3G7xnk8XYGn5F/+Y0cS2ZRMu00W+VyZSE=;
        b=R39ohjnwPW8GfyEqN3qJVLx3JlZfDRfnWrGGSIh0JxTP5vxwOTlpLHjR01QqKsRP+P
         uTYJCNuUCszcMgVTq8+fURnKhiXxa9z5XnnmJ8PK0ZDlh4LS57rpJvAeXyCyUhLmypD1
         nbo6qReaWn5tcW65+fRVkIVSBfW7XW3vYpcrbyW2tth8SDdHdCarUG1gE6nJbteSWvSN
         iHRcVNmQU4MKOwAjNnC43/po7PlueCvgNKXpSrDSMZi+/+Lw3qs1aPxRu7nwvA3GNe1H
         0MybgkmzUpIAZtKxdu3s+e72490kB9SS2NFoAByxwRTgbs3xPFNq016rr0hvwxQQsAF0
         cAlg==
X-Gm-Message-State: APjAAAUOZFPlFTGaaxLDy0C2p6MKxuUQ6GOM2CgEGD+2HipHJb4lsqL5
        7WpvQqgaWv2Z6AwPd6CfsOvB1w==
X-Google-Smtp-Source: APXvYqwtwuYOp6f8Vhqlap+/EK5khOXtFLcn1jsF+Vxq86qoKG+/lfrqqNQq0TATHAy6SJUuidIzwA==
X-Received: by 2002:a6b:b285:: with SMTP id b127mr46548010iof.179.1555368782824;
        Mon, 15 Apr 2019 15:53:02 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 77sm8873833itl.17.2019.04.15.15.53.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 15:53:02 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     linux-mmc@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     djkurtz@chromium.org, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        hongjiefang <hongjiefang@asrmicro.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Kyle Roeschley <kyle.roeschley@ni.com>,
        Avri Altman <avri.altman@wdc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v1 2/4] mmc: core: Add trace event for SD SSR response
Date:   Mon, 15 Apr 2019 16:52:39 -0600
Message-Id: <20190415225241.70088-2-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
In-Reply-To: <20190415225241.70088-1-rrangel@chromium.org>
References: <20190415225241.70088-1-rrangel@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Example:
sd_ssr: mmc0: au: 8192, erase time: 0, erase offset: 0x0, raw: {0x0,0x3000000,0x1019000,0x10000,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}

Signed-off-by: Raul E Rangel <rrangel@chromium.org>
---

 drivers/mmc/core/sd.c      |  2 ++
 include/trace/events/mmc.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 3bed7c4b6d75..cc33a4f96c6a 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -282,6 +282,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 		}
 	}
 
+	trace_sd_ssr(card);
+
 	/*
 	 * starting SD5.1 discard is supported if DISCARD_SUPPORT (b313) is set
 	 */
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index e45258e8a6cb..cad604ee800f 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -52,6 +52,37 @@ TRACE_EVENT(sd_scr,
 	)
 );
 
+TRACE_EVENT(sd_ssr,
+
+	TP_PROTO(struct mmc_card *card),
+
+	TP_ARGS(card),
+
+	TP_STRUCT__entry(
+		__array(u32,			raw,	16)
+		__field(unsigned int,		au)
+		__field(unsigned int,		erase_timeout)
+		__field(unsigned int,		erase_offset)
+		__string(name,			mmc_hostname(card->host))
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->raw, card->raw_ssr, sizeof(card->raw_ssr));
+		__entry->au = card->ssr.au;
+		__entry->erase_timeout = card->ssr.erase_timeout;
+		__entry->erase_offset = card->ssr.erase_offset;
+		__assign_str(name, mmc_hostname(card->host));
+	),
+
+	TP_printk("%s: au: %d, erase time: %d, erase offset: %#x, raw: %s",
+		  __get_str(name),
+		  __entry->au,
+		  __entry->erase_timeout,
+		  __entry->erase_offset,
+		  __print_array(__entry->raw, 16, sizeof(u32))
+	)
+);
+
 TRACE_EVENT(mmc_request_start,
 
 	TP_PROTO(struct mmc_host *host, struct mmc_request *mrq),
-- 
2.21.0.392.gf8f6787159e-goog

