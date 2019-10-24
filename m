Return-Path: <SRS0=8LZC=YR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86436CA9EAF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Oct 2019 12:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631BD21872
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Oct 2019 12:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbfJXMpZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 08:45:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36849 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbfJXMpY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 08:45:24 -0400
Received: by mail-lj1-f195.google.com with SMTP id v24so24896438ljj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Oct 2019 05:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=19XFcqBFfwM/GnhkixmLhv2V8RXG1Jrw+fo8viHRA0w=;
        b=Kd27UBxKVhQkol79wgwoVvRfS/P3Ek7b+KowxitnK+f9zfdFrbvVfelyU0NGTdg0j3
         PhMopOFkgN8MNmKwIPVSFq3zSYPfhSXoIaRDzTLuVJrfr909dn18tCRQoWU5LzY5gwnX
         ZkHrVEdzjiGYhULT020VuIy7NxRghX0R5lwU3res6UfXEJMUbKTnTSwtgZFv3wt5yBUn
         NYkWRLo4V8QLRKqxheaJj8hd63kE1Y1cTTgUUeknVeK8AYnVm4W9trXNOgd+Cwg4SyEd
         e8xOR6QkLedtS/Z5iOmEF7aYDJtztnvIphKytQ4CC9YFKMffW2M0i2HB3UUfSFZNx6Ob
         iqow==
X-Gm-Message-State: APjAAAXJBFA3LUYu2/+/4SbgqgTSWyBxgD+zkHAzymjo5X9Ila7X7L5o
        zoFd9fc89ZxW0Cwhmvcgrw==
X-Google-Smtp-Source: APXvYqy4cSwGBkMuc8uTwpij+NSjRIVdw2iLs21T7hG7nwPC1GzTM+dDs5+/RjNOpWRzw6nz1qYccw==
X-Received: by 2002:a2e:878a:: with SMTP id n10mr26756006lji.229.1571921122710;
        Thu, 24 Oct 2019 05:45:22 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g5sm10986707ljk.22.2019.10.24.05.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:45:22 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] Fix segmentation fault in trace-cmd record on invalid event hooks
Date:   Thu, 24 Oct 2019 15:45:17 +0300
Message-Id: <20191024124517.19320-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently passing an invalid event hook to trace-cmd record causes a
segmentation fault, e.g.

$ sudo trace-cmd record -e irq -H foobar
  Invalid hook format 'foobar'
  Segmentation fault

Fix this by checking the return value of tracecmd_create_event_hook().

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
Changes in v2:
 - fixed commit message

 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index c65731f..0596b63 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4632,6 +4632,8 @@ static void add_hook(struct buffer_instance *instance, const char *arg)
 	struct hook_list *hook;

 	hook = tracecmd_create_event_hook(arg);
+	if (!hook)
+		die("Failed to create event hook %s", arg);

 	hook->instance = instance;
 	hook->next = hooks;
--
2.20.1

