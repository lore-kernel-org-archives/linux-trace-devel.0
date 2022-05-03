Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEDEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 06:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiECGwh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 02:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiECGwe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 02:52:34 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4403437A19
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 23:49:02 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id kq17so31645680ejb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YsTAQ9Ii4FeVtlNyQgjs4SpYRKARgyiWanH1o31wirk=;
        b=O09FtmFnNCD/yXk4rUrn6RLjHzOeWQP3JWR/PgibfSHOT9rIUbDNhU8AX/c+dIEzHf
         N+wP1vXSNRrFvri1jo2sGmkOUsOvbYmsclSzQrY2rlC3gjlplnorjBxtWpuSNqZVXUNZ
         jax1aPQSgW0sa/4n4X+BSS0aVofDPYtgE/QL31JPNAyjiGin8VUnoQS52bpkiGDt1Gjd
         WQpLozs4SFvkOEhh2wEreIpaD/e8+wPAw0Ti8mugrBlUxYOK2KBQ0NzBpCUPyfu3ednv
         D90aSld03ANau6+R1zFnrycUl/xA+xPigcrWZKCRX2fh+HBIh0Yv0lKuvTXB8xFHtsM1
         izvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YsTAQ9Ii4FeVtlNyQgjs4SpYRKARgyiWanH1o31wirk=;
        b=El5GZgNP8zLNgKJwrzadYeRd1XpspeVzHHXBJtBPEFHFBfAUWuzkQW+MCyUz2NO5J2
         CT0NYo2OWj8z9PPDLFpeKR/UjwV37mwGLX0GcLs3vRQSBIcFPO8jYeYusXP92wmQc+yP
         xZ+PpX+wXpvbmMw5bz3aZHUpmn7L5oYdBnnDQfvEooqHLjRmgXyBqLhYP72kxxKsL1r2
         OEG2sV+KnxNCQJZTxaSWQx/i04clX2Y72IQ0kfWRDL9Cy27RJnjkcRNvhGdOq/eJFfcP
         mH6I70+x8puNBlcbw0R8Fc3y13YTYILNgJiChIKhX3U50P1BA4Sbidu5iOFVxytq4jq/
         E29g==
X-Gm-Message-State: AOAM533aQW4mSDJmL9qvn/J3NulRWQPDhLki1VZpdNTgpzmQr4ee0GgN
        oVGTL9QOCVv/4Y/YqCB0C6U=
X-Google-Smtp-Source: ABdhPJyPFJxXDZnyGIMFh8bl3p5DalJr47Zalhd6PKeg2ZLRJzsuj7PgeUup6FXu4/hTgWQ/w35SWQ==
X-Received: by 2002:a17:906:7948:b0:6da:64ed:178e with SMTP id l8-20020a170906794800b006da64ed178emr14757827ejo.523.1651560540781;
        Mon, 02 May 2022 23:49:00 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b006f3ef214e6csm4288457ejy.210.2022.05.02.23.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 23:49:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] trace-cruncher: Add define for bool type
Date:   Tue,  3 May 2022 09:48:55 +0300
Message-Id: <20220503064857.260937-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503064857.260937-1-tz.stoyanov@gmail.com>
References: <20220503064857.260937-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The logic for resolving function name to address uses bool type, which
is defined in stdbool.h header file. Add explicitly include to this
file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/trace-obj-debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/trace-obj-debug.c b/src/trace-obj-debug.c
index 0e0e293..3ce3b54 100644
--- a/src/trace-obj-debug.c
+++ b/src/trace-obj-debug.c
@@ -11,6 +11,7 @@
 
 #include <stdlib.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <string.h>
 #include <limits.h>
 #include <errno.h>
-- 
2.35.1

