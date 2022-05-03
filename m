Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9231EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 May 2022 06:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiECGwg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 May 2022 02:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiECGwe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 May 2022 02:52:34 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F214337031
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 May 2022 23:49:02 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l7so31677020ejn.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 May 2022 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4M8THBhG9j5YZoyswzf+9PE/jNFM++dhXAnfTpmBngg=;
        b=JCTBLADKvgQJBHrkndRO4qmYc9B6tTiv70WPxVlWyYEgbe15DJadWdvQOL1H8iZN68
         A4HkHOTIr9LmMOAjrxZib5/02e52BjRA1joiZaGPSuOMs/CQRekyujhQqDJay9X1MhTX
         1+kDE6LNAeQQxytw8Pdddge6ry3WEY0JycsdrW/nL/BpzIXyamHnMbZOhUfH9NWYqKX8
         5GQ9hEbxZkGMcV4Fi2n73WRvKLPsiFtGG37b3Zrtn6mgFp4leyutJ+AgZ8ZlkguO38qg
         9Cds6GDSZ1I637hG2ZMnUwPC/92oAZW1CJjRkW3F3ompBLQhXF/J07PHjFiiOmc3YzwG
         t1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4M8THBhG9j5YZoyswzf+9PE/jNFM++dhXAnfTpmBngg=;
        b=cjzvyYrrVw6Q4UZ/L8o/+2s44OQKJTZTMELaIWfa5ty4DfLoCF4R0HZtyop+azAqTO
         D+2kd/hXxgZlTpY7zmUeZIS4ip4QBkzwA8Qx9X397R/Cg1sf7YAuTIVKrrfhN1IKuZrQ
         a5pVL1RgDJizkMbgvqm0vzeeyFyt4EINDV1J2xfAQMn7ilKADcJHUgho9ahkXjJXZ7vf
         0QCiwrG3/8L7wOIemYymiQBNIAWPB8+n6e/B4TnYpNE1Yo9z5h9a+mE9Ba0t0HX59Jna
         6OI/e3DwypJgTejsiyhH3VZj8bPmkP3RZx+MSrAREFIKevMsC8xjxmzYsK8QC5Uj4XKK
         5GpA==
X-Gm-Message-State: AOAM533FBTcixi0jmzZVDa+O2BCI+A9GioLy2ZA6mkhxjwVl4NFiK8uL
        ZyYepEmgYCt0TTaWIovNt0LcIJyOh4VJ6A==
X-Google-Smtp-Source: ABdhPJxoLBkY3ghdKIAoRpuAuRGY+W9h6PhB9CM1VucR7vkteg8UwVSVHzkzPoHSWOZaWP9XAdFDAw==
X-Received: by 2002:a17:907:9615:b0:6f4:92ab:4fce with SMTP id gb21-20020a170907961500b006f492ab4fcemr1453543ejc.95.1651560541572;
        Mon, 02 May 2022 23:49:01 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906845a00b006f3ef214e6csm4288457ejy.210.2022.05.02.23.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 23:49:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cruncher: Update github workflows
Date:   Tue,  3 May 2022 09:48:56 +0300
Message-Id: <20220503064857.260937-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503064857.260937-1-tz.stoyanov@gmail.com>
References: <20220503064857.260937-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recent commits add functionality for function name to address resolving,
using bfd library. This breaks the github action, used for
trace-cruncher CI, as it does not have bfd development files. Updated
the workflow with bfd development package.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .github/workflows/main.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/main.yml b/.github/workflows/main.yml
index a9520e7..0d72bbf 100644
--- a/.github/workflows/main.yml
+++ b/.github/workflows/main.yml
@@ -17,7 +17,7 @@ jobs:
       shell: bash
       run: |
         sudo apt-get update
-        sudo apt-get install build-essential git cmake libjson-c-dev -y
+        sudo apt-get install build-essential git cmake libjson-c-dev binutils-dev -y
         sudo apt-get install libpython3-dev cython3 python3-numpy -y
         sudo apt install python3-pip
         sudo pip3 install --system pkgconfig GitPython
-- 
2.35.1

