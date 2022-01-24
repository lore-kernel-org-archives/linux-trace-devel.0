Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74A1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 09:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbiAXJjW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 04:39:22 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:45852
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbiAXJjV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 04:39:21 -0500
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9D8503F07D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643017159;
        bh=NAXSk75/uLxYcTidkDdi80qBdMblA97nAwT2mIQGh8Y=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ASYj9l8gaj7nQENkDWGki2GV16BRof/4LAmqvVSeK6DncOJxSkDP/99e8ZgogpkPF
         lOHCdxbT+YeM1PiWcp2xt4QtUR5NVwC6jKZ/qVi9X0JN1NQr9T+N1WJgfSpgnWurUW
         zBcmrV2K4rLaIeAbNb/3CxM5qKa0PWvF7AYT5pOkmHybZkRfHr6QT+0SDh7315SYSf
         AQfLDQq/PIqGWCQFPGSrp0rq+5UGsZMp4kqToxLkrpwjd50KM1qLaKRdin0YPisg0Q
         tvvF+B2lH+j/Eu9nwk33TU7rqZRKbfRvIRiMcT49pjzsMFnHD7eFSTpXSCReuHWUyc
         7Prr290wTmkhQ==
Received: by mail-wr1-f69.google.com with SMTP id r26-20020adfab5a000000b001d67d50a45cso1617533wrc.18
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 01:39:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NAXSk75/uLxYcTidkDdi80qBdMblA97nAwT2mIQGh8Y=;
        b=OFUxb6kaEKChnjj0/6WVxwJsh3ccu6Vc1s/180yLvNhSZTNf4rD+O3Wn2QBy/Kjawe
         oPopaB//9oID1VHQP3+4ou32zWHz5L/mfue4+gkRlnQsbroSQZNKbprWCQbZkv2NlRYh
         tU17oyEpLx6hTYAxAsLkDBoMNtvm9ph/WZTfaUReRdxQdzfznLtCOKrLxTKJvGmVw5xT
         mOi7lw0TQ8E8fHQ9ljGzSUpkT6WhBnP4u0UjYyxvH1COnFnrXIjX2sX0AUGbxWdOwREa
         y/I4nBLbsFunoSWQnFGi26rlG/c7FJLuEQQb/WZK3KwBervXpuD/SbvCgCtdEuWmj5Uc
         L1PQ==
X-Gm-Message-State: AOAM530pXKyai0RG2trfe40D6iAggmCxK/UgM9d+Uk9ZnLFLfZ9EqxcP
        WW0EpGG7zxfsjpfhEkVAJ5XvT2CHJTVhIbCOr5eCF6HAEIdj7ygfXBJO7rh/jg8hPz+NEFM85KJ
        hj6JfGbmgSt5wS1duYIIB8rlt/HRBMoh7Ebdecucf9yxwlBFy
X-Received: by 2002:a05:600c:3b91:: with SMTP id n17mr1039201wms.88.1643017158876;
        Mon, 24 Jan 2022 01:39:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypnYdImojyZ72OiqWEBxCgb1vNC5Pr39VZFhoEoF/dVCBuMEFqpnSHz9F/ycWmueCNiIKUEQ==
X-Received: by 2002:a05:600c:3b91:: with SMTP id n17mr1039190wms.88.1643017158665;
        Mon, 24 Jan 2022 01:39:18 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id h127sm21011125wmh.27.2022.01.24.01.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 01:39:18 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH] libtracefs/Documentation: correct instances-affinity section body
Date:   Mon, 24 Jan 2022 10:38:41 +0100
Message-Id: <20220124093841.47558-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Correct the instances-affinity section body error:

    asciidoc: ERROR: libtracefs-instances-affinity.txt: line 8: malformed name section body

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 Documentation/libtracefs-instances-affinity.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-instances-affinity.txt b/Documentation/libtracefs-instances-affinity.txt
index 0f3093d62035..c3c14628ef63 100644
--- a/Documentation/libtracefs-instances-affinity.txt
+++ b/Documentation/libtracefs-instances-affinity.txt
@@ -4,8 +4,9 @@ libtracefs(3)
 NAME
 ----
 tracefs_instance_set_affinity, tracefs_instance_set_affinity_set, tracefs_set_affinity_raw,
-tracefs_instance_get_affinity, tracefs_instance_get_affinity_set, tracefs_get_affinity_raw,
-Sets or retrieves the affinity for an instance or top level for what CPUs enable tracing.
+tracefs_instance_get_affinity, tracefs_instance_get_affinity_set,
+tracefs_get_affinity_raw - Sets or retrieves the affinity for an instance or
+top level for what CPUs enable tracing.
 
 SYNOPSIS
 --------
-- 
2.32.0

