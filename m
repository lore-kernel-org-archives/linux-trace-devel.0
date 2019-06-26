Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B40AC48BD8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 156F620656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdbEqjo8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfFZKw2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33616 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfFZKw2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so2213993wru.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EXWmlzBvw3BAUKdyQKPZwLK9Y0qN0eFtSBA29XCQezA=;
        b=pdbEqjo85GFvpuYA+qX4eyM9THFqXnSndo1krjcK/c1YrENYas1kEWmTFE8WhcNPbZ
         HtOspXiqZhAJtqt5l77qE46wvBNNf013BmkRYiBIsIoOIFdyxs08XMgkUsg02h//SQg/
         xGkF2k8V1SBumGC9G5jEQLd+VOVR438inCri/k1YAvtysAiF6xKq35+95xaI2nmY6G/n
         kOYpj4h+Ggf1FU74dRh1lRilwafLaVsP37FoMnQeYsll8Ow0SsieXnveOE256Xpvz3H/
         jX6X5gi/tlTS1FG6uBEeCPatXucGpoPRuVvwPA/pRbtjV6Ts37BHNRwHh4fwXWqszchE
         w2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EXWmlzBvw3BAUKdyQKPZwLK9Y0qN0eFtSBA29XCQezA=;
        b=l3V9iTG9g26Cs+QhDyA7uqjvwWArB5/ivtN2uHVg0UyT+QUy9iv8dTJqYweWtzRXQS
         HSi23LCJLUe5SJSHaRNhmJBlega/fmYwvx9lHwx3RXBgIDcZis6PvWH1S1maW1LLCNai
         t+KthT84DG7hmOAlhgvSbs6qMptrJGFU8McOS39fYHbPSB3cUDAf3a0LMtwKxuCzhmq/
         FQzB40eKSx5jH0r0ohnbJYNmxZiFgXQygGi1I4a1iM3iN0fBe3VKzdY5x1M9l/P1unRw
         ma3LblqgX1Vv1V/ysbkVVnFgU8N2MoadOWLhmi1+1TYazo7E6t3AAwAjNmaeVAHSv2JQ
         j1sw==
X-Gm-Message-State: APjAAAWpZVEzIZ60PLu3eedoKou6LpcK71JYBZ9d7QxHAniSzksQ86Ci
        rv6L77L2SAvaxjqjJyCjbOc2xPZj1g==
X-Google-Smtp-Source: APXvYqzFOehBFyyg25Uy8FMQIbAAFlItzOyqW/d56f2jeFCIlA6Xd5MJmEulmym1bP6NEsriCcjKrg==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr3106806wrw.10.1561546346986;
        Wed, 26 Jun 2019 03:52:26 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:26 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Wed, 26 Jun 2019 13:52:06 +0300
Message-Id: <20190626105209.13200-11-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c       |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index a6f58dc..a55a37d 100644
--- a/tracecmd/trace-setup-guest.c
+++ b/tracecmd/trace-setup-guest.c
@@ -93,6 +93,24 @@ static int make_guest_fifos(const char *guest, int nr_cpus, mode_t mode)
 	return ret;
 }
 
+static int get_guest_cpu_count(const char *guest)
+{
+	const char *cmd_fmt = "virsh vcpucount --maximum '%s' 2>/dev/null";
+	int nr_cpus = -1;
+	char cmd[1024];
+	FILE *f;
+
+	snprintf(cmd, sizeof(cmd), cmd_fmt, guest);
+	f = popen(cmd, "r");
+	if (!f)
+		return -errno;
+
+	fscanf(f, "%d", &nr_cpus);
+	pclose(f);
+
+	return nr_cpus;
+}
+
 static void do_setup_guest(const char *guest, int nr_cpus, mode_t mode, gid_t gid)
 {
 	gid_t save_egid;
@@ -171,6 +189,9 @@ void trace_setup_guest(int argc, char **argv)
 
 	guest = argv[optind+1];
 
+	if (nr_cpus <= 0)
+		nr_cpus = get_guest_cpu_count(guest);
+
 	if (nr_cpus <= 0)
 		pdie("invalid number of cpus for guest %s", guest);
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0d1b58e..a2a520c 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -251,7 +251,7 @@ static struct usage_help usage_help[] = {
 	{
 		"setup-guest",
 		"create FIFOs for tracing guest VMs",
-		" %s setup-guest -c cpus[-p perm][-g group] guest\n"
+		" %s setup-guest [-c cpus][-p perm][-g group] guest\n"
 		"          -c number of guest virtual CPUs\n"
 		"          -p FIFOs permissions (default: 0660)\n"
 		"          -g FIFOs group owner\n"
-- 
2.20.1

