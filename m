Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF5FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbhLBMcn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346836AbhLBMcn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:43 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73680C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l25so115170142eda.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y1DZI9vkFNa4Z9XGNeMzOagH15AKNe1aTIBjcQnDKcg=;
        b=mP2M17dyUKx0afBZMtwXJBfCLsIwKgjYWpXAGsPA/vPo1hR+WXviOI0r6om8Ja2d7Z
         0IYWUXvk3Ipwjv/rGPQPOXYuIpBXzKBa2bzmrDzluQsWaecum+mwyMPgm82m8BD1+hlu
         F5IxcAN4wt7zft5/BoxkxFoGqIqpR8gb8tuazBePR8KTl9/q3Ac+ULoBtvYhZHkLd+ZU
         rvIXWhwD7w63rsljuoapKPIo4i4Meq3jQMjlNAm0FN70nhnbfgH+xKpwE1TDxdl3luut
         LExINxQ10mBz+b+bkj5R0BwC8/KJiuuLps1kzF6BjJrl/ukMn7MwgUhzPrPEgfjZ5q8Y
         qqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y1DZI9vkFNa4Z9XGNeMzOagH15AKNe1aTIBjcQnDKcg=;
        b=kxmyEdRW0WySwxOYO0Fjz+Bt92Ttndtpfh8/O75G2t52woBCh05AmylX4hkhxF2Lx+
         zfkUZby+beWY4pd1fNr+Fb7YR6+5gUHsYLwg3usRKZ6WkG1lleRIemKvKBHsHXF49/ko
         K6bM7VLMAQ6alcLMVJ764ck3rlBPKZEkXdPKEqOknf1LP1e0o14qsy8z+VnGgbOu0xny
         4Th8tQrwazfvg+fH1q8J/0WU/MrbDLVZ35AykZkj8/IioN+lXKam/tePXXKI+CL1y9Q2
         YXf3wGz7ir2GrHmANOJw8c+9xa+Gqcx2IaloM2vlHvQtRGUWMjw2jfZMAZPHPWzD6Tna
         QR1A==
X-Gm-Message-State: AOAM533stRPmitDdd2CfjFj/80YEpngvW4zkCRSoLAdW6euPpAqFC9U8
        IVtVdiL8pMjvIJ/dVlG4ay2/iA6R1ed+0Q==
X-Google-Smtp-Source: ABdhPJxXgN36oRdvyBliBSLjFbc7SRSEAcg16aoLc9twasryxoYeUCta/sEDUTlHz3YZNU2Yugo/oQ==
X-Received: by 2002:a05:6402:4404:: with SMTP id y4mr17069272eda.321.1638448158720;
        Thu, 02 Dec 2021 04:29:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 10/10] trace-cmd dump: Align better the output of flyrecord dump
Date:   Thu,  2 Dec 2021 14:29:07 +0200
Message-Id: <20211202122907.44008-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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
index 8986f9b0..9013f8b5 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -943,7 +943,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.33.1

