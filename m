Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C2CCA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E41C222C5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNe5LWI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501912AbfJRO6E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:58:04 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43315 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388225AbfJRO6E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 10:58:04 -0400
Received: by mail-lj1-f194.google.com with SMTP id n14so6524363ljj.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2019 07:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U1AQi0Fr4289i6rijpCauP5CJWhpom154ZN6T8cg4Dw=;
        b=VNe5LWI0WPoZZXb7+wxGWZNCrmqfJLTItDDNTUvBv7JaPk+N4v/opPYiweMhlEtkt5
         AQYgoLXcbb315F7yBnewFHVeu42KiWVkvWdxLKp3dssmcXGHLS4f5BpkYgQcscw5ihlt
         7xHToCPrfh5hlmSoidVrEHJxvA5yYx1Sp+rz+L8kofJB/u4ybKQ4EpYB2RfCy8kiLa20
         ErD0SXsWzjCCpIag7p2wIsy5223WlwnazMSdKsWyb0/58LCdFV0Qistrgxt8mlYAI4yP
         m8UOOpKrPXfq4wEx6Cn7a/Kmm+PLI/TiZI4tpFMI7HW+v1D/Pk+mKf92MhiFLGGBjCZE
         aYmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U1AQi0Fr4289i6rijpCauP5CJWhpom154ZN6T8cg4Dw=;
        b=t+Mkpp3mwvRSUHCxtBpg7WHeU+WvQ6/1Orw+Fb1CbDvcdGhe7QRFe6U3jyx0Pdm9zZ
         e1IeTw3XwLnBw86TZ6987MMjML12QaSGbZG6+ekoYtnFh9rrYhGe9tqc+mnINtH/2QaT
         s/vhYSWQsPPd8dYiwudGuWz239+f0c3T5vNxeEp6XALHcrV1BSApq4WYnYIW31B3/c+l
         fdPmIZ5y2oxuN8UvpfZWMIoKcjgCAGPt1tPU0yFiVZsIfKowxLolUBgV9dwbKI2p7vmc
         GpGydURm4U7Qmo1CgZshjF+3TxnL8ypE7mTJK1zJvCiBeZRtn5Uor1zJBqkJtppxcjGq
         Q20g==
X-Gm-Message-State: APjAAAVMyDrqfZ3o3ra5PCWBCWyQdtiA0+rfRvfd5BJP5S+qQsD0+65k
        8A/clL57+NNWqk3LZrb2QmK1jjneVWE=
X-Google-Smtp-Source: APXvYqyEDGyjbEGeWACzJzit527ZXYR15wYR6ud6VNGGDLW+64im/cMqZ9YWxeDHRwtHkXoJYYlofw==
X-Received: by 2002:a2e:80d2:: with SMTP id r18mr82731ljg.228.1571410682222;
        Fri, 18 Oct 2019 07:58:02 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e10sm3008331ljg.38.2019.10.18.07.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:58:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Fix a crash on "trace-cmd reset" command
Date:   Fri, 18 Oct 2019 17:57:58 +0300
Message-Id: <20191018145759.15335-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A leftover in reset_cpu_mask() function causes a segmentation
fault of "trace-cmd reset".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index cfe67f9..81aca1f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4113,8 +4113,6 @@ static void reset_cpu_mask(void)
 
 	for_all_instances(instance)
 		write_instance_file(instance, "tracing_cpumask", buf, "cpumask");
-
-	free(buf);
 }
 
 static void reset_event_pid(void)
-- 
2.21.0

