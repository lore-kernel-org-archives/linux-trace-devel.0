Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F050FC43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352498AbiASIc0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352505AbiASIc0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:32:26 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BA0C06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c71so7669269edf.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pk2Jdd+0pV2MRmI4hP30SWHmhN1KGy5w659LlLasgEc=;
        b=pkkogFrak0i6sot7/nEzKqOhNSanSmCY/oEse5OPDqPoO1RGSZGSfbD1byTL8YMl5K
         1IIA/IyokTtE3AmOOWAX3a3c7p6Eq0eKo3KlzclBfc8R49n5vbrsS2ozTYRiIdZ9Ip+3
         dIrEVbWXpYCqBIDF/FVZpiKzDtSP2YKFmKmbSOHOo38jEJbbx/9Ic1SxwZKAb/BMhcBr
         D7y2U/Eo0tw9XFehMR8NNaQNxOWEDp0mWBYcoRppbhEo+thJ/vRghDN1kmKx1Cux3ntr
         WXSo6EFhNLezIe/2mHYCZ9xZo8OiSsktScKmtasUX0rCeCjEVXHJGDUiZfH00qpB4MAI
         dwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pk2Jdd+0pV2MRmI4hP30SWHmhN1KGy5w659LlLasgEc=;
        b=B4UzFvTGeQHxO62kayGetF9pk5ZrgUPqaoV+p3uGQIlcpBhiL2YAs4BnXi8SGoDjsi
         NFbyRTJH2HJ9hqL29KKQ8T5kWk/C3iDwq6jwQH2/xqimT8Y+4sJEgPlMUFJGWhn1BeiW
         K4kbRBGsi4OuJ79XQGsCXW08KNh7ScgjAljeF2sbOzu9pfsq8LI53NzkXGnLIzTmNlaS
         ONNqFWXqe2UGlnnm99EAHzkx7RI0XZrfpu1YBofzsGNbBa0dU5RH2RrxCpP1QCAb/UKX
         jsukUdIQx5AiY/AkWgwa9xrb27fjQod9nKpdy0ScW5y+owluvoD/628J/CN4lshUaJhH
         WXSg==
X-Gm-Message-State: AOAM533Khjs50yaNRfat8a6EheBb86xkHgwcduRHPLMmh5oPJ84Gdfhi
        JuTF087+GfjNPz39yG1DF6WlEPHOAFw=
X-Google-Smtp-Source: ABdhPJz8aiaO/rrmV0cTC9IGCLFcJvJoBgf6VgcE94OwZFQajgX83BI3q7y7tpEHgXh+orCMkmf0pA==
X-Received: by 2002:a17:907:b1a:: with SMTP id h26mr23321469ejl.175.1642581144282;
        Wed, 19 Jan 2022 00:32:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm875969edb.58.2022.01.19.00.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:32:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 3/4] tarce-cmd: Update record man page
Date:   Wed, 19 Jan 2022 10:32:18 +0200
Message-Id: <20220119083219.246347-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083219.246347-1-tz.stoyanov@gmail.com>
References: <20220119083219.246347-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new arguments of the "trace-cmd record" subcommand:
 --compression
 --file-version

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 96c27108..b3620474 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -377,6 +377,19 @@ OPTIONS
 
       trace-cmd record --verbose=warning
 
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.34.1

