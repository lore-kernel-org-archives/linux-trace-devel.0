Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF86C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 19:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A336322C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Nov 2021 19:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbhKPTZU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Nov 2021 14:25:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236700AbhKPTZU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 14:25:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637090542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qTUGLXYhod8mbPAebnddX/FsumfbftxAMfngSsa7eQY=;
        b=UldBMdjZow6UzcwJ2EAGI05p7i2HOFW8TV+SnJpGpi+oLE/f+8NuGqD8eI+IcwHmfqhMsH
        S0psodU6NU8+mnbaTvKv41n5BBj93EfkbTsR3DpNxbwrXCmHzThPe4MfWmzUnsmRXA1UVl
        NsNSdonZDxV9Cwo1B2g7/xcEObU4ndA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-CObOLd9uOnKlnqehh1imeQ-1; Tue, 16 Nov 2021 14:22:21 -0500
X-MC-Unique: CObOLd9uOnKlnqehh1imeQ-1
Received: by mail-wm1-f72.google.com with SMTP id v10-20020a1cf70a000000b00318203a6bd1so149100wmh.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 16 Nov 2021 11:22:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qTUGLXYhod8mbPAebnddX/FsumfbftxAMfngSsa7eQY=;
        b=2DFaapK1MktTP9x/+egvMjwtE0VxmQ/LbkvTTcgLTLVltFBXrtBNbePmNqTGtZ6f7r
         46+XOkl+xYx6XvHIGFZfNyKglx4njGxSr61WzLJA5/PKySbxNc0+pwkbJ9LPD6MysB/f
         wQv74tT2f4xh/Ef4HbGZs0u2CZC4aZI3P0ASv6od1ZazHL6cjO9+g/epLJECCSbkibhh
         An4pjIW3KaOVfevMLzvBWhU8/0/Ssnuh5C39viRTUU/2XTX3C0Xd6o+s8f5GlZmZ4Ih+
         nZwfffTGaaGdMBG4zZsMoIfgev+vMhcJu6c+UcrTTI0NDNJyH5sb4F6xViJofibPkEdi
         g7pA==
X-Gm-Message-State: AOAM530qpb3l/uE07xmvtgsa1w1BN8nCS/4vgTFyB5j1668Y19OIRXda
        YBUU+3U7yskhjKxx0UEqSulUqDxGrsttY/vedLlTY/gKnmRSW4VDTKPiWm4+FK/jE7jYQle9N4J
        gmAacPfZGg0D4rsWEDvgerYHKfU0VHrJpnyZJEHaqREa7lXJJbgPzTsg1yobANfrb8SL9LWpsUP
        NdWgE5N3E=
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr70962835wms.186.1637090539813;
        Tue, 16 Nov 2021 11:22:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxMJassrRnIdobOWRl/iWagxeqH+9aQ3XOkl+e7qlo8sc9gxOf9jQTtKaFlpLJijPAqZz2kyg==
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr70962803wms.186.1637090539561;
        Tue, 16 Nov 2021 11:22:19 -0800 (PST)
Received: from vian.redhat.com ([2a0c:5a80:3c10:3400:3c70:6643:6e71:7eae])
        by smtp.gmail.com with ESMTPSA id h1sm3346444wmb.7.2021.11.16.11.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 11:22:19 -0800 (PST)
From:   Nicolas Saenz Julienne <nsaenzju@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     tz.stoyanov@gmail.com, rostedt@goodmis.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Subject: [PATCH] trace-cmd: Fix trace_tsc2nsec_is_supported() on !x86
Date:   Tue, 16 Nov 2021 20:21:52 +0100
Message-Id: <20211116192152.1360993-1-nsaenzju@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

'trace-cmd list -C' outputs 'tsc2nsec' on my arm64 machine. TSC is an
x86 specific counter, so it shouldn't be supported. Fix this by making
sure TSC exists as a trace clock in trace_tsc2nsec_is_supported().

Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
---
 tracecmd/trace-record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1767a6c..78e9566 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6122,6 +6122,9 @@ static int get_tsc_nsec(int *shift, int *mult)
 
 bool trace_tsc2nsec_is_supported(void)
 {
+	if (!clock_is_supported(NULL, TSC_CLOCK))
+		return false;
+
 	return get_tsc_nsec(NULL, NULL) == 0;
 }
 
-- 
2.33.1

