Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6399C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8575C20652
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCGPnn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:43:43 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46873 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfCGPnn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:43:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so17958184wrs.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:43:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2lo2WEDRuEdyIPOfJAVbLGdfhu/OMhY0/4TDFAALgs=;
        b=Fn9X4aVX0GjrPmYbSQ/foBX0dMomjp+O8QAYRy6G1M8dRPYSFbvWxgGiITGrUCj9NG
         4wuh9ssJFAHI3bedJ9sLOFP1f5ILTudQzhlq5T+655e8zIDN31DsH/ikfatC1JhS/9Jr
         i25NBgma3SWJ+ejgt1x2nVBIDEJwcZOHjopdwpsWU4czu1awAEtC5sGGjh1GRbF8x3Mj
         lrMp2w7bvIDHB/D3AAdAWGTVUq290TxoMpMnQuz1VnnSVedxFDg4OtUcty922qcLkjkT
         dEywh4nmY/zLtAmGKbtb3wDWws92mlBLQFIl1+/N9gPc3o5FyxP2ocYL3Xv7cdsLpqLi
         4ehg==
X-Gm-Message-State: APjAAAV4KmchCGSBk/WTX4wuTt3H3cARfORkVOTrZsp/LUNcWZyv9nRZ
        mz/PJ7Y3hHvUN69rdAtmOnQ6yyMEaBg=
X-Google-Smtp-Source: APXvYqwkb3KRVFpeCvSTQBiSpHICCwGYhDHorOSD4ALKC6CIGeaP4yO/T5GcNoqxjx98ZDV0v8Q/og==
X-Received: by 2002:a5d:6744:: with SMTP id l4mr2692255wrw.226.1551973421450;
        Thu, 07 Mar 2019 07:43:41 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id h9sm10081463wrv.11.2019.03.07.07.43.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:43:41 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 1/4] kernel-shark: Specify the OpenGL interface used by KernelShark
Date:   Thu,  7 Mar 2019 17:43:13 +0200
Message-Id: <20190307154316.19194-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307154316.19194-1-ykaradzhov@vmware.com>
References: <20190307154316.19194-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We instruct CMAKE to prefer using the legacy libGL library, if
available. Although this is the default choice, the latest versions
of CMAKE are printing a warning message in the case when no explicit
preference is provided.

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 9460026..20ced14 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -22,6 +22,7 @@ include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
+set(OpenGL_GL_PREFERENCE LEGACY)
 find_package(OpenGL)
 find_package(GLUT)
 
-- 
2.19.1

