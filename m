Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C463C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 06:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiECGwh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 02:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiECGwe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 02:52:34 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CF37AA1
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 23:49:03 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z99so18817278ede.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 23:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DHuk/E4tKmkU8xE5gT1KiVwuAtTNfojw+1qCzCWy2MU=;
        b=JuY6QCb2VeOpgtCLsVQMtCeAsILtDL3qJAY8EP44mxz0ud++v4HyXQZwhJesRkd5W3
         +svUurahLZF10MtRJtmULZwexMiejKfrL8qZaUQS7jc2JlhSTDIqOpM7F5PS+h6csg8P
         l+OHDyu7/5hVBAv/eReZteMjYPhrdTUc9qen67XASLyR6765BcSZX2w5wUtiEHsZ0IV7
         EDNigc8gFUUklZZ5P38gXdyZSfhEk3k3Hnh+6DDa+v6hy98ZsmIxxJlp+6PMKsPl28wS
         9QOE0kHIhXfFPxUXWoMa7wWB6WibCIApUfHs+aJd4xbBRFlL6lYXA/fgDHCgfCRzCD9z
         sHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DHuk/E4tKmkU8xE5gT1KiVwuAtTNfojw+1qCzCWy2MU=;
        b=kGuUR5s+/RZ2043Td7tGvomCqMbMa5fyO2j/SVWMjidR0GcwXPbUsxGaVaZ+MOzkaa
         arWv0bLBxE7pToO856hg4rNKn6zr5C/Xp9IPcyl/6Jcd2H4hXF3LZ5rQqbx1MIQT1nhR
         sFnWTd79NrEFUNXO7mtDgO8HwGKAFS8MDhXvUJF7RtwDtPlkf0X+6Bc2Si5RefaiYVv6
         pOlZuKNF56WzOTx292cvXAZBBlblg07/xIxXfsc42QNtSF54ww5qW89s4AUlO50TpHGB
         BoxRUEPRDRiuhY7ZFMgYLHAoJU2vcxtpSeKyonP1FBRFPZVD2a3S0bAEo4//2/5bQajq
         5OSQ==
X-Gm-Message-State: AOAM532NfoDypk8n//iAZl2SYEz+wA9Cg5bOKchMrGyvMpAc811p0uTX
        rx0iDbQ4Xj5Xs5PhOMFwIdtWEpiFLdEY2A==
X-Google-Smtp-Source: ABdhPJzGgIiIONpY95WyjXs1XERK8W4Bck75cKHv64UrNfMrWbahqcgjmJz8/gAAsc61u6jAdzmWyA==
X-Received: by 2002:a05:6402:50cd:b0:427:f285:e0d4 with SMTP id h13-20020a05640250cd00b00427f285e0d4mr145013edb.211.1651560542219;
        Mon, 02 May 2022 23:49:02 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b006f3ef214e6csm4288457ejy.210.2022.05.02.23.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 23:49:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cruncher: Add object files to gitignore
Date:   Tue,  3 May 2022 09:48:57 +0300
Message-Id: <20220503064857.260937-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503064857.260937-1-tz.stoyanov@gmail.com>
References: <20220503064857.260937-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Object files, produced by the compilation should not be committed.
Updated the .gitignore file with these files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 9fb86e5..2d47632 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,6 @@
 *.so
 *.a
+*.o
 .*.d
 *~
 *.pyc
-- 
2.35.1

