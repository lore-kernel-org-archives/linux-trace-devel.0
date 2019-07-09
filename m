Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5180FC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21D8D216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sBucg1ha"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfGIP5X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37843 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIP5W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so12480930wrr.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KUJu4Rni6rC/rSWs4QI8yRyv6goC3gpPLBmQaOsz+bM=;
        b=sBucg1ha+Q5s5itulihgchHlxeA+VWIbiZDkmf3U3JFboX/vSh3+ksNglyML8IBqo1
         Uhr3CmBbi87HqlD8Ykz9hKWK8Axiw/xhJhTkFLMY6ltt8PZ06ZI4wb+GglOrqDRIB96n
         WnndukAD6k/orXbXNFY5je28cdxFMP2PTxTJn8RLUVsiucMWMj2ENTpUsI3ItPn4xUS9
         0Yz4lmz6yZyt7Kd3XhMrg08zmM65EGYws4kOBZeYmHoT5yPDr5S5p6yJmAocs1ySE0mJ
         7w8ALxtI9qtWccC1Nuq8txDvKfeLXx/m5U/dRrX8WWYtqB4R+2jSdTv/vYnpKLWG1v6l
         rGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KUJu4Rni6rC/rSWs4QI8yRyv6goC3gpPLBmQaOsz+bM=;
        b=O7U5actbontSN2SZ4whrs5+17ePCdR3vdW9VBbFGw8+LSL7ZlHtD4n9W+ynOaHHEhj
         MTRYkg/Uf0JERoNrnozHkoyvh3cZULJ4Ox/xthOOF1pK+xPilzjxYscfy/i3LR2cXmoI
         dpsnug9gleFKpsxWbOIH5oYPCO8qgUn/NV/dapse9PPjJYl4zD1w8Zng7eIBbjUtPviJ
         nEGlZowDVXKKqVyrqn3KwJaeZCyTY3wD4gXVRKnDqdrOE2CJUzhVMP0TliJOZbz7JZfs
         RZV573uYKtjn+s2WKCsNhnq2eQU1Om4VXLh2yfj5riT2qd19PVuvgf2a4RsyT3jniAFg
         Fimg==
X-Gm-Message-State: APjAAAVCNjsaG/G9E+hMhHP/jSmpH5v+6PGdEsFUyLYHANWm82SfMAkg
        yc1MXR23G6LVO44atpBFf8s=
X-Google-Smtp-Source: APXvYqyB1RzGNU3FOKK/NGZNdizMDJzYxvasbvdgUEE9aLzz2OEJ+6EsBiS2dX1tuhZKizPfWeNbVw==
X-Received: by 2002:adf:c706:: with SMTP id k6mr25913387wrg.40.1562687840903;
        Tue, 09 Jul 2019 08:57:20 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:20 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/8] kernel-shark: Don't free the string field of KS_CONFIG_STRING document
Date:   Tue,  9 Jul 2019 18:56:43 +0300
Message-Id: <20190709155650.2345-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In kshark_config_doc_get() if the outputted document is of type
KS_CONFIG_STRING, do not try to free the old string before setting
the new one. Note that those strings are owned by the json object.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Fixes: 	b3b5b6504b1 ("kernel-shark-qt: Add I/O for configuration data.")
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-configio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index 9106522..cac27a7 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -310,7 +310,6 @@ bool kshark_config_doc_get(struct kshark_config_doc *conf,
 			if (!get_jval(conf, key, &tmp->conf_doc))
 				goto fail;
 
-			free(val->conf_doc);
 			val->conf_doc =
 				(char *) json_object_get_string(tmp->conf_doc);
 			free(tmp);
-- 
2.20.1

