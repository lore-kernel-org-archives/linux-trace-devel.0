Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABC4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Mar 2022 10:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346293AbiCUK1k (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 06:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346241AbiCUK1k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 06:27:40 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CB3ABF42
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Mar 2022 03:26:15 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v22so6089793wra.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Mar 2022 03:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PBJqC8asyaPeorpLg8tUNFLUX3aC8GzoTa+lXvRtDLc=;
        b=fn8bDPotSfbduzACIvLvgPQ6nB5KwSrNu6Cu6G37buBxwvJPHR1kpCQxx3EUmTU1Tn
         DTFPswwCfgxFKGk2JhcwzBYlHLTOWeefG4pVafm+fcJEnbW+6PHhnHOygdcp2Oy94sgX
         iQvmKD6hD77StNI6evhSvpIPT41wTTbnPbe3ZoUpc/gMied4DOACkEQzbNF+az7r4W/+
         j1ZyI8O6umSEtCvy92Mqbt9WSnzmmkP3K2+QlK6FcoZ1iji08a1u2Blp6DmqSKhCIxPp
         3WvlWymQxpYiv7NhelrM8IioD8c59Y2G3Q5lVE5KMgizowLObE7RCL/Vb6SlcDi+dFf3
         nzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PBJqC8asyaPeorpLg8tUNFLUX3aC8GzoTa+lXvRtDLc=;
        b=TQZgGAnWSKOmmT3gqdsYDCxAeBM5Xda461lj1jdSWvbkkqxuvEDX5/5u0YJUJlmow7
         ZVAwC3dVhC62EW94xdR0c1wiF5vo9GQHcTTQGIPNZ93YKtkkm3qcaPVrOC6iq3eX3R/n
         JSt4qQGsGNXA++DINVOK2rrk3QZcj5q8ZddG2+t68wYqx6GzGsteGRkpF8Lo6vFL2Qm5
         wf+i4J3MzF0nKC6J7MDNXWyosERD198RbJZZ7QnMe2tbzRaKQwf6qxNcNna+tm/m2wRa
         fWJKi0Ts8fCflVvVaIT9w7VLOCfiurhgEuhbnD3aUiIW29DanaxUoTsWLXI0dd9vKhTw
         A0KA==
X-Gm-Message-State: AOAM5315Tvtp8SRyLKokugNKOeKlbodAojlnu1PDbVn4TBtgH3QjBZzP
        umQh3FINWv4wTkaVQkOujvqxtR9LqYU=
X-Google-Smtp-Source: ABdhPJzm+wLAt2Jw1D2E1Fi/68JzfahdoelCDwsg2ByP/G0vya97iGhhiQMVY6Em7G4WEcNyYKT2cA==
X-Received: by 2002:a5d:64ce:0:b0:204:1177:e1c4 with SMTP id f14-20020a5d64ce000000b002041177e1c4mr3537062wri.692.1647858373668;
        Mon, 21 Mar 2022 03:26:13 -0700 (PDT)
Received: from crow.. (78-154-13-168.ip.btc-net.bg. [78.154.13.168])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm18415003wmn.46.2022.03.21.03.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 03:26:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, gentoo@digadd.de,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark:Fix the version field in kernelshark.desktop
Date:   Mon, 21 Mar 2022 12:25:58 +0200
Message-Id: <20220321102558.63227-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The 'version' field describes the version of the file format the
'.desktop' file conforms to, not the version of the application
it links.

Reported-by: Christian Schmidt <gentoo@digadd.de>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/ks.desktop.cmake | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/build/ks.desktop.cmake b/build/ks.desktop.cmake
index 2b02c0d..9765e61 100644
--- a/build/ks.desktop.cmake
+++ b/build/ks.desktop.cmake
@@ -1,5 +1,5 @@
 [Desktop Entry]
-Version=@KS_VERSION_STRING@
+Version=1.5
 Type=Application
 Name=Kernel Shark
 GenericName=Kernel Shark
-- 
2.32.0

