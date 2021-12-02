Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1B1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357995AbhLBM0Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358127AbhLBMZk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:40 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94200C0613E1
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x6so114898160edr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YtF0CRxyG+bVpMuzic2x+wHSr5SuX7J1FJuORjls3+c=;
        b=TI9XKlXR7pIbH79WuqliEbPVeZ2z41NEFW9TCpDkQq37/sRso2R7HsElnnhsSIC/q0
         8rGfODbeA+nILJoxnwRcgNyvZG/OMnqO8eis1zfYI8XyyUClx0qWs3XtS9SJc4Z2iRPT
         E97FR0yomMunzI9qQaDIH8v0OExw/isuUeUUo4wvplaC5Ss8ezupxGHPpPSSmd1obCqx
         j1q4RGWI04tuz7ddDVfdusWR0i3dH2dV2RkdUH6Qeg+j31/7SzQTLtDMg0r4JLMQHEWq
         Rb0P8qsiETrEhRYHJAvPDm9WDmvAAp8M0CNQSMKunkgc6Eeot2Bn3N7adMMUD2k4QB50
         BHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YtF0CRxyG+bVpMuzic2x+wHSr5SuX7J1FJuORjls3+c=;
        b=lxSwu6y04hE7uNy2fdXzDtxf6GKYU+AXENZ9ggnNyCLX3z7GLwyQdPWbHMMPJCLnWZ
         K6j1xWpsqep9ZzOybyN2pCG54gk+jES6eCqD8M53z1DakEcLw513DQO1s3nq5ePH21Ro
         HkH1HlohlifD02KUy86j+5NmTz3uly2dkG3jl6Lq4L4Z/it6pAfdbb/pUT1Nfj9hjXgs
         v6zl7pOQfaE0ZtOk4q06oxc8riOxd/Hu/NNRL8KVAc+v32DPC2BZSVEyAkzKaBcRe6M4
         y8rRxfK8qS282xNisBwhuKB+C2+mIDw1vDQeL6m3ayjknTBGv9uCdzQ89HJtzUbTUlqr
         T0Rw==
X-Gm-Message-State: AOAM530CB0ymIaeIIp0KRIcMvVXgybiKH8vQmSRRPJoV+/AyCefahIw6
        64wXRWya62D7/GHloAfxDA68YMZ2LOcnDg==
X-Google-Smtp-Source: ABdhPJzz8fAsNfh/zJV/EtcyQiBKqorxhcOA4xGwru/61ItBiJS/n+JYFDCIqo8I+oTjaVHroGLlkg==
X-Received: by 2002:aa7:d794:: with SMTP id s20mr16994865edq.305.1638447736115;
        Thu, 02 Dec 2021 04:22:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 22/23] trace-cmd: Write buffers metadata in  trace files version 6
Date:   Thu,  2 Dec 2021 14:21:51 +0200
Message-Id: <20211202122152.43275-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace file, tracecmd_write_buffer_info() should be
called, to write buffers metadata in file version 6 trace files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c | 3 +++
 tracecmd/trace-record.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 45ba1211..874ecd61 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffer_info(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2c222ed9..442e55bd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3729,6 +3729,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffer_info(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -4092,6 +4095,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffer_info(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
-- 
2.33.1

