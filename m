Return-Path: <SRS0=sUNk=X2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3731CC352AA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 14:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CFF920842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  1 Oct 2019 14:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XxdUSEPl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389555AbfJAO5q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 10:57:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39948 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfJAO5q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 10:57:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id l3so15922085wru.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Oct 2019 07:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cZ/aOnWwCD89QYkOIYb9nBbkD7csPYkLem8bSGqJdRg=;
        b=XxdUSEPltDuJ8YG4zS7r2n5RLT0V3fJdR69XqGilHIFOZPL25WvwEeVD5yut7LXnCH
         N2ZColGE3mn45UDSoCboz9LuMwnY0lQltr5xz8zq1u66dROJneYEvHhRbw8dhq7ceJ+a
         XQy4plzoLxSjZ97QhfGTM8WGqk2AgwGcHISahDyBjE2HOffkucWSko68NUELSCHtqugp
         0tzrk7Q6m4D9RNJrxGjwsmhLv9VfAdSbqFmsSPCaSDII35toUEN2JzUd0liqKYkEFsmn
         R507z4gZ4aK0MJMOSjIwyBYT60RHo9sCDFdxVtkR2Opi5OjsZ6lfMzLBoGxQQO2I0Qus
         6C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cZ/aOnWwCD89QYkOIYb9nBbkD7csPYkLem8bSGqJdRg=;
        b=afmDldo/CnwdhASQFhILTf/5oHI6NxIV8DWDYN5ByBk41eoM8nMsxP7gUI6MdlECnD
         /YFK+Exz9RzUlTyU37R3p0xnirvsXru5883TWwuIYg0uztEh3IqXRZw44cSH//hP8n4p
         SXVb+6rKSw1yR9u4120qd6ozpmPFJi2+flw+doOTUYx4y4aQVWvNA3kuy7YFIsop80gT
         dSHJZKvDr1WRxDL189XUp6z//HP13qWR9Va0UbbSAFQYhIkrhznNpg5rRXIpJfJ4A+7r
         CqnHhuRHoF5QZfUP88A2zhykR75vYbzu+ZcMnT3G+slbJTTRsJiNAGR3fmfAgEe8PUFQ
         KB4w==
X-Gm-Message-State: APjAAAWG90+0aocDAaneEtpLYRTKlxepYdH1Iz0ErjuRgfTntRAdSgiK
        /bU8mt9vBf8iVXp4K3JkvffUqp/J
X-Google-Smtp-Source: APXvYqz9RtLN1U3z8HJFomLXPAhIejRGPFeJ9rGIF8YUafs9/RKTlsWGsAmKZ10HjmCRM/DHQ1/1PA==
X-Received: by 2002:adf:f008:: with SMTP id j8mr1147005wro.75.1569941864813;
        Tue, 01 Oct 2019 07:57:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm3220758wmj.17.2019.10.01.07.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 07:57:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Reset CPU mask after setting it in trace-cmd record with option -M
Date:   Tue,  1 Oct 2019 17:57:39 +0300
Message-Id: <20191001145740.8866-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001145740.8866-1-tz.stoyanov@gmail.com>
References: <20191001145740.8866-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When trace-cmd is run with option -M, to set the tracing cpumask, it was not reset
to its previous state. The trace-cmd record should put back the original value
after using -M for the tracing cpu masks.
Fixes https://bugzilla.kernel.org/show_bug.cgi?id=204941

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 96d2c1a..69de82a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2403,6 +2403,7 @@ static void set_mask(struct buffer_instance *instance)
 	path = get_instance_file(instance, "tracing_cpumask");
 	if (!path)
 		die("could not allocate path");
+	reset_save_file(path, RESET_DEFAULT_PRIO);
 
 	ret = stat(path, &st);
 	if (ret < 0) {
-- 
2.21.0

