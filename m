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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79137C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55A29610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhINNOT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhINNOS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:18 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B84C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q26so20129998wrc.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=aR8mUJfokL7FJkQhxMJDlY1F5pSd+3AdZ3mBGqq9CsgOIiIIdO0Pzfr501RXz+x8dc
         5Bl+zqGYgOVuIU8OhRKGliQkibP57MpdL3D3RqI2zu8jJhgEvvqz+9MI2ITgdgvvUPj0
         ucB4ltz8ihyvUWgW/2vhj93P9Bxpc7NHblTIb3FVYpDv9CJ4/95oWHAlIWkmHsAKA8JT
         bABxgvEE/mqtG7BLGf9ZcT3VYsPy8tJ71oqNSn+TF0qLS2Tv2vRDNRScC+6w/zkCnZZT
         syxA9zxH58C8RKuRssVUhlIwwLgpWveW6sJPMEQKIfKhrcU7Jaqjmbg/NkQ1rN8/Z8FX
         ExGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=g+yZ/EAGD43k0iEDOA9PmCRvVC3cRap/aDOVmXNgQf878aGX1MqL8BTVHbV97hhtLg
         ew/RdPP+CtGQs8aCkAQbrRvs2VsNNQ7yKrbDpCT8aG7rLtQqjpVBdjw4XJ8enp3DmIHY
         3C4EGHdg8MThaS4aiHl8UKjeD2F8G5JsRxNMNbQzo4RMMwcg3Hk5vyfXiiRWydMMcBjR
         ODN2b6x1/DCmEjDcHvLlLLSAPblNd3SFTRlSjflyhKlFQ2vA7NbvCBFhDsL92HsuIEbM
         70L0floWDzUipL4jidegaMGCRJ7BcXRWhK1KohR/yfNV+1scq3SH//ERevXz6RhUd8hD
         2B9g==
X-Gm-Message-State: AOAM5315PWYULwR5DPQM3G2Rf1q2pbyafaqMuwHJXS2f2DRQ1N3rZsBO
        oon2S5+Ppjjz16BuXQV3Gv/eTHZylEc=
X-Google-Smtp-Source: ABdhPJx+7WbfY/cDAplmLeOLcB2O90lT5jn6xp6fAMGblirsiAbt0RI9xIwf/PdoSNSFIQLHuly0SQ==
X-Received: by 2002:adf:d4cb:: with SMTP id w11mr19015214wrk.125.1631625179874;
        Tue, 14 Sep 2021 06:12:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 17/21] trace-cmd report: Do not print empty buffer name
Date:   Tue, 14 Sep 2021 16:12:28 +0300
Message-Id: <20210914131232.3964615-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where the top buffer is saved with its empty file name, string "".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4261088d..02f75cb9 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1173,7 +1173,7 @@ static void print_handle_file(struct handle_list *handles)
 	/* Only print file names if more than one file is read */
 	if (!multi_inputs && !instances)
 		return;
-	if (handles->file)
+	if (handles->file && *handles->file != '\0')
 		printf("%*s: ", max_file_size, handles->file);
 	else
 		printf("%*s  ", max_file_size, "");
-- 
2.31.1

