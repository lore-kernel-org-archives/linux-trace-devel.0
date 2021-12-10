Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 772DEC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:55:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhLJL6r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhLJL6r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:58:47 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6359BC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:55:12 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id l25so29364501eda.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ka7b/2GrrNvDwFGt3ray0Czz1MMhhxkgCxM7Z76STo8=;
        b=E/IXA4WsEcuLCHe04Wfk+UJoBDpORjKY72xzfZox4n7J0HyWxmn1Y97WQ9+IQM/va+
         5Ercz3Ut4PLpq1lkOZOL+IWUWUXppklCNg/2OAqKh9AecDl955/5F2MoIBamQP3vAz3/
         ++CaF6SwpFein2aK/neFFC1tdYGBM9usQWdg+cLqB4VxegxZ4yekbJiWrZD/07uO0CaI
         QR3ERT2xHyNMqT7bz39lqjMm+AEC5NHtdajaNWGl+8Ob4vw+XPU0cHdHB6fUIHAHMuzT
         8Z5/Vj3tlFVVR/A4Llhgg8TBYVNEyZzUG2wMNMs3DN8oXNxT45AqbeXhtOzc5iW9l00g
         IRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ka7b/2GrrNvDwFGt3ray0Czz1MMhhxkgCxM7Z76STo8=;
        b=YEnwPiCg9M2O8tonSPYMj/eYlwAUo0J0bgJqv8GT/jcYJdGvbYthCzpCjZW2G41c34
         ZD949RwxuBv5AFn6qXGDFZjq87phlC61AprW2LlwYTjBqteCmPUdeJ4AIvJeuH8UcCAz
         03z7QsUlxnzOd4m28Yiopgjl11yndcWkpeowsv/Y1/aDAaibkXdQZDB13xo+EZzsF4zN
         h8HmaCk+/Zh86pez9X5OTEBu8UFiMoeu1+wZ9tYdK1oF/af+DfGKT/XzwGqkEFo5IP+x
         3QDtgpjmQIoz00wrxnveYc6U4EgG08BJhJftYyXovvLwztp7TT3StadO7LwW7aksQPtz
         v8fA==
X-Gm-Message-State: AOAM532rRCpp8YNLvFQ8uO4haP9Q66piZKT5voFKB+jbwpX191K9TgS+
        oZJ5g0QOrIKAnTOcC5UM4qY46qGeRkY=
X-Google-Smtp-Source: ABdhPJw26yC6FuvGW3a1pyk7tpnICsjjzOBKL81x2Na2U6wmPMgoETT1yd8QbOrAFM6ailzsbZoeFg==
X-Received: by 2002:a05:6402:51cb:: with SMTP id r11mr37641352edd.150.1639137310261;
        Fri, 10 Dec 2021 03:55:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t5sm1357188edd.68.2021.12.10.03.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:55:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd library: Do not record TSC frac bits if scaling is default
Date:   Fri, 10 Dec 2021 13:55:08 +0200
Message-Id: <20211210115508.103569-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Guest's TSC fraction bits have sens only if there is TSC scaling. In
case of default value for TSC scaling, fraction bits should not be used
in TSC guest clock calculation.

Fixes: https://lore.kernel.org/linux-trace-devel/20211014150204.2485499-3-tz.stoyanov@gmail.com/
	(trace-cmd library: Extend host-guest time sync with fraction bits)

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync-kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 8d531922..12a22d4c 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -415,7 +415,7 @@ static int kvm_clock_host(struct tracecmd_time_sync *tsync,
 			kvm_scaling = 1;
 	}
 
-	if (kvm->vcpu_frac && kvm->vcpu_frac[cpu])
+	if (kvm->vcpu_frac && kvm->vcpu_frac[cpu] && kvm_scaling != 1)
 		ret = read_ll_from_file(kvm->vcpu_frac[cpu], &kvm_frac);
 	msg = (char *)&packet;
 	size = sizeof(packet);
-- 
2.33.1

