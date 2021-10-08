Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C028C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 805FE610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhJHEWG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbhJHEWG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49954C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so17983916eda.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0GTha3/ne30L8HIHJTSmQpH3vRYIjN2fIFjlzkjPu8E=;
        b=Z9XUWPBRVx2JY5EftoELExCrOLBfdi2kRB0QKoban6L7HVkc8grqkapNXWb4LQxUYa
         lbp4maDcDCn1szdsu/fZ6f3140cxu9pVdNU12kRTxw0uql9uV/5nu1UNTyfSMrz+wRlK
         X0mnWAIPSewDEKwKbWS89Ujvdw3vomLAD/U0HcTVnS3T5BY0NxA9TNRuUQlW7qiDSaHY
         WuwVUHAF4le2F0G/SZoz4TXgHIkk3XCxvbHmSZ31BKGzuqr/P0qcdpM1WL/kAhvR1HzX
         dEZPrIoS75VZi7n+r2HRJ5iUyoUZGdSMU4qyF1QBlACNgXWM+46AKVKVDw80QE8TIWp3
         qtqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0GTha3/ne30L8HIHJTSmQpH3vRYIjN2fIFjlzkjPu8E=;
        b=AbbW1emfBz2Gk6aSWLviElGJDaSaP7nU0iIjqaU5deIGGIL+qRhY2zixPNev+g+W4Q
         5wsoerDbP+V+MGV5fVCo1j5ies4D4MYfD5POZH2FA31KG17qCXzZXZT6gusUHVmfInVw
         QnOuHtEhPRbCxH01C3aa3YECvyVFu6memFVj9qMYddNnp7Z4871OqKJnYnhrhnndI5/5
         WjPxYyNnZT0Wv198uFvtVa146Irln12rVjiuWk8RgXMuX1Vjv+3FOkpIGo+4MWgY/0x7
         JD3sjtC6nXg6GzkMsG+lxxaLbN3pR5eQdp27b6byqv+v+4B54Kue57GRD6fsWKW2Baq9
         sl5g==
X-Gm-Message-State: AOAM530TGmm65mX4mD66Ie11ENoOl70YQba81ucqT/NJ1WvzDyqJ5S/j
        YKWO/QFq/Wm8XmpgHOfEU30Jx4slnCognQ==
X-Google-Smtp-Source: ABdhPJyBW2Pf6a2NhTC7LqcTajJvnnxWwr7gb1oUXiFGefZ5G1dPngqlqtQYfXN1WcE7LTeexVyJ4Q==
X-Received: by 2002:a17:906:3b44:: with SMTP id h4mr1332602ejf.402.1633666809876;
        Thu, 07 Oct 2021 21:20:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 09/25] trace-cmd record: Append trace options after the trace data are written
Date:   Fri,  8 Oct 2021 07:19:42 +0300
Message-Id: <20211008041958.976309-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the CPU trace metadata is saved in a trace
option. As this metadata has file offsets, which depend on the CPU trace
data, the option must be written in the file after the CPU trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 757dab0f..32270e20 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, NULL) < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4597,7 +4600,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.31.1

