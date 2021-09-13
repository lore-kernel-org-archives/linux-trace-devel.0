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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5F2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1892D6103B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhIMMwI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234945AbhIMMwH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:52:07 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4373C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:51 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x6so14492392wrv.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=e+wr4oXhtZfvH2atrv4E66yY9NTEhu3ayS69PgpfArSZf4p/u4zYekOYrc1GPsbmfA
         Wxess+/6XVEEujqiBmumNFncuzlWoNiT9tb+nTC/pE/9qkz8vxzrsZGQXsQ3UCdYJgRM
         YbDVecYc1PedCOKxB9xl11W+Zzhcw1Om797murpnNWEPeX/ddIsFBAbvRTVTb88sOrP7
         2Do5e8g1qmiZvijZURMuBKF7oJ0rRk9mWEA+TbUq8+mZkm32DGioegW9Au+cHr1HjF9r
         H7SA8G8ZrxIHLznH/1dsFoagjCGNqNZW2Xbb3T524vyjUTxv10lr1vRsXlAZSwCaCmlz
         ydow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=uY3v1yxxhZMeBn2MKOVcWup9bjN4QpPEOwkf7hbgIZHSoHOR+kskV2xfGOR/r+xG6Q
         X02vZedno4f8UgOZtPurTsTE2+SLLTJwN55NsNoEpmu0K5m0J99Tz+d7tfGBNlriUJ18
         txnqXyuqXwg9cUxDzGx1WTscVHTczKCkO8QYe2m4HR57MofTxjy0kVo8HyrCEtJsdR4E
         XYB/n3WSMOK9hvaSOzs5TSFNeVHtwBZQJCCdybVfd9ZcF5lUo8/JdBFk+AWtgvvntIko
         tD9fxuOdlbmyf4GGrSD6t4PrPfaC/F+X/3S5UMMPocDDUdsJeJm871Zv7L89ID0heOyW
         KF9Q==
X-Gm-Message-State: AOAM5315NkG68cCIhGCs/0PHYab8oO96ZCuxJAUMFlpphd3BYVuVSsIs
        MWyxqTyoLbtbb4t2xYK1GUJHMdGSYqQ=
X-Google-Smtp-Source: ABdhPJx1mVwl9zrC9gMZPcwfO/GSCCJm9vqr2gvXz7ah/w34/zkVzhOCyXwuH/jlMcJp9bkO6RFF+g==
X-Received: by 2002:a05:6000:1b82:: with SMTP id r2mr10941760wru.113.1631537450435;
        Mon, 13 Sep 2021 05:50:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u27sm7756448wru.2.2021.09.13.05.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:50:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 10/10] trace-cmd dump: Align better the output of flyrecord dump
Date:   Mon, 13 Sep 2021 15:50:39 +0300
Message-Id: <20210913125039.3680986-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
References: <20210913125039.3680986-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index ab2fa2e5..6a148cae 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -898,7 +898,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.31.1

