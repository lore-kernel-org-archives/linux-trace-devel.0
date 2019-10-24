Return-Path: <SRS0=8LZC=YR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CFACA9EBD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Oct 2019 12:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E4492084C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Oct 2019 12:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfJXMlq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 08:41:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43440 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbfJXMlq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 08:41:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so24841318ljj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Oct 2019 05:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yfNR9GRa4VsMsJO6h8B8QqEr3KA2qR8uxKFv0Y5XL0Q=;
        b=qZTHVGGeLay3bVKzxHeenV3rTK+Sd773gi8LI9qc/EGgVvo1wHKroVQz59++CIOVb9
         RjtRu/Mtu+B56QgmKImPt869rem5lLMJK6LZVUHA599Y0WsEx4lrN2otfzZZDhu/sCyz
         72PE9NC+MmY0EbYX3yKeqbaS6/uOLNESo1NHAHbbnYtmnDJ1ICcok4uczHifr+Fhqln3
         /Lala7B6quT2WX8vBZhHFAH597PyqnO+8PMdKk2jC9Kkopj7NyLdoCbEYFkw1mbf4EVI
         nbK/dDrN/96YuknADFl6eEBNcUHOaJuzL7edteeuMyqzlCq9dGpdufXYGjWxXsmp8ETq
         z0Qw==
X-Gm-Message-State: APjAAAVObSKRGZYT/eCvCMGsQKXVPsi0muNOXV1Lxgx/b9cNWzQvMaPy
        Zw9Q6lqUk7O1T9J+W4ZEfAVRX2k=
X-Google-Smtp-Source: APXvYqyMQVBDM1JmYNVF/IYN5zRlP4unsfIYtQooTysN3oqPBGdPd3CKQT+mb2ilZCEG++2UUvJPPA==
X-Received: by 2002:a2e:b010:: with SMTP id y16mr26647772ljk.147.1571920904817;
        Thu, 24 Oct 2019 05:41:44 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 90sm8327052ljc.0.2019.10.24.05.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:41:44 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] Fix segmentation fault in trace-cmd record on invalid event hooks
Date:   Thu, 24 Oct 2019 15:41:39 +0300
Message-Id: <20191024124139.18459-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently passing an invalid event hook to trace-cmd record causes a
segmentation fault, e.g.

  Invalid hook format 'foobar'
  Segmentation fault

Fix this by checking the return value of tracecmd_create_event_hook().

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
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

