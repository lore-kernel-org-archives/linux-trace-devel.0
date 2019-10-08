Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75678ECE596
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 591FE206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730589AbfJHIP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45817 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbfJHIP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so18169523wrm.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HQk32nv2xe+CQAXiM8rVBlP5krNRXPIG0SmucCq9ZLc=;
        b=ixuAZWa9xnspN4mUAPN+4fxXT7M1Esy5dWyEmUacGumV4ghpfmBjm95xAZNa8//GgB
         1gvEQZ9zTflw9mb+z8OCCLw5oqUBRuQ3NKiz7u+NpJoZ9c/zLBP4Vx0I+2aMP7KXostc
         x4OMHW5OszGGtbMAzn7SKGLRnZ+7csl9ehW04Tv4tdD9fHq04MUKHJ7Wm3IFRs2TQi6u
         2oh9AyDVi50xpYub4S0O0nKieNFwV2sd6MgTwtdf3Ur0GzNwul+w8LlMHNy2xriabXdZ
         YBSKi3P/StU0195t8WPQEqFxBjwBdlsb8K5/La5QTFJtumGzamZuNBtDBOQCjyvFllIU
         ICQg==
X-Gm-Message-State: APjAAAUTTU2zjbV7e6T+4AW1RwWbicQsYjfJgBYP27JTETvcAHi0fDg9
        M3uOEtSwrJj+47kJssHIzeJGNYTVIw==
X-Google-Smtp-Source: APXvYqwiOHMlyELvpz585SlTA5QC5mvXeJ09peN9OAoqYkHxjwEddD8kUvNPVALCsK0SXaE3dDbrpg==
X-Received: by 2002:adf:eecd:: with SMTP id a13mr21185352wrp.204.1570522554190;
        Tue, 08 Oct 2019 01:15:54 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:53 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 10/13] trace-cmd: Try to autodetect number of guest CPUs in setup-guest if not specified
Date:   Tue,  8 Oct 2019 11:15:34 +0300
Message-Id: <20191008081537.11536-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When no number of guest CPUs is provided with the -c flag to `trace-cmd
setup-guest`, try to autodetect it using virsh for libvirt managed guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-setup-guest.c | 21 +++++++++++++++++++++
 tracecmd/trace-usage.c       |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
index 2f8bfeb..0610104 100644
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
 		die("invalid number of cpus for guest %s", guest);
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index edc4ac6..b41d7d5 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -253,7 +253,7 @@ static struct usage_help usage_help[] = {
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

