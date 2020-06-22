Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA906C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E5520738
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uczHyeDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgFVOg6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729334AbgFVOg5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:57 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75111C061795
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so18240791ejc.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HT5STaF/nN8C6Lwu7PGD0AkZTJeAsUMMC/qwWQVhojU=;
        b=uczHyeDMteKtZ5jHOLjf7s4Dz8Qoo9rE0v2duWZ4jZqXnOKcRgDz4ss+hdyrqRF1+G
         ltUKCCX4CKoCY6AHa/k7rMNxeWuI1iYQGv9DB06D3MOvOjNgAYYhbypmyg/9kjbKPSnI
         bPiLqfdRcP2Gkt2z4SUqBF5A5FaWBYXbCJ+Bxdh/gjVUCx524DudTLh1OWpai4cNg40o
         7KAiYfatZjAGGctr0qvcKZ8yDPcHD0NIOrg3aSrWM8Thz8pXd3lz2ILo4yTjQPi0yzP1
         7M1Avs4aE6OVKDMfUMPmob6YxG3oc9Aci01Sxun0v8RfVGj1hsWvAm9SSL0sXNyOybzd
         y6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HT5STaF/nN8C6Lwu7PGD0AkZTJeAsUMMC/qwWQVhojU=;
        b=WU2wUM5OAsq2zt9eGRb9o/NLWeiRSKuta8uEdGK0fLty8OMAT1WoHxkLxvUCP6Snis
         wW/0WzVsR2nn/v8VRBgyIm3aZPNyRkWLNBEm4HVv+Jth8xZq50HetpTsurIrHbIfQj0D
         GohYQ5zYpjP82+IFNKW5s6S0qBA1iowhbr+HlUZ/nJC7L9x1026fOfU5OIOHACfizrzj
         5ItpojEzt3oFuz7ccJG3x6f5IrRk75S8rjNadXpLwHKAyj9JKU5J21SQ+J7c1qaTnWHs
         kgPs8lsGC7DepykqV80YpoUQa7Y1MbFHxSypR6/IVXWqA3KhIgeuplSXCLwDxZr7p0AD
         HE8w==
X-Gm-Message-State: AOAM531aSJi/ZnmoJ0UydHIiImwYBwMPGRrNlGww0J8aqcG4cD6uay24
        xhI6QCil2rULB/jmId5HfuA=
X-Google-Smtp-Source: ABdhPJxeTH4osRLx98cHHq+UuJIRoGGJsVfWhOrZjtz1gryfBoZo+uMeTuDfVHS+dYeaMIiaXXoXqg==
X-Received: by 2002:a17:906:4f13:: with SMTP id t19mr15365489eju.269.1592836616180;
        Mon, 22 Jun 2020 07:36:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z1sm11810259eji.92.2020.06.22.07.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:36:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/4] trace-cmd traceevent: Fix memory leakage in filter_event
Date:   Mon, 22 Jun 2020 17:36:49 +0300
Message-Id: <20200622143651.179674-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622143651.179674-1-tz.stoyanov@gmail.com>
References: <20200622143651.179674-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Hewenliang <hewenliang4@huawei.com>

It is necessary to call free_arg(arg) when add_filter_type() returns NULL
in filter_event().

Signed-off-by: Hewenliang <hewenliang4@huawei.com>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Link: http://lore.kernel.org/lkml/20191209063549.59941-1-hewenliang4@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/parse-filter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index f3cbf86e..20eed719 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1228,8 +1228,10 @@ filter_event(struct tep_event_filter *filter, struct tep_event *event,
 	}
 
 	filter_type = add_filter_type(filter, event->id);
-	if (filter_type == NULL)
+	if (filter_type == NULL) {
+		free_arg(arg);
 		return TEP_ERRNO__MEM_ALLOC_FAILED;
+	}
 
 	if (filter_type->filter)
 		free_arg(filter_type->filter);
-- 
2.26.2

