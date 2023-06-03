Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9195C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 08:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjFCIgp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjFCIgo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 04:36:44 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F133A6
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 01:36:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5149b63151aso4096494a12.3
        for <linux-trace-devel@vger.kernel.org>; Sat, 03 Jun 2023 01:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685781401; x=1688373401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=56RAodgz2RrZ7bhM4myinzdmxW6roVGknI6ypaL14cA=;
        b=rzrX0LU2VDOlurDmIUrzDjuJQXgoAYwSEeT/wuRmXBax3PwzZ5WK3DtW+U6QiiSXbM
         FXxKhipz/WouLrTUkDii6yVi46DcGTn8W5PK5ipXZoGjp04dqzP3CRMBNyEOf5Mfc0zh
         D2ebnCmS1gzml1LTELt9K84W1WHOp4xkPCTn6zga7YtiFwVw9f5UEzSmsoWuZf4t0UTz
         DTVqqVb19uhQJcwFbNSUYQVfB8HzNyLsueyba/4WaG+Q2eYBQmdw19iCGwNBB9tlVfAx
         Y+xFxc+Ux0HSGW2ch4pKz/M9EvatNVQuPGbGDlfvRRIkD/34bozMGzJui/Ot1tsqqTc/
         lHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685781401; x=1688373401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56RAodgz2RrZ7bhM4myinzdmxW6roVGknI6ypaL14cA=;
        b=i21NloL2VINLbg2/+mOelENsEHvH/cGh78apGHO4uytpvWOi8fcFVA4nl4M/1XSBAl
         MEwUqopkxaOn722J+ao85NLXU/LV2vZ4kp2cUt4+TRg5GQfTpNbUyJIgTB4wz+voewqP
         ZRPWZnQUzhfrJATmHixQEYBXhhopOVILwqAUd7uyzIcOoN3A7jEVC8Fyo7lXe/Nwkpl3
         H3/wK7r1WmVe55p7jW2BTLPQlKM8EX5svoUAEfZ1CDM8D00H26/oQp8y2W5xzHRDyMl+
         m/TmZjzNZshqrLdCD3C8F0r0lxKglmIh5G1p5XJnSIGg1LyojRKXpHq7v+Z/g34GFsMp
         rJhQ==
X-Gm-Message-State: AC+VfDzSmZL4nr+WzXFSVJ6/GzgHLb1STa5W0o3hlbAYlDWL3wsJfT6F
        nn8nt+tqTohUzMqs0xdAEdjnxp3OKtc=
X-Google-Smtp-Source: ACHHUZ7Ko0y1qZFyIf3oy+pRwxLG511y/obQ4vpnxnkce0gvmXEFW/irUt7FF6MQBMY+VJ0GI3sQkQ==
X-Received: by 2002:a17:906:7954:b0:96f:88a3:3a0e with SMTP id l20-20020a170906795400b0096f88a33a0emr1038131ejo.0.1685781401200;
        Sat, 03 Jun 2023 01:36:41 -0700 (PDT)
Received: from belmeken.. (78-154-14-41.ip.btc-net.bg. [78.154.14.41])
        by smtp.gmail.com with ESMTPSA id dx1-20020a170906a84100b0096f7ae359a5sm1699483ejb.30.2023.06.03.01.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jun 2023 01:36:40 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Vitaly Chikunov <vt@altlinux.org>
Subject: [PATCH] kernel-shark: Fix Capture if directory contains space
Date:   Sat,  3 Jun 2023 11:36:32 +0300
Message-Id: <20230603083632.597760-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Desktop directory could be two words separated by a space, for example "Work place".
The Capture widget then tries to write into file named "Work".

Suggested-by: Vitaly Chikunov <vt@altlinux.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217459
Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 bin/kshark-su-record | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bin/kshark-su-record b/bin/kshark-su-record
index 70d781d..f3d971a 100755
--- a/bin/kshark-su-record
+++ b/bin/kshark-su-record
@@ -2,4 +2,4 @@
 
 xhost +si:localuser:root &>/dev/null
 
-pkexec kshark-record -o ${PWD}/trace.dat
+pkexec kshark-record -o "${PWD}/trace.dat"
-- 
2.40.1

