Return-Path: <SRS0=K4HJ=PW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966CAC43387
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B102087E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jan 2019 15:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfANP2M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:28:12 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45251 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfANP2L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jan 2019 10:28:11 -0500
Received: by mail-wr1-f67.google.com with SMTP id t6so23276137wrr.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jan 2019 07:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qAVEmCrwQ7LbzgWl1iLQa+qb+EmOa9tBt+vB6/lwOjI=;
        b=j/yNeTuaHP+EY7n+kJOui+z1rhFLQZGqhcCNmJYLh1jq1dNkWu8l778Js2/+zKOgGw
         H6MJcv4YjbYWNUkua+TGPKH8eKaL6ktVxk2egLk0ppSBxEq5gcc7UeP2aOYnumM+xsuz
         7vyUQsF0hH07fDaCAG5mvql38+wqdM/3fRywfMbI1SUdz0LLFZmTo8ZoF8sbH8sWZMNr
         ifbw2SRBkjnT/dTNx4hKIiRrEOL6tJXq6bcC1493wyrPATHqCp2FJbUg2Yff4PEQ3uCP
         nVPdQQVIrV7tgy7pTpsR8Wu2eHnUdBWeIgwiuOk4G5vUwRQLjNkaV2EgiMXH2zeAepyI
         f5HQ==
X-Gm-Message-State: AJcUukeKOaD2Ed5uWAORgX9/ZyKcV5Kq9g4yV77sV1/r9A6QQTkhPpU1
        UXCKlMl3m2FWiTS7Ft8PSMlZhCzyqHmU
X-Google-Smtp-Source: ALg8bN7ledfxlwl/UICgJPlperXekKZSAlQn3OaMbB9TUbhpWFXi8ijY8caVxNC5AS6wsqT9AEOAvw==
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr24469693wrw.215.1547479689860;
        Mon, 14 Jan 2019 07:28:09 -0800 (PST)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a132sm34784167wmh.5.2019.01.14.07.28.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 07:28:09 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v3 2/6] trace-cmd: Detect if vsock sockets are available
Date:   Mon, 14 Jan 2019 17:27:56 +0200
Message-Id: <20190114152800.31060-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190114152800.31060-1-kaslevs@vmware.com>
References: <20190114152800.31060-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Detect and define VSOCK if vsock sockets are available on the system.
This macro is used to disable VM remote tracing features on older kernels.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Makefile b/Makefile
index 27d3683..abc4f0c 100644
--- a/Makefile
+++ b/Makefile
@@ -205,6 +205,13 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+VSOCK_DEFINED := $(shell if (echo "\#include <linux/vm_sockets.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+
+export VSOCK_DEFINED
+ifeq ($(VSOCK_DEFINED), 1)
+CFLAGS += -DVSOCK
+endif
+
 export CFLAGS
 export INCLUDES
 
-- 
2.19.1

